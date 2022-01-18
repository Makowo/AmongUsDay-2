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
    if managers.network:session() and  peer_id == managers.network:session():local_peer():id() or 1 then
        self:_assign_tasks(peer_id)
    end
    log(tprint(self._players[peer_id].tasks))
    --TODO: generate tasks for the new player if they are a crewmate
end

--Get tasks and assign them to the player depending on how many tasks are needed from the task table
function AmongUs.GM:_assign_tasks(player_id)
    local player = self._players[player_id]
    local tasks_amounts = AmongUs._tasks
    local tasks_table = AmongUs.TweakData.tasks
    --incase _create_new_player is called more than once for the same player.
    --common is called last, so it ensures they are all assigned.
    if #player.tasks.common >= tasks_amounts.common then
        return
    end

    --Creates a table of the keys, selects one randomly, removes it from the key table and adds the task to the player. cursed, i know.
    for task_type, amount in pairs(AmongUs._tasks) do
        local fuckihatetables = table.map_keys(tasks_table[task_type])
        for i = 1, amount, 1 do
            local random = math.random(#fuckihatetables)
            local task = fuckihatetables[random]
            table.insert(player.tasks[task_type], tasks_table[task_type][task])
            table.remove(fuckihatetables, random)
        end
    end
end

--get total number of connected players
function AmongUs.GM:num_connected_players()
    local num = 0
    for i = 1, 18, 1 do
        if self._players[i].connected then
            num = num + 1
        end
    end
    return num
end

--get total amount of completed tasks
function AmongUs.GM:get_total_completed_tasks()
    local total = 0
    for i = 1, 18, 1 do
        if self._players[i].connected then
            local tasks = self._players[i].tasks.completed
            total = total + tasks.common + tasks.short + tasks.long
        end
    end
    return total
end
