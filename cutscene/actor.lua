local actor = {}

local configFileReader = require("configFileReader")
local tween = require 'libs/tween'

function actor:delete()
	for k,v in ipairs(actor) do
		if v == self then
			return table.remove(actor, k)
		end
	end
end

function actor.new(name, args)
	local v = {}
	
	local path = ('cutscene/actor/' .. name)
	local file = configFileReader.parseTxt(path .. '.txt')
	local args = table.join(args or {}, file)
	
	local parent = args.parent or {}
	
	v.name = name
	
	local texture = args.texture or Graphics.loadImageResolved(path .. '.png')

	local frames = {
		args.xFrames or 1,
		args.yFrames or 1,
	}
	
	v.frame = {
		args.xFrame or 1,
		args.yFrame or 1,
	}
		
	v.x = args.x or 0
	v.y = args.y or 0
	
	v.sprite = Sprite{
		texture = texture,
		
		x = parent.x or 0, 
		y = parent.y or 0, 
		
		frames = frames, 
		
		pivot = vector(0.5, 0.5),
	}
	
	v.width = texture.width / frames[1]
	v.height = texture.height / frames[2]
	
	v.frameTimer = 0
	v.parent = parent
	
	v.gravity = args.gravity
	v.rotation = 0
	
	v.scaleX = args.scaleX or 1
	v.scaleY = args.scaleY or 1
	
	v.shakeX = args.shakeX or args.shake or 0
	v.shakeY = args.shakeY or args.shake or 0
	
	v.tween = {}
	
	setmetatable(v, {__index = actor})
	table.insert(actor, v)
	return v
end

function actor:setDirection(dir)
	self.parent.direction = dir
end

function actor:shake(power, t)
	local v = self
	
	local origP = power
	local power
	
	if type(origP) == 'number' then
		power = {origP, origP}
	elseif type(origP) == 'table' then
		power = origP
	else
		power = {1, 1}
	end
	
	local ogX, ogY = v.shakeX, v.shakeY
	
	if t and t > 0 then
		Routine.run(function()
			v.shakeX = power[1]
			v.shakeY = power[2]
			
			Routine.waitFrames(t)
			
			v.shakeX = ogX
			v.shakeY = ogY
		end)
	else
		v.shakeX = power[1]
		v.shakeY = power[2]
	end
end

function actor:setAnimation(anim)
	if #anim == 1 then
		self.frame = anim[1]
		self.animation = nil
	end
	
	anim.framespeed = anim.framespeed or 8
	anim.frame = 0
	
	self.animation = anim
	self.frame = anim[1]
end

function actor:move(dest, t, style)
	local dx = dest[1]
	local dy = dest[2]
	
	if dx == 0 then
		dx = nil
	end
	
	if dy == 0 then
		dy = nil
	end
	
	table.insert(self.tween, tween.new(t or 1, self, {x = dx, y = dy}, style))
end

function actor:jump(p)
	local v = self
	local parent = v.parent
	
	if parent then
		parent.speedY = -(p or 4)
	end
end

function actor:scale(dest, t, style)
	local dx = dest[1]
	local dy = dest[2]
	
	if dx == 0 then
		dx = nil
	else
		dx = self.scaleX + dx
	end
	
	if dy == 0 then
		dy = nil
	else
		dy = self.scaleY + dy
	end
	
	table.insert(self.tween, tween.new(t or 1, self, {scaleX = dx, scaleY = dy}, style))
end

function actor:target(cam, t, args)
	local t = t or 0
	
	if t > 0 then
		local args = table.join({time = t, targets = {self.parent}}, args or {})
		
		cam:transition(args)
	else
		cam.targets = cam.targets or {}
		table.insert(cam.targets, self.parent)	
	end
end

function actor:rotate(val, t, style)
	if t and t > 0 then
		table.insert(self.tween, tween.new(t or 1, self, {rotation = val}, style))
	else
		self.rotation = val
	end
end

function actor:draw()
	local paused = Misc.isPaused()
	local v = self
	
	local parent = v.parent
	
	local sprite = v.sprite
	local pivot = sprite.pivot
	
	for k, tween in ipairs(v.tween) do
		local done = tween:update(0.01)
		
		if done then
			table.remove(v.tween, k)
		end
	end
	
	sprite.scale = vector(v.scaleX, v.scaleY)
	
	local shakeX, shakeY = v.shakeX, v.shakeY
	
	if parent and parent.x and parent.y then
		if parent.direction == 1 then
			sprite.scale[1] = -sprite.scale[1]
		end
		
		local h = (v.height - parent.height) * v.scaleY

		sprite.x = (parent.x + (v.width * pivot[1]) / v.scaleX) + v.x + math.random(-shakeX, shakeX)
		sprite.y = (parent.y - h) + (v.height * pivot[2]) + v.y + math.random(-shakeY, shakeY)
	end
	
	sprite.rotation = v.rotation
	
	local animation = v.animation
	local animationEnd = false
	
	if animation and not paused then
		v.frameTimer = v.frameTimer + 1
		
		if v.frameTimer >= animation.framespeed then
			animation.frame = (animation.frame + 1)
			
			if animation.frame >= #animation then
				animation.frame = 0
				animationEnd = true
			end
			
			v.frame = animation[animation.frame + 1]
			v.frameTimer = 0
		end
		
		if animation.stop and animationEnd then
			if type(animation.stop) == 'number' then
				animation.stop = (animation.stop - 1)
				
				if animation.stop <= 0 then
					v.animation = nil
				end
			else
				v.animation = nil
			end
		end
	end
	
	-- sprite.texscale = vector(v.width * v.scaleX, v.height * v.scaleY)

	sprite:draw{
		frame = v.frame,
		
		priority = v.priority or -45.1,
		sceneCoords = true,
	}
end

setmetatable(actor, {__call = function(self, name)
	for k,v in ipairs(actor) do
		if v.name == name then
			return v
		end
	end
end})

return actor