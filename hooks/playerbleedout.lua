function PlayerBleedOut:enter(state_data, enter_data)
	PlayerBleedOut.super.enter(self, state_data, enter_data)

	self._unit:camera():play_shaker("player_taser_shock", 5, 0.05)
	self._drop_wait_t = managers.player:player_timer():time() + 0.4

	self:_interupt_action_steelsight()
	self:_interupt_action_melee(managers.player:player_timer():time())
	self:_interupt_action_ladder(managers.player:player_timer():time())
	local projectile_entry = managers.blackmarket:equipped_projectile()

	if tweak_data.blackmarket.projectiles[projectile_entry].is_a_grenade then
		self:_interupt_action_throw_grenade(managers.player:player_timer():time())
	else
		self:_interupt_action_throw_projectile(managers.player:player_timer():time())
	end

	self:_interupt_action_charging_weapon(managers.player:player_timer():time())
	self:_start_action_unequip_weapon(managers.player:player_timer():time(), {
		selection_wanted = 1
	})
	self._unit:base():set_slot(self._unit, 4)
	self._unit:character_damage():on_fatal_state_enter()
	self._reequip_weapon = enter_data and enter_data.equip_weapon
end

function PlayerBleedOut:exit(state_data, new_state_name)
	PlayerBleedOut.super.exit(self, state_data, new_state_name)
	self:_end_action_bleedout(managers.player:player_timer():time())

	local exit_data = {
		equip_weapon = self._reequip_weapon
	}

	if new_state_name == "standard" then
		exit_data.wants_crouch = false
	end
	return exit_data
end

function PlayerBleedOut:update(t, dt)
	PlayerBleedOut.super.update(self, t, dt)
	if self._drop_wait_t then
		local tilt = math.lerp(35, 0, self._drop_wait_t - t)

		if self._drop_wait_t < t then
			self._drop_wait_t = nil

			self:_start_action_bleedout(managers.player:player_timer():time())
		end
	end
end

function PlayerBleedOut:_start_action_bleedout(t)
	self:_interupt_action_running(t)

	self._state_data.dying = true

	self:_stance_entered()
	self:_update_crosshair_offset()
	self._unit:kill_mover()
	self:_activate_mover(Idstring("duck"))
end

function PlayerBleedOut:_end_action_bleedout(t)
	if not self:_can_stand() then
		return
	end

	self._state_data.dying = false

	self:_stance_entered()
	self:_update_crosshair_offset()
	self._unit:kill_mover()
	self:_activate_mover(Idstring("stand"))
end

function PlayerBleedOut:_stance_entered(unequipped)
	local stance_standard = tweak_data.player.stances.default.standard
	local head_stance = (self._state_data.dying and tweak_data.player.stances.default.bleed_out.head) or (self._state_data.ducking and tweak_data.player.stances.default.crouched.head) or stance_standard.head
	local stance_id = nil
	local stance_mod = {
		translation = Vector3(0, 0, 0)
	}

	if not unequipped then
		stance_id = self._equipped_unit:base():get_stance_id()

		if self._state_data.in_steelsight and self._equipped_unit:base().stance_mod then
			stance_mod = self._equipped_unit:base():stance_mod() or stance_mod
		end
	end

	local stances = nil
	stances = (self:_is_meleeing() or self:_is_throwing_projectile()) and tweak_data.player.stances.default or tweak_data.player.stances[stance_id] or tweak_data.player.stances.default
	local misc_attribs = stances.standard
	misc_attribs = (not self:_is_using_bipod() or self:_is_throwing_projectile() or stances.bipod) and (self._state_data.in_steelsight and stances.steelsight or self._state_data.ducking and stances.crouched or stances.standard)
	local duration = tweak_data.player.TRANSITION_DURATION + (self._equipped_unit:base():transition_duration() or 0)
	local duration_multiplier = self._state_data.in_steelsight and 1 / self._equipped_unit:base():enter_steelsight_speed_multiplier() or 1
	local new_fov = self:get_zoom_fov(misc_attribs) + 0

	self._camera_unit:base():clbk_stance_entered(misc_attribs.shoulders, head_stance, misc_attribs.vel_overshot, new_fov, misc_attribs.shakers, stance_mod, duration_multiplier, duration)
	managers.menu:set_mouse_sensitivity(self:in_steelsight())
end

function PlayerBleedOut:_update_check_actions(t, dt)
	local input = self:_get_input(t, dt)

	self:_update_foley(t, input)

	local new_action = nil

	if input.btn_stats_screen_press then
		self._unit:base():set_stats_screen_visible(true)
	elseif input.btn_stats_screen_release then
		self._unit:base():set_stats_screen_visible(false)
	end

	self:_check_action_interact(t, input)
end

function PlayerBleedOut:_check_action_interact(t, input)
	if input.btn_interact_press then
		if _G.IS_VR then
			self._interact_hand = input.btn_interact_left_press and PlayerHand.LEFT or PlayerHand.RIGHT
		end
	end
end

function PlayerBleedOut._register_revive_SO(revive_SO_data, variant)

end
