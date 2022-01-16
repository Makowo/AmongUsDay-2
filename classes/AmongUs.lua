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
        short_tasks = custom_rules and custom_rules.short_tasks or 5,
        long_tasks = custom_rules and custom_rules.long_tasks or 2,
        common_tasks = custom_rules and custom_rules.common_tasks or 1
    }

    self:_init_hooks()
    self:_init_rules(rules)

    self._devs = {
        76561198043882024
    }

    self._helpers = {

    }

    log("[AmongUs] Gamemode fully initialized.")
end

function AmongUs:_init_rules(rules)
    self._tasks = {
        short = rules.short_tasks,
        long = rules.long_tasks,
        common = rules.common_tasks
    }

    self._emergency = {
        cooldown = rules.emergency_cooldown,
        duration = rules.emergency_duration,
        meetings = rules.emergency_meetings,
        voting_time = rules.voting_time,
        anon_voting = rules.anon_voting
    }

    self._gameplay = {
        visual_tasks = rules.visual_tasks,
        task_bar_updates = rules.task_bar_updates,
        max_players = rules.max_players,
        min_players = rules.min_players,
        imposter_count = rules.impostor_count,
        kill_cooldown = rules.kill_cooldown,
        player_speed_multiplier = rules.player_speed_multiplier
    }
end

function AmongUs:_init_hooks()
    --[[
    local map = BeardLib.Frameworks.Map:GetModByName("Mogus")
    local mod_path = map:GetPath()
    log(tostring(mod_path))

    self._hooks = {
        --"classes/AmongUsHUD"

    }

    self._elements = {
        "WeaponSwitch"
    }

    if Global.editor_mode then
        for _, element in pairs(self._elements) do
            dofile(mod_path .. "classes/Editor/Editor" .. element .. ".lua")
            table.insert(BLE._config.MissionElements, "Element".. element)
        end
    end

    for _, hook in pairs(self._hooks) do
        dofile(mod_path .. hook .. ".lua")
        log("Included script ", hook)
    end]]--
end