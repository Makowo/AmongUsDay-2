AmongUsMinigameBase = AmongUsMinigameBase or class()

function AmongUsMinigameBase:init(class, ...)
    --log(class)
    self._minigame = class:new(self, ...)
end

--create a callback for when the minigame is finished
function AmongUsMinigameBase:on_minigame_finished()
    self:Destroy()
end

function AmongUsMinigameBase:Destroy()
    self._minigame:Destroy()
end


Asteroids = Asteroids or class()

function Asteroids:init(class, ...)
    --self._minigame = class:new(self, ...)
    self._menu = MenuUI:new({
        name = "Asteroids",
        layer = 2500, --big number go brr
        use_default_close_key = true,
        disable_player_controls = true,
    })

    self._menu:SetEnabled(true)
end

--create a callback for when the minigame is finished
function Asteroids:on_minigame_finished()
    self:Destroy()
end

function Asteroids:Destroy()
    self._menu:Destroy()
end