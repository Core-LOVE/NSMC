local npc = {}

local id = NPC_ID
local npcManager = require 'npcManager'

npcManager.setNpcSettings{
	id = id,
	
	width = 24,
	height = 24,
	gfxwidth = 24,
	gfxheight = 24,
	
	frames = 3,
	framestyle = 0,
	
	jumphurt = true,
	nohurt = true,
	
	nogravity = true,
	score = 0,
}


npcManager.registerHarmTypes(id,
	{
		HARM_TYPE_JUMP,
		--HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		--HARM_TYPE_SWORD
	}, 
	{

	}
);

function npc.onNPCKill(e, v, r)
	if v.id ~= id then return end
	
	local x = v.x + v.width * .5
	local y = v.y + v.height * .5

	for i = 0, 360, 64 do
		local i = math.rad(i)
		
		local dx = math.cos(i) * 12
		local dy = math.sin(i) * 12
		
		Effect.spawn(751, x + dx, y + dy)
	end
	
	Effect.spawn(752, v.x - 2, v.y - 2)
end

function npc.onTickEndNPC(v)
	if v.collidesBlockBottom or v.collidesBlockLeft or v.collidesBlockRight or v.collidesBlockTop then
		return v:kill(9)
	end
	
	local data = v.data
	local cfg = NPC.config[id]
	
	data.frame = data.frame or 0
	data.timer = data.timer or 0
	
	data.timer = data.timer + 1
	if data.timer >= 8 and data.frame < cfg.frames - 1 then
		data.frame = data.frame + 1
		data.timer = 0
		
		if data.frame >= cfg.frames -1 then
			v.speedX = data.speedX or (4 * v.direction)
		end
	end
	
	v.animationFrame = data.frame
	
	if math.abs(v.speedX) > 2 then
		v.speedX = v.speedX - (0.1 * v.direction)
	end
	
	v.ai1 = v.ai1 + (v.speedX * 0.01)
	v.speedY = math.sin(v.ai1 * 2) * 0.5 * -v.direction
	
	for _,p in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
		p.speedY = -6
		p:mem(0x11C, FIELD_WORD, 20)
		return v:kill(1)
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	registerEvent(npc, 'onNPCKill')
end

return npc