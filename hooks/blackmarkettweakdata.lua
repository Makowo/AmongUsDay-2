--[[
function BlackMarketTweakData:_init_characters(tweak_data)

	--Locked
	self.characters = {
		locked = {}
	}
	self.characters.locked.fps_unit =	"units/payday2/characters/fps_mover/fps_mover"
	self.characters.locked.npc_unit =	"units/pd2_mod_pvp/characters/npc_criminals_suit_1/npc_criminals_suit_1"
	self.characters.locked.menu_unit =	"units/pd2_mod_pvp/characters/npc_criminals_suit_1/npc_criminals_suit_1"
	self.characters.locked.sequence = "var_material_01"
	self.characters.locked.name_id = "bm_character_locked"
	
	--Dallas
	self.characters.locked.dallas = {
		sequence =	"var_mtr_dallas",
		installed = true,
		material_config = {
			fps = "units/payday2/characters/fps_criminals_suit_1/mtr_dallas",
			npc = "units/payday2/characters/npc_criminals_suit_1/mtr_dallas"
		}
	}
	self.characters.locked.wolf = deep_clone(self.characters.locked.dallas)
	self.characters.locked.hoxton = deep_clone(self.characters.locked.dallas)
	self.characters.locked.chains = deep_clone(self.characters.locked.dallas)
	self.characters.locked.jowi = deep_clone(self.characters.locked.dallas)
	self.characters.locked.old_hoxton = deep_clone(self.characters.locked.dallas)
	self.characters.locked.dragan = deep_clone(self.characters.locked.dallas)
	self.characters.locked.jacket = deep_clone(self.characters.locked.dallas)
	self.characters.locked.sokol = deep_clone(self.characters.locked.dallas)
	self.characters.locked.dragon = deep_clone(self.characters.locked.dallas)
	self.characters.locked.bodhi = deep_clone(self.characters.locked.dallas)
	self.characters.locked.jimmy = deep_clone(self.characters.locked.dallas)
	self.characters.female_1 = deep_clone(self.characters.locked.dallas)
	self.characters.bonnie = deep_clone(self.characters.locked.dallas)
	self.characters.sydney = deep_clone(self.characters.locked.dallas)
	self.characters.wild = deep_clone(self.characters.locked.dallas)
	self.characters.chico = deep_clone(self.characters.locked.dallas)
	self.characters.max = deep_clone(self.characters.locked.dallas)
	self.characters.joy = deep_clone(self.characters.locked.dallas)
	self.characters.myh = deep_clone(self.characters.locked.dallas)
	self.characters.ecp_female = deep_clone(self.characters.locked.dallas)
	self.characters.ecp_male = deep_clone(self.characters.locked.dallas)
	
	--AI
	self.characters.ai_dallas = {
		npc_unit = "units/pd2_mod_pvp/characters/npc_criminals_suit_1/npc_criminals_suit_1",
		sequence = "var_mtr_dallas"
	}
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_chains = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_chains = deep_clone(self.characters.ai_dallas)
	self.characters.ai_wolf = deep_clone(self.characters.ai_dallas)
	self.characters.ai_jowi = deep_clone(self.characters.ai_dallas)
	self.characters.ai_old_hoxton = deep_clone(self.characters.ai_dallas)
	self.characters.ai_female_1 = deep_clone(self.characters.ai_dallas)
	self.characters.ai_dragan = deep_clone(self.characters.ai_dallas)
	self.characters.ai_jacket = deep_clone(self.characters.ai_dallas)
	self.characters.ai_bonnie = deep_clone(self.characters.ai_dallas)
	self.characters.ai_sokol = deep_clone(self.characters.ai_dallas)
	self.characters.ai_dragon = deep_clone(self.characters.ai_dallas)
	self.characters.ai_bodhi = deep_clone(self.characters.ai_dallas)
	self.characters.ai_jimmy = deep_clone(self.characters.ai_dallas)
	self.characters.ai_sydney = deep_clone(self.characters.ai_dallas)
	self.characters.ai_wild = deep_clone(self.characters.ai_dallas)
	self.characters.ai_chico = deep_clone(self.characters.ai_dallas)
	self.characters.ai_max = deep_clone(self.characters.ai_dallas)
	self.characters.ai_joy = deep_clone(self.characters.ai_dallas)
	self.characters.ai_myh = deep_clone(self.characters.ai_dallas)
	self.characters.ai_ecp_female = deep_clone(self.characters.ai_dallas)
	self.characters.ai_ecp_male = deep_clone(self.characters.ai_dallas)
	
	
	local free_dlcs = tweak_data:free_dlc_list()

	for _, data in pairs(self.characters) do
		if free_dlcs[data.dlc] then
			data.dlc = nil
		end
	end

	for _, data in pairs(self.characters.locked) do
		if free_dlcs[data.dlc] then
			data.dlc = nil
		end
	end
end
]]--
