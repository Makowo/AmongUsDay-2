Hooks:PostHook(EquipmentsTweakData,"init","pvp_init",function(self)

	local pvp_teams = {
		"pvp_team_swat",
		"pvp_team_crim"
	}
	self.specials.pvp_team_crim = {
		icon =					"icon_crim_white",
		text_id =				"pvp_team_crim_text",
		sync_possession =		true,
		avoid_tranfer =			true,
		shares_pickup_with =	pvp_teams
	}
	self.specials.pvp_team_swat = {
		icon =					"icon_swat_white",
		text_id =				"pvp_team_crim_text",
		sync_possession =		true,
		avoid_tranfer =			true,
		shares_pickup_with =	pvp_teams
	}

end)