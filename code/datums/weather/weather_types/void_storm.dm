/datum/weather/void_storm
	name = "void storm"
	desc = "A rare and highly anomalous event. We'd advise you to start running to safety."
	probability = 25
	telegraph_duration = 1 MINUTES
	telegraph_overlay = "void"
	weather_overlay = "void_storm"
	end_overlay = "void"
	next_hit_time = 35 MINUTES
	weather_message = span_hypnophrase("You feel the air around you getting colder... The anomalous weather vibrates the air...")
	weather_color = COLOR_BLACK
	weather_duration_lower = 2 MINUTES
	weather_duration_upper = 3 MINUTES

	use_glow = FALSE

	end_duration = 3 MINUTES

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_VOIDSTORM

	immunity_type = TRAIT_VOIDSTORM_IMMUNE

	barometer_predictable = TRUE
	perpetual = FALSE

	/// List of areas that were once impacted areas but are not anymore. Used for updating the weather overlay based whether the ascended heretic is in the area.
	var/list/former_impacted_areas = list()

/datum/weather/void_storm/can_weather_act(mob/living/mob_to_check)
	. = ..()
	if(IS_HERETIC_OR_MONSTER(mob_to_check))
		return FALSE

/datum/weather/void_storm/weather_act(mob/living/victim)
	var/need_mob_update = FALSE
	victim.adjustFireLoss(1, updating_health = FALSE)
	victim.adjustOxyLoss(rand(1, 3), updating_health = FALSE)
	if(need_mob_update)
		victim.updatehealth()
	victim.adjust_eye_blur(rand(0 SECONDS, 2 SECONDS))
	victim.adjust_bodytemperature(-30 * TEMPERATURE_DAMAGE_COEFFICIENT)

// Goes through former_impacted_areas and sets the overlay of each back to the telegraph overlay, to indicate the ascended heretic is no longer in that area.
/datum/weather/void_storm/update_areas()
	for(var/area/former_area as anything in former_impacted_areas)
		former_area.icon_state = telegraph_overlay
		former_impacted_areas -= former_area
	return ..()
