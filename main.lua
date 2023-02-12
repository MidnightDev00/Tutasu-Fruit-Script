local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Player = game:GetService("Players").LocalPlayer
local function Char()
	return Player.Character or Player.CharacterAdded:Wait()
end

_G.Settings = {
	Version_ = 'V1',
	-- Local Player
	BypassWater = false,
	HitBoxExpanded = false,
	-- Fruits
	FruitEsp = false,
	FruitsAvaible = {}
}

_G.TPpos = {
	
	Initial_Island = Vector3.new(230.437, 12.5318, 650.012),
	Jungle = Vector3.new(1758.28, 13.6017, -236.117),
	Bobby_Island = Vector3.new(-2110.45, 12.152, -47.2241),
	Ice_Island = Vector3.new(-725.879, 13.3033, -2282.19),
	MarineFord = Vector3.new(-2698.67, 568.579, 4092.13)
}

local TweenService = game:GetService('TweenService')
local tweeninfo = TweenInfo.new(1,Enum.EasingStyle.Linear)

function bypass_teleport(pos)
	if Char() and 
		Char():FindFirstChild('HumanoidRootPart') then
		local CoordinatedFrame = CFrame.new(pos)
		local tp_tween = TweenService:Create(Char().HumanoidRootPart,tweeninfo,{CFrame=CoordinatedFrame})
		tp_tween:Play()
	end
end

local function FruitEsp(bool)
	if bool == true then
		for i,v in pairs(workspace:GetChildren()) do
			if v:IsA("Tool") then
				local Esp = game:GetService("ReplicatedStorage").frutaestaqui
				Esp:Clone().Parent = v.Handle
			end
		end
		workspace.ChildAdded:Connect(function(child)
			if _G.Settings.FruitEsp == false then return end
			if child:IsA("Tool") then
				local Esp = game:GetService("ReplicatedStorage").frutaestaqui
				Esp:Clone().Parent = child.Handle
			end
		end)
	elseif bool == false then
		for i,v in pairs(workspace:GetChildren()) do
			if v:IsA("Tool") then
				if v.Handle:FindFirstChild('frutaestaqui') then
					v.Handle.frutaestaqui:Destroy()
				end
			end
		end
	end
end

local function ArmsUp(bool, CharP)
	if bool == true then
		CharP['Left Arm'].Size = Vector3.new(2, 20, 2)
		CharP['Right Arm'].Size = Vector3.new(2, 20, 2)
	elseif bool == false then
		CharP['Left Arm'].Size = Vector3.new(1, 2, 1)
		CharP['Right Arm'].Size = Vector3.new(1, 2, 1)
	end
end

local function ToggleArms(bool, CharP)
	if bool == true then
		CharP['Left Arm'].Transparency = 1
		CharP['Right Arm'].Transparency = 1
	elseif bool == false then
		CharP['Left Arm'].Transparency = 0
		CharP['Right Arm'].Transparency = 0
	end
end

Player.CharacterAdded:Connect(function(CharP)
	if _G.Settings.BypassWater == true then
		CharP:WaitForChild("MorrerNaAgua"):Destroy()
	end

	if _G.Settings.HitBoxExpanded == true then
		ArmsUp(_G.Settings.HitBoxExpanded, CharP)
	end
	print(_G.Settings.BypassWater)
end)

local Window = OrionLib:MakeWindow({
	Name = "Tutasu Fruits Script",
	HidePremium = true,
	SaveConfig = false,
	IntroEnabled = true,
	IntroText = 'By Midnight Job#3202',
	KeySystem = false, -- Set this to true to use our key system
})

local LocalPlayer = Window:MakeTab({
	Name = "Local Player",
	Icon = "rbxassetid://2795572803",
	PremiumOnly = false
})

local BypassWaterToggle = LocalPlayer:AddToggle({
	Name = "Bypass water damage",
	Default = false,
	Callback = function(Value)
		_G.Settings.BypassWater = Value
		Char():WaitForChild("MorrerNaAgua"):Destroy()
		print(_G.Settings.BypassWater)
	end,
})

local HitBoxExpander = LocalPlayer:AddToggle({
	Name = "HitBox Expander",
	Default = false,
	Callback = function(Value)
		_G.Settings.HitBoxExpanded = Value
		ArmsUp(Value, Char())
	end,
})

local HideArms = LocalPlayer:AddToggle({
	Name = "Hide Arms (Client)",
	Default = false,
	Callback = function(Value)
		ToggleArms(Value, Char())
	end,
})

local UIs = {

	['Sword Seller'] = function()
		local Seller = workspace.VendedorDeEspada
		local Click = Seller.Model.ClickDetector
		fireclickdetector(Click) -- this should work on executor
	end;

	['Buy Haki'] = function()
		local Seller = workspace['Buy haki']
		local Click = Seller.ClickDetector
		fireclickdetector(Click) -- this should work on executor
	end;

	['Buy Fruit'] = function()
		local Seller = workspace['Buy fruit']
		local Click = Seller.ClickDetector
		fireclickdetector(Click) -- this should work on executor
	end;

}

local OpenGuis = LocalPlayer:AddDropdown({
	Name = "UIs Open",
	Default = "None",
	Options = {"Sword Seller", "Buy Haki", "Buy Fruit"},
	Callback = function(Option)
		local sucess, err = pcall(function()
			local testeClick = Instance.new("ClickDetector")
			fireclickdetector(testeClick)
			testeClick:Destroy()
		end)

		if sucess then
			UIs[Option]()
		else
			OrionLib:MakeNotification({
				Name = "NOT SUPPORTED",
				Content = 'U Executor do not suport FireClickDetector(); Get a Better Executor.',
				Time = 6.5,
			})
		end
	end,
})

local Fruits = Window:MakeTab({
	Name = "Fruits",
	Icon = "rbxassetid://11337826445",
	PremiumOnly = false
})

local FruitEsp = Fruits:AddToggle({
	Name = "Fruit Esp",
	Default = false,
	Callback = function(Value)
		_G.Settings.FruitEsp = Value
		FruitEsp(Value)
	end,
})

local function FruitTeleport(FruitName)
	if workspace:FindFirstChild(FruitName) then
		bypass_teleport(workspace[FruitName]:WaitForChild("Handle").Position)
	end
end

local FruitTp = Fruits:AddDropdown({
	Name = "Fruit TP",
	CurrentOption = "None",
	Options = {},
	Callback = function(Option)
		FruitTeleport(Option)
	end,
})

local function UpdateFruitList()
	print("here")
	_G.Settings.FruitsAvaible = {}
	-- table.clear(_G.Settings.FruitsAvaible)
	for i,v in pairs(workspace:GetChildren()) do
		if v:IsA('Tool') then
			print("found")
			table.insert(_G.Settings.FruitsAvaible, v.Name)
		end
	end
	return true
end

local FruitUpdate = Fruits:AddButton({
	Name = "Update Fruit List",
	Callback = function()
		if UpdateFruitList() == true then
			FruitTp:Refresh(_G.Settings.FruitsAvaible,true)
		end
	end,
})

local Islands = Window:MakeTab({
	Name = "Islands",
	Icon = "rbxassetid://11337826445",
	PremiumOnly = false
})

local Island_Tp = Islands:AddDropdown({
	Name = "Teleport to Islands",
	Default = "None",
	Options = {'Initial_Island', 'Jungle', 'Bobby_Island', 'Ice_Island', 'MarineFord'},
	Callback = function(Option)
		bypass_teleport(_G.TPpos[Option])
	end,
})

local Misc = Window:MakeTab({
	Name = "Misc.",
})

Misc:AddButton({
	Name = "Destroy Gui",
	Callback = function()
		OrionLib:Destroy()
	end    
})

local function Boats(bool)
	if bool == false then
		workspace.tirarbarcos.Parent = game:GetService("ReplicatedStorage")
	elseif bool == true then
		pcall(function()
			game:GetService("ReplicatedStorage").tirarbarcos.Parent = workspace
		end)
	end
end

local DontRemoveBoats = Misc:AddToggle({
	Name = "Crash boats on the coast",
	Default = true,
	Callback = function(Value)
		Boats(Value)
	end,
})

local Health = Window:MakeTab({
	Name = "Health",
})

local function Test(something)
	return tonumber(something)
end

local ResetHealth = Health:AddButton({
	Name = "Reset Health",
	Callback = function()
		workspace.Eventos.Dadano:FireServer(9999999999999999999999999999999999999)
	end    
})

local RegenHealth = Health:AddButton({
	Name = "Regen Health",
	Callback = function()
		workspace.Eventos.Dadano:FireServer(-Char().Humanoid.MaxHealth)
	end    
})

local InfHealth = Health:AddButton({
	Name = "Infinite Health",
	Callback = function()
		workspace.Eventos.Dadano:FireServer(-9999999999999999999999999999999999999)
	end    
})

local TakeDamage = Health:AddTextbox({
	Name = "Damage yourself",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		if Test(Value) ~= nil then
			workspace.Eventos.Dadano:FireServer(tonumber(Value))
		elseif Test(Value) == nil then
			OrionLib:MakeNotification({
				Name = "Invalid Argument",
				Content = 'Can u just put ONLY numbers?',
				Time = 6.5,
				Actions = { -- Notification Buttons
					Agree = {
						Name = "Of course...",
				}},
			})
		end
	end,
})

OrionLib:MakeNotification({
	Name = "Version",
	Content = _G.Settings.Version_,
	Time = 6.5,
})

OrionLib:Init()
