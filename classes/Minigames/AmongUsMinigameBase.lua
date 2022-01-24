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
    self._game = self._menu:Holder({
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
    BeardLib:RemoveUpdater("AmongUsMinigame")
    self._menu:Destroy()
    self._asteroids = nil
end

function Asteroids:AsteroidDestroy(asteroidnum, clicked)
    self._asteroids[asteroidnum]:Destroy()
    self._asteroids[asteroidnum] = nil
    if clicked then
        local player_id = managers.network:session():local_peer():id()
        local completed = AmongUs.GM:progress_task(player_id, "long", "Asteroids")
        if completed then
            self:on_minigame_finished()
        end
    end
end

--will be used to update the asteroids flying around
function Asteroids:update(t, dt)
    self._time = self._time or 0.5
    self._time = self._time - dt
    if self._time < 0 then
        self._time = 0.5
        self:CreateAsteroid()
    end
    for _, asteroid in pairs(self._asteroids) do
        asteroid:update(t, dt)
    end
end

AsteroidObject = AsteroidObject or class()

--initialize the asteroid object
function AsteroidObject:init(parent, asteroidnum)
    self._parent = parent
    self._asteroidnum = asteroidnum
    --TODO: randomize texture
    self._asteroid = self._parent._game:ImageButton({
        name = "Asteroid",
        texture = "guis/textures/pd2/endscreen/exp_ring",
        texture_rect = {0, 0, 256, 256},
        w = 64,
        h = 64,
        color = Color(1, 1, 1),
        alpha = 1,
        visible = true,
        layer = 2500,
        on_callback = ClassClbk(self, "Clicked"),
        position = function(item)
            item:SetPosition(-64, math.random(0, self._parent._game:H())) --spawn off screen, with a random height
        end
    })
    --setting ANY rotation breaks the clipping on the objects, see images, rotation on: https://i.imgur.com/bLFf79W.png, rotation off: https://i.imgur.com/CLJCSgC.png
    --self._asteroid.img:set_rotation(math.random() * 360) -- game gets pissy if it's rotating when it's destroyed, just set it in a random direction
    self.startpos = self.startpos or self._asteroid:Position()
    self.endpos = self.endpos or {self._parent._game:W(), math.random(self._parent._game:H())}
    self.seconds = 0
    self.max_seconds = table.random({0.5, 1, 1.5, 1.75, 2, 2.25, 2.5, 3, 1.75, 2, 2.25, 2.5, 3})
end

--Moves the asteroid across the panel
--this caused a lot of pain :)
function AsteroidObject:animate(t, dt)
    self.seconds = self.seconds + dt
    if self.seconds >= self.max_seconds then self._parent:AsteroidDestroy(self._asteroidnum) end
    local progress = math.clamp(self.seconds / self.max_seconds, 0, 1)
    local xpos = math.lerp(self.startpos[1], self.endpos[1], progress)
    local ypos = math.lerp(self.startpos[2], self.endpos[2], progress)
    self._asteroid:SetPosition(xpos, ypos)
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

CleanVent = CleanVent or class()

function CleanVent:init(parent, ...)
    self._cleanvent = {}
    self._parent = parent
    self._menu = MenuUI:new({
        name = "CleanVent",
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
        h = self._menu_panel:h() / 1.25,
        w = self._menu_panel:w() / 2,
        min_height = 64,
        scrollbar = false,
		offset = 8,
        position = function(item)
            item:SetPosition(self._menu_panel:w() / 2 - item.w / 2 , self._menu_panel:h() / 2 - item.h / 2)
        end
    })

    self._cover = self._game:ImageButton({
        name = "VentCover",
        texture = "pd2_mod_amongus/units/black_df",
        texture_rect = {0, 0, 16, 16},
        w = self._game:W(),
        h = self._game:H(),
        enabled_alpha = 1,
        layer = 2,
        position = function(item)
            item:SetPosition(0, 0)
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

    --BeardLib:AddUpdater("AmongUsMinigame", ClassClbk(self, "update"))
    --self._menu:SetEnabled(true)
end


--create a callback for when the minigame is finished successfully
function CleanVent:on_minigame_finished()
    self._parent:_on_executed()
    self:Destroy()
end


function CleanVent:CreateObjects()
    self._asteroidnum = self._asteroidnum or math.random(3,7)
    for i = 1, self._asteroidnum, 1 do
        self._cleanvent[i] = CleanVentObject:new(self, i)
    end
end

function CleanVent:Destroy()
    self._menu:Destroy()
    self._cleanvent = nil
end

function CleanVent:VentDestroy(vent_num)
    self._cleanvent[vent_num]:Destroy()
    self._cleanvent[vent_num] = nil

    if table.size(self._cleanvent) == 0 then
        local player_id = managers.network:session():local_peer():id()
        local completed = AmongUs.GM:progress_task(player_id, "short", "CleanVent")
        if completed then
            self:on_minigame_finished()
        end
    end
end

CleanVentObject = CleanVentObject or class()

--initialize the cleanvent object
function CleanVentObject:init(parent, obj_num)
    self._parent = parent
    self._obj_num = obj_num
    --TODO: randomize texture
    self._cleanvent = self._parent._game:ImageButton({
        name = "CleanVent",
        texture = "guis/textures/pd2/endscreen/exp_ring",
        texture_rect = {0, 0, 256, 256},
        w = 64,
        h = 64,
        color = Color(1, 1, 1),
        alpha = 1,
        visible = true,
        layer = 1,
        on_callback = ClassClbk(self, "Clicked"),
        position = function(item)
            item:SetPosition(math.random(64, self._parent._game:W() - 64), math.random(64, self._parent._game:H() - 64)) --spawn off screen, with a random height
        end
    })
end

function CleanVentObject:Clicked()
    self._parent:VentDestroy(self._obj_num)
end

--destroy the cleanvent object
function CleanVentObject:Destroy()
    self._cleanvent:Destroy()
    self._parent = nil
    self._obj_num = nil
end