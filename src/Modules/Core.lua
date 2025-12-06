local Service = import("service")

local Players = Service.Players
local RunService = Service.RunService
local CoreGui = Service.CoreGui
local TweenService = Service.TweenService

local Core = {}
Core._instances = {}
Core._tweens = {}

local function parentSafe(gui)
	gui.Parent = CoreGui
end

function Core.newScreen(name, safe)
	local success, result = pcall(function()
		local screen = Instance.new("ScreenGui")
		screen.Name = name or "EasyGui"
		screen.IgnoreGuiInset = false
		screen.ResetOnSpawn = false

		if safe then
			parentSafe(screen)
		end

		return screen
	end)

	if not success then
		error("[*] Failed to create screen: " .. tostring(result))
		return nil
	end

	Core._instances[("screen_%s"):format(name or "default")] = result
	return result
end

function Core.tween(instance, props, info)
	local ti = info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(instance, ti, props)
	Core._tweens[tween] = true
	tween:Play()
	return tween
end

function Core.center(obj)
	obj.AnchorPoint = Vector2.new(0.5, 0.5)
	obj.Position = UDim2.fromScale(0.5, 0.5)
end

function Core.addToRegistry(k, v)
	Core._instances[k] = v
	return v
end

function Core.removeFromRegistry(k)
	Core._instances[k] = nil
end

return Core
