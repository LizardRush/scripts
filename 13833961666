local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
	Name = "LRush's Bob fighter",
	LoadingTitle = "LRush hub",
	LoadingSubtitle = game.PlaceId,
	ConfigurationSaving = {
		Enabled = false
	}
})

local assets = {
	GUI = {
		
	}
}

function getAsset(assetId)
	local success, objects = pcall(function()
		return game:GetObjects("rbxassetid://" .. tostring(assetId))
	end)

	if success and objects[1] then
		return objects[1]
	else
		warn("Failed to load asset:", assetId)
		return nil
	end
end

if not player.Character then
	player.CharacterAdded:Wait()
end

local HomeTab = Window:CreateTab("Home")
local FightTab = Window:CreateTab("Bob")
local TycoonTab = Window:CreateTab("Tycoon")
local PlayerTab = Window:CreateTab("Player")
local ScriptedTab = Window:CreateTab("Scripted")

local DamageBob = false
local AutoTycoon = false
local EverythingActive = false
local AttackBobMinions = false
local HitMeteors = false

local FlyEnabled = false
local FlySpeed = 50

local TeleportInsteadOfFly = false

local ScriptedFlyTarget = nil
local ScriptedDirection = nil

HomeTab:CreateToggle({
	Name = "Everything Active",
	CurrentValue = false,
	Callback = function(v)
		EverythingActive = v
	end
})

FightTab:CreateToggle({
	Name = "Damage Bob",
	CurrentValue = false,
	Callback = function(v)
		DamageBob = v
	end
})

FightTab:CreateToggle({
	Name = "Kill Bob Minions",
	CurrentValue = false,
	Callback = function(v)
		AttackBobMinions = v
	end
})

FightTab:CreateToggle({
	Name = "Hit Meteors",
	CurrentValue = false,
	Callback = function(v)
		HitMeteors = v
	end
})

TycoonTab:CreateToggle({
	Name = "Auto Tycoon",
	CurrentValue = false,
	Callback = function(v)
		AutoTycoon = v
	end
})

PlayerTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Callback = function(v)
		FlyEnabled = v
	end
})

PlayerTab:CreateInput({
	Name = "Fly Speed",
	PlaceholderText = "50",
	RemoveTextAfterFocusLost = false,
	Callback = function(v)
		local n = tonumber(v)
		if n then
			FlySpeed = n
		end
	end
})

ScriptedTab:CreateToggle({
	Name = "Teleport instead of Fly",
	CurrentValue = false,
	Callback = function(v)
		TeleportInsteadOfFly = v
	end
})

-- fly system
local flyPart
local weld
local flying = false

local function startFly()
	if flying then return end

	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	flyPart = Instance.new("Part")
	flyPart.Size = Vector3.new(1,1,1)
	flyPart.Anchored = true
	flyPart.CanCollide = true
	flyPart.Transparency = 1
	flyPart.CFrame = root.CFrame
	flyPart.Parent = workspace

	weld = Instance.new("WeldConstraint")
	weld.Part0 = flyPart
	weld.Part1 = root
	weld.Parent = flyPart

	flying = true
end

local function stopFly()
	flying = false
	if weld then weld:Destroy() end
	if flyPart then flyPart:Destroy() end
	weld = nil
	flyPart = nil
end

local function getNextMovement()

	local v = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		v += Vector3.new(0,0,-1)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		v += Vector3.new(0,0,1)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		v += Vector3.new(-1,0,0)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		v += Vector3.new(1,0,0)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
		v += Vector3.new(0,1,0)
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.E) then
		v += Vector3.new(0,-1,0)
	end

	return CFrame.new(v * FlySpeed)

end

-- trackers
local Minions = {}
local Meteors = {}

local function getFirstPart(model)
	for _,v in ipairs(model:GetDescendants()) do
		if v:IsA("BasePart") then
			return v
		end
	end
end

local function trackMinion(obj)
	if obj.Name ~= "BobMinion" then return end
	table.insert(Minions,obj)
end

local function trackMeteor(model)

	if model.Name ~= "SpiritRock" then return end

	local part = getFirstPart(model)
	if not part then return end

	local lastPos = part.Position
	local stillTimer = 0

	RunService.Heartbeat:Connect(function(dt)

		if not part.Parent then
			Meteors[model] = nil
			return
		end

		if (part.Position - lastPos).Magnitude < 0.05 then
			stillTimer += dt
		else
			stillTimer = 0
		end

		lastPos = part.Position

		if stillTimer >= 1 then
			Meteors[model] = part
		end

	end)

end

for _,v in ipairs(workspace:GetDescendants()) do
	trackMinion(v)
	trackMeteor(v)
end

workspace.DescendantAdded:Connect(function(obj)
	trackMinion(obj)
	trackMeteor(obj)
end)

-- automation loops

task.spawn(function()
	while true do
		if EverythingActive and DamageBob then
			workspace.bobBoss.DamageEvent:FireServer()
		end
		task.wait()
	end
end)

task.spawn(function()
	while true do
		if EverythingActive and AutoTycoon then
			fireclickdetector(workspace["ÅTycoon"..player.Name].Click.ClickDetector)
		end
		task.wait()
	end
end)

-- AI controller

task.spawn(function()

	while true do

		if not EverythingActive then
			task.wait(.2)
			continue
		end

		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")

		if not root then
			task.wait(.2)
			continue
		end

		local targetPart = nil

		if HitMeteors then

			local dist = math.huge

			for _,part in pairs(Meteors) do
				if part and part.Parent then
					local d = (root.Position - part.Position).Magnitude
					if d < dist then
						dist = d
						targetPart = part
					end
				end
			end

		end

		if not targetPart and AttackBobMinions then

			local dist = math.huge

			for _,obj in ipairs(Minions) do
				local part = obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") or obj
				if part and part.Parent then
					local d = (root.Position - part.Position).Magnitude
					if d < dist then
						dist = d
						targetPart = part
					end
				end
			end

		end

		if targetPart then

			while targetPart.Parent and EverythingActive do

				if TeleportInsteadOfFly then
					root.CFrame = CFrame.new(targetPart.Position + Vector3.new(0,3,0))
				else
					ScriptedFlyTarget = targetPart.Position
				end

				if (root.Position - targetPart.Position).Magnitude <= 6 then
					break
				end

				RunService.Heartbeat:Wait()

			end

			local tool = char:FindFirstChildOfClass("Tool")

			if tool then
				tool:Activate()
			end

		end

		ScriptedFlyTarget = nil
		ScriptedDirection = nil

		task.wait(.05)

	end

end)

-- fly logic

RunService.RenderStepped:Connect(function()

	local char = player.Character
	if not char then return end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if ScriptedFlyTarget and not TeleportInsteadOfFly then

		startFly()

		local dir = ScriptedFlyTarget-root.Position
		local dist = dir.Magnitude

		if dist <= 0.1 then
			ScriptedFlyTarget = nil
			return
		end

		if ScriptedDirection then
			root.CFrame = CFrame.lookAt(root.Position,ScriptedDirection)
		else
			root.CFrame = CFrame.lookAt(root.Position,ScriptedFlyTarget)
		end

		flyPart.CFrame = CFrame.new(root.Position + dir.Unit*FlySpeed,ScriptedFlyTarget)

		return

	end

	if FlyEnabled then

		startFly()

		local look = (Camera.Focus.Position-Camera.CFrame.Position).Unit
		local pos = flyPart.Position
		local nextMove = getNextMovement()

		flyPart.CFrame = CFrame.new(pos,pos+look)*nextMove

	else
		stopFly()
	end

end)
