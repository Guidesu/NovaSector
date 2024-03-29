/// Used for all kinds of weather, ex. lavaland ash storms.
SUBSYSTEM_DEF(weather)
	name = "Weather"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/weather_controllers = list()
	var/list/processing = list()
	var/list/eligible_zlevels = list()
	var/list/next_hit_by_zlevel = list() //Used by barometers to know when the next storm is coming
	var/z_levels
	var/weather_datum_type

/datum/controller/subsystem/weather/fire()
	// process active weather controllers
	// process active weather
	for(var/V in processing)
		var/datum/weather/our_event = V
		if(our_event.aesthetic || our_event.stage != MAIN_STAGE)
			continue
		for(var/mob/act_on as anything in GLOB.mob_living_list)
			if(our_event.can_weather_act(act_on))
				our_event.weather_act(act_on)
	for(var/i in weather_controllers)
		var/datum/weather_controller/iterated_controller = i
		iterated_controller.process()

	// start random weather on relevant levels

/datum/controller/subsystem/weather/Initialize()
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		// any weather with a probability set may occur at random
		if (probability)
			for(var/z in SSmapping.levels_by_trait(target_trait))

	if (isnull(z_levels))
		z_levels = SSmapping.levels_by_trait(initial(weather_datum_type.target_trait))
	else if (isnum(z_levels))
		z_levels = list(z_levels)
	else if (!islist(z_levels))
		CRASH("run_weather called with invalid z_levels: [z_levels || "null"]")

	var/datum/weather/W = new weather_datum_type(z_levels)
	W.telegraph()

/datum/controller/subsystem/weather/proc/make_eligible(z, possible_weather)
	eligible_zlevels[z] = possible_weather
	next_hit_by_zlevel["[z]"] = null

/datum/controller/subsystem/weather/proc/get_weather(z, area/active_area)
	var/datum/weather/A
	for(var/V in processing)
		var/datum/weather/W = V
		if((z in W.impacted_z_levels) && W.area_type == active_area.type)
			A = W
			break
	return A

///Returns an active storm by its type
/datum/controller/subsystem/weather/proc/get_weather_by_type(type)
	return locate(type) in processing

/**
 * Calls end() on all current weather effects that are currently processing in the weather subsystem.
 */
/client/proc/stop_weather()
	set category = "Debug"
	set name = "Stop All Active Weather"

	log_admin("[key_name(src)] stopped all currently active weather.")
	message_admins("[key_name_admin(src)] stopped all currently active weather.")
	for(var/datum/weather/current_weather as anything in SSweather.processing)
		if(current_weather in SSweather.processing)
			current_weather.end()
	BLACKBOX_LOG_ADMIN_VERB("Stop All Active Weather")
/datum/controller/subsystem/weather/proc/GetAllCurrentWeathers()
	var/list/returned_weathers = list()
	for(var/i in weather_controllers)
		var/datum/weather_controller/iterated_controller = i
		if(iterated_controller.current_weathers)
			for(var/b in iterated_controller.current_weathers)
				returned_weathers += iterated_controller.current_weathers[b]
	return returned_weathers
