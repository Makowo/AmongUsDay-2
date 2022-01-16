Hooks:PostHook(PlayerTweakData,"init","pvp_init_boogaloo",function(self)
	self.stances.default.bleed_out = deep_clone(self.stances.default.standard)
	self.stances.default.bleed_out.head.translation = Vector3(0, 0, 35)
end)