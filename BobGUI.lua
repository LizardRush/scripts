local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
	Name = "LRush's Bob fighter",
	LoadingTitle = "LRush hub",
	LoadingSubtitle = "LRush's Bob fighter",
	ConfigurationSaving = {
		Enabled = false
	}
})

function NotImplemented()
	Rayfield:Notify({
		Title = "LRTools",
		Content = "This is currently not implemented, do not expect it to do anything",
		Duration = 5
	})
end

if not player.Character then
	player.CharacterAdded:Wait()
end

local HRP: BasePart = player.Character:WaitForChild("HumanoidRootPart")

local FlyForce = Instance.new("BodyVelocity")
FlyForce.MaxForce = Vector3.new(1e9,1e9,1e9)
FlyForce.Parent = HRP

local GetMoveVector = require(player:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))

local HomeTab = Window:CreateTab("Home")
local FightTab = Window:CreateTab("Bob")
local TycoonTab = Window:CreateTab("Tycoon")
local PlayerTab = Window:CreateTab("Player")
local MiscTab = Window:CreateTab("Misc")

local DamageBob = false
local AutoTycoon = false
local EverythingActive = false
local AttackBobMinions = false
local HitMeteors = false

local FlyEnabled = false
local NoclipFly = false
local FlySpeed = 50

local ScriptedFlyTarget: Vector3? = nil
local ScriptedDirection: Vector3? = nil

HomeTab:CreateToggle({
	Name = "Everything Active",
	CurrentValue = false,
	Callback = function(Value)
		EverythingActive = Value
	end
})

FightTab:CreateToggle({
	Name = "Damage Bob",
	CurrentValue = false,
	Callback = function(Value)
		DamageBob = Value
	end
})

TycoonTab:CreateToggle({
	Name = "Auto Tycoon",
	CurrentValue = false,
	Callback = function(Value)
		AutoTycoon = Value
	end
})

FightTab:CreateToggle({
	Name = "Kill Bob Minions",
	CurrentValue = false,
	Callback = function(Value)
		AttackBobMinions = Value
	end
})

FightTab:CreateToggle({
	Name = "Hit Meteors",
	CurrentValue = false,
	Callback = function(Value)
		HitMeteors = Value
		NotImplemented()
	end
})

PlayerTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Callback = function(Value)
		FlyEnabled = Value
	end
})

PlayerTab:CreateToggle({
	Name = "Noclip Fly",
	CurrentValue = false,
	Callback = function(Value)
		NoclipFly = Value
	end
})

PlayerTab:CreateInput({
	Name = "Fly Speed",
	PlaceholderText = "50",
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
		local n = tonumber(Value)
		if n then
			FlySpeed = n
		end
	end
})

local function setNoclip(state)
	local char = player.Character
	if not char then return end
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = not state
		end
	end
end

task.spawn(function()
	while true do
		if EverythingActive and DamageBob then
			local Event = workspace.bobBoss.DamageEvent
			Event:FireServer()
		end
		task.wait()
	end
end)

task.spawn(function()
	while true do
		if EverythingActive and AutoTycoon then
			local Event = workspace["ÅTycoon".. player.Name].Click.ClickDetector
			fireclickdetector(Event)
		end
		task.wait()
	end
end)

task.spawn(function()
	while true do
		if AttackBobMinions and EverythingActive then
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj.Name == "BobMinion" then
					local character = player.Character
					local root = character and character:FindFirstChild("HumanoidRootPart")
					if root then
						local targetRoot = obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") or obj
						if targetRoot then
							while targetRoot.Parent and AttackBobMinions and EverythingActive do
								ScriptedFlyTarget = targetRoot.Position
								if (root.Position - targetRoot.Position).Magnitude <= 0.5 then
									break
								end
								task.wait()
							end

							

							local tool = character:FindFirstChildOfClass("Tool")
							if tool then
								tool:Activate()
							end
						end
					end
				end
			end
			ScriptedFlyTarget = nil
		end
		task.wait()
	end
end)

task.spawn(function()
	while true do
		if HitMeteors and EverythingActive then
			local obj = workspace:FindFirstChild("", true) -- meteor name here
			if not obj then
				task.wait()
				continue
			end

			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not root then
				task.wait()
				continue
			end

			local targetRoot = obj:IsA("Model") and obj:FindFirstChild("") or obj
			if not targetRoot then
				task.wait()
				continue
			end

			ScriptedDirection = targetRoot.Position

			while HitMeteors and EverythingActive do
				-- meteor destroyed → skip iteration
				if not targetRoot.Parent then
					ScriptedFlyTarget = nil
					ScriptedDirection = nil
					break
				end

				ScriptedFlyTarget = targetRoot.Position

				if (root.Position - targetRoot.Position).Magnitude <= 1 then
					break
				end

				task.wait()
			end

			local tool = character:FindFirstChildOfClass("Tool")
			if tool then
				tool:Activate()
			end

			ScriptedFlyTarget = nil
			ScriptedDirection = nil
		end

		task.wait()
	end
end)


RunService.RenderStepped:Connect(function()

	if not player.Character then return end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if ScriptedFlyTarget then
		setNoclip(true)

		local dir = (ScriptedFlyTarget - root.Position)
		local dist = dir.Magnitude

		if dist <= 0.1 then
			ScriptedFlyTarget = nil
			FlyForce.Velocity = Vector3.zero
			return
		end

		if ScriptedDirection then
			root.CFrame = CFrame.lookAt(root.Position, ScriptedDirection)
		else
			root.CFrame = CFrame.lookAt(root.Position, ScriptedFlyTarget)
		end

		FlyForce.Velocity = dir.Unit * FlySpeed
		return
	end

	if FlyEnabled then
		setNoclip(NoclipFly)

		FlyForce.Velocity = Vector3.new()
		local MoveDir: Vector3 = GetMoveVector:GetMoveVector()

		if MoveDir.X ~= 0 then
			FlyForce.Velocity = FlyForce.Velocity + Camera.CFrame.RightVector * MoveDir.X * FlySpeed
		end

		if MoveDir.Z ~= 0 then
			FlyForce.Velocity = FlyForce.Velocity - Camera.CFrame.LookVector * MoveDir.Z * FlySpeed
		end

	else
		setNoclip(false)
		FlyForce.Velocity = Vector3.zero
	end

end)
