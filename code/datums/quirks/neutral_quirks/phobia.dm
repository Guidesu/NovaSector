/datum/quirk/phobia
	name = "Phobia"
	desc = "You are irrationally afraid of something."
	icon = FA_ICON_SPIDER
	value = 0
	medical_record_text = "Patient has an irrational fear of something."
	mail_goodies = list(/obj/item/clothing/glasses/blindfold, /obj/item/storage/pill_bottle/psicodine)

/datum/quirk_constant_data/phobia
	associated_typepath = /datum/quirk/phobia
	customization_options = list(/datum/preference/choiced/phobia)

// Phobia will follow you between transfers
/datum/quirk/phobia/add(client/client_source)
	var/phobia = client_source?.prefs.read_preference(/datum/preference/choiced/phobia)
	if(!phobia)
		return

	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(new /datum/brain_trauma/mild/phobia(phobia), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/nymphomania
	name = "Nynmphomania"
	desc = "You are irrationally nymphomaniac. At least it is something you can manage."
	icon = FA_ICON_SHIRT
	value = 0
	medical_record_text = "Patient has an irrational fear of something."
	mail_goodies = list(/obj/item/clothing/sextoy/dildo)

/datum/quirk/nymphomania/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(new /datum/brain_trauma/very_special/bimbo, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/nymphomania/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/very_special/bimbo, TRAUMA_RESILIENCE_ABSOLUTE)
