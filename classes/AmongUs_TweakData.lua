AmongUs.TweakData = AmongUs.TweakData or class()
--Still thinking of how to deal with this, Pain.
--Current idea is to have a table of all the tweak data, and then have a function to add the required amount of tasks to their player table, this would not be synced.
function AmongUs.TweakData:init()
    self.tasks = {
        common = {
            AdminSwipe = {
                id = "AdminSwipe", --Unique ID, mostly for custom tasks
                location = "Admin", --Location of the task
                name = "Swipe Keycard", --Name of the task
                progress = 0, --Progress of the task, this will be modified by the game
                max_progress = 1, --Max progress of the task, when progress == max_progress, the task is completed
                text_id = "nil", --Text id of the task, this will be modified by the game
            },
            FixWiring = {
                id = "AdminSwipe",
                location = "Admin", --Default start location?, have the game change this on task step completion to the next area?? or just make it a table that steps through the locations?, ex {"Admin", "Weapons", "Security"}
                name = "Swipe Keycard",
                progress = 0,
                max_progress = 3,
                text_id = "nil",
            },
        },
        long = {
            Asteroids = {
                id = "Asteroids",
                location = "Weapons",
                name = "Clear Asteroids",
                progress = 0,
                max_progress = 20,
                text_id = "nil",
                class = Asteroids,
            },
            --[[despacito = {
                id = "despacito",
                location = "Weapons",
                name = "Clear Asteroids",
                progress = 0,
                max_progress = 20,
                text_id = "nil",
            },]]
        },
        short = {
            CleanVent = {
                id = "CleanVent",
                location = "Weapons",
                name = "Clean Vent",
                progress = 0,
                max_progress = 1,
                text_id = "nil",
                class = CleanVent,
            },
            Wires = {
                id = "Wires",
                location = {"Weapons", "Security", "Admin"},
                name = "Wires",
                progress = 0,
                max_progress = 3,
                text_id = "nil",
                class = Wires
            },
            DownloadData = {
                id = "DownloadData",
                location = {"Weapons", "Security"},
                name = {"Download Data", "Upload Data"},
                progress = 0,
                max_progress = 2,
                text_id = "nil",
                class = DownloadData
            },
        }
    }
    --PrintTable(self.tasks.common)
end

--To add a new custom task
--[[task_table = {
    id = "AdminSwipe", The id of the task, this is used to identify the task
    location = "Admin", The location of the task, this is used in the task list as a prefix to name
    name = "Swipe Keycard", The name of the task
    progress = 0, --Starting progress of the task, this will be modified by the game, should almost always be 0
    max_progress = 3, --Max progress of the task, when progress == max_progress, the task is completed. Should be 1 unless your task is a multi-step task
},]]
function AmongUs.TweakData:add_task(task_type, task_table)
    if not self.tasks[task_type] then
        log("[AmongUs] Task Type " .. task_type .. " is invalid.")
        return
    end

    if self:verify_task(task_table) then
        if not self.tasks[task_type][task_table.id] then
            self.tasks[task_type][task_table.id] = task_table
        else
            log("[AmongUs] Task " .. task_table.id .. " already exists in Task Type " .. task_type)
        end
    end
end

--Verify task_table has valid values
function AmongUs.TweakData:verify_task(task_table)
    if not task_table.id then
        log("[AmongUs] Task ID is invalid.")
        return false
    end

    if not task_table.location then
        log("[AmongUs] Task Location is invalid.")
        return false
    end

    if not task_table.name then
        log("[AmongUs] Task Name is invalid.")
        return false
    end

    if not task_table.progress then
        log("[AmongUs] Task Progress is invalid.")
        return false
    end

    if not task_table.max_progress then
        log("[AmongUs] Task Max Progress is invalid.")
        return false
    end
end