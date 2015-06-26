minetest.register_privilege("nointeract", "Can enter keyword to get interact")

-- load from config
local keyword = minetest.setting_get("interact_keyword") or "iaccept"
local keyword_privs = minetest.string_to_privs(minetest.setting_get("keyword_interact_privs") or "interact,shout,fast")
local keyword_liveupdate = minetest.setting_getbool("interact_keyword_live_changing") or nil

--global plug-- 
mki_keyword_live = keyword_liveupdate


minetest.register_on_chat_message(function(name, message)
	if message == keyword and minetest.get_player_privs(name).nointeract then
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
			keyword = param
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
			minetest.chat_send_player(name,"Keyword is: " ..keyword)
			return true, "Success"
		else
			return false, "Your are not allowed to view the keyword this way. (Required privs: basic_privs, modarator or server.)"
		end
	end,
})
