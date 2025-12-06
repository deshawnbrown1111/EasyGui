local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Core = {}
Core._instances = {}
Core._tweens = {}

function Core.newScreen(name)
	local screen = Instance.new("ScreenGui")
	screen.Name = name or "EasyGui"
	screen.ResetOnSpawn = false
	return screen
end

function Core.tween(instance, props, info)
	local info = info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(instance, info, props)
	tween:Play()
	return tween
end

function Core.center(frame)
	frame.AnchorPoint = Vector2.new(0.5,0.5)
	frame.Position = UDim2.fromScale(0.5,0.5)
end

function Core.addToRegistry(k,v)
	Core._instances[k] = v
end

function Core.removeFromRegistry(k)
	Core._instances[k] = nil
end

function Core.getPlayerGui()
	local player = Players.LocalPlayer
	if not player then
		local rs = RunService:IsClient()
		if not rs then
			return nil
		end
		repeat
			player = Players.LocalPlayer
			task.wait()
		until player
	end
	return player:WaitForChild("PlayerGui")
end

return Core
