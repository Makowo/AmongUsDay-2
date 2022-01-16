Hooks:PostHook(PlayerManager, "init", "AmongUs_PlayerManager_init", function(self)
    self._player_states.crewmate = "ingame_crewmate"
    Gamemode.STATES.ingame_crewmate = "ingame_crewmate"
end)