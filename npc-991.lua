local npc = {}

local id = NPC_ID

local npcManager = require 'npcManager'
local afterimages = require 'libs/afterimages'
local mounts = require 'libs/mounts'

npcManager.setNpcSettings{
	id = id,
	
	width = 64,
	height = 64,
	gfxwidth = 64,
	gfxheight = 64,
	
	frames = 2,
	framestyle = 1,
	framespeed=16,
	
	jumphurt = true,
	
	nohurt = true,
	noyoshi = true,
	nofireball = true,
	noiceball = true,
}

function npc.onTickEndNPC(v)
	if v.collidesBlockBottom then
		v.speedY = -2
	end
	
	for _,p in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
		if p.speedY > 0 and p.y <= v.y then
			local done = mounts.setMount(p, 'reznor')
			
			if done then
				return v:kill(9)
			end
		end
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

local frames = 3

local charge = Graphics.loadImageResolved 'graphics/reznorCharge.png'

local sfx = {
	'sounds/footstep1.ogg',
	'sounds/footstep2.ogg',
	'sounds/footstep3.ogg',
}

local transition = table.map{
	FORCEDSTATE_POWERDOWN_SMALL,
	FORCEDSTATE_POWERDOWN_FIRE,
	FORCEDSTATE_POWERDOWN_ICE,

	FORCEDSTATE_POWERUP_BIG,
	FORCEDSTATE_POWERUP_LEAF,
	FORCEDSTATE_POWERUP_TANOOKI,
	FORCEDSTATE_POWERUP_HAMMER,
	FORCEDSTATE_POWERUP_ICE,
}

local function allowedNPC(v, p)
	local cfg = NPC.config[v.id]
	
	if cfg.nohurt or cfg.iscoin or v.isFriendly or v.isHidden then return end
	
	if not v:mem(0x136, FIELD_BOOL) then
		v.speedX = 6 * p.direction
		v.speedY = -6
		
		v:mem(0x136, FIELD_BOOL, true)
	end
end

local function smash(v)
	v.speedX = -v.speedX
	v.speedY = -3
	Defines.earthquake = 8
end

local allowedMap = table.map{
	90,
	4,
	188,
	60,
	226,
}

local function allowedBlock(v)
	local cfg = Block.config[v.id]
	
	if cfg.floorslope ~= 0 or cfg.ceilingslope ~= 0 then
		return
	end
	
	if v.contentID ~= 0 then
		v:hit()
		smash(v)
	else
		if allowedMap[v.id] then
			v:remove(true)
		end
	end
end

local function colliderStuff(v, data)
	if math.abs(v.speedX) < 6 then return end
	
	local x = v.x + (v.width * .5) - 36
	local y = (v.y + v.height) - 64
	
	local collider = Colliders.Box(x, y - 2, 64, 64)

    for _ in ipairs(Colliders.getColliding{
		a = collider, 
		btype = Colliders.BLOCK, 
		b = Block.MEGA_HIT_SMASH,

		filter = allowedBlock
	}) do
		smash(v)
    end
	
    for _,n in ipairs(Colliders.getColliding{
		a = collider, 
		btype = Colliders.NPC, 
		b = NPC_HITTABLE,
	}) do
		allowedNPC(n, v)
    end
end

local shootPower = {
	[3] = {npc = id + 1, delay = 24},
	[6] = {npc = id + 2, delay = 48},
}

mounts.registerMount('reznor', {
	sfx = 'sounds/reznor1.wav',
	
	onPlayerHarm = function(v)
		SFX.play('sounds/reznor2.wav')
		Effect.spawn(199, v.x + (v.width * 0.5) - 32, (v.y + v.height) - 64)
	end,
	
	onInputUpdate = function(v)
		local data = mounts.getData(v)
		data.canShoot = data.canShoot or 0
		
		if v:isOnGround() and v.keys.jump and math.abs(v.speedX) >= 6 then
			v:mem(0x11C, FIELD_WORD, Defines.jumpheight + 2.5)
		end
		
		if v.keys.altJump then
			local x, y = v.x + (v.width * 0.5) - 36, (v.y + v.height) - 64
			
			local n = NPC.spawn(id, x, y)
			n.direction = v.direction
			
			v:mem(0x11C, FIELD_WORD, Defines.jumpheight)
			v.speedY = 0
			v.keys.altJump = false
			v.y = v.y - 8
			
			return mounts.clear(v)
		end
		
		if v.keys.run == KEYS_PRESSED and data.canShoot <= 0 and shootPower[v.powerup] then
			SFX.play(18)
			data.canShoot = shootPower[v.powerup].delay
			
			local x = 32 * v.direction
			if v.direction == -1 then
				x = 0
			end
			
			local ball = NPC.spawn(shootPower[v.powerup].npc, (v.x + v.width * .5) - 32 + x, (v.y + v.height) - 42)
			ball.direction = v.direction
			ball.speedX = 5 * v.direction
			
			if v.keys.up then
				ball.speedY = -6
				ball.speedX = ball.speedX * .5
			elseif v.keys.down then
				ball.speedY = 1
			else
				ball.speedY = -1
			end
			
			data.frame = 2
			data.frameTimer = -math.abs(v.speedX)
		end
		
		v.keys.down = false
	end,
	
	onTickEnd = function(v, style)
		local data = mounts.getData(v)
		local settings = v:getCurrentPlayerSetting()
		
		colliderStuff(v, data)
		
		data.frame =data.frame or 0
		data.frameTimer = data.frameTimer or 0
		data.canShoot = data.canShoot or 0
		
		if data.canShoot > 0 then
			data.canShoot = data.canShoot - 1
		end
		
		local speedX = math.abs(v.speedX)
		
		if speedX == 0 and data.frame == 2 then
			data.frameTimer = data.frameTimer + 1
			if data.frameTimer >= 8 then
				data.frame = 0
				data.frameTimer = 0
			end
		end
		
		data.frameTimer = (data.frameTimer + speedX * .5)
		if data.frameTimer >= 8 then
			data.frame = (data.frame + 1) % 2
			data.frameTimer = 0
		end
		
		if speedX == 0 and data.frame == 1 then
			data.frameTimer = 0
			data.frame = 0
		end
		
		if not v:isOnGround() and data.frame == 0 then
			data.frame = 1
		end
		
		v.height = (64 + settings.hitboxHeight * .5) - 16
		v:mem(0x160, FIELD_WORD, 1)
		v:mem(0x168, FIELD_FLOAT, 0)

		if transition[v.forcedState] then
			data.height = data.height or v.height
			
			if data.height ~= v.height then
				v.y = v.y - (v.height - data.height)
				
				data.height = v.height
			end
		end
		
		if math.abs(v.speedX) >= 6 then
			local time = lunatime.tick() % 12

			if v:isOnGround() then
				local x = 16
				x = (v.direction == 1 and -x) or x
				
				if time % 4 == 0 then
					SFX.play(sfx[math.random(1, #sfx)])
					
					local e = Effect.spawn(74, v.x + (v.width * .5) - 4 + x, (v.y + v.height) - 4)
					e.speedX = 1 * -v.direction
					e.speedY = -0.5
				end
			end
		end
	end,
	
	onDraw = function(v, style)
		local data = mounts.getData(v)
		
		local texture = style.texture
		
		local w, h = texture.width, texture.height / (frames + frames)
		
		local f = data.frame or 0
		f = (v.direction == 1 and f + frames) or f
		
		local x = 4
		
		v:render{
			x = v.x + ((v.direction == 1 and -x) or x),
			y = v.y - 16,
			
			frame = 24,
		}
		
		local args = {
			texture = texture,
			
			x = v.x + (v.width * .5) - (w * .5),
			y = (v.y + v.height) - h,
			
			sourceY = h * f,
			sourceHeight = h,
			
			sceneCoords = true,
			priority = -25,
		}
		
		Graphics.drawBox(args)
	
		if math.abs(v.speedX) >= 6 then
			local f = (lunatime.tick() % 8 >= 4 and 1) or 0
			f = (v.direction == 1 and f + 2) or f
		
			args.x = args.x + (8 * v.direction)
			args.texture = charge
			args.sourceY = h * f
			
			Graphics.drawBox(args)
		end
	end
})

return npc