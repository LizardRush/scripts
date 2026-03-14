local placeId = game.PlaceId
local url = "https://raw.githubusercontent.com/LizardRush/scripts/refs/heads/main/" .. placeId

local success, response = pcall(function()
    return game:HttpGet(url)
end)

if success and response and #response > 0 then
    loadstring(response)()
else
    warn("Invalid place. No script found for PlaceId:", placeId)
end
