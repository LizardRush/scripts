local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local listURL = "https://raw.githubusercontent.com/LizardRush/scripts/refs/heads/main/ScriptList.lua"

local success, response = pcall(function()
	return game:HttpGet(listURL)
end)

if not success then
	warn("Failed to fetch ScriptList")
	return
end

local scripts = loadstring(response)()
if type(scripts) ~= "table" then
	warn("ScriptList did not return a table")
	return
end

local Window = Rayfield:CreateWindow({
	Name = "LRush Script Loader",
	LoadingTitle = "LRush Script Loader",
	LoadingSubtitle = "Fallback UI",
	ConfigurationSaving = {
		Enabled = false
	}
})

local Tab = Window:CreateTab("Scripts")

local names = {}
for name,_ in pairs(scripts) do
	table.insert(names, name)
end

-- store the current loaded script, if any
local currentScript = nil

Tab:CreateDropdown({
	Name = "Select Script",
	Options = names,
	CurrentOption = nil,
	MultipleOptions = false,
	Callback = function(option)
		local url = scripts[option]
		if not url then
			warn("Invalid script selection")
			return
		end
		
		-- unload previous script by clearing references
		if currentScript and type(currentScript) == "table" then
			for k in pairs(currentScript) do
				currentScript[k] = nil
			end
		end
		
		-- destroy the fallback UI
		Rayfield:Destroy()
		
		local ok, scriptCode = pcall(function()
			return game:HttpGet(url)
		end)
		
		if ok then
			currentScript = loadstring(scriptCode)()
		else
			warn("Failed to load script:", option)
		end
	end
})
