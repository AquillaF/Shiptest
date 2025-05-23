/datum/map_generator/planet_generator/lava
	// values near 0.5 look bad due to the behavior of naive perlin noise
	// so this was bumped down a little below 0.5
	mountain_height = 0.45
	perlin_zoom = 65

	primary_area_type = /area/overmap_encounter/planetoid/lava

	biome_table = list(
		BIOME_COLDEST = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/lavaland/forest,
			BIOME_LOW_HUMIDITY = /datum/biome/lavaland/plains/dense/mixed,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/lavaland/forest/rocky,
			BIOME_HIGH_HUMIDITY = /datum/biome/lavaland/outback,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/lavaland/plains/dense
		),
		BIOME_COLD = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/lavaland/plains,
			BIOME_LOW_HUMIDITY = /datum/biome/lavaland/outback,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/lavaland/plains/dense,
			BIOME_HIGH_HUMIDITY = /datum/biome/lavaland/plains/dense/mixed,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/lavaland,
		),
		BIOME_WARM = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/lavaland,
			BIOME_LOW_HUMIDITY = /datum/biome/lavaland/lush,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/lavaland/forest,
			BIOME_HIGH_HUMIDITY = /datum/biome/lavaland/,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/lavaland/lava
		),
		BIOME_TEMPERATE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/lavaland/plains/dense/mixed,
			BIOME_LOW_HUMIDITY = /datum/biome/lavaland/forest,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/lavaland/plains/dense,
			BIOME_HIGH_HUMIDITY = /datum/biome/lavaland,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/lavaland/lava
		),
		BIOME_HOT = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/lavaland/outback,
			BIOME_LOW_HUMIDITY = /datum/biome/lavaland,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/lavaland/plains/dense/mixed,
			BIOME_HIGH_HUMIDITY = /datum/biome/lavaland,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/lavaland/lava
		),
		BIOME_HOTTEST = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/lavaland/forest/rocky,
			BIOME_LOW_HUMIDITY = /datum/biome/lavaland/outback,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/lavaland,
			BIOME_HIGH_HUMIDITY = /datum/biome/lavaland/nearlava,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/lavaland/lava
		)
	)

	cave_biome_table = list(
		BIOME_COLDEST_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/lavaland/rocky,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/lavaland/rocky,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/lavaland,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/lavaland,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/lavaland/mossy
		),
		BIOME_COLD_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/lavaland/rocky,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/lavaland,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/lavaland/lava,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/lavaland,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/lavaland/lava
		),
		BIOME_WARM_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/lavaland/rocky,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/lavaland,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/lavaland/mossy,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/lavaland/obsidian,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/lavaland/lava
		),
		BIOME_HOT_CAVE = list(
			BIOME_LOWEST_HUMIDITY = /datum/biome/cave/lavaland/rocky,
			BIOME_LOW_HUMIDITY = /datum/biome/cave/lavaland/mossy,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/cave/lavaland/obsidian,
			BIOME_HIGH_HUMIDITY = /datum/biome/cave/lavaland/lava,
			BIOME_HIGHEST_HUMIDITY = /datum/biome/cave/lavaland/lava
		)
	)

/datum/biome/lavaland
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/basalt/lava_land_surface/lit = 1,
	)
	flora_spawn_chance = 1
	flora_spawn_list = list(
		/obj/structure/flora/ausbushes/ywflowers/hell = 10,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 40,
		/obj/structure/flora/ash/fern = 5,
		/obj/structure/flora/ash/fireblossom = 1,
		/obj/structure/flora/ash/puce = 5,
	)
	feature_spawn_chance = 0.3
	feature_spawn_list = list(
		/obj/structure/flora/rock/hell = 20,
		/obj/structure/geyser/random = 4,
		/obj/effect/spawner/random/anomaly/lava = 2,
		/obj/structure/flora/rock/hell = 14,
		/obj/structure/vein/lavaland = 5,
		/obj/structure/vein/lavaland/classtwo = 2,
		/obj/structure/geyser/random = 2,
		/obj/structure/vein/lavaland/classthree = 1,
		/obj/effect/spawner/random/anomaly/lava = 1,
	)
	mob_spawn_chance = 4
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50,
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/random = 40,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/random = 30,
		/mob/living/simple_animal/hostile/asteroid/goldgrub/lavagrub = 10,
		/mob/living/simple_animal/hostile/asteroid/brimdemon = 20,
		/mob/living/simple_animal/hostile/asteroid/goliath/beast/ancient/crystal = 1,
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/forgotten = 1,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/crystal = 1,
		/obj/structure/spawner/burrow/lava_planet = 10
	)

/datum/biome/lavaland/forest
	open_turf_types = list(/turf/open/floor/plating/asteroid/purple/lit = 1)
	flora_spawn_list = list(
		/obj/structure/flora/tree/dead/tall/grey = 1,
		/obj/structure/flora/tree/dead/barren = 1,
		/obj/structure/flora/ausbushes/fullgrass/hell = 10,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 5
	)
	flora_spawn_chance = 80

/datum/biome/lavaland/forest/rocky
	flora_spawn_list = list(
		/obj/structure/flora/rock/pile/lava = 5,
		/obj/structure/flora/rock/lava = 4,
		/obj/structure/flora/tree/dead/tall/grey = 10,
		/obj/structure/flora/ausbushes/fullgrass/hell = 40,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 20,
		/obj/structure/flora/ausbushes/hell = 4
	)
	flora_spawn_chance = 75

/datum/biome/lavaland/plains
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/dirt/grass/lavaland = 30
	)

	flora_spawn_list = list(
		/obj/structure/flora/ausbushes/fullgrass/hell = 50,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 35,
		/obj/structure/flora/ausbushes/ywflowers/hell = 1,
		/obj/structure/flora/ausbushes/grassybush/hell = 4,
		/obj/structure/flora/firebush = 1,
	)
	flora_spawn_chance = 15

/datum/biome/lavaland/plains/dense
	flora_spawn_chance = 85
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/dirt/grass/lavaland = 50
	)
	feature_spawn_chance = 5
	feature_spawn_list = list(
		/obj/structure/flora/tree/dead/barren = 50,
		/obj/structure/flora/tree/dead/tall/grey = 45,
		/obj/effect/spawner/random/anomaly/lava = 10,
		/obj/structure/vein/lavaland = 5,
		/obj/structure/vein/lavaland/classtwo = 2,
		/obj/structure/vein/lavaland/classthree = 1,
	)

/datum/biome/lavaland/plains/dense/mixed
	flora_spawn_chance = 50
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/dirt/grass/lavaland = 50,
		/turf/open/floor/plating/asteroid/dirt/grass/lavaland = 45,
		/turf/open/floor/plating/moss = 1
	)

/datum/biome/lavaland/outback
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/dirt/grass/lavaland = 20
	)

	flora_spawn_list = list(
		/obj/structure/flora/ausbushes/grassybush/hell = 10,
		/obj/structure/flora/ausbushes/genericbush/hell = 10,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 3,
		/obj/structure/flora/ausbushes/hell = 3,
		/obj/structure/flora/tree/dead/hell = 3,
		/obj/structure/flora/rock/lava = 2
	)
	flora_spawn_chance = 30

/datum/biome/lavaland/lush
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/dirt/grass/lavaland = 20,
		/turf/open/floor/plating/asteroid/basalt/lava_land_surface/lit = 1
	)
	flora_spawn_list = list(
		/obj/structure/flora/ash/fireblossom = 3,
		/obj/structure/flora/tree/dead/hell = 1,
		/obj/structure/flora/ausbushes/grassybush/hell = 5,
		/obj/structure/flora/ausbushes/fullgrass/hell = 10,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 8,
		/obj/structure/flora/ausbushes/hell = 5,
		/obj/structure/flora/ausbushes/fernybush/hell = 5,
		/obj/structure/flora/ausbushes/genericbush/hell = 5,
		/obj/structure/flora/ausbushes/ywflowers/hell = 7,
		/obj/structure/flora/firebush = 3
	)
	flora_spawn_chance = 30

/datum/biome/lavaland/lava
	open_turf_types = list(/turf/open/lava/smooth/lava_land_surface = 1)
	flora_spawn_list = list(
		/obj/structure/flora/rock/lava = 1,
		/obj/structure/flora/rock/pile/lava = 1
	)
	flora_spawn_chance = 2
	feature_spawn_chance = 0

/datum/biome/lavaland/nearlava
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/obsidian/lit = 1,
	)
	flora_spawn_list = list(
		/obj/structure/flora/rock/lava = 1,
		/obj/structure/flora/rock/pile/lava = 1
	)
	flora_spawn_chance = 2

/datum/biome/lavaland/lava/rocky
	flora_spawn_chance = 4

/datum/biome/cave/lavaland
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/basalt/lava_land_surface = 1
	)
	closed_turf_types = list(
		/turf/closed/mineral/random/volcanic = 1
	)
	mob_spawn_chance = 4
	mob_spawn_list = list(
		/mob/living/simple_animal/hostile/asteroid/goliath/beast/random = 50,
		/mob/living/simple_animal/hostile/asteroid/basilisk/watcher/random = 40,
		/mob/living/simple_animal/hostile/asteroid/hivelord/legion/random = 30,
		/mob/living/simple_animal/hostile/asteroid/goldgrub/lavagrub = 10,
		/obj/structure/spawner/burrow/lava_planet = 10
	)
	flora_spawn_chance = 1
	flora_spawn_list = list(
		/obj/structure/flora/ash/leaf_shroom = 1,
		/obj/structure/flora/ash/cap_shroom = 2,
		/obj/structure/flora/ash/stem_shroom = 2,
		/obj/structure/flora/ash/cacti = 1,
		/obj/structure/flora/ash/tall_shroom = 2,
		/obj/structure/flora/ash/fern = 2,
		/obj/structure/flora/ash/puce = 2,
	)

/datum/biome/cave/lavaland/obsidian
	open_turf_types = list(
		/turf/open/floor/plating/asteroid/obsidian = 1
	)

/datum/biome/cave/lavaland/rocky
	open_turf_types = list(/turf/open/floor/plating/asteroid/purple = 1)
	flora_spawn_list = list(
		/obj/structure/flora/rock/pile/lava = 6,
		/obj/structure/flora/rock/lava = 6,
	)
	flora_spawn_chance = 5

/datum/biome/cave/lavaland/mossy
	open_turf_types = list(/turf/open/floor/plating/moss = 1)
	flora_spawn_chance = 80
	flora_spawn_list = list(
		/obj/structure/flora/ausbushes/fullgrass/hell = 10,
		/obj/structure/flora/ausbushes/sparsegrass/hell = 5,
		/obj/structure/flora/ash/leaf_shroom = 1,
		/obj/structure/flora/ash/cap_shroom = 2,
		/obj/structure/flora/ash/stem_shroom = 2,
		/obj/structure/flora/ash/cacti = 1,
		/obj/structure/flora/ash/tall_shroom = 2,
	)

/datum/biome/cave/lavaland/lava
	open_turf_types = list(/turf/open/lava/smooth/lava_land_surface = 1)
	feature_spawn_chance = 1
	feature_spawn_list = list(/obj/structure/flora/rock/pile/lava = 1)
