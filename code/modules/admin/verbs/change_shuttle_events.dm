///Manipulate the events that are gonna run/are running on the escape shuttle
/datum/admins/proc/change_shuttle_events()
	set category = "Admin.Events"
	set name = "Change Shuttle Events"
	set desc = "Allows you to change the events on a shuttle."

	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!", confidential = TRUE)
		return

	//At least for now, just letting admins modify the emergency shuttle is fine
	var/obj/docking_port/mobile/port = SSshuttle.emergency

	if(!port)
		to_chat(usr, span_admin("Uh oh, couldn't find the escape shuttle!"))
