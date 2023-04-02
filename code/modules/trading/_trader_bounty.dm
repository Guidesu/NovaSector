/datum/trader_bounty
	/// Name of the bounty
	var/bounty_name = "Epic Items Bounty Quest"
	/// Name of the requested item, if none set it'll be autogenerated
	var/name
	/// Amount of requested items
	var/amount = 1
	/// Whether to check type for the item, if FALSE, make sure your subtype is checking the item in IsValid()
	var/check_type = TRUE
	/// Type path of the requested item
	var/path
	/// List of possible paths
	var/list/possible_paths
	/// Reward for the bounty in cash, wont appear in UI or paper if 0
	var/reward_cash = 1000
	/// Name of the reward item, if any, autogenerated if not set
	var/reward_item_name
	/// Path of the reward item, if any
	var/reward_item_path
	/// Possible paths of the reward items
	var/list/possible_reward_item_paths
	/// The dialogue the trader shows for this bounty
	var/bounty_text = "I'm looking to acquire a couple of this exotic item."
	/// The dialogue the trader shows after completing the bounty
	var/bounty_complete_text = "Thank you very much for getting me those."
	/// Whether this bounty is a supplies bounty.
	var/supplies_bounty = FALSE

/datum/trader_bounty/New()
	. = ..()
	if(possible_paths)
		path = pick(possible_paths)
		possible_paths = null
	if(!name)
		var/atom/movable/cast = path
		name = initial(cast.name)
	if(possible_reward_item_paths)
		reward_item_path = pick(possible_reward_item_paths)
		possible_reward_item_paths = null
	if(reward_item_path && !reward_item_name)
		var/atom/movable/cast = reward_item_path
		reward_item_name = initial(cast.name)

/datum/trader_bounty/proc/Validate(atom/movable/movable_to_valid)
	if((!check_type || movable_to_valid.type == path) && IsValid(movable_to_valid))
		return GetAmount(movable_to_valid)

/datum/trader_bounty/proc/IsValid(atom/movable/movable_to_valid)
	return TRUE

/datum/trader_bounty/proc/GetAmount(atom/movable/movable_to_valid)
	return 1

/datum/trader_bounty/stack

/datum/trader_bounty/stack/GetAmount(atom/movable/movable_to_valid)
	var/obj/item/stack/our_stack = movable_to_valid
	return our_stack.amount

/datum/trader_bounty/reagent
	check_type = FALSE
	var/reagent_type
	var/list/possible_reagent_types

/datum/trader_bounty/reagent/New()
	. = ..()
	if(possible_reagent_types)
		reagent_type = pick(possible_reagent_types)
		possible_reagent_types = null
	if(!name)
		var/datum/reagent/reagent_cast = reagent_type
		name = "[initial(reagent_cast.name)]"

/datum/trader_bounty/reagent/IsValid(atom/movable/movable_to_valid)
	if(!istype(movable_to_valid, /obj/item/reagent_containers))
		return FALSE
	var/datum/reagents/holder = movable_to_valid.reagents
	if(!holder)
		return FALSE
	if(!holder.has_reagent(reagent_type))
		return FALSE
	return TRUE

/datum/trader_bounty/gas
	check_type = FALSE
	var/gas_type
	var/list/possible_gas_types

/datum/trader_bounty/gas/New()
	. = ..()
	if(possible_gas_types)
		gas_type = pick(possible_gas_types)
		possible_gas_types = null
	if(!name)
		var/datum/gas/gas_cast = gas_type
		name = "[initial(gas_cast.name)]"

/datum/trader_bounty/gas/IsValid(atom/movable/movable_to_valid)
	if(!istype(movable_to_valid, /obj/item/tank))
		return FALSE
	var/obj/item/tank/holder = movable_to_valid
	var/datum/gas_mixture/our_mix = holder.return_air()
	if(!our_mix.gases[gas_type])
		return FALSE
	return TRUE

/datum/trader_bounty/gas/GetAmount(atom/movable/movable_to_valid)
	var/obj/item/tank/holder = movable_to_valid
	var/datum/gas_mixture/our_mix = holder.return_air()
	return our_mix.gases[gas_type][MOLES]
