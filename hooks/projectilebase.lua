function ProjectileBase:create_sweep_data()
	self._sweep_data = {slot_mask = self._slot_mask}
	self._sweep_data.slot_mask = managers.menu:modify_value_ff("ProjectileBase:create_sweep_data:slot_mask", self._sweep_data.slot_mask)
	self._sweep_data.current_pos = self._unit:position()
	self._sweep_data.last_pos = mvector3.copy(self._sweep_data.current_pos)
end