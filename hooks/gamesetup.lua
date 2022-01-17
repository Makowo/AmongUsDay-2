dofile(ModPath .. "classes/AmongUs.lua")

Hooks:PostHook(GameSetup, "init_managers", "init_AmongUsManager", function(self, managers)
	AmongUs:init()
end)