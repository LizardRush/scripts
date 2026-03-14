local placeId = game.PlaceId
local url = "https://raw.githubusercontent.com/LizardRush/scripts/refs/heads/main/" .. placeId
local Fallbackurl = "https://raw.githubusercontent.com/LizardRush/scripts/refs/heads/main/Fallback.lue"


local success, response = pcall(function()
    return game:HttpGet(url)
end)

if success and response and #response > 0 then
    loadstring(response)()
else
    loadstring(game:HttpGet(Fallbackurl))()
end
