dofile(ModPath .. "classes/States/playercrewmate.lua")
Hooks:PostHook(PlayerMovement, "_setup_states", "AmongUs_PlayerMovement", function(self)
    self._states.crewmate = PlayerCrewmate:new(self._unit)
end)