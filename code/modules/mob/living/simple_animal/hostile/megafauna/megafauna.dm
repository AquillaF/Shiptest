/mob/living/simple_animal/hostile/megafauna
	name = "boss of this gym"
	desc = "Attack the weak point for massive damage."
	health = 1000
	maxHealth = 1000
	a_intent = INTENT_HARM
	sentience_type = SENTIENCE_BOSS
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	mob_biotypes = MOB_ORGANIC|MOB_EPIC
	obj_damage = 400
	light_range = 3
	faction = list("mining", "boss")
	weather_immunities = list("lava","ash")
	movement_type = FLYING
	robust_searching = TRUE
	ranged_ignores_vision = TRUE
	stat_attack = DEAD
	atmos_requirements = IMMUNE_ATMOS_REQS
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	minbodytemp = 0
	maxbodytemp = INFINITY
	vision_range = 5
	aggro_vision_range = 18
	move_force = MOVE_FORCE_OVERPOWERING
	move_resist = MOVE_FORCE_OVERPOWERING
	pull_force = MOVE_FORCE_OVERPOWERING
	mob_size = MOB_SIZE_HUGE
	layer = LARGE_MOB_LAYER //Looks weird with them slipping under mineral walls and cameras and shit otherwise
	mouse_opacity = MOUSE_OPACITY_OPAQUE // Easier to click on in melee, they're giant targets anyway
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1
	var/mob_trophy
	var/achievement_type
	var/crusher_achievement_type
	var/score_achievement_type
	var/elimination = 0
	var/anger_modifier = 0
	var/gps_name = null
	var/recovery_time = 0
	var/true_spawn = TRUE // if this is a megafauna that should grant achievements, or have a gps signal
	var/nest_range = 10
	var/chosen_attack = 1 // chosen attack num
	var/list/attack_action_types = list()
	var/small_sprite_type

/mob/living/simple_animal/hostile/megafauna/Initialize(mapload)
	. = ..()
	if(gps_name && true_spawn)
		AddComponent(/datum/component/gps, gps_name)
	apply_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
	ADD_TRAIT(src, TRAIT_NO_TELEPORT, MEGAFAUNA_TRAIT)
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)
	for(var/action_type in attack_action_types)
		var/datum/action/innate/megafauna_attack/attack_action = new action_type()
		attack_action.Grant(src)
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)
	become_hearing_sensitive(ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/megafauna/Moved()
	if(nest && nest.parent && get_dist(nest.parent, src) > nest_range)
		var/turf/closest = get_turf(nest.parent)
		for(var/i = 1 to nest_range)
			closest = get_step(closest, get_dir(closest, src))
		forceMove(closest) // someone teleported out probably and the megafauna kept chasing them
		LoseTarget()
		return
	return ..()

/mob/living/simple_animal/hostile/megafauna/death(gibbed, list/force_grant)
	if(health > 0)
		return
	else
		spawn_mob_trophy()
		var/datum/status_effect/crusher_damage/crusher = has_status_effect(STATUS_EFFECT_CRUSHERDAMAGETRACKING)
		var/crusher_kill = FALSE
		if(crusher && mob_trophy && crusher.total_damage >= maxHealth * 0.6)
			crusher_kill = TRUE
		if(true_spawn && !(flags_1 & ADMIN_SPAWNED_1))
			var/tab = "megafauna_kills"
			if(crusher_kill)
				tab = "megafauna_kills_crusher"
			if(!elimination)	//used so the achievment only occurs for the last legion to die.
				grant_achievement(achievement_type, score_achievement_type, crusher_kill, force_grant)
				SSblackbox.record_feedback("tally", tab, 1, "[initial(name)]")
		..()

/mob/living/simple_animal/hostile/megafauna/proc/spawn_mob_trophy()
	if(mob_trophy)
		loot += mob_trophy

/mob/living/simple_animal/hostile/megafauna/gib()
	if(health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/dust(just_ash, drop_items, force)
	if(!force && health > 0)
		return
	else
		..()

/mob/living/simple_animal/hostile/megafauna/AttackingTarget()
	if(recovery_time >= world.time)
		return
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			if(!client && ranged && ranged_cooldown <= world.time)
				OpenFire()
		else
			devour(L)

/mob/living/simple_animal/hostile/megafauna/proc/devour(mob/living/L)
	if(!L)
		return FALSE
	visible_message(
		span_danger("[src] devours [L]!"),
		span_userdanger("You feast on [L], restoring your health!"))
	adjustBruteLoss(-L.maxHealth/2)
	L.gib()
	return TRUE

/mob/living/simple_animal/hostile/megafauna/ex_act(severity, target)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			adjustBruteLoss(250)

		if (EXPLODE_HEAVY)
			adjustBruteLoss(100)

		if (EXPLODE_LIGHT)
			adjustBruteLoss(50)

/mob/living/simple_animal/hostile/megafauna/proc/SetRecoveryTime(buffer_time, ranged_buffer_time)
	recovery_time = world.time + buffer_time
	ranged_cooldown = world.time + buffer_time
	if(ranged_buffer_time)
		ranged_cooldown = world.time + ranged_buffer_time

/mob/living/simple_animal/hostile/megafauna/proc/grant_achievement(medaltype, scoretype, crusher_kill, list/grant_achievement = list())
	if(!achievement_type || (flags_1 & ADMIN_SPAWNED_1) || !SSachievements.achievements_enabled) //Don't award medals if the medal type isn't set
		return FALSE
	if(!grant_achievement.len)
		for(var/mob/living/L in view(7,src))
			grant_achievement += L
	for(var/mob/living/L as anything in grant_achievement)
		if(L.stat || !L.client)
			continue
		L.client.give_award(/datum/award/achievement/boss/boss_killer, L)
		L.client.give_award(achievement_type, L)
		if(crusher_kill && istype(L.get_active_held_item(), /obj/item/kinetic_crusher))
			L.client.give_award(crusher_achievement_type, L)
		L.client.give_award(/datum/award/score/boss_score, L) //Score progression for bosses killed in general
		L.client.give_award(score_achievement_type, L) //Score progression for specific boss killed
	return TRUE

/datum/action/innate/megafauna_attack
	name = "Megafauna Attack"
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = ""
	var/chosen_message
	var/chosen_attack_num = 0

/datum/action/innate/megafauna_attack/Grant(mob/living/L)
	if(!ismegafauna(L))
		return FALSE
	return ..()

/datum/action/innate/megafauna_attack/Activate()
	var/mob/living/simple_animal/hostile/megafauna/fauna = owner
	fauna.chosen_attack = chosen_attack_num
	to_chat(fauna, chosen_message)

/mob/living/simple_animal/hostile/megafauna
	var/list/enemies = list()

/mob/living/simple_animal/hostile/megafauna/Found(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			return L
		else
			enemies -= L
	else if(ismecha(A))
		var/obj/mecha/M = A
		if(M.occupant)
			return A

/mob/living/simple_animal/hostile/megafauna/ListTargets()
	if(!enemies.len)
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/megafauna/proc/Retaliate()
	var/list/around = view(src, vision_range)

	for(var/atom/A as anything in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(faction_check_mob(M) && attack_same || !faction_check_mob(M))
				enemies |= M
			if(ismegafauna(M))
				var/mob/living/simple_animal/hostile/megafauna/boss = M
				if(faction_check_mob(boss) && !attack_same && !boss.attack_same)
					boss.enemies |= enemies
		else if(ismecha(A))
			var/obj/mecha/M = A
			if(M.occupant)
				enemies |= M
				enemies |= M.occupant

	return 0

/mob/living/simple_animal/hostile/megafauna/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0 && stat == CONSCIOUS)
		Retaliate()
