/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/pai.dmi'
	icon_state = "repairbot"
	mouse_opacity = MOUSE_OPACITY_ICON
	density = FALSE
	hud_type = /datum/hud/pai
	pass_flags = PASSTABLE | PASSMOB | PASSDOORHATCH
	mob_size = MOB_SIZE_TINY
	desc = "A generic pAI mobile hard-light holographics emitter. It seems to be deactivated."
	weather_immunities = list("ash")
	health = 500
	maxHealth = 500
	layer = BELOW_MOB_LAYER
	worn_slot_flags = ITEM_SLOT_HEAD
	held_lh = 'icons/mob/pai_item_lh.dmi'
	held_rh = 'icons/mob/pai_item_rh.dmi'
	head_icon = 'icons/mob/pai_item_head.dmi'
	radio = /obj/item/radio/headset/silicon/pai
	var/network = "ss13"
	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/paicard/card	// The card we inhabit
	var/hacking = FALSE		//Are we hacking a door?

	var/speakStatement = "states"
	var/speakExclamation = "declares"
	var/speakDoubleExclamation = "alarms"
	var/speakQuery = "queries"

	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 100, >= 100 means the hack is complete and will be reset upon next check

	var/obj/item/integrated_signaler/signaler // AI's signaller

	var/obj/item/instrument/piano_synth/internal_instrument
	var/obj/machinery/newscaster			//pAI Newscaster
	var/obj/item/healthanalyzer/hostscan				//pAI healthanalyzer

	var/encryptmod = FALSE
	var/holoform = FALSE
	var/canholo = TRUE
	var/can_transmit = TRUE
	var/can_receive = TRUE
	var/obj/item/card/id/access_card = null
	var/chassis = "repairbot"
	var/list/possible_chassis = list("bat" = TRUE, "butterfly" = TRUE, "carp" = TRUE, "cat" = TRUE, "corgi" = TRUE, "corgi_puppy" = TRUE, "crow" = TRUE, "duffel" = TRUE, "fox" = TRUE, "frog" = TRUE, "hawk" = TRUE, "lizard" = TRUE, "monkey" = TRUE, "mothroach" = TRUE, "mouse" = TRUE, "rabbit" = TRUE, "repairbot" = TRUE, "snake" = TRUE, "spider" = TRUE) //assoc value is whether it can be picked up.

	var/emitterhealth = 20
	var/emittermaxhealth = 20
	var/emitterregen = 0.125
	var/emittercd = 50
	var/emitteroverloadcd = 100
	var/emittercurrent_cooldown = FALSE

	var/overload_ventcrawl = 0
	var/overload_bulletblock = 0	//Why is this a good idea?
	var/overload_maxhealth = 0
	var/silent = FALSE
	var/brightness_power = 5

/mob/living/silicon/pai/can_unbuckle()
	return FALSE

/mob/living/silicon/pai/can_buckle()
	return FALSE

/mob/living/silicon/pai/Destroy()
	QDEL_NULL(internal_instrument)
	QDEL_NULL(laws)
	if(cable)
		QDEL_NULL(cable)
	if (loc != card)
		card.forceMove(drop_location())
	card.pai = null
	card.cut_overlays()
	card.add_overlay("pai-off")
	GLOB.pai_list -= src
	return ..()

/mob/living/silicon/pai/Initialize()
	ADD_TRAIT(src, TRAIT_HOLDABLE, INNATE_TRAIT)
	var/obj/item/paicard/P = loc
	START_PROCESSING(SSfastprocess, src)
	GLOB.pai_list += src
	make_laws()
	if(!istype(P)) //when manually spawning a pai, we create a card to put it into.
		var/newcardloc = P
		P = new /obj/item/paicard(newcardloc)
		P.setPersonality(src)
	forceMove(P)
	card = P
	job = "Personal AI"
	signaler = new(src)
	hostscan = new /obj/item/healthanalyzer(src)
	newscaster = new /obj/machinery/newscaster(src)
	if(!aicamera)
		aicamera = new /obj/item/camera/siliconcam/ai_camera(src)
		aicamera.flash_enabled = TRUE

	addtimer(CALLBACK(src, PROC_REF(pdaconfig)), 5)

	. = ..()

	emittercurrent_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(emittercool)), 600)

	if(!holoform)
		ADD_TRAIT(src, TRAIT_IMMOBILIZED, PAI_FOLDED)
		ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, PAI_FOLDED)


/mob/living/silicon/pai/proc/pdaconfig()
	//PDA
	aiPDA = new/obj/item/pda/ai(src)
	aiPDA.owner = real_name
	aiPDA.ownjob = "pAI Messenger"
	aiPDA.name = real_name + " (" + aiPDA.ownjob + ")"

/mob/living/silicon/pai/proc/process_hack()
	if(cable && cable.machine && istype(cable.machine, /obj/machinery/door) && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
		hackprogress = clamp(hackprogress + 4, 0, 100)
	else
		temp = "Door Jack: Connection to airlock has been lost. Hack aborted."
		hackprogress = 0
		hacking = FALSE
		hackdoor = null
		return
	if(screen == "doorjack" && subscreen == 0) // Update our view, if appropriate
		paiInterface()
	if(hackprogress >= 100)
		hackprogress = 0
		var/obj/machinery/door/D = cable.machine
		D.open()
		hacking = FALSE

/mob/living/silicon/pai/make_laws()
	laws = new /datum/ai_laws/pai()
	return TRUE

/mob/living/silicon/pai/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	client.perspective = EYE_PERSPECTIVE
	if(holoform)
		client.eye = src
	else
		client.eye = card

/mob/living/silicon/pai/get_status_tab_items()
	. += ..()
	if(!stat)
		. += text("Emitter Integrity: [emitterhealth * (100/emittermaxhealth)]")
	else
		. += text("Systems nonfunctional")


// See software.dm for Topic()

/mob/living/silicon/pai/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(be_close && !in_range(M, src))
		to_chat(src, span_warning("You are too far away!"))
		return FALSE
	return TRUE

/mob/proc/makePAI(delold)
	var/obj/item/paicard/card = new /obj/item/paicard(get_turf(src))
	var/mob/living/silicon/pai/pai = new /mob/living/silicon/pai(card)
	pai.key = key
	pai.name = name
	card.setPersonality(pai)
	if(delold)
		qdel(src)

/datum/action/innate/pai
	name = "PAI Action"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	var/mob/living/silicon/pai/P

/datum/action/innate/pai/Trigger()
	if(!ispAI(owner))
		return 0
	P = owner

/datum/action/innate/pai/software
	name = "Software Interface"
	button_icon_state = "pai"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/software/Trigger()
	..()
	P.paiInterface()

/datum/action/innate/pai/shell
	name = "Toggle Holoform"
	button_icon_state = "pai_holoform"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/shell/Trigger()
	..()
	if(P.holoform)
		P.fold_in(0)
	else
		P.fold_out()

/datum/action/innate/pai/chassis
	name = "Holochassis Appearance Composite"
	button_icon_state = "pai_chassis"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/chassis/Trigger()
	..()
	P.choose_chassis()

/datum/action/innate/pai/rest
	name = "Rest"
	button_icon_state = "pai_rest"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/rest/Trigger()
	..()
	P.toggle_resting()

/datum/action/innate/pai/light
	name = "Toggle Integrated Lights"
	icon_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "emp"
	background_icon_state = "bg_tech"

/datum/action/innate/pai/light/Trigger()
	..()
	P.toggle_integrated_light()

/mob/living/silicon/pai/Process_Spacemove(movement_dir = 0)
	. = ..()
	if(!.)
		add_movespeed_modifier(/datum/movespeed_modifier/pai_spacewalk)
		return TRUE
	remove_movespeed_modifier(/datum/movespeed_modifier/pai_spacewalk)
	return TRUE

/mob/living/silicon/pai/examine(mob/user)
	. = ..()
	. += "A personal AI in holochassis mode. Its master ID string seems to be [master]."

/mob/living/silicon/pai/Life()
	. = ..()
	if(QDELETED(src) || stat == DEAD)
		return
	if(cable)
		if(get_dist(src, cable) > 1)
			var/turf/T = get_turf(src)
			T.visible_message(span_warning("[cable] rapidly retracts back into its spool."), span_hear("You hear a click and the sound of wire spooling rapidly."))
			QDEL_NULL(cable)
	if(hacking)
		process_hack()
	silent = max(silent - 1, 0)

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		return
	set_health(maxHealth - getBruteLoss() - getFireLoss())
	update_stat()

/mob/living/silicon/pai/process(seconds_per_tick)
	emitterhealth = clamp((emitterhealth + emitterregen * seconds_per_tick), -50, emittermaxhealth)

/obj/item/paicard/attackby(obj/item/W, mob/user, params)
	..()
	user.set_machine(src)
	if(pai && pai.encryptmod == TRUE)
		if(W.tool_behaviour == TOOL_SCREWDRIVER)
			pai.radio.attackby(W, user, params)
		else if(istype(W, /obj/item/encryptionkey))
			pai.radio.attackby(W, user, params)
	else
		to_chat(user, span_alert("Encryption Key ports not configured."))

//Wipe
/mob/living/silicon/pai/verb/wipe_self()
	var/confirm = alert("Are you sure you want to wipe your own personality? This is PERMANENT.", "Confirm Wipe", "Yes", "No")
	if(confirm == "Yes")
		var/turf/T = get_turf(src.loc)
		T.visible_message(
			span_notice("[src] flashes a message across its screen,\"Wiping core files. Please acquire a new personality to continue using pAI device functions.\""), null, \
			span_notice("[src] bleeps electronically."))
		death(FALSE)
		ghostize(FALSE)	// Disallows reentering body and disassociates mind
	else
		to_chat(src, "Aborting wipe attempt.")
