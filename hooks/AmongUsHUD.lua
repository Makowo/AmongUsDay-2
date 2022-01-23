--Hides the unwanted HUD elements and adds the custom HUD elements.
Hooks:PostHook(HUDManager, "_setup_player_info_hud_pd2", "AmongUsHUDManager", function(self)
    self:hide_panels("assault_panel", "custody_panel", "hostages_panel", "heist_timer_panel", "teammates_panel")
    self:_setup_amongus_hud()
end)

function HUDManager:_setup_amongus_hud()
    --Is this bad, probably?
    local hud = managers.gui_data:create_fullscreen_workspace()
    self._hud_amongus = HUDAMONGUS:new(hud:panel())
    self._hud_amongus:set_visible(false)
end

HUDAMONGUS = HUDAMONGUS or class()
HUDAMONGUS.DEFAULT_FONT = "fonts/escom_outline"
HUDAMONGUS.DEFAULT_SHADOW_FONT = "fonts/font_medium_shadow_mf"

function HUDAMONGUS:init(parent)
    self:create_task_bar(parent)
    self:create_panel(parent)
end

function HUDAMONGUS:set_visible(state)
    if state == true then self:update_task_panel() end
    self._task_bar:set_visible(state)
    self._task_panel:set_visible(state)
end

--TODO:Add textured background
--Creates the task bar
function HUDAMONGUS:create_task_bar(parent)
    self._task_bar = parent:panel({
        name = "task_bar",
        visible = true,
        layer = 1,
        w = parent:w() / 3,
        h = parent:h() / 16,
        x = 16,
        y = 16,
        valign = "top",
        halign = "left",
        alpha = 1,
    })
    --black outline
    self._task_bar_outline = self._task_bar:rect({
        name = "task_bar_background",
        layer = 1,
        w = self._task_bar:w(),
        h = self._task_bar:h(),
        x = 0,
        y = 0,
        color = Color.black,
    })
    self._task_bar_border = self._task_bar:rect({
        name = "task_bar_background",
        layer = 1,
        w = self._task_bar_outline:w() - 8,
        h = self._task_bar_outline:h() - 8,
        x = 4,
        y = 4,
        color = Color("8d8f8d"),
    })
    --Light green progress bar
    self._task_bar_progress = self._task_bar:rect({
        name = "task_bar_progress",
        layer = 2,
        w = 0,
        h = self._task_bar_border:h() - 8,
        x = 8,
        y = 8,
        color = Color.green,
    })
    --Dark green progress bar bg
    self._task_bar_bg = self._task_bar:rect({
        name = "task_bar_background",
        layer = 1,
        w = self._task_bar_border:w() - 8,
        h = self._task_bar_border:h() - 8,
        x = 8,
        y = 8,
        color = Color("2e402e"),
    })
    self._task_bar_text = self._task_bar:text({
        name = "task_bar_text",
        layer = 3,
        text = "TOTAL TASKS COMPLETED",
        font = HUDAMONGUS.DEFAULT_FONT,
        font_size = self._task_bar_bg:h() * 0.8,
        color = Color.white,
        align = "left",
        vertical = "center",
        w = self._task_bar:w(),
        h = self._task_bar:h(),
        x = 16,
        y = 0,
    })
end

--Update the task bar progress
function HUDAMONGUS:update_task_bar()
    local task_amount = AmongUs:get_total_tasks()
    local completed_tasks = AmongUs.GM:get_total_completed_tasks()
    --don't you love math? i don't.
    local progress = math.map_range(completed_tasks, task_amount, 0, 1, 0)
    local clamped_progress = math.clamp(self._task_bar_bg:w() * progress, 0, self._task_bar_bg:w())

    self._task_bar_progress:set_w(clamped_progress)
    --self._task_bar_text:set_text(string.format("%d%%", progress * 100))
end

--Creates the panel that contains the task information
function HUDAMONGUS:create_panel(parent)
    self._task_panel = parent:panel({
        name = "task_panel",
        visible = true,
        layer = 1,
        w = parent:w() / 4,
        h = parent:h() / 4,
        x = 20,
        y = 16,
        alpha = 1,
    })
    self._task_panel_bg = self._task_panel:rect({
        name = "task_bar_background",
        layer = 1,
        w = self._task_panel:w(),
        h = self._task_panel:h(),
        x = 0,
        y = 0,
        alpha = 0.75,
        color = Color("616868"),
    })
    self._task_panel:set_top(self._task_bar:bottom() + 8)
end

function HUDAMONGUS:update_task_panel()
    local player_tasks = AmongUs.GM._players[managers.network:session():local_peer():id()].tasks

    for task_type, amount in pairs(player_tasks) do
        for task_name, task_tbl in pairs(player_tasks[task_type]) do
            log(tostring(task_name) .. " " .. tostring(task_tbl))
            if type(task_tbl) == "table" then
                self:create_task_text(task_type, task_name, task_tbl)
            end
        end
    end
end

--Creates the task text
function HUDAMONGUS:create_task_text(task_type, task_name, task_table)
    self._task_text = self._task_text or {}
    self._lazy_amount = self._lazy_amount and self._lazy_amount + 1 or 1
    --log(tprint(task_table))

    local location = task_table.location
    if type(location) == "table" then
        location = location[task_table.progress + 1]
    end
    log(tostring(location) .. " " .. tostring(task_table.progress))
    local text = location .. ": " .. task_table.name .. " (" .. task_table.progress .. "/" .. task_table.max_progress .. ")"

    self._task_text[self._lazy_amount] = self._task_panel:text({
        name = "task_text" .. self._lazy_amount,
        layer = 3,
        text = text or "ERROR",
        font = HUDAMONGUS.DEFAULT_FONT,
        font_size = 24,
        color = Color.white,
        align = "left",
        vertical = "left",
        h = 28,
        y = 4,
        x = 8
    })
    --Store the text so we can update it later
    task_table.text_id = self._task_text[self._lazy_amount]

    log(tostring(AmongUs.GM._players[managers.network:session():local_peer():id()].tasks[task_type][task_name].text_id))

    --thx shiny hoppip for :text_rect()
    local x, y, w, h = self._task_text[self._lazy_amount]:text_rect()
    if self._lazy_amount ~= 1 then
        --can't run this everytime because otherwise it'll be smaller than the earlier task
        if self._task_panel:w() < w then
            self._task_panel:set_w(w + 16)
        end

        self._task_text[self._lazy_amount]:set_top(self._task_text[self._lazy_amount-1]:bottom())
        self._task_panel:set_h(self._task_text[self._lazy_amount]:bottom())
    else --first task
        self._task_panel:set_w(w + 16)
    end
end

function HUDAMONGUS:update_task_text(task)
    local x, y, w, h = task.text_id:text_rect()
    log(tostring(w).. " " .. tostring(self._task_panel:w()))
    if self._task_panel:w() - 16 < w then
        self._task_panel:set_w(w + 16)
    end
    local location = task.location
    if type(location) == "table" then
        location = location[task.progress + 1]
    end
    task.text_id:set_text(location .. ": " .. task.name .. " (" .. task.progress .. "/" .. task.max_progress .. ")")
    task.text_id:set_color(Color.yellow)
end