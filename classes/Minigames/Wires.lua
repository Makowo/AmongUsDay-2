Wires = Wires or class()

function Wires:init(parent, ...)
    self._wires = {}
    self._parent = parent
    self._menu = MenuUI:new({
        name = "Wires",
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

    self.Wire1 = self._game:Image({
        name = "VentCover",
        texture = "pd2_mod_amongus/red_wire",
        texture_rect = {0, 0, 1024, 1024},
        w = self._menu_panel:w(),
        h = self._menu_panel:h(),
        align = "grow",
        --foreground = Color.red,
        --background_color = Color.white,
        enabled_alpha = 1,
        layer = 2,
        position = function(item)
            item:SetPosition(0, 0)
        end,
        on_callback = function(item)
            item:SetVisible(false)
        end
    })
    --PrintTable(getmetatable(self.Wire1:Panel()))

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
    PrintTable(getmetatable(self.Wire1.img))
    local function MouseMoved(o, x, y)
        --log("MouseMoved x:" .. tostring(x) .. " " .. tostring(y))
        if o:Inside(x, y) then
            local pnlx, pnly = self._game:Panel():world_position()
            --log("pnlx:" .. tostring(pnlx) .. " " .. tostring(pnly))
            local rotX = pnlx - x
            local rotY = pnly - y
            local rot = math.atan2(rotY, rotX) + 180
            --log("rot: " .. tostring(rot))
            --local x, y = x - pnlx, y - pnly
            local w = self.Wire1:Panel():w()
            --local x = math.floor(x / w)
            if self._pressed then
                self:drawline(pnlx, pnly, x, y, rot)
            else
                self:destroyline()
            end
            --self.Wire1:Panel():set_w(x)
            --[[self.Wire1:Panel():set_h(y)
            self.Wire1.img:set_width(x)
            --self.Wire1.img:set_height(y)
            --self.Wire1.img:set_rotation(rot)
            log(tostring(self.Wire1:Panel():w()))]]
        end
        return (self.menu_type and o:MouseMovedMenuEvent(x,y)) or o:MouseMovedSelfEvent(x,y)
    end

    local function MousePressed(o, b, x, y)
        if b == Idstring("0") then
            self._pressed = true
        end
        if self.menu_type and o:MousePressedMenuEvent(b, x, y) then
            return true
        else
            return o:MousePressedSelfEvent(b, x, y)
        end
    end

    local function MouseReleased(o, b, x, y)
        if b == Idstring("0") then
            self._pressed = false
        end
        if o.menu_type then
            if not o.menu._highlighted then
                o:SetPointer()
            end
            for _, item in pairs(o._my_items) do
                if item:MouseReleased(b, x, y) then
                    return true
                end
            end
        end
    
        if o._list then
            o._list:MouseReleased(b, x, y)
        end
    end

    if self._game.MouseMoved then
        self._game.MouseMoved = MouseMoved
        self._game.MousePressed = MousePressed
        self._game.MouseReleased = MouseReleased
    end


    --BeardLib:AddUpdater("AmongUsMinigame", ClassClbk(self, "update"))
    --self._menu:SetEnabled(true)
end
--self:drawline(pnlx, pnly, x, y, rot)
function Wires:drawline(x, y, x2, y2, rot)
    if self.Wires then self:destroyline() end
    for i = 1, 20, 1 do
        local x1 = math.abs((x - x2) * (i / 22))
        local y1 = math.abs((y - y2) * (i / 22))
        local y3 = math.abs((y2 - y)*(i*0.01))
        local x3 = math.abs((x2 - x)*(i*0.01))
        --log(tostring(x1) .. " " .. tostring(y1))
        --log("drawline" .. tostring(i))
        if y3 then
            self.Wires[i] = WiresObject:new(self, x1, y1, rot)
        end
    end
end

function Wires:destroyline()
    if self.Wires then
        for i = 1, 20, 1 do
            if self.Wires[i] then
                self.Wires[i]:Destroy()
            end
        end
    end
    self.Wires = {}
end


--create a callback for when the minigame is finished successfully
function Wires:on_minigame_finished()
    self._parent:_on_executed()
    self:Destroy()
end


function Wires:CreateObjects()
    self._asteroidnum = self._asteroidnum or math.random(3,7)
    for i = 1, self._asteroidnum, 1 do
        self._wires[i] = WiresObject:new(self, i)
    end
end

function Wires:Destroy()
    self._menu:Destroy()
    self._wires = nil
end

function Wires:VentDestroy(vent_num)
    self._wires[vent_num]:Destroy()
    self._wires[vent_num] = nil
    PrintTable(self._wires)
    log(tostring(#self._wires) .. " asteroids left")
    if table.size(self._wires) == 0 then
        local player_id = managers.network:session():local_peer():id()
        local completed = AmongUs.GM:progress_task(player_id, "short", "Wires")
        if completed then
            self:on_minigame_finished()
        end
    end
end

--will be used to update the asteroids flying around
function Wires:update(t, dt)
    for _, asteroid in pairs(self._asteroids) do
        asteroid:update(t, dt)
    end
end

WiresObject = WiresObject or class()

--initialize the wires object
function WiresObject:init(parent, x, y, rot)
    self._parent = parent
    --TODO: randomize texture
    self._wires = self._parent._game:Image({
        name = "Wires",
        texture = "pd2_mod_amongus/red_wire",
        texture_rect = {0, 0, 1024, 1024},
        w = 64,
        h = 64,
        color = Color(1, 1, 1),
        alpha = 1,
        visible = true,
        layer = 1,
        position = function(item)
            item:SetPosition(x, y)
        end
    })
    self._wires.img:set_rotation(rot)
    --self._wires:SetCenter(x - 32, y - 32)
end

--destroy the wires object
function WiresObject:Destroy()
    self._wires:Destroy()
    self._parent = nil
end