local npc = {}

local id = NPC_ID
local npcManager = require 'npcManager'

npcManager.setNpcSettings{
	id = id,
	
	width = 32,
	height = 32,
	gfxwidth = 42,
	gfxheight = 58,
	
	frames = 10,
	framestyle = 1,
	
	cliffturn = true,
	score = 0,
}

npcManager.registerHarmTypes(id,
	{
		HARM_TYPE_JUMP,
		HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		--HARM_TYPE_SWORD
	}, 
	{

	}
);

local start = 16
local ending = 80

function npc.onNPCHarm(e, v, r)
	if v.id ~= id then return end
	local data = v.data
	
	if data.state == 0 then
		data.state = 1
		v.speedX = 0
	end
	
	e.cancelled = true
end

function npc.onTickEndNPC(v)
	local data = v.data
	
	data.direction = data.direction or v.direction
	data.state = data.state or 0
	data.timer = data.timer or 0
	
	if data.state == 0 then 
		v.speedX = 1 * v.direction
	else
		local cfg = NPC.config[id]
		
		v.animationFrame = (cfg.frames + cfg.frames)
		if v.direction == 1 then
			v.animationFrame = (v.animationFrame + 2)
		end
		
		data.timer = data.timer + 1
		if data.timer > start and data.timer <= ending then
			v.animationFrame = (v.animationFrame + 1)
			
			if data.timer % 20 == 0 then
				local bubble = NPC.spawn(id + 1, v.x + (v.width * 0.5) - 12, v.y)
				bubble.x = bubble.x + (6 * v.direction)
				bubble.data.speedX = 4 * v.direction
				bubble.direction = v.direction
			end
		elseif data.timer > ending then
			data.timer = 0
			data.state = 0
			v.direction = -v.direction
			data.direction = v.direction
		end
	end
	
	if v.direction == -data.direction then
		data.state = 1
		v.speedX = 0
		v.direction = -v.direction
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	registerEvent(npc, 'onNPCHarm')
end

return npc