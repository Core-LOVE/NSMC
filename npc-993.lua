local npc = {}

local id = NPC_ID

local npcManager = require 'npcManager'
local afterimages = require 'libs/afterimages'

npcManager.setNpcSettings{
	id = id,
	
	frames = 4,
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
	afterimages.create(v, 12, Color.red, false, -16)
	local collider = Colliders.Box(v.x, v.y, v.width, v.height)
	
	for _,n in NPC.iterate() do
		local cfg = NPC.config[n.id]
			
		if n ~= v and not n.friendly and Colliders.collideNPC(collider, n) and not cfg.iscoin and not cfg.isvine and not cfg.isyoshi and n:mem(0x156, FIELD_WORD) <= 0 then
			if not cfg.nofireball then
				n:harm(3)
				n:mem(0x156, FIELD_WORD, 8)
			end
		end
	end
	
	if v.collidesBlockTop or v.collidesBlockLeft or v.collidesBlockRight or v.collidesBlockBottom then
		return v:kill(3)
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	registerEvent(npc, 'onPostNPCKill')
end

return npc