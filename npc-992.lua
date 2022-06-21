local npc = {}

local id = NPC_ID

local npcManager = require 'npcManager'
local afterimages = require 'libs/afterimages'

npcManager.setNpcSettings{
	id = id,
	
	frames = 8,
	framestyle = 0,
	framespeed=4,
	
	jumphurt = true,
	foreground = true,
	
	nohurt = true,
	nofireball = true,
	noiceball = true,
	
	score = 0,
}

function npc.onPostNPCKill(v, r)
	if v.id ~= id or r == 9 then return end
	
	SFX.play(3)
	
	Effect.spawn(131, v.x, v.y)
end

function npc.onTickEndNPC(v)
	afterimages.create(v, 9, Color.orange, false, -16)
	
	local collider = Colliders.Box(v.x + v.speedX, v.y + v.speedY, v.width, v.height)
	
	for _,n in NPC.iterate() do
		local cfg = NPC.config[n.id]
			
		if n.id ~= v.id and not n.friendly and Colliders.collideNPC(collider, n) and not cfg.iscoin and not cfg.isvine and not cfg.isyoshi then
			if not cfg.nofireball then
				n:harm(3)
			end
			
			return v:kill(3)
		end
	end
	
	if v.collidesBlockTop or v.collidesBlockLeft or v.collidesBlockRight then
		return v:kill(3)
	end
	
	if v.collidesBlockBottom then
		v.speedY = -6
		v.ai1 = v.ai1 + 1
		
		if v.ai1 > 2 then
			return v:kill(3)
		end
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	registerEvent(npc, 'onPostNPCKill')
end

return npc