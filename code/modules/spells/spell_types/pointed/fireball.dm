/datum/action/cooldown/spell/pointed/projectile/fireball
	name = "Pyrokinesis"
	desc = "This focus fires an explosive pyroall at a target."
	button_icon_state = "fireball0"

	sound = 'sound/magic/fireball.ogg'
	school = SCHOOL_EVOCATION
	cooldown_time = 50 SECONDS
	cooldown_reduction_per_rank = 1 SECONDS // 1 second reduction per rank

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	active_msg = "You prepare to cast your pyrokinetic flame!"
	deactive_msg = "You extinguish your fireball... for now."
	cast_range = 8
	projectile_type = /obj/projectile/magic/fireball

/datum/action/cooldown/spell/pointed/projectile/fireball/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.range = (6 + 2 * spell_level)
