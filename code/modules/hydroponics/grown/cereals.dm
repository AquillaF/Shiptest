// Wheat
/obj/item/seeds/wheat
	name = "pack of wheat seeds"
	desc = "These may, or may not, grow into wheat."
	icon_state = "seed-wheat"
	species = "wheat"
	plantname = "Wheat Stalks"
	product = /obj/item/food/grown/wheat
	production = 1
	yield = 4
	potency = 30
	icon_dead = "wheat-dead"
	mutatelist = list(/obj/item/seeds/wheat/oat, /obj/item/seeds/wheat/meat)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.04)

/obj/item/food/grown/wheat
	seed = /obj/item/seeds/wheat
	name = "wheat"
	desc = "Sigh... wheat... a-grain?"
	gender = PLURAL
	icon_state = "wheat"
	bite_consumption_mod = 0.5 // Chewing on wheat grains?
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0)
	tastes = list("wheat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/beer

// Oat
/obj/item/seeds/wheat/oat
	name = "pack of oat seeds"
	desc = "These may, or may not, grow into oat."
	icon_state = "seed-oat"
	species = "oat"
	plantname = "Oat Stalks"
	product = /obj/item/food/grown/oat
	mutatelist = list()
	research = PLANT_RESEARCH_TIER_0

/obj/item/food/grown/oat
	seed = /obj/item/seeds/wheat/oat
	name = "oat"
	desc = "Eat oats, do squats."
	gender = PLURAL
	icon_state = "oat"
	bite_consumption_mod = 0.5
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0)
	tastes = list("oat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/ale

// Rice
/obj/item/seeds/wheat/rice
	name = "pack of rice seeds"
	desc = "These may, or may not, grow into rice."
	icon_state = "seed-rice"
	species = "rice"
	plantname = "Rice Stalks"
	product = /obj/item/food/grown/rice
	mutatelist = list()
	growthstages = 3

/obj/item/food/grown/rice
	seed = /obj/item/seeds/wheat/rice
	name = "rice"
	desc = "Rice to meet you."
	gender = PLURAL
	icon_state = "rice"
	bite_consumption_mod = 0.5
	foodtypes = GRAIN
	grind_results = list(/datum/reagent/consumable/rice = 0)
	tastes = list("rice" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/sake

//Meatwheat - grows into synthetic meat
/obj/item/seeds/wheat/meat
	name = "pack of meatwheat seeds"
	desc = "If you ever wanted to drive a vegetarian to insanity, here's how."
	icon_state = "seed-meatwheat"
	species = "meatwheat"
	plantname = "Meatwheat"
	product = /obj/item/food/grown/meatwheat
	mutatelist = list()
	research = PLANT_RESEARCH_TIER_2

/obj/item/food/grown/meatwheat
	name = "meatwheat"
	desc = "Some blood-drenched wheat stalks. You can crush them into what passes for meat if you squint hard enough."
	icon_state = "meatwheat"
	gender = PLURAL
	bite_consumption_mod = 0.5
	seed = /obj/item/seeds/wheat/meat
	foodtypes = MEAT | GRAIN
	grind_results = list(/datum/reagent/consumable/flour = 0, /datum/reagent/blood = 0)
	tastes = list("meatwheat" = 1)
	can_distill = FALSE

/obj/item/food/grown/meatwheat/attack_self(mob/living/user)
	user.visible_message(
		span_notice("[user] crushes [src] into a meaty ball."),
		span_notice("You crush [src] into something that resembles meat."),
		span_warning("You hear a sickening squelch."),
		)
	playsound(user, 'sound/effects/blobattack.ogg', 50, TRUE)
	var/obj/item/food/meat/slab/meatwheat/M = new
	qdel(src)
	user.put_in_hands(M)
	return 1
