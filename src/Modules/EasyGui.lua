local Service = import("service")
local Players = Service.Players
local RunService = Service.RunService
local CoreGui = Service.CoreGui
local TweenService = Service.TweenService

local EasyGui = {}
EasyGui._instances = {}
EasyGui._tweens = {}

local function parentSafe(gui, safe)
	local player = Players.LocalPlayer
	if safe then
		gui.Parent = CoreGui
		return
	end
	if not player then
		gui.Parent = CoreGui
		return
	end
	local pg = player:FindFirstChildOfClass("PlayerGui")
	gui.Parent = pg or CoreGui
end

function EasyGui.newScreen(name, safe)
	local screen
	local ok, res = pcall(function()
		screen = Instance.new("ScreenGui")
		screen.Name = name or "EasyGui"
		screen.ResetOnSpawn = false
		parentSafe(screen, safe)
		return screen
	end)
	if not ok then
		error(tostring(res))
	end
	EasyGui._instances["screen_" .. (name or tostring(screen))] = screen
	return screen
end

function EasyGui.tween(instance, props, info)
	local ti = info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tw = TweenService:Create(instance, ti, props)
	EasyGui._tweens[tw] = true
	tw:Play()
	return tw
end

local function applyProps(obj, opts)
	for k, v in pairs(opts or {}) do
		if k ~= "Parent" and k ~= "OnClick" and k ~= "Extras" then
			pcall(function()
				obj[k] = v
			end)
		end
	end
	if opts and opts.Parent then
		obj.Parent = opts.Parent
	end
	return obj
end

local function attachExtras(obj, extras)
	if not extras then return end
	if extras.Gradient then
		local g = Instance.new("UIGradient")
		g.Color = extras.Gradient
		if extras.Rotation then pcall(function() g.Rotation = extras.Rotation end) end
		g.Parent = obj
	end
	if extras.Stroke then
		local s = Instance.new("UIStroke")
		s.Color = extras.Stroke.Color or Color3.fromRGB(255,255,255)
		s.Thickness = extras.Stroke.Thickness or 1
		pcall(function() s.Transparency = extras.Stroke.Transparency or 0 end)
		s.Parent = obj
	end
	if extras.CornerRadius then
		local c = Instance.new("UICorner")
		c.CornerRadius = extras.CornerRadius
		c.Parent = obj
	end
	if extras.Padding then
		local p = Instance.new("UIPadding")
		p.PaddingLeft = extras.Padding.Left or UDim.new(0,0)
		p.PaddingTop = extras.Padding.Top or UDim.new(0,0)
		p.PaddingRight = extras.Padding.Right or UDim.new(0,0)
		p.PaddingBottom = extras.Padding.Bottom or UDim.new(0,0)
		p.Parent = obj
	end
end

local function wrap(instance)
	local conns = {}
	local proxy = {}
	function proxy:SetPosition(pos) instance.Position = pos end
	function proxy:SetOffset(x,y)
		local p = instance.Position
		instance.Position = UDim2.new(p.X.Scale, x or p.X.Offset, p.Y.Scale, y or p.Y.Offset)
	end
	function proxy:SetXY(x,y) instance.Position = UDim2.new(0, x, 0, y) end
	function proxy:MoveBy(dx,dy)
		local p = instance.Position
		instance.Position = UDim2.new(p.X.Scale, p.X.Offset + (dx or 0), p.Y.Scale, p.Y.Offset + (dy or 0))
	end
	function proxy:Center()
		instance.AnchorPoint = Vector2.new(0.5,0.5)
		instance.Position = UDim2.fromScale(0.5,0.5)
	end
	function proxy:OnClick(fn)
		if instance:IsA("TextButton") or instance:IsA("ImageButton") then
			local c = instance.MouseButton1Click:Connect(fn)
			table.insert(conns, c)
			return c
		end
	end
	function proxy:Destroy()
		for _,c in ipairs(conns) do
			pcall(function() c:Disconnect() end)
		end
		pcall(function() instance:Destroy() end)
	end
	setmetatable(proxy, {
		__index = function(t,k)
			local v = rawget(proxy,k)
			if v ~= nil then return v end
			return instance[k]
		end,
		__newindex = function(t,k,v)
			if rawget(proxy,k) ~= nil then
				rawset(proxy,k,v)
			else
				instance[k] = v
			end
		end
	})
	EasyGui._instances[tostring(instance)] = proxy
	return proxy
end

function EasyGui.Frame(opts)
	opts = opts or {}
	local f = Instance.new("Frame")
	f.Name = opts.Name or "Frame"
	f.BackgroundColor3 = opts.BackgroundColor3 or Color3.fromRGB(40,40,40)
	f.BorderSizePixel = 0
	applyProps(f, opts)
	attachExtras(f, opts.Extras)
	return wrap(f)
end

function EasyGui.Button(opts)
	opts = opts or {}
	local b = Instance.new("TextButton")
	b.Name = opts.Name or "Button"
	b.Text = opts.Text or "Button"
	b.BackgroundColor3 = opts.BackgroundColor3 or Color3.fromRGB(60,60,60)
	b.TextColor3 = opts.TextColor3 or Color3.fromRGB(255,255,255)
	b.AutoButtonColor = false
	b.BorderSizePixel = 0
	b.Font = opts.Font or Enum.Font.Gotham
	b.TextSize = opts.TextSize or 14
	applyProps(b, opts)
	attachExtras(b, opts.Extras)
	local p = wrap(b)
	if opts.OnClick then
		p:OnClick(opts.OnClick)
	end
	return p
end

function EasyGui.Text(opts)
	opts = opts or {}
	local t = Instance.new("TextLabel")
	t.Name = opts.Name or "Text"
	t.Text = opts.Text or "Text"
	t.BackgroundTransparency = 1
	t.Font = opts.Font or Enum.Font.Gotham
	t.TextSize = opts.TextSize or 14
	t.TextColor3 = opts.TextColor3 or Color3.fromRGB(255,255,255)
	applyProps(t, opts)
	attachExtras(t, opts.Extras)
	return wrap(t)
end

function EasyGui.addToRegistry(k,v)
	EasyGui._instances[k] = v
	return v
end

function EasyGui.removeFromRegistry(k)
	EasyGui._instances[k] = nil
end

return EasyGui
