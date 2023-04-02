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

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Possess Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release()
	set name = "Release Obj"
	set category = "Object"

	qdel(usr.GetComponent(/datum/component/object_possession))
	BLACKBOX_LOG_ADMIN_VERB("Release Object")
