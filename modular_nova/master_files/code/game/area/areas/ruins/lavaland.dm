// Lavaland Ruins
// NOTICE: /unpowered means you never get power. Thanks Fikou!

// Free Union of Vulken planetary base

/area/ruin/interdyne_planetary_base // used as parent type and for turret control
	name = "Free Union of Vulken Pharmaceuticals Spinward Sector Base"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "syndie-control"
	ambience_index = AMBIENCE_DANGER
	ambient_buzz = 'sound/ambience/magma.ogg'
	area_flags = UNIQUE_AREA | BLOBS_ALLOWED

/area/ruin/interdyne_planetary_base/cargo
	name = "Free Union of Vulken Cargo Bay"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"

/area/ruin/interdyne_planetary_base/cargo/deck
	name = "Free Union of Vulken Deck Officer's Office"
	icon_state = "qm_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/ruin/interdyne_planetary_base/cargo/ware
	name = "Free Union of Vulken Warehouse"
	icon_state = "cargo_warehouse"

/area/ruin/interdyne_planetary_base/cargo/obs
	name = "Free Union of Vulken Observation Center"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "observatory"
	ambience_index = AMBIENCE_DANGER

/area/ruin/interdyne_planetary_base/cargo/obs/Initialize(mapload)
	if(!ambientsounds)
		var/list/temp_ambientsounds = GLOB.ambience_assoc[ambience_index]
		ambientsounds = temp_ambientsounds.Copy()
		ambientsounds += list(
			'modular_nova/modules/encounters/sounds/morse.ogg',
			'sound/ambience/ambitech.ogg',
			'sound/ambience/signal.ogg',
			'modular_nova/modules/encounters/sounds/morse.ogg',
		)
	return ..()

/area/ruin/interdyne_planetary_base/main
	name = "Free Union of Vulken Main Hall"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "hall"

/area/ruin/interdyne_planetary_base/main/vault
	name = "Free Union of Vulken Vault"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "syndie-control"

/area/ruin/interdyne_planetary_base/main/dorms
	name = "Free Union of Vulken Dormitories"
	icon_state = "crew_quarters"

/area/ruin/interdyne_planetary_base/main/dorms/lib
	name = "Free Union of Vulken Library"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "I love being in the base's library!"
	mood_trait = TRAIT_INTROVERT
	sound_environment = SOUND_AREA_WOODFLOOR

/area/ruin/interdyne_planetary_base/med
	name = "Free Union of Vulken Medical Wing"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "medbay"
	ambience_index = AMBIENCE_MEDICAL

/area/ruin/interdyne_planetary_base/med/pharm
	name = "Free Union of Vulken Pharmacy"
	icon_state = "pharmacy"

/area/ruin/interdyne_planetary_base/med/viro
	name = "Free Union of Vulken Virological Lab"
	icon_state = "virology"
	ambience_index = AMBIENCE_VIROLOGY

/area/ruin/interdyne_planetary_base/med/morgue
	name = "Free Union of Vulken Morgue"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	ambientsounds = list('sound/ambience/ambiicemelody4.ogg') // creepy, but a bit wistful
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ruin/interdyne_planetary_base/science
	name = "Free Union of Vulken Science Wing"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "science"

/area/ruin/interdyne_planetary_base/science/xeno
	name = "Free Union of Vulken Xenobiological Lab"
	icon_state = "xenobio"

/area/ruin/interdyne_planetary_base/serv
	name = "Free Union of Vulken Service Wing"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "hall_service"

/area/ruin/interdyne_planetary_base/serv/rstrm
	name = "Free Union of Vulken Unisex Restrooms"
	icon_state = "toilet"

/area/ruin/interdyne_planetary_base/serv/bar
	name = "Free Union of Vulken Bar"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "I love being in the base's bar!"
	mood_trait = TRAIT_EXTROVERT

/area/ruin/interdyne_planetary_base/serv/kitchen
	name = "Free Union of Vulken Kitchen"
	icon_state = "kitchen"

/area/ruin/interdyne_planetary_base/serv/hydr
	name = "Free Union of Vulken Hydroponics"
	icon_state = "hydro"

/area/ruin/interdyne_planetary_base/eng
	name = "Free Union of Vulken Engineering"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "maint_electrical" // given interdyne's powerplant is rtg's, thought this looked good on the frontend for mappers
	ambient_buzz = 'modular_nova/modules/encounters/sounds/gear_loop.ogg'

/area/ruin/interdyne_planetary_base/eng/Initialize(mapload)
	if(!ambientsounds)
		var/list/temp_ambientsounds = GLOB.ambience_assoc[ambience_index]
		ambientsounds = temp_ambientsounds.Copy()
		ambientsounds += list(
			'sound/items/geiger/low1.ogg',
			'sound/items/geiger/low2.ogg',
		)
	return ..()

/area/ruin/interdyne_planetary_base/eng/disp
	name = "Free Union of Vulken Disposals"
	icon_state = "disposal"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
