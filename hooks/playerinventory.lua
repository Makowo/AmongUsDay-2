--From Cpone's Secondary as Primary.
function PlayerInventory:add_unit_by_factory_name_selection_index(factory_name, equip, instant, blueprint, cosmetics, texture_switches, selection_index)
	local factory_weapon = tweak_data.weapon.factory[factory_name]
	local ids_unit_name = Idstring(factory_weapon.unit)

	if not managers.dyn_resource:is_resource_ready(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE) then
		managers.dyn_resource:load(Idstring("unit"), ids_unit_name, managers.dyn_resource.DYN_RESOURCES_PACKAGE, nil)
	end

	local new_unit = World:spawn_unit(ids_unit_name, Vector3(), Rotation())

	new_unit:base():set_factory_data(factory_name)
	new_unit:base():set_cosmetics_data(cosmetics)
	new_unit:base():set_texture_switches(texture_switches)

	if blueprint then
		new_unit:base():assemble_from_blueprint(factory_name, blueprint)
	else
		new_unit:base():assemble(factory_name)
	end

	local setup_data = {
		user_unit = self._unit,
		ignore_units = {
			self._unit,
			new_unit
		},
		expend_ammo = true,
		autoaim = true,
		alert_AI = true,
		alert_filter = self._unit:movement():SO_access(),
		timer = managers.player:player_timer()
	}

	if blueprint then
		setup_data.panic_suppression_skill = not managers.weapon_factory:has_perk("silencer", factory_name, blueprint) and managers.player:has_category_upgrade("player", "panic_suppression") or false
	end

	new_unit:base():setup(setup_data)
	self:add_unit_selection_index(new_unit, equip, instant, selection_index)

	if new_unit:base().AKIMBO then
		new_unit:base():create_second_gun()
	end
end

function PlayerInventory:add_unit_selection_index(new_unit, is_equip, equip_is_instant, selection_index)
	local new_selection = {}
	local use_data = new_unit:base():get_use_data(self._use_data_alias)
	new_selection.use_data = use_data
	new_selection.unit = new_unit

	new_unit:base():add_destroy_listener(self._listener_id, callback(self, self, "clbk_weapon_unit_destroyed"))
	new_unit:base().forced_selection_index = selection_index

	if self._available_selections[selection_index] then
		local old_weapon_unit = self._available_selections[selection_index].unit
		is_equip = is_equip or old_weapon_unit == self:equipped_unit()

		old_weapon_unit:base():remove_destroy_listener(self._listener_id)
		old_weapon_unit:base():set_slot(old_weapon_unit, 0)
		World:delete_unit(old_weapon_unit)

		if self._equipped_selection == selection_index then
			self._equipped_selection = nil
		end
	end

	self._available_selections[selection_index] = new_selection
	self._latest_addition = selection_index
	self._selected_primary = self._selected_primary or selection_index

	self:_call_listeners("add")

	if is_equip then
		self:equip_latest_addition(equip_is_instant)
	else
		self:_place_selection(selection_index, is_equip)
	end
end