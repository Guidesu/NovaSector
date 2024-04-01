/datum/space_level
	var/list/all_extensions = list()

#define TOOL_ACT_TOOLTYPE_SUCCESS (1<<0)

/datum/shuttle_extension
	var/name = "Extension"
	var/applied = FALSE
	var/datum/overmap_object/shuttle/overmap_object
	var/obj/docking_port/mobile/shuttle
	var/datum/space_level/z_level
	var/list/all_extensions = list()

/datum/shuttle_extension/proc/ApplyToPosition(turf/position)
	if(IsApplied())
		return
	if(SSshuttle.is_in_shuttle_bounds(position))
		var/obj/docking_port/mobile/M = SSshuttle.get_containing_shuttle(position)
		if(M)
			AddToShuttle(M)
	else
		var/datum/space_level/level = SSmapping.z_list[position.z]
		if(level && level.related_overmap_object && level.is_overmap_controllable)
			AddToZLevel(level)

/datum/shuttle_extension/proc/IsApplied()
	return (overmap_object || shuttle || z_level)

/datum/shuttle_extension/proc/AddToZLevel(datum/space_level/z_level_to_add)
	if(z_level)
		WARNING("Shuttle extension registered to a z level, while already registered to one")
		return
	z_level = z_level_to_add
	z_level.all_extensions += src
	if(z_level.related_overmap_object && z_level.is_overmap_controllable)
		AddToOvermapObject(z_level.related_overmap_object)

/datum/shuttle_extension/proc/RemoveFromZLevel()
	if(z_level.related_overmap_object)
		RemoveFromOvermapObject()
	z_level.all_extensions -= src
	z_level = null

/datum/shuttle_extension/proc/AddToShuttle(obj/docking_port/mobile/shuttle_to_add)
	if(shuttle)
		WARNING("Shuttle extension registered to a shuttle, while already registered to one")
		return
	shuttle = shuttle_to_add
	shuttle.all_extensions += src
	if(shuttle.my_overmap_object)
		AddToOvermapObject(shuttle.my_overmap_object)

/datum/shuttle_extension/proc/RemoveFromShuttle()
	if(shuttle.my_overmap_object)
		RemoveFromOvermapObject()
	shuttle.all_extensions -= src
	shuttle = null

/datum/shuttle_extension/proc/AddToOvermapObject(datum/overmap_object/shuttle/object_to_add)
	if(overmap_object)
		WARNING("Shuttle extension registered to overmap object, while already registered to one")
		return
	overmap_object = object_to_add
	overmap_object.all_extensions += src

/datum/shuttle_extension/proc/RemoveFromOvermapObject()
	overmap_object.all_extensions -= src
	overmap_object = null

/datum/shuttle_extension/proc/RemoveExtension()
	if(z_level)
		RemoveFromZLevel()
	else if(shuttle)
		RemoveFromShuttle()
	else if(overmap_object) //Implies that it's non physical and abstracct if it doesnt have a shuttle but has this
		RemoveFromOvermapObject()

/datum/shuttle_extension/Destroy()
	RemoveExtension()
	return ..()

/datum/shuttle_extension/engine
	name = "Engine"
	var/current_fuel = 100
	var/maximum_fuel = 100
	var/current_efficiency = 1
	var/granted_speed = 0.35
	var/minimum_fuel_to_operate = 1
	var/turned_on = FALSE
	var/cap_speed_multiplier = 5

/datum/shuttle_extension/engine/proc/UpdateFuel()
	return

/datum/shuttle_extension/engine/proc/CanOperate()
	if(!turned_on)
		return
	if(current_fuel < minimum_fuel_to_operate)
		return FALSE
	return TRUE

/datum/shuttle_extension/engine/proc/GetCapSpeed(impulse_percent)
	return granted_speed * impulse_percent * current_efficiency * cap_speed_multiplier

/datum/shuttle_extension/engine/proc/DrawThrust(impulse_percent)
	return granted_speed * impulse_percent * current_efficiency

/datum/shuttle_extension/engine/AddToOvermapObject(datum/overmap_object/shuttle/object_to_add)
	. = ..()
	overmap_object.engine_extensions += src

/datum/shuttle_extension/engine/RemoveFromOvermapObject()
	overmap_object.engine_extensions -= src
	..()

/datum/shuttle_extension/engine/AddToShuttle(obj/docking_port/mobile/shuttle_to_add)
	..()
	shuttle.engine_extensions += src

/datum/shuttle_extension/engine/RemoveFromShuttle()
	shuttle.engine_extensions -= src
	..()

/datum/shuttle_extension/engine/burst
	name = "Burst Engine"
	///Reference to the physical engine, we'll need to bother it to draw our thrust, just for the effect.
	var/obj/structure/shuttle/engine/our_engine

/datum/shuttle_extension/engine/burst/New(obj/structure/shuttle/engine/passed_engine)
	. = ..()
	our_engine = passed_engine

/datum/shuttle_extension/engine/burst/DrawThrust(impulse_percent)
	if(our_engine)
		our_engine.DrawThrust()
	return ..()

/datum/shuttle_extension/engine/propulsion
	name = "Propulsion Engine"
	///Reference to the physical engine, we'll need to bother it to draw our thrust.
	var/obj/machinery/atmospherics/components/unary/engine/our_engine

/datum/shuttle_extension/engine/propulsion/New(obj/machinery/atmospherics/components/unary/engine/passed_engine)
	. = ..()
	our_engine = passed_engine

/datum/shuttle_extension/engine/propulsion/Destroy()
	our_engine = null
	return ..()

/datum/shuttle_extension/engine/propulsion/UpdateFuel()
	if(our_engine)
		current_fuel = our_engine.GetCurrentFuel()

/datum/shuttle_extension/engine/propulsion/DrawThrust(impulse_percent)
	var/engine_multiplier = 1
	if(our_engine)
		engine_multiplier = our_engine.DrawThrust(impulse_percent * current_efficiency)
	return granted_speed * impulse_percent * current_efficiency * engine_multiplier

/datum/shuttle_extension/shield
	name = "Shield Generator"
	var/on = FALSE
	var/maximum_shield = 100
	var/current_shield = 0
	var/shield_per_process = 0.20
	var/maximum_buffer = 80
	var/current_buffer = 0
	var/buffer_per_process = 0.15
	var/max_buffer_drain = 10
	var/obj/machinery/shield_generator/my_generator
	var/next_operable_time = 0
	var/operable = TRUE

/datum/shuttle_extension/shield/proc/is_functioning()
	if(operable && on)
		return TRUE

/datum/shuttle_extension/shield/proc/take_damage(damage)
	if(!damage)
		return
	current_shield -= damage
	if(!current_shield)
		make_inoperable()

/datum/shuttle_extension/shield/proc/make_inoperable(inform = TRUE)
	current_shield = 0
	current_buffer = 0
	operable = FALSE
	next_operable_time = world.time + 1 MINUTES
	if(inform && overmap_object)
		overmap_object.inform_shields_down()

/datum/shuttle_extension/shield/AddToOvermapObject(datum/overmap_object/shuttle/object_to_add)
	. = ..()
	overmap_object.shield_extensions += src

/datum/shuttle_extension/shield/RemoveFromOvermapObject()
	overmap_object.shield_extensions -= src
	..()

/datum/shuttle_extension/shield/process(delta_time)
	if(my_generator && my_generator.machine_stat & NOPOWER)
		return
	if(!operable)
		if(world.time > next_operable_time)
			operable = TRUE
			if(on && overmap_object)
				overmap_object.inform_shields_up()
		else
			return
	if(on)
		var/charge_to_gain = shield_per_process
		//Draw power from the shield buffer
		if(current_buffer)
			var/drain = max_buffer_drain
			if(drain > current_buffer)
				drain = current_buffer
			current_buffer -= drain
			charge_to_gain += drain
		current_shield += charge_to_gain
		current_shield = min(current_shield, maximum_shield)
	else
		//If the shield generator is off, but has power, it generates a buffer
		if(current_buffer == maximum_buffer)
			return
		current_buffer += buffer_per_process
		current_buffer = min(current_buffer, maximum_buffer)

/datum/shuttle_extension/shield/proc/turn_on()
	if(on)
		return
	if(my_generator && my_generator.machine_stat & NOPOWER)
		return
	on = TRUE
	if(operable && overmap_object)
		overmap_object.inform_shields_up()

/datum/shuttle_extension/shield/proc/turn_off(malfunction = FALSE)
	if(!on)
		return
	on = FALSE
	if(malfunction)
		make_inoperable(FALSE)
	else
		//Half of the shields is added to the buffer when voluntairly turned off
		var/buffer_to_add = current_shield/2
		current_shield = 0
		current_buffer += buffer_to_add
		current_buffer = min(current_buffer, maximum_buffer)
	if(operable && overmap_object)
		overmap_object.inform_shields_down()

/datum/shuttle_extension/transporter
	name = "Transporter"
	var/transporter_progress = 0
	var/progress_to_success = 10
	///Reference to the physical transporter
	var/obj/machinery/transporter/our_machine

/datum/shuttle_extension/transporter/New(obj/machinery/transporter/passed_machine)
	. = ..()
	our_machine = passed_machine

/datum/shuttle_extension/transporter/Destroy()
	our_machine = null
	return ..()

/datum/shuttle_extension/transporter/AddToOvermapObject(datum/overmap_object/shuttle/object_to_add)
	. = ..()
	overmap_object.transporter_extensions += src

/datum/shuttle_extension/transporter/RemoveFromOvermapObject()
	overmap_object.transporter_extensions -= src
	..()

/datum/shuttle_extension/transporter/proc/CanTransport()
	if(!overmap_object.lock)
		return FALSE
	var/datum/overmap_object/target = overmap_object.lock.target
	if(TWO_POINT_DISTANCE_OV(overmap_object,target) < 1)
		return TRUE
	return FALSE

/datum/shuttle_extension/transporter/proc/ProcessTransport()
	transporter_progress++
	if(transporter_progress >= progress_to_success)
		var/turf/destination = null
		if(our_machine)
			destination = get_turf(our_machine)
			do_sparks(3, TRUE, destination)
		overmap_object.lock.target.DoTransport(destination)
		transporter_progress = 0
		return TRUE
	return FALSE

/datum/shuttle_extension/weapon
	name = "Weapon"
	var/next_fire = 0
	var/fire_cooldown = 3 SECONDS

/datum/shuttle_extension/weapon/AddToOvermapObject(datum/overmap_object/shuttle/object_to_add)
	. = ..()
	overmap_object.weapon_extensions += src

/datum/shuttle_extension/weapon/RemoveFromOvermapObject()
	overmap_object.weapon_extensions -= src
	..()

/datum/shuttle_extension/weapon/proc/PostFire(datum/overmap_object/target)
	return

/datum/shuttle_extension/weapon/proc/Fire(datum/overmap_object/target)
	next_fire = world.time + fire_cooldown
	PostFire(target)

/datum/shuttle_extension/weapon/proc/CanFire(datum/overmap_object/target)
	if(next_fire > world.time)
		return FALSE
	if(TWO_POINT_DISTANCE_OV(overmap_object,target) >= 1)
		return FALSE
	return TRUE

/datum/shuttle_extension/weapon/mining_laser
	name = "Mining Laser"
	///Reference to the physical weapon machine
	var/obj/machinery/mining_laser/our_laser

/datum/shuttle_extension/weapon/mining_laser/New(obj/machinery/mining_laser/passed_machine)
	. = ..()
	our_laser = passed_machine

/datum/shuttle_extension/weapon/mining_laser/Destroy()
	our_laser = null
	return ..()

/datum/shuttle_extension/weapon/mining_laser/Fire(datum/overmap_object/target)
	. = ..()
	new /datum/overmap_object/projectile/damaging/mining(overmap_object.current_system, overmap_object.x, overmap_object.y, overmap_object.partial_x, overmap_object.partial_y, overmap_object, target)

/datum/shuttle_extension/weapon/mining_laser/PostFire(datum/overmap_object/target)
	if(our_laser)
		our_laser.PostFire()



#define ENGINE_UNWRENCHED 0
#define ENGINE_WRENCHED 1
#define ENGINE_WELDED 2
///How long it takes to weld/unweld an engine in place.
#define ENGINE_WELDTIME (20 SECONDS)

/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	smoothing_groups = list(SMOOTH_GROUP_SHUTTLE_PARTS)
	max_integrity = 500


/obj/structure/shuttle/engine
	name = "engine"
	desc = "A bluespace engine used to make shuttles move."
	density = TRUE
	anchored = TRUE

	///How well the engine affects the ship's speed.
	var/engine_power = 1
	///Construction state of the Engine.
	var/engine_state = ENGINE_WELDED //welding shmelding
	var/extension_type = /datum/shuttle_extension/engine/burst
	var/datum/shuttle_extension/engine/extension

	///The mobile ship we are connected to.
	var/datum/weakref/connected_ship_ref

/obj/structure/shuttle/engine/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	if(!port)
		return FALSE
	connected_ship_ref = WEAKREF(port)
	port.engine_list += src
	port.current_engine_power += engine_power
	if(mapload)
		port.initial_engine_power += engine_power

/obj/structure/shuttle/engine/Destroy()
	if(engine_state == ENGINE_WELDED)
		alter_engine_power(-engine_power)
		RemoveExtension()
	unsync_ship()
	if(extension)
		qdel(extension)
	return ..()

/**
 * Called on destroy and when we need to unsync an engine from their ship.
 */
/obj/structure/shuttle/engine/proc/unsync_ship()
	var/obj/docking_port/mobile/port = connected_ship_ref?.resolve()
	if(port)
		port.engine_list -= src
		port.current_engine_power -= initial(engine_power)
	connected_ship_ref = null

/obj/structure/shuttle/engine/Initialize()
	. = ..()
	if(engine_state == ENGINE_WELDED)
		AddComponent(/datum/component/engine_effect)
		if(extension_type)
			extension = new extension_type()
			ApplyExtension()

/obj/structure/shuttle/engine/proc/DrawThrust()
	SEND_SIGNAL(src, COMSIG_ENGINE_DRAWN_POWER)

/obj/structure/shuttle/engine/proc/ApplyExtension()
	if(!extension)
		return
	if(SSshuttle.is_in_shuttle_bounds(src))
		var/obj/docking_port/mobile/M = SSshuttle.get_containing_shuttle(src)
		if(M)
			extension.AddToShuttle(M)
	else
		var/datum/space_level/level = SSmapping.z_list[z]
		if(level && level.related_overmap_object && level.is_overmap_controllable)
			extension.AddToZLevel(level)

/obj/structure/shuttle/engine/proc/RemoveExtension()
	if(!extension)
		return
	extension.RemoveExtension()

//Ugh this is a lot of copypasta from emitters, welding need some boilerplate reduction
/obj/structure/shuttle/engine/can_be_unfasten_wrench(mob/user, silent)
	if(engine_state == ENGINE_WELDED)
		if(!silent)
			to_chat(user, span_warning("[src] is welded to the floor!"))
		return FAILED_UNFASTEN
	return ..()

/obj/structure/shuttle/engine/default_unfasten_wrench(mob/user, obj/item/tool, time = 20)
	. = ..()
	if(. == SUCCESSFUL_UNFASTEN)
		if(anchored)
			connect_to_shuttle(port = SSshuttle.get_containing_shuttle(src)) //connect to a new ship, if needed
			engine_state = ENGINE_WRENCHED
		else
			unsync_ship() //not part of the ship anymore
			engine_state = ENGINE_UNWRENCHED

/obj/structure/shuttle/engine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/shuttle/engine/welder_act(mob/living/user, obj/item/tool)
	. = ..()
	switch(engine_state)
		if(ENGINE_UNWRENCHED)
			to_chat(user, span_warning("The [src.name] needs to be wrenched to the floor!"))
		if(ENGINE_WRENCHED)
			if(!tool.tool_start_check(user, amount=0))
				return TRUE

			user.visible_message(span_notice("[user.name] starts to weld the [name] to the floor."), \
				span_notice("You start to weld \the [src] to the floor..."), \
				span_hear("You hear welding."))

			if(tool.use_tool(src, user, ENGINE_WELDTIME, volume=50))
				engine_state = ENGINE_WELDED
				to_chat(user, span_notice("You weld \the [src] to the floor."))
				alter_engine_power(engine_power)
				ApplyExtension()

		if(ENGINE_WELDED)
			if(!tool.tool_start_check(user, amount=0))
				return TRUE

			user.visible_message(span_notice("[user.name] starts to cut the [name] free from the floor."), \
				span_notice("You start to cut \the [src] free from the floor..."), \
				span_hear("You hear welding."))

			if(tool.use_tool(src, user, ENGINE_WELDTIME, volume=50))
				engine_state = ENGINE_WRENCHED
				to_chat(user, span_notice("You cut \the [src] free from the floor."))
				alter_engine_power(-engine_power)
				RemoveExtension()
	return TRUE

//Propagates the change to the shuttle.
/obj/structure/shuttle/engine/proc/alter_engine_power(mod)
	if(!mod)
		return
	var/obj/docking_port/mobile/port = connected_ship_ref?.resolve()
	if(port)
		port.alter_engines(mod)

/obj/structure/shuttle/engine/heater
	name = "engine heater"
	icon_state = "heater"
	desc = "Directs energy into compressed particles in order to power engines."
	engine_power = 0 // todo make these into 2x1 parts
	extension_type = null

/obj/structure/shuttle/engine/platform
	name = "engine platform"
	icon_state = "platform"
	desc = "A platform for engine components."
	engine_power = 0
	extension_type = null

/obj/structure/shuttle/engine/propulsion
	name = "propulsion engine"
	icon_state = "propulsion"
	desc = "A standard reliable bluespace engine used by many forms of shuttles."
	opacity = TRUE

/obj/structure/shuttle/engine/propulsion/in_wall
	name = "in-wall propulsion engine"
	icon_state = "propulsion_w"
	density = FALSE
	opacity = FALSE
	smoothing_groups = list()

/obj/structure/shuttle/engine/propulsion/left
	name = "left propulsion engine"
	icon_state = "propulsion_l"

/obj/structure/shuttle/engine/propulsion/right
	name = "right propulsion engine"
	icon_state = "propulsion_r"

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst engine"
	desc = "An engine that releases a large bluespace burst to propel it."

/obj/structure/shuttle/engine/propulsion/burst/cargo
	engine_state = ENGINE_UNWRENCHED
	anchored = FALSE

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left burst engine"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right burst engine"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "engine router"
	icon_state = "router"
	desc = "Redirects around energized particles in engine structures."
	extension_type = null

/obj/structure/shuttle/engine/large
	name = "engine"
	icon = 'icons/obj/2x2.dmi'
	icon_state = "large_engine"
	desc = "A very large bluespace engine used to propel very large ships."
	opacity = TRUE
	bound_width = 64
	bound_height = 64
	appearance_flags = LONG_GLIDE

/obj/structure/shuttle/engine/large/in_wall
	name = "in-wall engine"
	icon_state = "large_engine_w"
	density = FALSE
	opacity = FALSE
	smoothing_groups = list()

/obj/structure/shuttle/engine/huge
	name = "engine"
	icon = 'icons/obj/3x3.dmi'
	icon_state = "huge_engine"
	desc = "An extremely large bluespace engine used to propel extremely large ships."
	opacity = TRUE
	bound_width = 96
	bound_height = 96
	appearance_flags = LONG_GLIDE

/obj/structure/shuttle/engine/huge/in_wall
	name = "in-wall engine"
	icon_state = "huge_engine_w"
	density = FALSE
	opacity = FALSE
	smoothing_groups = list()

#undef ENGINE_UNWRENCHED
#undef ENGINE_WRENCHED
#undef ENGINE_WELDED
#undef ENGINE_WELDTIME
