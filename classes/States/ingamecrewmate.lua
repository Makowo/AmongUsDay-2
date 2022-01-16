require("lib/states/GameState")

IngameCrewmateState = IngameCrewmateState or class(IngamePlayerBaseState)

function IngameCrewmateState:init(game_state_machine)
	IngameCrewmateState.super.init(self, "ingame_crewmate", game_state_machine)
end

function IngameCrewmateState:at_enter()
	local players = managers.player:players()

	for k, player in ipairs(players) do
		local vp = player:camera():viewport()

		if vp then
			vp:set_active(true)
		else
			Application:error("No viewport for player " .. tostring(k))
		end
	end

	managers.hud:show(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:show(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
	managers.hud:hide_local_player_gear()

	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(true)
		player:character_damage():set_invulnerable(true)
	end
end

function IngameCrewmateState:at_exit()
	local player = managers.player:player_unit()

	if player then
		player:base():set_enabled(false)
		player:character_damage():set_invulnerable(false)
	end

	managers.hud:show_local_player_gear()
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD)
	managers.hud:hide(PlayerBase.PLAYER_INFO_HUD_FULLSCREEN)
end

function IngameCrewmateState:on_server_left()
	print("[IngameCrewmateState:on server_left]")
	game_state_machine:change_state_by_name("server_left")
end

function IngameCrewmateState:on_kicked()
	print("[IngameCrewmateState:on on_kicked]")
	game_state_machine:change_state_by_name("kicked")
end

function IngameCrewmateState:on_disconnected()
	game_state_machine:change_state_by_name("disconnected")
end

SkyHook:Post(PlayerManager, "init", function(self)
    self._player_states.crewmate = "ingame_crewmate"
end)