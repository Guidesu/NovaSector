/datum/atmosphere
	/// The gas string that is generated from pools below, mole count will be equal to relative weight scalar to pressure and temperature
	var/gas_string
	var/id
	/// A list of gases to always have, associative to weight
	var/list/base_gases = list()
	/// A list of picked extra gases to roll, associative to weight
	var/list/normal_gases = list()
	/// How many extra gases will we roll from the normal pool
	var/normal_gas_picks = 1
	/// A list of allowed gases like normal_gases but each can only be selected a maximum of one time. Associative to weight
	var/list/restricted_gases = list()
	/// Chance to pick a restricted gas
	var/restricted_chance = 0
	var/minimum_temp
	var/maximum_temp
	var/minimum_pressure
	var/maximum_pressure


/datum/atmosphere/proc/generate_gas_string()
	var/list/spicy_gas = restricted_gases.Copy()
	var/target_pressure = rand(minimum_pressure, maximum_pressure)
	var/pressure_scalar = target_pressure / maximum_pressure
	var/target_temp = rand(minimum_temp, maximum_temp)
	var/target_moles = target_pressure * CELL_VOLUME / target_temp / R_IDEAL_GAS_EQUATION

	if(HAS_TRAIT(SSstation, STATION_TRAIT_UNNATURAL_ATMOSPHERE))
		restricted_chance = restricted_chance + 40

	// First let's set up the gasmix and base gases for this template
	// We make the string from a gasmix in this proc because gases need to calculate their pressure
	var/datum/gas_mixture/gasmix = new
	var/list/gaslist = gasmix.gases
	gasmix.temperature = rand(minimum_temp, maximum_temp)
	for(var/i in base_gases)
		ADD_GAS(i, gaslist)
		gaslist[i][MOLES] = base_gases[i]
	var/list/gas_weights = base_gases.Copy()

	// Now let the random choices begin
	var/datum/gas/gastype
	var/amount
	while(gasmix.return_pressure() < target_pressure)
		if(!prob(restricted_chance) || !length(spicy_gas))
			gastype = pick(normal_gases)
			amount = normal_gases[gastype]
		else
			gastype = pick(spicy_gas)
			amount = spicy_gas[gastype]
			spicy_gas -= gastype //You can only pick each restricted gas once
	/// Add normal gas picks
	var/list/normal_gases_to_pick_from = normal_gases.Copy()
	for(var/i in 1 to normal_gas_picks)
		if(!normal_gases_to_pick_from.len)
			break
		var/picked_gas_type = pick(normal_gases_to_pick_from)
		if(!gas_weights[picked_gas_type])
			gas_weights[picked_gas_type] = 0
		gas_weights[picked_gas_type] += normal_gases_to_pick_from[picked_gas_type]
		normal_gases_to_pick_from -= picked_gas_type

		amount *= rand(50, 200) / 100 // Randomly modifes the amount from half to double the base for some variety
		amount *= pressure_scalar // If we pick a really small target pressure we want roughly the same mix but less of it all
		amount = CEILING(amount, 0.1)
	/// Roll and add restricted gas pick
	if(prob(restricted_chance))
		if(restricted_gases.len)
			var/picked_gas_type = pick(restricted_gases)
			if(!gas_weights[picked_gas_type])
				gas_weights[picked_gas_type] = 0
			gas_weights[picked_gas_type] += restricted_gases[picked_gas_type]

		ASSERT_GAS_IN_LIST(gastype, gaslist)
		gaslist[gastype][MOLES] += amount

		gaslist[gastype][MOLES] -= gaslist[gastype][MOLES] * 0.1
	gaslist[gastype][MOLES] = FLOOR(gaslist[gastype][MOLES], 0.1)
	gasmix.garbage_collect()
	var/total_gas_weight = 0
	for(var/gas_type in gas_weights)
		total_gas_weight += gas_weights[gas_type]

	for(var/gas_type in gas_weights)
		var/gas_scalar = gas_weights[gas_type] / total_gas_weight
		gaslist[gas_type] = target_moles * gas_scalar

	// Now finally lets make that string
	var/list/gas_string_builder = list()
	for(var/i in gaslist)
		var/list/gas = gaslist[i]
		gas_string_builder += "[gas[GAS_META][META_GAS_ID]]=[gas[MOLES]]"
	gas_string_builder += "TEMP=[gasmix.temperature]"
	for(var/gas in gaslist)
		var/datum/gas/gas_cast = gas
		gas_string_builder += "[initial(gas_cast.id)]=[amount]"
	gas_string_builder += "TEMP=[target_temp]"

	gas_string = gas_string_builder.Join(";")
