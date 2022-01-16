Hooks:PostHook(BlackMarketTweakData,"_init_player_styles","_init_pvp_player_styles",function(self)

	local characters_female = {
		"female_1",
		"sydney",
		"joy",
		"ecp_female"
	}
	local characters_female_big = {
		"bonnie",
		"ecp_male"
	}
	local characters_male = {
		"dallas",
		"wolf",
		"hoxton",
		"chains",
		"jowi",
		"old_hoxton",
		"dragan",
		"jacket",
		"sokol",
		"dragon",
		"bodhi",
		"jimmy",
		"chico",
		"myh"
	}
	local characters_male_big = {
		"wild",
		"max"
	}
	
	local characters_all = table.list_union(characters_female, characters_male, characters_female_big, characters_male_big)
	local body_replacement_standard = {
		head = false,
		armor = true,
		body = true,
		hands = true,
		vest = true
	}
	
	local function set_characters_data(player_style, characters, data)
		self.player_styles[player_style].characters = self.player_styles[player_style].characters or {}

		for _, key in ipairs(characters) do
			self.player_styles[player_style].characters[key] = data
		end
	end
	
	local body_replacement_pvp_swat1 = {
		head = false,
		armor = true,
		body = true,
		hands = false,
		vest = true
	}
	self.player_styles.pvp_swat1 = {
		name_id = "bm_suit_pvp_swat1",
		desc_id = "bm_suit_pvp_swat1_desc",
		texture_bundle_folder = "trd",
		body_replacement = body_replacement_standard,
		third_body_replacement = body_replacement_pvp_swat1,
		unit = "units/pd2_mod_pvp/uniforms/swat/acc_swat_1_fps/acc_swat_1_fps",
		characters = {}
	}
	set_characters_data("pvp_swat1", characters_male, {
		third_unit = "units/pd2_mod_pvp/uniforms/swat/acc_swat_1_suit_man/acc_swat_1_suit_man"
	})
	set_characters_data("pvp_swat1", characters_male_big, {
		third_unit = "units/pd2_mod_pvp/uniforms/swat/acc_swat_1_suit_man/acc_swat_1_suit_man"
	})
	set_characters_data("pvp_swat1", characters_female, {
		third_unit = "units/pd2_mod_pvp/uniforms/swat/acc_swat_1_suit_fem/acc_swat_1_suit_fem"
	})
	set_characters_data("pvp_swat1", characters_female_big, {
		third_unit = "units/pd2_mod_pvp/uniforms/swat/acc_swat_1_suit_fem/acc_swat_1_suit_fem"
	})


end)