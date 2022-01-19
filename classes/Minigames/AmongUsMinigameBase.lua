AmongUsMinigameBase = AmongUsMinigameBase or class()

function AmongUsMinigameBase:init(parent, class, ...)
    --log(class)
    self._minigame = class:new(self, parent, ...)
end

--create a callback for when the minigame is finished
function AmongUsMinigameBase:on_minigame_finished()
    self:Destroy()
end

function AmongUsMinigameBase:Destroy()
    self._minigame:Destroy()
end
-- yeah i've given up on being clean.
function MenuUI:KeyPressed(o, k)
    if self.pre_key_press then
        if self.pre_key_press(o, k) == false then
            return
        end
    end
    self._key_pressed = k
    if self.toggle_key and k == self.toggle_key:id() then
        self:toggle()
    end
	if self:IsMouseActive() then
		if self.active_textbox then
			self.active_textbox:KeyPressed(o, k)
		end

		if self._openlist then
			self._openlist:KeyPressed(o, k)
		end

        if alive(self._popupmenu) then
			self._popupmenu:KeyPressed(o, k)
        end

        if self._highlighted and self._highlighted.parent:Enabled() and self._highlighted:KeyPressed(o, k) then
            return
        end
        if self.close_key and k == self.close_key:id() then
            self:Destroy() -- this entire thing is here so i can do this :) KeyBind doesn't allow me to use ESC so i have to use this. aaaaaaaaaaaaaaaaaaaaaaaa thanks lofi
        end
        for _, menu in pairs(self._menus) do
            if menu:KeyPressed(o, k) then
                return
            end
        end
        if self.key_press then self.key_press(o, k) end
    end
end


Asteroids = Asteroids or class()

function Asteroids:init(parent, ...)
    self._parent = parent
    self._menu = MenuUI:new({
        name = "Asteroids",
        layer = 2500, --big number go brr
        disable_player_controls = true,
        use_default_close_key = true,
        enabled = true,
        background_blur = true,
    })
    self._menu_panel = self._menu._panel
    self._penis = self._menu:Holder({
        name = "GameInfo",
        background_color = Color(0, 0, 0):with_alpha(0.35),
        h = self._menu_panel:h() / 2.25,
        w = self._menu_panel:w() / 4,
        min_height = 64,
        max_height = 270,
        max_width = 224,
        scrollbar = false,
		offset = 8,
        position = function(item)
            item:SetPosition(self._menu_panel:w() / 2 - item.w / 2 , self._menu_panel:h() / 2 - item.h / 2)
        end
    })

    self._penis:Button({
        name = "MyButton",
        text = "Press me!",
        on_callback = ClassClbk(self, "on_minigame_finished")
    })

    --self._menu:SetEnabled(true)
end

--create a callback for when the minigame is finished
function Asteroids:on_minigame_finished()
    self._parent:_on_executed()
    self:Destroy()
end

function Asteroids:Destroy()
    log("destroy")
    self._menu:Destroy()
end