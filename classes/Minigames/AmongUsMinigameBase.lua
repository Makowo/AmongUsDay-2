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
--[[ yeah i've given up on being clean.
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
end]]


Asteroids = Asteroids or class()

function Asteroids:init(parent, ...)
    self._asteroids = {}
    self._parent = parent
    self._menu = MenuUI:new({
        name = "Asteroids",
        layer = 2500, --big number go brr
        disable_player_controls = true,
        use_default_close_key = false, -- use the X button below, i can't be fucked to make esc work
        enabled = true,
        background_blur = true,
    })
    self._menu_panel = self._menu._panel
    self._penis = self._menu:Holder({
        name = "GameInfo",
        background_color = Color(0, 0, 0):with_alpha(0.35),
        h = self._menu_panel:h() / 1.25,
        w = self._menu_panel:w() / 2,
        min_height = 64,
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

    self._penis:Button({
        name = "ExitButton",
        text = "X",
        on_callback = ClassClbk(self, "Destroy")
    })

    self._penis:Button({
        name = "aadsada",
        text = "Xxx",
        on_callback = ClassClbk(self, "CreateAsteroid")
    })
    BeardLib:AddUpdater("AmongUsMinigame", ClassClbk(self, "update"))
    --self._menu:SetEnabled(true)
end


--create a callback for when the minigame is finished successfully
function Asteroids:on_minigame_finished()
    self._parent:_on_executed()
    self:Destroy()
end


function Asteroids:CreateAsteroid()
    local asteroidnum = #self._asteroids + 1
    self._asteroids[asteroidnum] = AsteroidObject:new(self, asteroidnum)
end

function Asteroids:Destroy()
    log("destroy")
    BeardLib:RemoveUpdater("AmongUsMinigame")
    self._menu:Destroy()
    self._asteroids = nil
end

function Asteroids:AsteroidDestroy(asteroidnum, clicked)
    self._asteroids[asteroidnum]:Destroy()
    self._asteroids[asteroidnum] = nil
    if clicked then
        --increment task
    end
end

--will be used to update the asteroids flying around
function Asteroids:update(t, dt)
    for _, asteroid in pairs(self._asteroids) do
        asteroid:update(t, dt)
    end
end

AsteroidObject = AsteroidObject or class()

--initialize the asteroid object
function AsteroidObject:init(parent, asteroidnum)
    self._parent = parent
    self._asteroidnum = asteroidnum
    self._asteroid = self._parent._penis:ImageButton({
        name = "Asteroid",
        texture = "guis/textures/pd2/endscreen/exp_ring",
        texture_rect = {0, 0, 256, 256},
        w = 64,
        h = 64,
        color = Color(1, 1, 1),
        alpha = 1,
        visible = true,
        layer = 2501,
        on_callback = ClassClbk(self, "Clicked"),
        position = function(item)
            item:SetPosition(0,0)
        end
    })
    log(tostring(self._parent._penis:W().. " " .. self._parent._penis:H()))
    local x, y = self._asteroid:Position()
    log(tostring(x) .. " " .. tostring(y))
    --self._asteroid:animate(ClassClbk(self, "animate"))
end

--animate the asteroid
function AsteroidObject:animate(t, dt)
    local startpos = self._asteroid:Position()
    self.endpos = {self._parent._penis:W(), self._parent._penis:H()}
    self.seconds = self.seconds and self.seconds + dt or 0

    log("t: " .. tostring(t) .. "DT: " .. tostring(dt) )
    self.max_seconds = self.max_seconds or 4
    log(t)
    if self.seconds >= self.max_seconds then self._parent:AsteroidDestroy(self._asteroidnum) end
    log("seconds: " .. tostring(self.seconds) .. " max_seconds: " .. tostring(self.max_seconds))
    log(tprint(startpos))
    log(tprint(self.endpos))
    self._x = self._x or startpos[1]
    self._y = self._y or math.random(0, startpos[2])
    self._progress = math.clamp(self.seconds / self.max_seconds, 0, 1)
    self._asteroid:SetPosition(Easing.linear(self._x, self.endpos[1], self._progress), Easing.linear(self._y, self.endpos[2], self._progress))
    --math.lerp(self._asteroid:Rotation(), math.random(0, 360), dt)
end

--update the astoroid
function AsteroidObject:update(t, dt)
    self:animate(t, dt)
end

function AsteroidObject:Clicked()
    self._parent:AsteroidDestroy(self._asteroidnum, true)
end

--destroy the asteroid object
function AsteroidObject:Destroy()
    self._asteroid:Destroy()
    self._parent = nil
    self._asteroidnum = nil
end