local json = require("com.json")



local function loadSettingConsole()
	-- Open engine/settings.json and read whether there should be a console open.
	local file = io.open("settings.json")
	if not file then
		return true -- defaults to true
	end
	io.input(file)
	local contents = json.decode(io.read("*a"))
	io.close(file)

	local setting = contents.consoleWindow
	return setting
end



function love.conf(t)
	t.console = loadSettingConsole()
	print("using console: " .. tostring(t.console))
	-- If we're running as a game verifier, prevent from running any operations that might need a graphics card.
	for k, v in pairs(arg) do
		if v == "--verifier" then
			t.modules.window = false
			t.modules.graphics = false
			t.window = nil
			-- In verifier mode, console is always on regardless of the settings.
			t.console = true
			break
		end
	end
end
