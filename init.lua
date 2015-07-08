minetest.register_privilege("nointeract", "Can enter keyword to get interact")

-- load from config
mki_interact_keyword = minetest.setting_get("interact_keyword") or "iaccept"
local keyword_privs = minetest.string_to_privs(minetest.setting_get("keyword_interact_privs") or "interact,shout,fast")
local keyword_liveupdate = minetest.setting_getbool("interact_keyword_live_changing") or nil



minetest.register_on_chat_message(function(name, message)
	if message == mki_interact_keyword then
		if minetest.get_player_privs(name).nointeract then
			local privs = minetest.get_player_privs(name)
				for priv, state in pairs(keyword_privs,privs) do
					privs[priv] = state
				end
				privs.nointeract = nil
			minetest.set_player_privs(name, privs)

			minetest.chat_send_all("<Server> player, "..name.." Read the rules and has been granted interact!")
			minetest.log("action", "[autogranter] Player, " .. name .. " Was granted interact for keyword")
			if minetest.get_modpath("irc") then
				irc:say(("* %s%s"):format("", "player, "..name.." Read the rules and has been granted interact!"))
			end
			if minetest.setting_get_pos("alt_spawnpoint") then minetest.get_player_by_name(name):setpos(minetest.setting_get_pos("alt_spawnpoint")) end
		else
			if minetest.get_player_privs(name).interact then
				minetest.chat_send_player(name,"You already have interact! It is only necessary to say the keyword once.")
				if minetest.setting_get_pos("alt_spawnpoint") then minetest.get_player_by_name(name):setpos(minetest.setting_get_pos("alt_spawnpoint")) end
			else
				minetest.chat_send_player(name,"You have been prevented from obtaining the interact privilege. Contact a server administrator if you believe this to be in error.")
			end
		end
	end
end)

minetest.register_chatcommand("setkeyword", {
	params = "<keyword>",
	description = "set the keyword",
	privs = {server = true},
	func = function(name, param)
		minetest.setting_set("interact_keyword", param)
		minetest.setting_save()
		minetest.log("action", "[autogranter] Admin, " .. name .. " has set a new keyward "..param)
		if keyword_liveupdate == true then
			mki_interact_keyword = param
			minetest.chat_send_player(name,"keyword has been set and will take effect immediately")
		else
			minetest.chat_send_player(name,"keyword has been set but will take effect after reboot")
		end
	end,
})

minetest.register_chatcommand("getkeyword", {
	params = "",
	description = "get the keyword",
	privs = {},
	func = function(name, param)
		if minetest.get_player_privs(name).basic_privs or minetest.get_player_privs(name).moderator or minetest.get_player_privs(name).server then
			minetest.chat_send_player(name,"Keyword is: " ..mki_interact_keyword)
			return true, "Success"
		else
			return false, "Your are not allowed to view the keyword this way. (Required privs: basic_privs, modarator or server.)"
		end
	end,
})
