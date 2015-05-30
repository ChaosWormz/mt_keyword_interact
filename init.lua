minetest.register_privilege("nointeract", "Can enter keyword to get interact")

local keyword = minetest.setting_get("interact_keyword") or "iaccept"

minetest.register_on_chat_message(function(name, message)
	if message == keyword and minetest.get_player_privs(name).nointeract then
		local privs = minetest.get_player_privs(name) --remember to abjust the privs to the ones you want to grant
			privs.interact = true
			privs.fly = true
			privs.fast = true
			privs.shout = true
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
		return true, "Keyword was set successfully, and will take effect after reboot."
	end,
})

minetest.register_chatcommand("getkeyword", {
	params = "",
	description = "get the keyword",
	privs = {},
	func = function(name, param)
		if minetest.get_player_privs(name).basic_privs or minetest.get_player_privs(name).moderator or minetest.get_player_privs(name).server then
			minetest.chat_send_player(name,"Keyword is: " ..keyword)
			return true, "got Keyword was  successfully"
		else
			return false, "Your are not allowed to view the keyword this way. (Required privs: basic_privs, modarator or server.)"
		end
	end,
})
