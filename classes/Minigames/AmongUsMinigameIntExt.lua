AmongUsMinigameIntExt = AmongUsMinigameIntExt or class(MissionElementInteractionExt)

function AmongUsMinigameIntExt:interact(player, potato, ...)
    --log("potato 2 " .. aaa)
	local res = AmongUsMinigameIntExt.super.interact(self, player, ...)

	if res and Network:is_server() then
		self._mission_element:on_interacted(player)
	end
	return res
    --self._class = class:new(self, player, ...)
end

--