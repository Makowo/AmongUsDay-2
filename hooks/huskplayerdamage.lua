function HuskPlayerDamage:damage_bullet(attack_data)
	local head = attack_data.col_ray.body and attack_data.col_ray.body:name() == Idstring("head")
	if attack_data.attacker_unit == managers.player:player_unit() then

		if head then
			attack_data.damage = attack_data.damage * 1.25
			attack_data.headshot = true
		end
	end

	self:_send_damage_to_owner(attack_data)
end

function HuskPlayerDamage:damage_melee(attack_data)
	self:_send_damage_to_owner(attack_data)
end

function HuskPlayerDamage:damage_fire(attack_data)
	attack_data.damage = attack_data.damage

	self:_send_damage_to_owner(attack_data)
end
function HuskPlayerDamage:_send_damage_to_owner(attack_data)
	if (not self._unit:movement():downed()) then
		local peer_id = managers.criminals:character_peer_id_by_unit(self._unit)
		local damage = attack_data.damage
		managers.network:session():send_to_peers("sync_friendly_fire_damage", peer_id, attack_data.attacker_unit, damage, attack_data.variant)

		if attack_data.attacker_unit == managers.player:player_unit() then
			if managers.hud.on_damage_confirmed then
				managers.hud:on_damage_confirmed(false, attack_data.headshot)
			else
				managers.hud:on_hit_confirmed()
			end
		end

		managers.job:set_memory("trophy_flawless", true, false)
	end
end
