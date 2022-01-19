AmongUsMinigameIntExt = AmongUsMinigameIntExt or class(MissionElementInteractionExt)

function AmongUsMinigameIntExt:interact(player, ...)
	local res = AmongUsMinigameIntExt.super.super.interact(self, player, ...)

	if res and Network:is_server() then
		self._mission_element:on_interacted(player)
	end

	return res
end