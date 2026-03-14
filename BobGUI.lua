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

function NotImplemented()
	Rayfield:Notify({
		Title = "LRTools",
		Content = "This is currently not implemented, do not expect it to do anything",
		Duration = 5
	})
end
function LoadScript(Url)
	loadstring(game:HttpGet(Url))()
end

function returnToInvinvincible()
	player.Character:PivotTo(CFrame.new(InvincibilityPosition))
end

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
local Invincibility = false
local TempNoInvincibility = false
local InvincibilityPosition = Vector3.new(0,100,0)

HomeTab:CreateToggle({
	Name = "Everything Active",
	CurrentValue = false,
	Callback = function(Value)
		EverythingActive = Value
		print("Everything Active:", Value)
	end
})

FightTab:CreateToggle({
	Name = "Damage Bob",
	CurrentValue = false,
	Callback = function(Value)
		DamageBob = Value
		print("Damage Bob:", Value)
	end
})

TycoonTab:CreateToggle({
	Name = "Auto Tycoon",
	CurrentValue = false,
	Callback = function(Value)
		AutoTycoon = Value
		print("Auto Tycoon:", Value)
	end
})

FightTab:CreateToggle({
	Name = "Kill Bob Minions (Requires Invincibility)",
	CurrentValue = false,
	Callback = function(Value)
		AttackBobMinions = Value
		print("Kill Bob Minions:", Value)
	end
})

PlayerTab:CreateToggle({
	Name = "Invincibility",
	CurrentValue = false,
	Callback = function(Value)
		Invincibility = Value
		print("Invincibility:", Value)
		if not AttackBobMinions then
			returnToInvinvincible()
		end
	end
})

FightTab:CreateToggle({
	Name = "Hit Meteors (Requires Invincibility)",
	CurrentValue = false,
	Callback = function(Value)
		HitMeteors = Value
		print("Hit Meteors:", Value)
		NotImplemented()
	end
})

local FlyButton
FlyButton = MiscTab:CreateButton({
	Name = "Load Fly Script",
	Callback = function()
		if FlyButton then
			LoadScript("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
			FlyButton:Destroy()
		end
	end
})

MiscTab:CreateButton({
	Name = "Return To Invincibility Spot",
	Callback = function()
		if Invincibility then
			returnToInvinvincible()
		end
	end
})


game["Run Service"].Heartbeat:Connect(function()
	if not EverythingActive then return end
	if DamageBob then
		local Event = game:GetService("Workspace").bobBoss.DamageEvent
		Event:FireServer()
	end
	if AutoTycoon then
		local Event = game.workspace["ÅTycoon".. player.Name].Click.ClickDetector
		fireclickdetector(Event)
	end
	if Invincibility and not TempNoInvincibility then
		returnToInvinvincible()
	end
end)
task.spawn(function()
while true do
	if AttackBobMinions and EverythingActive and Invincibility then
		for _, obj in ipairs(game.workspace:GetDescendants()) do
			if obj.Name == "BobMinion" then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
						local root = character
						TempNoInvincibility = true

					if obj:IsA("BasePart") then
						root.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
					elseif obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") then
						root:PivotTo(obj.HumanoidRootPart.CFrame)
					end

					local tool = character:FindFirstChildOfClass("Tool")
					if tool then
						tool:Activate()
					end

					
					if Invincibility then
						task.wait(0.25)
						TempNoInvincibility = false
						task.wait(0.25)
					end
				end
			end
		end
	end
	task.wait()
	end
end)
