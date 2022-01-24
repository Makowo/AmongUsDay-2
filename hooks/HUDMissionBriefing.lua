Hooks:PostHook(HUDMissionBriefing, "set_player_slot", "AmongUs_HudMission_Briefing", function(self, nr, params)
    local current_name = params.name
    local peer_id = params.peer_id
    local peer_data = managers.network and managers.network:session() and managers.network:session():peer(peer_id)


    local data = {
        id = peer_id,
        name = current_name,
        steam_id = peer_data:user_id()

    }


    AmongUs.GM:_create_new_player(data.id, data.name, data.steam_id)
end)
