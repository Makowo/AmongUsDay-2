function PlayerDamage:is_friendly_fire(unit)
	return false
end
--[[
--Godmode debug
function PlayerDamage:change_health(change_of_health)
	self:_check_update_max_health()
	local new_health = self:get_real_health() + change_of_health
	self._said_hurt = true
	return self:set_health(new_health < 1 and self:_max_health() or new_health)
end
]]--
Hooks:PreHook(PlayerDamage, "replenish", "replenish_reload", function(self, unit)
	for id, weapon in pairs(self._unit:inventory()._available_selections) do
		weapon.unit:base():replenish()
		managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
	end
end)

function PlayerDamage:_update_regenerate_timer(t, dt)
end

function PlayerDamage:damage_fall(data)
	local damage_info = {
		result = {
			variant = "fall",
			type = "hurt"
		}
	}

	if self._god_mode or self._invulnerable or self._mission_damage_blockers.invulnerable then
		self:_call_listeners(damage_info)

		return
	elseif self:incapacitated() then
		return
	elseif self._unit:movement():current_state().immortal then
		return
	elseif self._mission_damage_blockers.damage_fall_disabled then
		return
	end

	local height_limit = 300
	local death_limit = 1500

	if data.height < height_limit then
		return
	end

	local die = death_limit < data.height

	self._unit:sound():play("player_hit")
	managers.environment_controller:hit_feedback_down()
	managers.hud:on_hit_direction(Vector3(0, 0, 0), die and HUDHitDirection.DAMAGE_TYPES.HEALTH or HUDHitDirection.DAMAGE_TYPES.ARMOUR, 0)

	if self._bleed_out and self._unit:movement():current_state_name() ~= "jerry1" then
		return
	end

	local health_damage_multiplier = 0

	if die then
		self._check_berserker_done = false

		self:set_health(0)

		if self._unit:movement():current_state_name() == "jerry1" then
			self._revives = Application:digest_value(1, true)
		end
	else
		health_damage_multiplier = managers.player:upgrade_value("player", "fall_damage_multiplier", 1) * managers.player:upgrade_value("player", "fall_health_damage_multiplier", 1)

		self:change_health(-(tweak_data.player.fall_health_damage * health_damage_multiplier))
	end

	if die or health_damage_multiplier > 0 then
		local alert_rad = tweak_data.player.fall_damage_alert_size or 500
		local new_alert = {
			"vo_cbt",
			self._unit:movement():m_head_pos(),
			alert_rad,
			self._unit:movement():SO_access(),
			self._unit
		}

		managers.groupai:state():propagate_alert(new_alert)
	end

	local max_armor = self:_max_armor()

	if die then
		self:set_armor(0)
	else
		self:change_armor(-max_armor * managers.player:upgrade_value("player", "fall_damage_multiplier", 1))
	end

	SoundDevice:set_rtpc("shield_status", 0)
	self:_send_set_armor()

	self._bleed_out_blocked_by_movement_state = nil

	managers.hud:set_player_health({
		current = self:get_real_health(),
		total = self:_max_health(),
		revives = Application:digest_value(self._revives, false)
	})
	self:_send_set_health()
	self:_set_health_effect()
	self:_damage_screen()
	self:_check_bleed_out(nil, true)
	self:_call_listeners(damage_info)

	return true
end

function PlayerDamage:update_downed(t, dt)
	if self._downed_timer and self._downed_paused_counter == 0 then
		self._downed_timer = self._downed_timer - dt

		if self._downed_start_time == 0 then
			self._downed_progression = 100
		else
			self._downed_progression = math.clamp(1 - self._downed_timer / self._downed_start_time, 0, 1) * 100
		end

		return self._downed_timer <= 0
	end

	return false
end

function PlayerDamage:down_time()
	return 3
end

function PlayerDamage:_check_bleed_out(can_activate_berserker, ignore_movement_state)
	self._revives = Application:digest_value(3, true)
	if self:get_real_health() == 0 then
		self:disable_berserker()
		managers.environment_controller:set_last_life(true)
		self._bleed_out = true
		self._current_state = nil
		managers.player:set_player_state("bleed_out")
		self:on_downed()
	end
end

local calc_health_damage_orig = PlayerDamage._calc_health_damage
function PlayerDamage:_calc_health_damage(attack_data)
	local health_subtracted = calc_health_damage_orig(self, attack_data)
	
	if attack_data and attack_data.attacker_unit and self:get_real_health() <= 0 then
		managers.hud:cw_set_killer(attack_data.attacker_unit)
	end

	return health_subtracted
end

function PlayerDamage:_chk_dmg_too_soon(damage)
	return false
end

function PlayerDamage:_bleed_out_damage(attack_data)

end