/datum/quirk/telepathic
	name = "Telepathic"
	desc = "You are able to transmit your thoughts to other living creatures."
	gain_text = span_purple("Your mind roils with psychic energy.")
	lose_text = span_notice("Mundanity encroaches upon your thoughts once again.")
	medical_record_text = "Patient has an unusually enlarged Broca's area visible in cerebral biology, and appears to be able to communicate via extrasensory means."
	value = 0
	icon = FA_ICON_HEAD_SIDE_COUGH
	/// Ref used to easily retrieve the action used when removing the quirk from silicons
	var/datum/weakref/tele_action_ref

/datum/quirk/telepathic/add(client/client_source)
	if (iscarbon(quirk_holder))
		var/mob/living/carbon/human/human_holder = quirk_holder

		if (!human_holder.dna.activate_mutation(/datum/mutation/human/telepathy))
			human_holder.dna.add_mutation(/datum/mutation/human/telepathy, MUT_OTHER)
	else if (issilicon(quirk_holder))
		var/mob/living/silicon/robot_holder = quirk_holder
		var/datum/action/cooldown/spell/pointed/telepathy/tele_action = new

		tele_action.Grant(robot_holder)
		tele_action_ref = WEAKREF(tele_action)

/datum/quirk/telepathic/remove()
	var/datum/action/cooldown/spell/pointed/telepathy/tele_action = tele_action_ref?.resolve()
	if (isnull(tele_action))
		tele_action_ref = null
	if (iscarbon(quirk_holder))
		var/mob/living/carbon/human/human_holder = quirk_holder
		human_holder.dna.remove_mutation(/datum/mutation/human/telepathy)
	else if (issilicon(quirk_holder) && !isnull(tele_action))
		QDEL_NULL(tele_action)
		tele_action_ref = null

/datum/quirk/psyonaut
	name = "Psyonautic"
	desc = "You are a Psyonaut, one of the rare individuals who have awakened latent psionic abilities. Your mind resonates with the cosmic energies of the universe, granting you access to a spectrum of extraordinary powers. Whether manipulating the void between stars, drawing strength from celestial bodies, or delving into alternate dimensions, your Psionic Potential is a gateway to unlocking the mysteries of the cosmos. Choose your Psyonaut path wisely, for it will shape the nature of your psionic abilities and the role you play in the unfolding saga of the cosmic frontier."
	gain_text = span_purple("Your mind roils with psychic energy.")
	lose_text = span_notice("Mundanity encroaches upon your thoughts once again.")
	value = 0
	icon = FA_ICON_HIVE

/datum/quirk/psyonaut/add()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.dna.add_mutation(/datum/mutation/human/telepathy, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/shock, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/olfaction, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/cryokinesis, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/chameleon, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/geladikinesis, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/cryokinesis, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/firebreath, MUT_OTHER)
	human_holder.dna.add_mutation(/datum/mutation/human/thermal, MUT_OTHER)


/datum/quirk/psyonaut/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.dna.remove_mutation(/datum/mutation/human/telepathy, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/shock, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/olfaction, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/cryokinesis, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/chameleon, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/geladikinesis, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/cryokinesis, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/firebreath, MUT_OTHER)
	human_holder.dna.remove_mutation(/datum/mutation/human/thermal, MUT_OTHER)


/datum/mutation/human/telepathy
	name = "Telepathy"
	desc = "A rare mutation that allows the user to telepathically communicate to others."
	quality = POSITIVE
	text_gain_indication = "<span class='notice'>You can hear your own voice echoing in your mind!</span>"
	text_lose_indication = "<span class='notice'>You don't hear your mind echo anymore.</span>"
	difficulty = 12
	power_path = /datum/action/cooldown/spell/list_target/telepathy
	instability = 10
	energy_coeff = 1

/datum/brain_trauma/very_special/bimbo
