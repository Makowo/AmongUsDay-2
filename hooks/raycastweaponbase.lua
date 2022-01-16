function RaycastWeaponBase:selection_index()
	return self.forced_selection_index or self:weapon_tweak_data().use_data.selection_index
end