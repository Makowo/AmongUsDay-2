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
HUDAMONGUS.DEFAULT_FONT = "fonts/font_large_mf"
HUDAMONGUS.DEFAULT_SHADOW_FONT = "fonts/font_medium_shadow_mf"

function HUDAMONGUS:init(parent)
    self:create_task_bar(parent)
    self:create_panel(parent)
end

function HUDAMONGUS:set_visible(state)
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
        w = parent:w() / 2,
        h = parent:h() / 8,
        x = 0,
        y = 0,
        valign = "top",
        halign = "left",
        alpha = 1,
    })
    self._task_bar_progress = self._task_bar:rect({
        name = "task_bar_progress",
        layer = 2,
        w = 0,
        h = self._task_bar:h(),
        x = 0,
        y = 0,
        color = Color.green,
    })
    self._task_bar_bg = self._task_bar:rect({
        name = "task_bar_background",
        layer = 1,
        w = self._task_bar:w(),
        h = self._task_bar:h(),
        x = 0,
        y = 0,
        color = Color("2e402e"),
    })
    self._task_bar_text = self._task_bar:text({
        name = "task_bar_text",
        layer = 3,
        text = "0%",
        font = HUDAMONGUS.DEFAULT_FONT,
        font_size = self._task_bar:h() * 0.8,
        color = Color.white,
        align = "center",
        vertical = "center",
        w = self._task_bar:w(),
        h = self._task_bar:h(),
        x = 0,
        y = 0,
    })
end

--Update the task bar progress
function HUDAMONGUS:update_task_bar(progress)
    self._task_bar_progress:set_w(self._task_bar:w() * progress)
    self._task_bar_text:set_text(string.format("%d%%", progress * 100))
end

--Add more progress to the task bar
function HUDAMONGUS:add_task_bar_progress(progress)
    self:update_task_bar(self._task_bar_progress:w() / self._task_bar:w() + progress)
end

--Creates the panel that contains the task information
function HUDAMONGUS:create_panel(parent)
    self._task_panel = parent:panel({
        name = "task_panel",
        visible = true,
        layer = 25,
        w = parent:w() / 4,
        h = parent:h() / 4,
        x = 0,
        y = 0,
        alpha = 0.9,
    })
    self._task_panel_bg = self._task_panel:rect({
        name = "task_bar_background",
        layer = 1,
        w = self._task_panel:w(),
        h = self._task_panel:h(),
        x = 0,
        y = 0,
        color = Color("616868"),
    })
    self._task_panel:set_top(self._task_bar:bottom())
end

--Add text to the panel, one for each task
function HUDAMONGUS:add_task_text(text)
    self._task_panel_text = self._task_panel:text({
        name = "task_panel_text",
        layer = 3,
        text = "aaa",
        font = HUDAMONGUS.DEFAULT_FONT,
        font_size = self._task_panel:h() * 0.8,
        color = Color.white,
        align = "center",
        vertical = "center",
        w = self._task_panel:w(),
        h = self._task_panel:h(),
        x = 0,
        y = 0,
    })
end

