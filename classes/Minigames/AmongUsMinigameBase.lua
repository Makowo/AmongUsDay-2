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

    --[[self._penis:Button({
        name = "MyButton",
        text = "Press me!",
        on_callback = ClassClbk(self, "on_minigame_finished")
    })]]

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
            item:SetPosition(-64, math.random(0, self._parent._penis:H()))
        end
    })
    self.startpos = self.startpos or self._asteroid:Position()
    self.endpos = self.endpos or {self._parent._penis:W(), math.random(self._parent._penis:H())}
    self.seconds = 0
    self.max_seconds = table.random({0.5, 1, 1.5, 2, 2.5, 3})
end

--Moves the asteroid across the panel
--this caused a lot of pain :)
function AsteroidObject:animate(t, dt)
    self.seconds = self.seconds + dt
    --self.startpos[2] = math.random(self.startpos[2]) -- randomize the y position
    --log("t: " .. tostring(t) .. "DT: " .. tostring(dt) )
    --log(t)
    if self.seconds >= self.max_seconds then self._parent:AsteroidDestroy(self._asteroidnum) end
    --log("seconds: " .. tostring(self.seconds) .. " max_seconds: " .. tostring(self.max_seconds))
    --log(tprint(self.startpos))
    --log(tprint(self.endpos))
    local progress = math.clamp(self.seconds / self.max_seconds, 0, 1)
    local xpos = math.lerp(self.startpos[1], self.endpos[1], progress)
    local ypos = math.lerp(self.startpos[2], self.endpos[2], progress)
    self._asteroid:SetPosition(xpos, ypos)
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