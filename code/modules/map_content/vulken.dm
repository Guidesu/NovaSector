/datum/map_config/vulken
	map_name = "Vulken"
	map_path = "map_files/Mining"
	map_file = list("Lavaland.dmm")


	traits = list(list("Up" = 1,
						"Mining" = TRUE,
						"Station" = FALSE,
						"Linkage" = null,
						"Gravity" = TRUE,),
					list("Down" = -1,
						"Up" = 1,
						"Mining" = TRUE,
						"Linkage" = null,
						"Gravity" = TRUE,),
					list("Down" = -1,
						"Mining" = TRUE,
						"Linkage" = null,
						"Gravity" = TRUE,)
					)

	space_ruin_levels = 0
	space_empty_levels = 0

	minetype = "none"
	allow_custom_shuttles = FALSE
	shuttles = list(
		"cargo" = "cargo_nova",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box"
	)
	job_changes = list("cook" = list("additional_cqc_areas" = list("/area/service/kitchen/diner")),
						"captain" = list("special_charter" = "planet"))

	overmap_object_type = /datum/overmap_object/shuttle/planet/vulken
	weather_controller_type = /datum/weather_controller/vulken
	atmosphere_type = /datum/atmosphere/lavaland
	ore_node_seeder_type = /datum/ore_node_seeder
