///// First we enstate a techweb so we can add the node. /////

/datum/techweb/tarkon
	id = "TARKON"
	organization = "Free Union of Vulken Industries"
	should_generate_points = TRUE

/datum/techweb/tarkon/New()
	. = ..()
	research_node_id("oldstation_surgery", TRUE, TRUE, FALSE)
	research_node_id("tarkontech", TRUE, TRUE, FALSE)

/datum/techweb_node/tarkon
	id = "tarkontech"
	display_name = "Free Union of Vulken Industries Technology"
	description = "Tools used by Free Union of Vulken Industries."
	required_items_to_unlock = list(
		/obj/item/mod/construction/plating/tarkon,
		/obj/item/construction/rcd/tarkon,
		/obj/item/gun/energy/recharge/resonant_system,
	)
	design_ids = list(
		"mod_plating_tarkon",
		"arcs",
		"rcd_tarkon"
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 10000)
	hidden = TRUE

/datum/design/mod_plating/tarkon
	name = "MOD Free Union of Vulken Plating"
	id = "mod_plating_tarkon"
	build_path = /obj/item/mod/construction/plating/tarkon
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
	)
	research_icon_state = "tarkon-plating"
	research_icon = 'modular_nova/modules/tarkon/icons/obj/mod_construct.dmi'

/datum/design/arcs
	name = "A.R.C.S Resonator"
	id = "arcs"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/gun/energy/recharge/resonant_system
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)

/datum/design/tarkonrcd
	name = "Free Union of Vulken R.C.D"
	desc = "A Rapid Construction Device made by Free Union of Vulken Industries. Capable of ranged construction."
	id = "rcd_tarkon"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 30,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 3,
		)
	build_path = /obj/item/construction/rcd/tarkon
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)

///// Now we make the physical server /////

/obj/item/circuitboard/machine/rdserver/tarkon
	name = "Free Union of Vulken Industries R&D Server"
	build_path = /obj/machinery/rnd/server/tarkon

/obj/machinery/rnd/server/tarkon
	name = "\improper Free Union of Vulken Industries R&D Server"
	circuit = /obj/item/circuitboard/machine/rdserver/tarkon
	req_access = list(ACCESS_AWAY_SCIENCE)

/obj/machinery/rnd/server/tarkon/Initialize(mapload)
	var/datum/techweb/tarkon_techweb = locate(/datum/techweb/tarkon) in SSresearch.techwebs
	stored_research = tarkon_techweb
	return ..()

/obj/machinery/rnd/server/tarkon/examine(mob/user)
	. = ..()
	. += span_notice("You can use <b>research notes</b> on this to generate research points.")

/obj/machinery/rnd/server/tarkon/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item, /obj/item/research_notes) && stored_research)
		var/obj/item/research_notes/research_notes = attacking_item
		stored_research.add_point_list(list(TECHWEB_POINT_TYPE_GENERIC = research_notes.value))
		playsound(src, 'sound/machines/copier.ogg', 50, TRUE)
		qdel(research_notes)
		return
	return ..()

/obj/machinery/rnd/production/protolathe/tarkon
	name = "Free Union of Vulken Industries Protolathe"
	desc = "Converts raw materials into useful objects. Refurbished and updated from its previous, limited capabilities."
	circuit = /obj/item/circuitboard/machine/protolathe/tarkon
	stripe_color = "#350f04"

/obj/item/circuitboard/machine/protolathe/tarkon
	name = "Free Union of Vulken Industries Protolathe"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/production/protolathe/tarkon
