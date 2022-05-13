local actor = {}
local configFileReader = require("configFileReader")

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
		
	v.x = args.x or parent.x or 0
	v.y = args.y or parent.y or 0
	
	v.sprite = Sprite{
		texture = texture,
		
		x = v.x, 
		y = v.y, 
		
		frames = frames, 
		
		pivot = vector(0.5, 0.5),
	}
	
	v.width = texture.width / frames[1]
	v.height = texture.height / frames[2]
	
	v.frameTimer = 0
	v.parent = parent
	
	v.gravity = args.gravity
	v.rotation = 0
	
	setmetatable(v, {__index = actor})
	table.insert(actor, v)
	return v
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

function actor:jump(p)
	local v = self
	local parent = v.parent
	
	if parent then
		parent.speedY = -(p or 4)
	end
end

function actor:draw()
	local v = self
	
	local parent = v.parent
	
	local sprite = v.sprite
	local pivot = sprite.pivot
	
	if parent and parent.x and parent.y then
		local h = v.height - parent.height
		
		sprite.y = parent.y - h
	end
	
	sprite.x = sprite.x + v.width * pivot[1]
	sprite.y = sprite.y + v.height * pivot[2]
	sprite.rotation = sprite.rotation + v.rotation
	
	local animation = v.animation
	if animation and not Misc.isPaused() then
		v.frameTimer = v.frameTimer + 1
		
		if v.frameTimer >= animation.framespeed then
			animation.frame = (animation.frame + 1) % #animation
			
			v.frame = animation[animation.frame + 1]
			v.frameTimer = 0
		end
	end
	
	sprite:draw{
		frame = v.frame,
		
		priority = v.priority or -45.1,
		sceneCoords = true,
	}
	
	sprite.x = sprite.x - v.width * pivot[1]
	sprite.y = sprite.y - v.height * pivot[2]
end

setmetatable(actor, {__call = function(self, name)
	for k,v in ipairs(actor) do
		if v.name == name then
			return v
		end
	end
end})

return actor