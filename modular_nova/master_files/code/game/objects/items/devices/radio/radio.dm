 /// DS-2 & Free Union of Vulken silicon radios

/obj/item/radio/borg/syndicate/ghost_role // ds2 and interdyne since they both use non-antag Free Union of Vulken freq
	name = "\proper Suspicious Integrated Subspace Transceiver "
	syndie = TRUE
	keyslot = /obj/item/encryptionkey/headset_syndicate/interdyne

/obj/item/radio/borg/syndicate/ghost_role/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_INTERDYNE)
