/proc/possess(obj/target in world)
	set name = "Possess Obj"
	set category = "Object"

	var/result = usr.AddComponent(/datum/component/object_possession, target)

	if(isnull(result)) // trigger a safety movement just in case we yonk
		usr.forceMove(get_turf(usr))
		return

	var/turf/target_turf = get_turf(target)
	var/message = "[key_name(usr)] has possessed [target] ([target.type]) at [AREACOORD(target_turf)]"
	message_admins(message)
	log_admin(message)

	BLACKBOX_LOG_ADMIN_VERB("Possess Object")
	if(T)
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at [AREACOORD(T)]")
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at [AREACOORD(T)]")
	else
		log_admin("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location")
		message_admins("[key_name(usr)] has possessed [O] ([O.type]) at an unknown location")

	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.forceMove(O)
	usr.real_name = O.name
	usr.name = O.name
	usr.reset_perspective(O)
	usr.control_object = O
	O.AddElement(/datum/element/weather_listener, /datum/weather/ash_storm, GLOB.ash_storm_sounds)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Possess Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release()
	set name = "Release Obj"
	set category = "Object"

	qdel(usr.GetComponent(/datum/component/object_possession))
	BLACKBOX_LOG_ADMIN_VERB("Release Object")

/proc/give_possession_verbs(mob/dude in GLOB.mob_list)
	if(usr.name_archive) //if you have a name archived
		usr.real_name = usr.name_archive
		usr.name_archive = ""
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()

	usr.control_object.RemoveElement(/datum/element/weather_listener, /datum/weather/ash_storm, GLOB.ash_storm_sounds)
	usr.forceMove(get_turf(usr.control_object))
	usr.reset_perspective()
	usr.control_object = null
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Release Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/givetestverbs(mob/M in GLOB.mob_list)
	set desc = "Give this guy possess/release verbs"
	set category = "Debug"
	set name = "Give Possessing Verbs"

	add_verb(dude, GLOBAL_PROC_REF(possess))
	add_verb(dude, GLOBAL_PROC_REF(release))
	BLACKBOX_LOG_ADMIN_VERB("Give Possessing Verbs")
