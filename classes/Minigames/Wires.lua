Wires = Wires or class()

function Wires:init(parent, ...)
    self._wires = {}
    self._pressed = {}
    self._colors = {"white", "red", "green", "blue", "yellow", "cyan", "purple"}
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

    self:CreateObjects()

    --BeardLib:AddUpdater("AmongUsMinigame", ClassClbk(self, "update"))
    --self._menu:SetEnabled(true)
end
--self:drawline(pnlx, pnly, x, y)
function Wires:drawline(x, y, x2, y2, pos, color)
    if self.Wires then self:destroyline() end
    local rotX = x - x2
    local rotY = y - y2
    local rot = math.atan2(rotY, rotX) + 180
    for i = 1, 20, 1 do
        local x1 = math.abs((rotX) * (i / 22))
        local y1 = math.abs((rotY) * (i / 22) - pos)

        if y1 and x1 then
            self.Wires[i] = WiresObject:new(self, x1, y1, rot, color)
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

--pain, i'm so sorry
--Create the wire, and attach the mouse code to it
function Wires:CreateObjects()

    local function MouseMoved(o, x, y)
        if self._game:Inside(x, y) then
            local pnlx, pnly = o:Panel():world_position()
            local tbl = self._pressed[o:Name()]
            if tbl and tbl.state then
                self:drawline(pnlx, pnly, x, y, tbl.pos, tbl.color)
            else
                self:destroyline()
            end
        end
        return (self.menu_type and o:MouseMovedMenuEvent(x,y)) or o:MouseMovedSelfEvent(x,y)
    end

    local function MouseReleased(o, b, x, y)
        if b == Idstring("0") then
            local state = self._pressed[o:Name()] and self._pressed[o:Name()].state
            if state and self._WireRight:Inside(x,y) then
                self:CompleteStep()
            end
            self:destroyline()
            self._pressed[o:Name()] = {state = false, pos = 0, color = nil}
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
    --left wire
    self._WireLeft = {}
    local name = "WireLeft1"
    local pos = math.clamp(math.random(self._game:H()), 64, self._game:H() - 64) --select a random position
    local color = math.random(#self._colors) --select a random color
    table.remove(self._colors, color) --remove it from the list

    self._WireLeft = self._game:ImageButton({
        name = name,
        layer = 2,
        texture = "pd2_mod_amongus/red_wire",
        texture_rect = {0, 0, 32, 32},
        w = 32,
        h = 16,
        img_color = Color[self._colors[color]],
        position = function(item)
            item:SetPosition(0, pos)
        end,
        on_callback = ClassClbk(self, "update", name, pos, Color[self._colors[color]])
    })

    --Right wire.
    local otherpos = math.clamp(math.random(self._game:H()), 64, self._game:H() - 64)
    self._WireRight = self._game:Image({
        name = "WireRight",
        layer = 2,
        texture = "pd2_mod_amongus/red_wire",
        texture_rect = {0, 0, 32, 32},
        w = 32,
        h = 16,
        img_color = Color[self._colors[color]],
        position = function(item)
            item:SetPosition(self._game:W() - 32, otherpos)
        end,
    })
    --Replace the mouse code for the left wire
    self._WireLeft.MouseMoved = MouseMoved
    self._WireLeft.MouseReleased = MouseReleased
end

--when a wire is connected, this is called
function Wires:CompleteStep()
    self._step = self._step and self._step + 1 or 1
    if self._step >= 4 then
        local player_id = managers.network:session():local_peer():id()
        AmongUs.GM:progress_task(player_id, "short", "Wires")
        self:on_minigame_finished()
    else
        self:DestroyObjects()
        self:CreateObjects()
    end
end

function Wires:DestroyObjects()
    self._WireLeft:Destroy()
    self._WireLeft = {}
    self._WireRight:Destroy()
    self._WireRight = {}
end

function Wires:Destroy()
    self._menu:Destroy()
    self._wires = nil
end

--updates the pressed table
--jank because i was trying to do 4 wires at once and it was too hard
function Wires:update(o, pos, color)
    self._pressed[o] = {state = true, pos = pos, color = color}
end

WiresObject = WiresObject or class()

--initialize the wires object
function WiresObject:init(parent, x, y, rot, color)
    self._parent = parent

    self._wires = self._parent._game:Image({
        name = "Wires",
        texture = "pd2_mod_amongus/red_wire",
        texture_rect = {0, 0, 32, 32},
        w = 64,
        h = 16,
        img_color = color,
        alpha = 1,
        visible = true,
        layer = 1,
        position = function(item)
            item:SetCenter(x + 16, y + 16)
        end
    })
    self._wires.img:set_rotation(rot)
end

--destroy the wires object
function WiresObject:Destroy()
    self._wires:Destroy()
    self._parent = nil
end