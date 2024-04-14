/datum/weather/rain_storm
	name = "rain storm"
	desc = "Harsh rain storms roam the topside of this planet, burying any area unfortunate enough to be in its path."
	probability = 45
	next_hit_time = 25 MINUTES

	telegraph_message = "<span class='warning'>Drifting particles of rain begin to water the surrounding area..</span>"
	telegraph_duration = 2 MINUTES
	telegraph_overlay = "rain"
	weather_color = COLOR_CYAN
	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense rain begins to fall from the sky!</i></span>"
	weather_overlay = "storm"
	weather_duration_lower = 6 MINUTES
	weather_duration_upper = 10 MINUTES

	end_duration = 2 MINUTES
	end_message = "<span class='boldannounce'>The rain dies down.</span>"

	area_type = /area
	protect_indoors = TRUE
	barometer_predictable = TRUE
	target_trait = ZTRAIT_RAIN
	weather_sound = 'sound/weather/rain/short-rain-loop-101550.ogg'
	telegraph_sound = 'sound/weather/rain/mixkit-bad-weather-heavy-rain-and-thunder-1261.ogg'

/datum/weather/acid_rain
	name = "acid rain"
	desc = "The planet's thunderstorms are by nature acidic, and will incinerate anyone standing beneath them without protection."
	next_hit_time = 35 MINUTES
	probability = 20
	target_trait = ZTRAIT_ACID_RAIN

	telegraph_duration = 2 MINUTES
	telegraph_message = "<span class='boldwarning'>Thunder rumbles far above. You hear acidic droplets drumming against the canopy. Seek shelter.</span>"

	weather_message = "<span class='userdanger'><i>Acidic rain pours down around you! Get inside!</i></span>"
	weather_overlay = "acid_rain"
	weather_duration_lower = 6 MINUTES
	weather_duration_upper = 2 MINUTES

	end_duration = 1 MINUTES
	end_message = "<span class='boldannounce'>The downpour gradually slows to a light shower. It should be safe outside now.</span>"

	area_type = /area
	protect_indoors = TRUE

	barometer_predictable = TRUE

/datum/weather/acid_rain/weather_act(mob/living/L)
	var/resist = L.getarmor(null, ACID)
	if(prob(max(0,100-resist)))
		L.acid_act(20,20)

/datum/weather/sandstorm
	name = "sandstorm"
	desc = "Wshshshshh."
	next_hit_time = 60 MINUTES
	probability = 10
	target_trait = ZTRAIT_SANDSTORM


	telegraph_message = "<span class='warning'>You see waves of sand traversing as the wind picks up the pace..</span>"
	telegraph_duration = 2 MINUTES
	telegraph_overlay = "dust"

	weather_message = "<span class='userdanger'><i>A sand storm is upon you! Seek shelter!</i></span>"
	weather_overlay = "sandstorm"
	weather_duration_lower = 5 MINUTES
	weather_duration_upper = 10 MINUTES

	end_duration = 1 MINUTES
	end_message = "<span class='boldannounce'>The storm dissipiates.</span>"
	end_overlay = "dust"

	area_type = /area
	protect_indoors = TRUE

	barometer_predictable = TRUE

/datum/weather/sandstorm/weather_act(mob/living/L)
	if(iscarbon(L))
		var/mob/living/carbon/carbon = L
		if(!carbon.is_mouth_covered())
			carbon.adjustOxyLoss(1.5)
			if(prob(10))
				carbon.emote("cough")

/datum/weather/shroud_storm
	name = "shroudstorm"
	desc = "Zap."
	next_hit_time = 120 MINUTES
	probability = 5
	target_trait = ZTRAIT_SHROUDSTORM

	telegraph_message = "<span class='warning'>You hear thunder in the distance, static electricity rising in the air, wind starts to pickup..</span>"
	telegraph_duration = 2 MINUTES
	telegraph_overlay = "electric_ash"

	weather_message = "<span class='userdanger'><i>An electric storm is upon you! Seek shelter!</i></span>"
	weather_overlay = "electric_storm"
	weather_duration_lower = 3 MINUTES
	weather_duration_upper = 7 MINUTES

	end_duration = 2 MINUTES
	end_message = "<span class='boldannounce'>The storm dissipates.</span>"
	end_overlay = "electric_ash"

	area_type = /area
	protect_indoors = TRUE

	barometer_predictable = TRUE

/datum/weather/shroud_storm/weather_act(mob/living/L)
	if(prob(10))
		L.electrocute_act(rand(5, 20), "weather", TRUE)
	if(prob(10))
		empulse(L, 0, 3)

/datum/weather/hailstorm
	name = "hailstorm"
	desc = "Harsh hailstorm, battering the unfortunate who wound up in it."
	next_hit_time = 120 MINUTES
	probability = 10
	target_trait = ZTRAIT_HAIL_STORM

	telegraph_message = "<span class='warning'>Dark clouds converge as drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 2 MINUTES
	telegraph_overlay = "snowfall_light"

	weather_message = "<span class='userdanger'><i>Hail starts to rain down from the sky! Seek shelter!</i></span>"
	weather_overlay = "hail"
	weather_duration_lower = 1 MINUTES
	weather_duration_upper = 7 MINUTES

	end_duration = 2 MINUTES
	end_message = "<span class='boldannounce'>The hailstorm dies down, it should be safe to go outside again.</span>"

	area_type = /area
	protect_indoors = TRUE


	barometer_predictable = TRUE

/datum/weather/hailstorm/weather_act(mob/living/L)
	L.adjust_bodytemperature(-rand(3,6))
	L.adjustBruteLoss(rand(2,4))

/datum/weather/night
	name = "Night Time"
	desc = "Wow! Darkness!"
	probability = 70
	next_hit_time = 10 MINUTES
	telegraph_message = "<span class='warning'>The sun starts to die. Darkness starts to appear from the skies.</span>"
	telegraph_duration = 2 MINUTES
	telegraph_overlay = "darkness"
	target_trait = ZTRAIT_NIGHT_CYCLE

	weather_message = "<span class='userdanger'><i>It is now fully night</i></span>"
	weather_overlay = "darkness_fully"
	weather_duration_lower = 10 MINUTES
	weather_duration_upper = 30 MINUTES

	end_duration = 2 MINUTES
	end_message = "<span class='boldannounce'>The sun starts to appear yet again.</span>"

	area_type = /area
	protect_indoors = TRUE


	barometer_predictable = FALSE
