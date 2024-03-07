/datum/round_event_control/wisdomcow
	name = "Wisdom Cow"
	typepath = /datum/round_event/wisdomcow
	max_occurrences = 1
	weight = 20
	category = EVENT_CATEGORY_FRIENDLY
	description = "A cow appears to tell you wise words."
	admin_setup = list(
		/datum/event_admin_setup/set_location/wisdom_cow,
		/datum/event_admin_setup/listed_options/wisdom_cow,
		/datum/event_admin_setup/input_number/wisdom_cow,
	)

/datum/round_event/wisdomcow
	///Location override that, if set causes the cow to spawn in a pre-determined locaction instead of randomly.
	var/turf/spawn_location
	///An override that, if set rigs the cow to spawn with a specific wisdow rather than a random one.
	var/selected_wisdom
	///An override that, if set modifies the amount of wisdow the cow will add/remove, if not set will default to 500.
	var/selected_experience

/datum/round_event/wisdomcow/announce(fake)
	priority_announce("A wise cow has been spotted in the area. Be sure to ask for her advice.", "Free Union Of Vulken Cow Ranching Agency")

/datum/round_event/wisdomcow/start()
	var/turf/targetloc
	if(spawn_location)
		targetloc = spawn_location
	else
		targetloc = get_safe_random_station_turf()
	var/mob/living/basic/cow/wisdom/wise = new(targetloc, selected_wisdom, selected_experience)
	do_smoke(1, holder = wise, location = targetloc)
	announce_to_ghosts(wise)

/datum/event_admin_setup/set_location/wisdom_cow
	input_text = "Spawn on current turf?"

/datum/event_admin_setup/set_location/wisdom_cow/apply_to_event(datum/round_event/wisdomcow/event)
	event.spawn_location = chosen_turf

/datum/event_admin_setup/listed_options/wisdom_cow
	input_text = "Select a specific wisdom type?"
	normal_run_option = "Random Wisdom"

/datum/event_admin_setup/listed_options/wisdom_cow/get_list()
	return subtypesof(/datum/skill)

/datum/event_admin_setup/listed_options/wisdom_cow/apply_to_event(datum/round_event/wisdomcow/event)
	event.selected_wisdom = chosen

/datum/event_admin_setup/input_number/wisdom_cow
	input_text = "How much experience should this cow grant?"
	default_value = 500
	max_value = 2500
	min_value = -2500

/datum/event_admin_setup/input_number/wisdom_cow/apply_to_event(datum/round_event/wisdomcow/event)
	event.selected_experience = chosen_value
	
	
