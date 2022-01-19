EditorTask = EditorTask or class(MissionScriptEditor)
EditorTask.ON_EXECUTED_ALTERNATIVES = {"interacted", "interupt", "start"}
function EditorTask:init(...)
	local unit = "pd2_mod_amongus/units/dev_tools/mission_elements/point_interaction/interaction_dummy"
	local assets = self:GetPart("assets")
	if not PackageManager:has(Idstring("unit"), Idstring(unit)) and assets then
		self:GetPart("assets"):quick_load_from_db("unit", unit)
	end
	return EditorTask.super.init(self, ...)
end

function EditorTask:create_element(...)
	self.super.create_element(self, ...)
	self._element.class = "ElementTask"
	self._element.values.tweak_data_id = "none"
	self._element.values.override_timer = -1 
end

function EditorTask:update_interaction_unit(pos, rot)
	local element = managers.mission:get_element_by_id(self._element.id)
	if alive(self._last_alert) then
		self._last_alert:Destroy()
	end
	if element then
		if tweak_data.interaction[self._element.values.tweak_data_id] then
			if not alive(element._unit) then
				element._unit = CoreUnit.safe_spawn_unit("pd2_mod_amongus/units/dev_tools/mission_elements/point_interaction/interaction_dummy", self._element.values.position, self._element.values.rotation)
				element._unit:interaction():set_mission_element(element)
			end
			element._unit:interaction():set_tweak_data(self._element.values.tweak_data_id)
		else
			local msg = "Current tweak data ID does not exist"
			if self._element.values.tweak_data_id == "none" then
				msg = "No interaction tweak data ID set"
			end
			self._last_alert = self:Alert(msg..". \nThe element will not work.")
			self._holder:AlignItems(true)
		end
		if alive(element._unit) then
			element._unit:set_position(self._element.values.position)
			element._unit:set_rotation(self._element.values.rotation)
			element._unit:set_moving()
			element._unit:interaction():set_override_timer_value(self._element.values.override_timer ~= -1 and self._element.values.override_timer or nil)
		end
	end
end

function EditorTask:set_element_data(...)
	EditorTask.super.set_element_data(self, ...)
	self:update_interaction_unit()
end

function EditorTask:update_positions(...)
	EditorTask.super.update_positions(self, ...)
	self:update_interaction_unit()
end

function EditorTask:_build_panel()
	self:_create_panel()
	self:ComboCtrl("task_type", table.map_keys(AmongUs.TweakData.tasks))
	self:ComboCtrl("task_id", table.map_keys(AmongUs.TweakData.tasks[self._element.values.task_type or "common"]), {help = "The ID of the task you wish to spawn."})
	--self:Text("This element creates an interaction that will create a Task minigame UI.")
	self:ComboCtrl("tweak_data_id", table.list_add({"none"}, table.map_keys(tweak_data.interaction)))
	self:NumberCtrl("override_timer", {floats = 1, min = -1, help = "Can be used to override the interaction time specified in tweak data. -1 means that it should not override."})
	self:update_interaction_unit()
	self:BuildElementsManage("elements")
	self:ComboCtrl("toggle", {"on","off","toggle"}, {help = "Select how you want to toggle an element"})
	self:NumberCtrl("set_trigger_times", {floats = 0, min = -1, help = "Sets the elements trigger times when toggle on (-1 means do not use)"})

	self:Info("This element creates an interaction that will create a Task minigame UI.\nIt also provides the ability to toggle elements on successful task completion.")
end