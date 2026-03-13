local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
	Name = "LRush's Bob fighter",
	LoadingTitle = "LRush's Bob fighter",
	LoadingSubtitle = "by LRush",
	ConfigurationSaving = {
		Enabled = false
	}
})

function LoadScript(Url)
	loadstring(game:HttpGet(Url))()
end

local HomeTab = Window:CreateTab("Home", 4483362458)

local DamageBob = false
local AutoTycoon = false
local EverythingActive = false
local AttackBobMinions = false
local HitMeteors = false
local Invincibility = false
local InvincibilityPosition = Vector3.new(0,100,0)

HomeTab:CreateToggle({
	Name = "Everything Active",
	CurrentValue = false,
	Callback = function(Value)
		EverythingActive = Value
		print("Everything Active:", Value)
	end
})

HomeTab:CreateToggle({
	Name = "Damage Bob",
	CurrentValue = false,
	Callback = function(Value)
		DamageBob = Value
		print("Damage Bob:", Value)
	end
})

HomeTab:CreateToggle({
	Name = "Auto Tycoon",
	CurrentValue = false,
	Callback = function(Value)
		AutoTycoon = Value
		print("Auto Tycoon:", Value)
	end
})

HomeTab:CreateToggle({
	Name = "Kill Bob Minions",
	CurrentValue = false,
	Callback = function(Value)
		AttackBobMinions = Value
		print("Kill Bob Minions:", Value)
	end
})

HomeTab:CreateToggle({
	Name = "Invincibility",
	CurrentValue = false,
	Callback = function(Value)
		Invincibility = Value
		print("Invincibility:", Value)
		if not AttackBobMinions then
			player.Character.HumanoidRootPart.Position = (InvincibilityPosition)
		end
	end
})

HomeTab:CreateToggle({
	Name = "Hit Meteors",
	CurrentValue = false,
	Callback = function(Value)
		Invincibility = Value
		print("Hit Meteors:", Value)
	end
})

local FlyButton
FlyButton = HomeTab:CreateButton({
	Name = "Load Fly Script",
	Callback = function()
		if FlyButton then
			LoadScript("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
			FlyButton:Destroy()
		end
	end
})

local ReturnButton
ReturnButton = HomeTab:CreateButton({
	Name = "Return To Invincibility Spot",
	Callback = function()
		if Invincibility then
			player.Character.HumanoidRootPart.Position = (InvincibilityPosition)
		end
	end
})

local function findTycoon()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name:sub(1,7) == "ÅTycoon" then
			return obj
		end
	end
end

game["Run Service"].Heartbeat:Connect(function()
	if not EverythingActive then return end
	if DamageBob then
		local Event = game:GetService("Workspace").bobBoss.DamageEvent
		Event:FireServer()
	end
	if AutoTycoon then
		local Event = findTycoon().Click.ClickDetector
		fireclickdetector(Event)
	end
	if Invincibility then
		player.Character.HumanoidRootPart.Anchored = true
		ReturnButton.Visible = true
	else
		player.Character.HumanoidRootPart.Anchored = false
		ReturnButton.Visible = false
	end
end)

while true do
	if AttackBobMinions and EverythingActive then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "BobMinion" then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local root = character.HumanoidRootPart

					if obj:IsA("BasePart") then
						root.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
					elseif obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
						root.CFrame = obj.HumanoidRootPart.CFrame
					end

					local tool = character:FindFirstChildOfClass("Tool")
					if tool then
						tool:Activate()
					end

					
					if Invincibility then
						task.wait(0.25)
						player.Character.HumanoidRootPart.Position = (InvincibilityPosition)
						task.wait(0.25)
					else
						task.wait(0.5)
					end
				end
			end
		end
	end
	task.wait()
end
