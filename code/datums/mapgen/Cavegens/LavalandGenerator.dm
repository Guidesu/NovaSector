/datum/map_generator/cave_generator/lavaland
	weighted_open_turf_types = list(/turf/open/misc/asteroid/basalt/lava_land_surface = 20, /turf/open/misc/asteroid/snow/icemoon = 20, /turf/open/misc/grass/lavaland = 5, /turf/open/misc/ice/icemoon = 1)
	weighted_closed_turf_types = list(/turf/closed/mineral/random/volcanic = 1, /turf/closed/mineral/random/snow = 1)

	weighted_mob_spawn_list = list(
		/mob/living/basic/mining/bileworm = 2,
		/mob/living/basic/mining/brimdemon = 2,
		/mob/living/basic/mining/lobstrosity/lava = 2,
		/mob/living/basic/mining/goldgrub = 1,
		/mob/living/basic/mining/lobstrosity = 2,
		/mob/living/basic/mining/wolf = 5,
		/mob/living/simple_animal/hostile/asteroid/polarbear = 2,
		/obj/structure/spawner/ice_moon = 1,
		/obj/structure/spawner/ice_moon/polarbear = 1,
		/mob/living/basic/carp/mega = 1,
		/obj/effect/spawner/random/lavaland_mob/raptor = 3,
		/mob/living/basic/carp = 1,
		/mob/living/basic/mining/watcher = 1,
		/mob/living/basic/mining/watcher/magmawing = 1,
		/mob/living/basic/mining/watcher/icewing = 1,
		/mob/living/basic/mining/goliath = 1,
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
		/obj/structure/flora/rock/pile/icy/style_random = 10,
		/obj/structure/flora/tree/pine/style_random = 15,
		/obj/structure/flora/tree/pine/style_2 = 10,
		/obj/structure/flora/tree/pine/style_3 = 6,
		/obj/structure/flora/tree/jungle/small/style_4 = 4,
		/obj/structure/flora/bush/style_2 = 4,
		/obj/structure/flora/bush/reed = 3,
		/obj/structure/flora/rock/style_2 = 2,
		/obj/structure/flora/lunar_plant/style_1 = 4,
		/obj/structure/flora/lunar_plant/style_2 = 3,
		/obj/structure/flora/lunar_plant/style_3 = 4,
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

/datum/map_generator/cave_generator/lavaland/icelands
	weighted_open_turf_types = list( /turf/open/misc/asteroid/snow/icemoon/normal = 20, /turf/open/misc/ice/icemoon/normal = 1)
	weighted_closed_turf_types = list(/turf/closed/mineral/random/volcanic = 1, /turf/closed/mineral/random/snow = 1)
