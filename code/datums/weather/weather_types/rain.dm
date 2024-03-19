/datum/weather/rain_storm
	name = "rain storm"
	desc = "Harsh rain storms roam the topside of this planet, burying any area unfortunate enough to be in its path."
	probability = 40

	telegraph_message = "<span class='warning'>Drifting particles of rain begin to water the surrounding area..</span>"
	telegraph_duration = 300
	telegraph_overlay = "light_snow"
	weather_color = COLOR_CYAN
	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense rain begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 600
	weather_duration_upper = 1200

	end_duration = 100
	end_message = "<span class='boldannounce'>The rain dies down, it should be safe to go outside again.</span>"

	area_type = /area
	protect_indoors = TRUE
	barometer_predictable = TRUE
	target_trait = ZTRAIT_RAIN
	weather_sound = 'sound/weather/rain/short-rain-loop-101550.ogg'
	telegraph_sound = 'sound/weather/rain/mixkit-bad-weather-heavy-rain-and-thunder-1261.ogg'

