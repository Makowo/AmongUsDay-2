AmongUs.GM = AmongUs.GM or class()

function AmongUs.GM:init()
    self._players = {}
    --Create a new player for every possible peer
    --If there's a way to detect how many players there are, i'm unaware of it.
    for i = 1, 18, 1 do
        self._players[i] = {
            name = "none",
            steam_id = 0,
            connected = false,
            team = "pregame", --dead, crewmate or impostor (pregame is for before the game starts)
            tasks = {
                completed = {
                    short = 0,
                    long = 0,
                    common = 0
                },

                short = {}, --To be filled with tasks from tweak data
                long = {},
                common = {}
            }
        }
    end
end

function AmongUs.GM:_create_new_player(peer_id, name, steam_id)
    self._players[peer_id].name = name
    self._players[peer_id].steam_id = steam_id
    self._players[peer_id].connected = true
    --TODO: generate tasks for the new player if they are a crewmate
end