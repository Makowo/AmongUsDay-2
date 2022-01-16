function HuskPlayerMovement:sync_start_auto_fire_sound()
	if self._state == "mask_off" or self._state == "clean" or self._state == "civilian" then
		return
	end

	if self._auto_firing <= 0 then
		local delay = self._stance.values[3] < 0.7

		if delay then
			self._auto_firing = 1

			local function f(t)
				local equipped_weapon = self._unit:inventory():equipped_unit()
				local start_auto_fire = equipped_weapon:base().start_autofire

				local name = equipped_weapon:base():get_name_id()

				if equipped_weapon then
					if start_auto_fire then
						equipped_weapon:base():start_autofire()
					end
                end

				self._auto_firing = 2
			end

			self:_change_stance(3, f)
		else
			local equipped_weapon = self._unit:inventory():equipped_unit()
			local start_auto_fire = equipped_weapon:base().start_autofire

            if equipped_weapon then
			    if start_auto_fire then
					equipped_weapon:base():start_autofire()
				end
             end

			self:_change_stance(3, false)

			self._auto_firing = 2
		end

		self._aim_up_expire_t = TimerManager:game():time() + 2
	end
end

function HuskPlayerMovement:sync_stop_auto_fire_sound()
	if self._state == "mask_off" or self._state == "clean" or self._state == "civilian" then
		return
	end

	if self._auto_firing > 0 then
		local equipped_weapon = self._unit:inventory():equipped_unit()
		local stop_autofire = equipped_weapon:base().stop_autofire

		local name = equipped_weapon:base():get_name_id()

		if equipped_weapon then
			if stop_autofire then
				equipped_weapon:base():stop_autofire()
			end
		end
		
		self._auto_firing = 0
		local stance = self._stance

		if stance.transition then
			stance.transition.delayed_shot = nil
		end
	end
end


function HuskPlayerMovement:set_need_revive(need_revive, down_time)
	if self._need_revive == need_revive then
		return
	end
	self._unit:character_damage():set_last_down_time(down_time)
	self._need_revive = need_revive
end

function HuskPlayerMovement:_sync_movement_state_bleed_out(event_descriptor)
	self._arm_animator:set_state_blocked("bleed_out", true)
	self._unit:set_slot(3)
	self:set_need_revive(true, event_descriptor.down_time)
	self:play_redirect("death")

	if self._atention_on then
		self._machine:forbid_modifier(self._look_modifier_name)
		self._machine:forbid_modifier(self._head_modifier_name)
		self._machine:forbid_modifier(self._arm_modifier_name)
		self._machine:forbid_modifier(self._mask_off_modifier_name)

		self._atention_on = false
	end

	self:set_attention_updator(self._upd_attention_bleedout)
	self:set_movement_updator(self._upd_move_no_animations)
end
Hooks:PostHook(HuskPlayerMovement, "_sync_movement_state_standard", "CW_reequip_weapon", function(self, event_descriptor)
	self._primary_hand = 1
	self._unit:inventory():refresh_primary_hand()
	self._primary_hand = 0
	self._unit:inventory():refresh_primary_hand()
end)