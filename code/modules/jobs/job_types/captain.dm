/datum/job/captain
	title = JOB_CAPTAIN
	description = "You are the the owner of the colony. Self-explanatory."
	faction = FACTION_NONE
	total_positions = 1
	spawn_positions = 1
	supervisors = "Yourself"
	config_tag = "CAPTAIN"

	outfit = /datum/outfit/job/captain
	plasmaman_outfit = /datum/outfit/plasmaman/captain

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_CMD // NOVA EDIT - Original: paycheck_department = ACCOUNT_SEC

	mind_traits = list(HEAD_OF_STAFF_MIND_TRAITS)
	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	department_for_prefs = /datum/job_department/captain
	departments_list = list(
		/datum/job_department/command,
	)

	family_heirlooms = list(/obj/item/reagent_containers/cup/glass/flask/gold, /obj/item/toy/captainsaid/collector)

	mail_goodies = list(
		/obj/item/clothing/mask/cigarette/cigar/havana = 20,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 15,
		/obj/item/reagent_containers/cup/glass/bottle/champagne = 5,
		/obj/item/reagent_containers/cup/glass/bottle/champagne/cursed = 5,
		/obj/item/toy/captainsaid/collector = 20,
		/obj/item/skillchip/sabrage = 5,
	)

	job_flags = STATION_JOB_FLAGS | HEAD_OF_STAFF_JOB_FLAGS
	rpg_title = "Star Duke"

	voice_of_god_power = 1.4 //Command staff has authority


/datum/job/captain/get_captaincy_announcement(mob/living/captain)
	return "Colony Caretaker [captain.real_name] on deck!"

/datum/job/captain/get_radio_information()
	. = ..()
	. += "\nYou have access to all radio channels, but they are not automatically tuned. Check your radio for more information."

/datum/outfit/job/captain
	name = "Colony Caretaker"
	jobtype = /datum/job/captain

	id = /obj/item/card/id/advanced/gold
	id_trim = /datum/id_trim/job/captain
	uniform = /obj/item/clothing/under/rank/captain
	suit = /obj/item/clothing/suit/armor/vest/capcarapace
	backpack_contents = list(
		/obj/item/melee/baton/telescopic = 1,
		/obj/item/station_charter = 1,
		)
	belt = /obj/item/modular_computer/pda/heads/captain
	ears = /obj/item/radio/headset/heads/captain/alt
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/captain
	head = /obj/item/clothing/head/hats/caphat
	shoes = /obj/item/clothing/shoes/laceup


	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	duffelbag = /obj/item/storage/backpack/duffelbag/captain
	messenger = /obj/item/storage/backpack/messenger/cap

	accessory = /obj/item/clothing/accessory/medal/gold/captain
	chameleon_extras = list(
		/obj/item/gun/energy/e_gun,
		/obj/item/stamp/head/captain,
		)
	implants = list(/obj/item/implant/mindshield)
	skillchips = list(/obj/item/skillchip/disk_verifier)

	var/special_charter

/datum/outfit/job/captain/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	special_charter = CHECK_MAP_JOB_CHANGE(JOB_CAPTAIN, "special_charter")
	if(!special_charter)
		return

	backpack_contents -= /obj/item/station_charter

	if(!l_hand)
		l_hand = /obj/item/station_charter/banner
	else if(!r_hand)
		r_hand = /obj/item/station_charter/banner

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/equipped, visualsOnly)
	. = ..()
	if(visualsOnly || !special_charter)
		return

	var/obj/item/station_charter/banner/celestial_charter = locate() in equipped.held_items
	if(isnull(celestial_charter))
		// failed to give out the unique charter, plop on the ground
		celestial_charter = new(get_turf(equipped))

	celestial_charter.name_type = special_charter

/datum/outfit/job/captain/mod
	name = "Colony Caretaker (MODsuit)"

	suit_store = /obj/item/tank/internals/oxygen
	back = /obj/item/mod/control/pre_equipped/magnate
	suit = null
	head = null
	mask = /obj/item/clothing/mask/gas/atmos/captain
	internals_slot = ITEM_SLOT_SUITSTORE


/datum/job/captain/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(!ishuman(spawned))
		return
	var/mob/living/carbon/human/human_spawned = spawned
	var/obj/item/book/bible/booze/holy_bible = new
	if(GLOB.religion)
		if(human_spawned.mind)
			human_spawned.mind.holy_role = HOLY_ROLE_PRIEST
		holy_bible.deity_name = GLOB.deity
		holy_bible.name = GLOB.bible_name
		// These checks are important as there's no guarantee the "HOLY_ROLE_HIGHPRIEST" captain has selected a bible skin.
		if(GLOB.bible_icon_state)
			holy_bible.icon_state = GLOB.bible_icon_state
		if(GLOB.bible_inhand_icon_state)
			holy_bible.inhand_icon_state = GLOB.bible_inhand_icon_state
		to_chat(human_spawned, span_boldnotice("There is already an established religion onboard the station. You are an acolyte of [GLOB.deity]. Defer to them."))
		human_spawned.equip_to_slot_or_del(holy_bible, ITEM_SLOT_BACKPACK, indirect_action = TRUE)
		var/nrt = GLOB.holy_weapon_type || /obj/item/nullrod
		var/obj/item/nullrod/nullrod = new nrt(human_spawned)
		human_spawned.put_in_hands(nullrod)
		if(GLOB.religious_sect)
			GLOB.religious_sect.on_conversion(human_spawned)
		return
	if(human_spawned.mind)
		human_spawned.mind.holy_role = HOLY_ROLE_HIGHPRIEST

	var/new_religion = player_client?.prefs?.read_preference(/datum/preference/name/religion) || DEFAULT_RELIGION
	var/new_deity = player_client?.prefs?.read_preference(/datum/preference/name/deity) || DEFAULT_DEITY
	var/new_bible = player_client?.prefs?.read_preference(/datum/preference/name/bible) || DEFAULT_BIBLE

	holy_bible.deity_name = new_deity
	switch(lowertext(new_religion))
		if("homosexuality", "gay", "penis", "ass", "cock", "cocks")
			new_bible = pick("Guys Gone Wild","Coming Out of The Closet","War of Cocks")
			switch(new_bible)
				if("War of Cocks")
					holy_bible.deity_name = pick("Dick Powers", "King Cock")
				else
					holy_bible.deity_name = pick("Gay Space Jesus", "Gandalf", "Dumbledore")
			human_spawned.adjustOrganLoss(ORGAN_SLOT_BRAIN, 100) // starts off brain damaged as fuck
		if("lol", "wtf", "poo", "badmin", "shitmin", "deadmin", "meme", "memes")
			new_bible = pick("Woody's Got Wood: The Aftermath", "Sweet Bro and Hella Jeff: Expanded Edition","F.A.T.A.L. Rulebook")
			switch(new_bible)
				if("Woody's Got Wood: The Aftermath")
					holy_bible.deity_name = pick("Woody", "Andy", "Cherry Flavored Lube")
				if("Sweet Bro and Hella Jeff: Expanded Edition")
					holy_bible.deity_name = pick("Sweet Bro", "Hella Jeff", "Stairs", "AH")
				if("F.A.T.A.L. Rulebook")
					holy_bible.deity_name = "Twenty Ten-Sided Dice"
			human_spawned.adjustOrganLoss(ORGAN_SLOT_BRAIN, 100) // also starts off brain damaged as fuck
		if("servicianism", "partying")
			holy_bible.desc = "Happy, Full, Clean. Live it and give it."
		if("weeaboo","kawaii")
			new_bible = pick("Fanfiction Compendium","Japanese for Dummies","The Manganomicon","Establishing Your O.T.P")
			holy_bible.deity_name = "Anime"
		else
			if(new_bible == DEFAULT_BIBLE)
				new_bible = DEFAULT_BIBLE_REPLACE(new_bible)

	holy_bible.name = new_bible

	GLOB.religion = new_religion
	GLOB.bible_name = new_bible
	GLOB.deity = holy_bible.deity_name

	human_spawned.equip_to_slot_or_del(holy_bible, ITEM_SLOT_BACKPACK, indirect_action = TRUE)

	SSblackbox.record_feedback("text", "religion_name", 1, "[new_religion]", 1)
	SSblackbox.record_feedback("text", "religion_deity", 1, "[new_deity]", 1)
	SSblackbox.record_feedback("text", "religion_bible", 1, "[new_bible]", 1)
