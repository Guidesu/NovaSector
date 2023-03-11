/datum/weather/rain_storm
	name = "rain storm"
	desc = "Harsh rain storms roam the topside of this planet, burying any area unfortunate enough to be in its path."
	probability = 95
	next_hit_time = 25

	telegraph_message = "<span class='warning'>Drifting particles of rain begin to water the surrounding area..</span>"
	telegraph_duration = 6 MINUTES
	telegraph_overlay = "light_snow"
	weather_color = COLOR_CYAN
	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense rain begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 2 MINUTES
	weather_duration_upper = 3 MINUTES

	end_duration = 2 MINUTES
	end_message = "<span class='boldannounce'>The rain dies down, it should be safe to go outside again.</span>"
	target_trait = ZTRAIT_RAIN
	weather_sound = 'sound/weather/rain/short-rain-loop-101550.ogg'
	telegraph_sound = 'sound/weather/rain/mixkit-bad-weather-heavy-rain-and-thunder-1261.ogg'

/datum/weather/rain
	name = "rain"
	desc = "Rain falling down the surface."

	telegraph_message = "<span class='notice'>Dark clouds hover above and you feel humidity in the air..</span>"
	telegraph_duration = 300
	telegraph_skyblock = 0.2

	weather_message = "<span class='notice'>Rain starts to fall down..</span>"
	weather_overlay = "rain"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_skyblock = 0.4

	end_duration = 100
	end_message = "<span class='notice'>The rain stops...</span>"
	end_skyblock = 0.2

	area_type = /area
	protect_indoors = TRUE
	barometer_predictable = TRUE
	affects_underground = FALSE
	aesthetic = TRUE

	sound_active_outside = /datum/looping_sound/weather/rain/indoors
	sound_active_inside = /datum/looping_sound/weather/rain

/datum/weather/rain/heavy
	name = "heavy rain"
	desc = "Downpour of rain."

	telegraph_message = "<span class='notice'>Rather suddenly, clouds converge and tear into rain..</span>"
	telegraph_overlay = "rain"
	telegraph_skyblock = 0.4

	weather_message = "<span class='notice'>The rain turns into a downpour..</span>"
	weather_overlay = "storm"
	weather_skyblock = 0.6

	end_message = "<span class='notice'>The downpour dies down...</span>"
	end_overlay = "rain"
	end_skyblock = 0.4

	sound_active_outside = /datum/looping_sound/weather/rain/indoors
	sound_active_inside = /datum/looping_sound/weather/rain
	sound_weak_outside = /datum/looping_sound/weather/rain/indoors
	sound_weak_inside = /datum/looping_sound/weather/rain

	thunder_chance = 2

/datum/weather/rain/heavy/storm
	name = "storm"
	desc = "Storm with rain and lightning."
	weather_message = "<span class='warning'>The clouds blacken and the sky starts to flash as thunder strikes down!</span>"
	thunder_chance = 10
