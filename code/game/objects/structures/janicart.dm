/obj/structure/janitorialcart
	name = "janitorial cart"
	desc = "This is the alpha and omega of sanitation."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cart"
	anchored = FALSE
	density = TRUE
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/obj/item/storage/bag/trash/mybag
	var/obj/item/mop/mymop
	var/obj/item/pushbroom/mybroom
	var/obj/item/reagent_containers/spray/cleaner/myspray
	var/obj/item/lightreplacer/myreplacer
	var/signs = 0
	var/const/max_signs = 4


/obj/structure/janitorialcart/Initialize()
	. = ..()
	create_reagents(100, OPENCONTAINER)

/obj/structure/janitorialcart/proc/wet_mop(obj/item/mop, mob/user)
	if(reagents.total_volume < 1)
		to_chat(user, span_warning("[src] is out of water!"))
		return 0
	else
		var/obj/item/mop/M = mop
		reagents.trans_to(mop, M.mopcap, transfered_by = user)
		to_chat(user, span_notice("You wet [mop] in [src]."))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return 1

/obj/structure/janitorialcart/proc/put_in_cart(obj/item/I, mob/user)
	if(!user.transferItemToLoc(I, src))
		return
	updateUsrDialog()
	to_chat(user, span_notice("You put [I] into [src]."))
	return


/obj/structure/janitorialcart/attackby(obj/item/I, mob/user, params)
	var/fail_msg = span_warning("There is already one of those in [src]!")

	if(istype(I, /obj/item/mop))
		var/obj/item/mop/m=I
		if(m.reagents.total_volume < m.reagents.maximum_volume)
			if (wet_mop(m, user))
				return
		if(!mymop)
			m.janicart_insert(user, src)
		else
			to_chat(user, fail_msg)
	else if(istype(I, /obj/item/pushbroom))
		if(!mybroom)
			var/obj/item/pushbroom/b=I
			b.janicart_insert(user,src)
		else
			to_chat(user, fail_msg)
	else if(istype(I, /obj/item/storage/bag/trash))
		if(!mybag)
			var/obj/item/storage/bag/trash/t=I
			t.janicart_insert(user, src)
		else
			to_chat(user,  fail_msg)
	else if(istype(I, /obj/item/reagent_containers/spray/cleaner))
		if(!myspray)
			put_in_cart(I, user)
			myspray=I
			update_appearance()
		else
			to_chat(user, fail_msg)
	else if(istype(I, /obj/item/lightreplacer))
		if(!myreplacer)
			var/obj/item/lightreplacer/l=I
			l.janicart_insert(user,src)
		else
			to_chat(user, fail_msg)
	else if(istype(I, /obj/item/clothing/suit/caution))
		if(signs < max_signs)
			put_in_cart(I, user)
			signs++
			update_appearance()
		else
			to_chat(user, span_warning("[src] can't hold any more signs!"))
	else if(mybag)
		mybag.attackby(I, user)
	else if(I.tool_behaviour == TOOL_CROWBAR)
		user.visible_message(span_notice("[user] begins to empty the contents of [src]."), span_notice("You begin to empty the contents of [src]..."))
		if(I.use_tool(src, user, 30))
			to_chat(usr, span_notice("You empty the contents of [src]'s bucket onto the floor."))
			reagents.expose(src.loc)
			src.reagents.clear_reagents()
	else
		return ..()

/obj/structure/janitorialcart/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.set_machine(src)
	var/dat
	if(mybag)
		dat += "<a href='?src=[REF(src)];garbage=1'>[mybag.name]</a><br>"
	if(mymop)
		dat += "<a href='?src=[REF(src)];mop=1'>[mymop.name]</a><br>"
	if(mybroom)
		dat += "<a href='?src=[REF(src)];broom=1'>[mybroom.name]</a><br>"
	if(myspray)
		dat += "<a href='?src=[REF(src)];spray=1'>[myspray.name]</a><br>"
	if(myreplacer)
		dat += "<a href='?src=[REF(src)];replacer=1'>[myreplacer.name]</a><br>"
	if(signs)
		dat += "<a href='?src=[REF(src)];sign=1'>[signs] sign\s</a><br>"
	var/datum/browser/popup = new(user, "janicart", name, 240, 160)
	popup.set_content(dat)
	popup.open()


/obj/structure/janitorialcart/Topic(href, href_list)
	if(!in_range(src, usr))
		return
	if(!isliving(usr))
		return
	var/mob/living/user = usr
	if(href_list["garbage"])
		if(mybag)
			user.put_in_hands(mybag)
			to_chat(user, span_notice("You take [mybag] from [src]."))
			mybag = null
	if(href_list["mop"])
		if(mymop)
			user.put_in_hands(mymop)
			to_chat(user, span_notice("You take [mymop] from [src]."))
			mymop = null
	if(href_list["broom"])
		if(mybroom)
			user.put_in_hands(mybroom)
			to_chat(user, span_notice("You take [mybroom] from [src]."))
			mybroom = null
	if(href_list["spray"])
		if(myspray)
			user.put_in_hands(myspray)
			to_chat(user, span_notice("You take [myspray] from [src]."))
			myspray = null
	if(href_list["replacer"])
		if(myreplacer)
			user.put_in_hands(myreplacer)
			to_chat(user, span_notice("You take [myreplacer] from [src]."))
			myreplacer = null
	if(href_list["sign"])
		if(signs)
			var/obj/item/clothing/suit/caution/Sign = locate() in src
			if(Sign)
				user.put_in_hands(Sign)
				to_chat(user, span_notice("You take \a [Sign] from [src]."))
				signs--
			else
				WARNING("Signs ([signs]) didn't match contents")
				signs = 0

	update_appearance()
	updateUsrDialog()


/obj/structure/janitorialcart/update_overlays()
	. = ..()
	if(mybag)
		. += "cart_garbage"
	if(mymop)
		. += "cart_mop"
	if(mybroom)
		. += "cart_broom"
	if(myspray)
		. += "cart_spray"
	if(myreplacer)
		. += "cart_replacer"
	if(signs)
		. += "cart_sign[signs]"
	if(reagents.total_volume > 0)
		. += "cart_water"
