/// Used for all kinds of weather, ex. lavaland ash storms.
SUBSYSTEM_DEF(weather)
	name = "Weather"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/weather_controllers = list()

/datum/controller/subsystem/weather/fire()
	// process active weather controllers
	for(var/i in weather_controllers)
		var/datum/weather_controller/iterated_controller = i
		iterated_controller.process()

	// start random weather on relevant levels
	for(var/z in eligible_zlevels)
		var/possible_weather = eligible_zlevels[z]
		var/datum/weather/our_event = pick_weight(possible_weather)
		run_weather(our_event, list(text2num(z)))
		eligible_zlevels -= z
		var/randTime = rand(3000, 6000)
		next_hit_by_zlevel["[z]"] = addtimer(CALLBACK(src, PROC_REF(make_eligible), z, possible_weather), randTime + initial(our_event.weather_duration_upper), TIMER_UNIQUE|TIMER_STOPPABLE) //Around 5-10 minutes between weathers

/datum/controller/subsystem/weather/Initialize()
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		// any weather with a probability set may occur at random
		if (probability)
			for(var/z in SSmapping.levels_by_trait(target_trait))
				LAZYINITLIST(eligible_zlevels["[z]"])
				eligible_zlevels["[z]"][W] = probability
	return SS_INIT_SUCCESS

/datum/controller/subsystem/weather/proc/update_z_level(datum/space_level/level)
	var/z = level.z_value
	for(var/datum/weather/weather as anything in subtypesof(/datum/weather))
		var/probability = initial(weather.probability)
		var/target_trait = initial(weather.target_trait)
		if(probability && level.traits[target_trait])
			LAZYINITLIST(eligible_zlevels["[z]"])
			eligible_zlevels["[z]"][weather] = probability

/datum/controller/subsystem/weather/proc/run_weather(datum/weather/weather_datum_type, z_levels)
	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/weather))
			var/datum/weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

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
