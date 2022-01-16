Hooks:PostHook(InteractionTweakData,"init","pvp_init",function(self)

	self.revive.interact_distance = 0
	self.revive.timer = 999
	self.pvp_drill = {
		text_id =			"pvp_drill_place",
		equipment_text_id = "pvp_drill_no_drill",
		special_equipment = "pvp_team_crim",
		equipment_consume = false,
		interact_distance = 150,
		timer = 5
	}
	self.pvp_take_wep_primary = {
		text_id = "pvp_take_wep_primary",
		start_active = true,
		interact_distance = 150,
		timer = 1
	}
	self.pvp_take_wep_secondary = {
		text_id = "pvp_take_wep_secondary",
		start_active = true,
		interact_distance = 150,
		timer = 1
	}
	self.pvp_take_wep = {
		text_id = "pvp_take_wep_secondary",
		start_active = true,
		interact_distance = 150,
		timer = 1
	}

end)