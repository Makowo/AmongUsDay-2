dofile(ModPath .. "classes/States/ingamecrewmate.lua")
Hooks:PostHook(GameStateMachine, "init", "AmongUs_GSM", function(self)
    local ingame_crewmate = IngameCrewmateState:new(self)
    local ingame_crewmate_func = callback(nil, ingame_crewmate, "default_transition")

    --local ingame_impostor = IngameImpostorState:new(self)
    --local ingame_impostor_func = callback(nil, ingame_impostor, "default_transition")

    --local ingame_ghost = IngameCrewmateState:new(self)
    --local ingame_ghost_func = callback(nil, ingame_ghost, "default_transition")
    for _, state in pairs(self._states) do
        self:add_transition(state, ingame_crewmate, callback(nil, state, "default_transition"))
        self:add_transition(ingame_crewmate, state, ingame_crewmate_func)

        --[[self:add_transition(state, ingame_impostor, callback(nil, state, "default_transition"))
        self:add_transition(ingame_impostor, state, ingame_impostor_func)

        self:add_transition(state, ingame_ghost, callback(nil, state, "default_transition"))
        self:add_transition(ingame_ghost, state, ingame_ghost_func)]]--
    end
end)