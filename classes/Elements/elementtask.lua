core:import("CoreMissionScriptElement")

ElementTask = ElementTask or class(CoreMissionScriptElement.MissionScriptElement)

function ElementTask:init(...)
	ElementTask.super.init(self, ...)

	if Network:is_server() then
		local host_only = self:value("host_only")

		if host_only then
			self._unit = CoreUnit.safe_spawn_unit("pd2_mod_amongus/units/dev_tools/mission_elements/point_interaction/interaction_dummy", self._values.position, self._values.rotation)
		else
			self._unit = CoreUnit.safe_spawn_unit("pd2_mod_amongus/units/dev_tools/mission_elements/point_interaction/interaction_dummy", self._values.position, self._values.rotation)
		end

		if self._unit then
			self._unit:interaction():set_host_only(host_only)
			self._unit:interaction():set_active(false)
			self._unit:interaction():set_mission_element(self)
			self._unit:interaction():set_tweak_data(self._values.tweak_data_id)

			if self._values.override_timer ~= -1 then
				self._unit:interaction():set_override_timer_value(self._values.override_timer)
			end
		end
	end
end

function ElementTask:on_script_activated()
	if alive(self._unit) and self._values.enabled then
		self._unit:interaction():set_active(self._values.enabled, true)
	end
end

function ElementTask:set_enabled(enabled)
	ElementTask.super.set_enabled(self, enabled)

	if alive(self._unit) then
		self._unit:interaction():set_active(enabled, true)
	end
end

function ElementTask:on_executed(instigator, ...)
	if not self._values.enabled then
		return
	end
	local class = AmongUs.TweakData.tasks[self._values.task_type][self._values.task_id].class
	--AmongUsMinigameBase:init(self, class, ...)
	class:new(self, ...)
end

function ElementTask:_on_executed(instigator, ...)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		if element then
			if self._values.toggle == "on" then
				element:set_enabled(true)

				if self._values.set_trigger_times and self._values.set_trigger_times > -1 then
					element:set_trigger_times(self._values.set_trigger_times)
				end
			elseif self._values.toggle == "off" then
				element:set_enabled(false)
			else
				element:set_enabled(not element:value("enabled"))
			end

			element:on_toggle(element:value("enabled"))
		end
	end

	ElementTask.super.on_executed(self, instigator, ...)
end

function ElementTask:on_interacted(instigator)
	self:on_executed(instigator, "interacted")
end

function ElementTask:on_interact_start(instigator)
	--self:on_executed(instigator, "start")
end

function ElementTask:on_interact_interupt(instigator)
	--self:on_executed(instigator, "interupt")
end

function ElementTask:stop_simulation(...)
	ElementTask.super.stop_simulation(self, ...)

	if alive(self._unit) then
		World:delete_unit(self._unit)
	end
end
