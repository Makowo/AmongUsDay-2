Hooks:PostHook(HUDPlayerDowned, "init", "init_cw_killbox", function(self, hud)
	if self._hud_panel:child("kill_panel") then
		self._hud_panel:remove(self._hud_panel:child("kill_panel"))
	end

	if self._hud_panel:child("downed_panel") then
		self._hud_panel:child("downed_panel"):hide()
	end

	local downed_panel = self._hud_panel:panel({
		name = "kill_panel"
	})
	local h = 100
	local w = math.round(self._hud_panel:w() / 1.6)
	local x = math.round(self._hud_panel:w() / 2 - w / 2)
	local y = math.round(self._hud_panel:h() / 1.4)
	self._death_panel = HUDBGBox_create(downed_panel, {
		w = w,
		h = h,
		x = x,
		y = y,
		valign = {
			0,
			0
		}
	})

	local killer_image = self._death_panel:bitmap({
		layer = 2,
		x = 10,
		y = 10,
		w = 50,
		h = 50,
		name = "killer_image"
	})
	local health_panel = self._death_panel:panel({
		name = "health_panel",
		w = 45,
		h = 45
	})
	health_panel:set_left(killer_image:right()+5)
	health_panel:set_center_y(killer_image:center_y())

	local radial_bg = health_panel:bitmap({
		texture = "guis/textures/pd2/hud_radialbg",
		name = "radial_bg",
		alpha = 1,
		layer = 0,
		w = health_panel:w(),
		h = health_panel:h()
	})
	local radial_health = health_panel:bitmap({
		texture = "guis/textures/pd2/hud_health",
		name = "radial_health",
		layer = 2,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0.5, 1, 1),
		w = health_panel:w(),
		h = health_panel:h()
	})
	local radial_shield = health_panel:bitmap({
		texture = "guis/textures/pd2/hud_shield",
		name = "radial_shield",
		layer = 1,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			128,
			0,
			-128,
			128
		},
		color = Color(1, 0, 1, 1),
		w = health_panel:w(),
		h = health_panel:h()
	})

	local killer_name = self._death_panel:text({
		text = "Very Epic Killer Man",
		y = 13,
		name = "killer_name",
		align = "left",
		font = tweak_data.hud.medium_font_noshadow,
		font_size = 25
	})
	killer_name:set_left(health_panel:right()+5)
	local character = self._death_panel:text({
		text = "Chins",
		y = 38,
		name = "character",
		align = "left",
		font = tweak_data.hud.medium_font_noshadow,
		font_size = 20
	})
	character:set_left(killer_name:left())
	local killed_with = self._death_panel:text({
		name = "killed_with",
		text = "BAD LUCK",
		x = 10,
		align = "left",
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.one_down,
		font_size = 30
	})
	killed_with:set_range_color(0, utf8.len(killed_text), tweak_data.screen_colors.risk)
	killed_with:set_y(killer_image:bottom()+5)
	
	local timer_panel = self._death_panel:panel({
		name = "timer_panel"
	})
	local respawn_text = timer_panel:text({
		text = managers.localization:text("pvp_respawn_in"),
		name = "respawn_text",
		font = tweak_data.hud.medium_font_noshadow,
		color = tweak_data.screen_colors.risk,
		font_size = 25
	})
	managers.hud:make_fine_text(respawn_text)
	timer_panel:set_w(respawn_text:w())
	local timer = timer_panel:text({
		name = "timer",
		text = "0.0",
		font = tweak_data.menu.pd2_large_font,
		color = tweak_data.screen_colors.risk,
		font_size = 50
	})
	managers.hud:make_fine_text(timer)
	timer:set_y(respawn_text:bottom()+5)
	timer:set_right(timer_panel:w())
	timer_panel:set_h(timer:bottom())
	timer_panel:set_center_y(self._death_panel:h() / 2)

	local timer_clock_fg = timer_panel:bitmap({
		layer = 2,
		w = 38,
		h = 38,
		rotation = 360,
		texture = "units/pd2_mod_pvp/guis/icon_respawn",
		name = "timer_clock_fg"
	})
	timer_clock_fg:set_right(timer:left()-5)
	timer_clock_fg:set_center_y(timer:center_y()-3)

	local timer_clock = timer_panel:bitmap({
		name = "timer_clock",
		layer = 1,
		texture = "guis/textures/test_blur_df",
		render_template = "VertexColorTexturedRadial",
		texture_rect = {
			32,
			0,
			-32,
			32
		},
		color = Color(0, 1, 1),
		w = 22,
		h = 22
	})
	timer_clock:set_center_x(timer_clock_fg:center_x())
	timer_clock:set_bottom(timer_clock_fg:bottom()-5)

	self._timer = timer
	local weapon_image = downed_panel:bitmap({
		texture = "guis/textures/pd2/blackmarket/icons/weapons/outline/amcar",
		layer = 2,
		rotation = 25,
		w = 270,
		h = 130,
		name = "weapon_image"
	})
	weapon_image:set_right(self._death_panel:x() + self._death_panel:w() / 1.2)
	weapon_image:set_center_y(self._death_panel:y() + self._death_panel:h() / 2)
end)

function HUDPlayerDowned:on_downed()
	local kill_panel = self._hud_panel:child("kill_panel")
	local weapon_image = kill_panel:child("weapon_image")
	self._death_panel:animate(callback(self, self, "open_deathbox"), weapon_image)
	self._hud.timer:set_text("")
end

function HUDPlayerDowned:start_timer(o, time)
	local start_time = time
	local timer = o:parent():child("timer_clock")
	while time > 0 do
		local dt = coroutine.yield()
		time = time - dt
		local text = time
		o:set_text(string.format("%.1f", text) )
		timer:set_color(Color(time/start_time, 1, 1))
	end
	o:set_text("0.0")
end

function HUDPlayerDowned:open_deathbox(panel, weapon_image)
	local TOTAL_T = 0.3
	local t = TOTAL_T

	local h = 100
	local w = math.round(self._hud_panel:w() / 1.6)
	local x = math.round(self._hud_panel:w() / 2 - w / 2)
	local y = math.round(self._hud_panel:h() / 1.4)

	panel:set_shape(x,y,w,h)
	local center_x, center_y = panel:center()

	weapon_image:set_size(270, 130)
	weapon_image:set_right(panel:x() + panel:w() / 1.2)
	weapon_image:set_center_y(panel:y() + panel:h() / 2)
	local weapon_center_x, weapon_center_y = weapon_image:center()

	local timer_panel = panel:child("timer_panel")
	while t > 0 do
		local dt = coroutine.yield()
		t = t - dt
		local curr_w = math.lerp(w, 0, t / TOTAL_T)
		local curr_h = math.lerp(h, 0, t / TOTAL_T)
		panel:set_w(curr_w)
		panel:set_center(center_x, center_y)

		curr_w = math.lerp(270, 520, t / TOTAL_T)
		curr_h = math.lerp(130, 380, t / TOTAL_T)
		weapon_image:set_size(curr_w, curr_h)
		weapon_image:set_center(weapon_center_x, weapon_center_y)
		weapon_image:set_alpha(math.lerp(1, 0, t / TOTAL_T))
		timer_panel:set_right(panel:w() - 5)
	end
	panel:set_size(w, h)
	panel:set_position(x,y)
	timer_panel:set_right(panel:w() - 5)

	weapon_image:set_size(270, 130)
	weapon_image:set_center(weapon_center_x, weapon_center_y)
	weapon_image:set_alpha(1)
end

function HUDPlayerDowned:cw_set_killer(killer)
	if alive(killer) then
		--if killer.contour then killer:contour():add("mark_unit", false) end
		local peer = managers.network:session():peer_by_unit(killer)
		if peer then
			local killer_text = self._death_panel:child("killer_name")
			local character = self._death_panel:child("character")
			local killed_with = self._death_panel:child("killed_with")
			local killer_image = self._death_panel:child("killer_image")
			local kill_panel = self._hud_panel:child("kill_panel")
			local weapon_image = kill_panel:child("weapon_image")
			local health_panel = self._death_panel:child("health_panel")
			local radial_health = health_panel:child("radial_health")
			local radial_shield = health_panel:child("radial_shield")
			
			
			local killer_name = peer:name() or ""
			local character_name = managers.localization:text("menu_" ..peer:character())
			local equipped_weapon = killer:inventory():equipped_unit()
			local weapon_factory_id = (equipped_weapon:base()._factory_id):gsub("_npc", "")
			local weapon_id = managers.weapon_factory:get_weapon_id_by_factory_id(weapon_factory_id) or "amcar"
			local weapon_name = managers.localization:text(tweak_data.weapon[weapon_id].name_id)
			local peer_id = peer:id()
			local character_data = managers.criminals:character_data_by_peer_id(peer_id)

			local prefix = "guis"
			local texture = "/textures/pd2/blackmarket/icons/weapons/outline/" .. weapon_id
			
			if not DB:has(Idstring("texture"), Idstring(prefix .. texture)) then
				if tweak_data.weapon[weapon_id] and tweak_data.weapon[weapon_id].texture_bundle_folder then
					prefix = "guis/dlcs/" .. tweak_data.weapon[weapon_id].texture_bundle_folder
				end
			end
			
			local weapon_texture = prefix..texture
			local killed_text = managers.localization:text("pvp_killed_by")

			local user_id = peer:user_id()
			Steam:friend_avatar(Steam.LARGE_AVATAR, user_id, function(texture)
				killer_image:set_image(texture or "guis/textures/pd2/none_icon")
			end)
			killer_text:set_text(killer_name)
			character:set_text(character_name)
			killed_with:set_text(killed_text..weapon_name)
			killed_with:set_range_color(0, utf8.len(killed_text), tweak_data.screen_colors.risk)
			weapon_image:set_image(weapon_texture)
			if character_data and character_data.panel_id then
				local health, armor = managers.hud:get_teammate_stats(character_data.panel_id)
				radial_health:set_color(Color(health, 1, 1))
				radial_shield:set_color(Color(armor, 1, 1))
			end
		end
	end
end