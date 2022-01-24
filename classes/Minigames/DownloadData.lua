DownloadData = DownloadData or class()

function DownloadData:init(parent, ...)
    self._downloaddata = {}
    self._parent = parent
    self._menu = MenuUI:new({
        name = "DownloadData",
        layer = 1, --big number go brr
        disable_player_controls = true,
        use_default_close_key = false, -- use the X button below, i can't be fucked to make esc work
        enabled = true,
        background_blur = true,
    })

    self._menu_panel = self._menu._panel

    self._game = self._menu:Holder({
        name = "GameInfo",
        background_color = Color(0, 0, 0):with_alpha(0.35),
        h = self._menu_panel:h() / 3,
        w = self._menu_panel:w() / 2,
        min_height = 64,
        scrollbar = false,
		offset = 8,
        position = function(item)
            item:SetPosition(self._menu_panel:w() / 2 - item.w / 2 , self._menu_panel:h() / 2 - item.h / 2)
        end
    })

    self._download = self._game:Button({
        name = "downloadbutton",
        texture = "pd2_mod_amongus/units/black_df",
        texture_rect = {0, 0, 16, 16},
        text = "download",
        text_align = "center",
        w = self._game:W() / 4,
        h = self._game:H() / 8,
        enabled_alpha = 1,
        layer = 2,
        position = function(item)
            item:SetCenter(self._game:W() / 2, self._game:H() / 2)
        end,
        on_callback = function(item)
            self:CreateObjects()
            item:SetVisible(false)
        end
    })

    self._exit_holder = self._menu:Holder({
        name = "exit_holder",
        background_color = Color(0, 0, 0):with_alpha(0.35),
        h = 64,
        w = 64,
        min_height = 64,
        scrollbar = false,
		offset = 0,
        position = function(item)
            item:SetPosition(self._game:X() - 64, self._game:Y())
        end
    })

    self._exit = self._exit_holder:ImageButton({
        name = "ExitButton",
        texture = "guis/textures/pd2/endscreen/exp_ring",
        texture_rect = {0, 0, 256, 256},
        w = 64,
        h = 64,
        position = function(item)
            item:SetPosition(0, 0)
        end,
        on_callback = ClassClbk(self, "Destroy")
    })

    --Set task to upload if progress is 1
    self._peerid = managers.network:session():local_peer():id()
    self._taskprogress = AmongUs.GM:get_task_progress(self._peerid, "short", "DownloadData")

    if self._taskprogress == 1 then
        self._download:SetText("Upload")
    end
    --self._menu:SetEnabled(true)
end


--create a callback for when the minigame is finished successfully
function DownloadData:on_minigame_finished()
    AmongUs.GM:progress_task(self._peerid, "short", "DownloadData")
    self._parent:_on_executed()
    self:Destroy()
end

--Create a progress bar
function DownloadData:CreateObjects()
    self._progress_bg = self._game:Panel():rect({
        name = "downloadbarbg",
        layer = 1,
        w = self._game.w / 1.25,
        h = self._game.h / 8,
        x = 0,
        y = 0,
        color = Color.black,
    })
    self._progress_bg:set_center(self._game.w / 2, self._game.h / 2)

    self._progress = self._game:Panel():rect({
        name = "downloadbar",
        layer = 1,
        w = 0,
        h = self._progress_bg:h(),
        x = self._progress_bg:x(),
        y = self._progress_bg:y(),
        color = Color.green,
    })
    BeardLib:AddUpdater("AmongUsMinigame", ClassClbk(self, "update"))
end

function DownloadData:update(t, dt)
    self.max_seconds = self.max_seconds or table.random({8, 10, 12, 14, 16})
    self.seconds = self.seconds and self.seconds + dt or 0
    self.startpos = self.startpos or self._progress:w()
    local progress = math.clamp(self.seconds / self.max_seconds, 0, 1)

    if self._progress then
        self._progress:set_w(math.lerp(self.startpos, self._progress_bg:w(), progress))

        if self.seconds >= self.max_seconds then
            self:downloadfinished()
            if self.seconds >= self.max_seconds + 1.5 then
                self:on_minigame_finished()
            end
        end
    end
end
--create a text object to display the that the download has finished
function DownloadData:downloadfinished()
    local div = self._game:Divider({
        name = "downloadfinished",
        text = "Download Finished",
        font = "fonts/escom_outline",
        font_size = self._game:H() / 8,
        text_align = "center",
        layer = 5,
        w = self._game:W() / 2,
        h = self._game:H() / 8,
        position = function(item)
            item:SetCenter(self._game:W() / 2, self._game:H() / 2)
        end
    })
    if self._taskprogress == 1 then
        div:SetText("Upload Finished")
    end
end

function DownloadData:Destroy()
    BeardLib:RemoveUpdater("AmongUsMinigame")
    self._menu:Destroy()
    self._downloaddata = nil
end