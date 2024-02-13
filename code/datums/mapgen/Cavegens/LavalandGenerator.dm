/datum/map_generator/cave_generator/lavaland
	weighted_open_turf_types = list(/turf/open/misc/asteroid/basalt/lava_land_surface = 1, /turf/open/misc/asteroid/snow/icemoon = 1, /turf/open/misc/ice/icemoon = 1)
	weighted_closed_turf_types = list(/turf/closed/mineral/random/volcanic = 1, /turf/closed/mineral/random/snow = 1)

	weighted_mob_spawn_list = list(
		/mob/living/basic/mining/bileworm = 1,
		/mob/living/basic/mining/brimdemon = 1,
		/mob/living/basic/mining/lobstrosity/lava = 1,
		/mob/living/basic/mining/goldgrub = 10,
		/obj/structure/spawner/lavaland = 1,
		/obj/structure/spawner/lavaland/goliath = 1,
		/obj/structure/spawner/lavaland/legion = 1,
		/mob/living/basic/mining/legion/snow = 1,
		/mob/living/basic/mining/lobstrosity = 1,
		/mob/living/basic/mining/wolf = 20,
		/mob/living/simple_animal/hostile/asteroid/polarbear = 15,
		/obj/structure/spawner/ice_moon = 1,
		/obj/structure/spawner/ice_moon/polarbear = 1,
	)

	weighted_flora_spawn_list = list(
		/obj/structure/flora/ash/cacti = 1,
		/obj/structure/flora/ash/cap_shroom = 2,
		/obj/structure/flora/ash/fireblossom = 2,
		/obj/structure/flora/ash/leaf_shroom = 2,
		/obj/structure/flora/ash/seraka = 2,
		/obj/structure/flora/ash/stem_shroom = 2,
		/obj/structure/flora/ash/tall_shroom = 2,
		/obj/structure/flora/ash/chilly = 2,
		/obj/structure/flora/grass/both/style_random = 6,
		/obj/structure/flora/rock/icy/style_random = 2,
		/obj/structure/flora/rock/pile/icy/style_random = 2,
		/obj/structure/flora/tree/pine/style_random = 2,
	)

	///Note that this spawn list is also in the icemoon generator
	weighted_feature_spawn_list = list(
		/obj/structure/geyser/hollowwater = 10,
		/obj/structure/geyser/plasma_oxide = 10,
		/obj/structure/geyser/protozine = 10,
		/obj/structure/geyser/random = 2,
		/obj/structure/geyser/wittel = 10,
		/obj/structure/ore_vent/boss = 1,
		/obj/structure/ore_vent/boss/icebox = 1
	)

	initial_closed_chance = 45
	smoothing_iterations = 50
	birth_limit = 4
	death_limit = 3

/datum/map_generator/cave_generator/lavaland/ruin_version
	weighted_open_turf_types = list(/turf/open/misc/asteroid/basalt/lava_land_surface/no_ruins = 1)
	weighted_closed_turf_types = list(/turf/closed/mineral/volcanic/lava_land_surface/do_not_chasm = 1)
