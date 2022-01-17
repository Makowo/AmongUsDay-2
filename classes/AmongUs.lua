AmongUs = AmongUs or class()

function AmongUs:init(custom_rules)
    log("AmongUs:init()")
    local rules = {
        impostor_count = custom_rules and custom_rules.impostor_count or 1,
        kill_cooldown = custom_rules and custom_rules.kill_cooldown or 30,

        max_players = custom_rules and custom_rules.max_players or 10,
        min_players = custom_rules and custom_rules.min_players or 4,

        emergency_meetings = custom_rules and custom_rules.emergency_meetings or 1,
        emergency_cooldown = custom_rules and custom_rules.emergency_cooldown or 15,
        emergency_duration = custom_rules and custom_rules.emergency_duration or 30,
        voting_time = custom_rules and custom_rules.voting_time or 60,
        anon_voting = custom_rules and custom_rules.anon_voting or false,

        player_speed_multiplier = custom_rules and custom_rules.player_speed_multiplier or 1,

        visual_tasks = custom_rules and custom_rules.visual_tasks or true,
        task_bar_updates = custom_rules and custom_rules.task_bar_updates or true,
        short_tasks = custom_rules and custom_rules.short_tasks or 1,
        long_tasks = custom_rules and custom_rules.long_tasks or 1,
        common_tasks = custom_rules and custom_rules.common_tasks or 1
    }

    self:_init_hooks()
    self:_init_rules(rules)

    AmongUs.TweakData:init()
    AmongUs.GM:init()

    self._devs = {
        76561198043882024
    }

    self._helpers = {

    }
PrintTable(AmongUs)
    log("[AmongUs] Gamemode fully initialized.")
end

function AmongUs:_init_rules(rules)
    log("AmongUs:_init_rules()")
    self._tasks = {
        short = rules.short_tasks, --Amount of short tasks
        long = rules.long_tasks, --Amount of long tasks
        common = rules.common_tasks --Amount of common tasks
    }

    self._emergency = {
        cooldown = rules.emergency_cooldown, --Amount of time between emergencies
        duration = rules.emergency_duration, --Amount of disscussion time before the voting starts
        meetings = rules.emergency_meetings, --Amount of times the emergency meeting can happen per player
        voting_time = rules.voting_time, --Amount of time (in seconds) that the players have to vote on who to vote out.
        anon_voting = rules.anon_voting --Can players see who voted for who?
    }

    self._gameplay = {
        visual_tasks = rules.visual_tasks, --Can the players see other players complete certain tasks?
        task_bar_updates = rules.task_bar_updates, --Can the players see the task bar update in real time?
        max_players = rules.max_players, --Max amount of players that can join the game
        min_players = rules.min_players, --Min amount of players to start the game
        imposter_count = rules.impostor_count, --Maximum amount of players that can be impostors
        kill_cooldown = rules.kill_cooldown, --Cooldown between killing players (in seconds)
        player_speed_multiplier = rules.player_speed_multiplier --Speed multiplier for players
    }
    log("Self TASKS: ")
    PrintTable(AmongUs._tasks)
end

function AmongUs:_init_hooks()

    local map = BeardLib.Frameworks.Map:GetModByName("Mogus")
    local mod_path = map:GetPath()
    log(tostring(mod_path))

    self._hooks = {
        "classes/AmongUs_TweakData",
        "classes/AmongUs_GameManager",
        "hooks/HUDMissionBriefing",

    }

    --[[self._elements = {
        "WeaponSwitch"
    }

    if Global.editor_mode then
        for _, element in pairs(self._elements) do
            dofile(mod_path .. "classes/Editor/Editor" .. element .. ".lua")
            table.insert(BLE._config.MissionElements, "Element".. element)
        end
    end]]

    for _, hook in pairs(self._hooks) do
        dofile(mod_path .. hook .. ".lua")
        log("Included script ", hook)
    end
end


--Snippet from /lib/utils/tprint.lua, it doesn't get run so lmao

function tprint(tbl, indent)
	indent = indent or 0
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2

	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)

		if type(k) == "number" then
			toprint = toprint .. "[" .. k .. "] = "
		elseif type(k) == "string" then
			toprint = toprint .. k .. "= "
		end

		if type(v) == "number" then
			toprint = toprint .. v .. ",\r\n"
		elseif type(v) == "string" then
			toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif type(v) == "table" then
			toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
		else
			toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end

	toprint = toprint .. string.rep(" ", indent - 2) .. "}"

	return toprint
end
