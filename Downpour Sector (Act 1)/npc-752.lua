local npc = {}

local id = NPC_ID
local npcManager = require 'npcManager'

local rain = require 'rain'

local size = 64

npcManager.setNpcSettings{
	id = id,
	
	width = size,
	height = size,
	gfxwidth = size,
	gfxheight = size,
	
	frames = 2,
	framestyle = 1,
	
	noiceball = true,
	noyoshi = true,	
	
	score = 0,
	
	nogravity = true,
	noblockcollision = true,
}

npcManager.registerHarmTypes(id,
	{
		HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		--HARM_TYPE_NPC,
		--HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		--HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		--HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=10,
		--[HARM_TYPE_FROMBELOW]=10,
		--[HARM_TYPE_NPC]=10,
		--[HARM_TYPE_PROJECTILE_USED]=10,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		--[HARM_TYPE_HELD]=10,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=10,
	}
);

function npc.onNPCHarm(e, v, r, c)
	if v.id ~= id then return end
	
	if v.speedY == 0 then
		v.speedY = (rain.up and -6) or 6
	end
	
	e.cancelled = true
end

local acceleration = 0.2

function npc.onTickEndNPC(v)
	if v.speedY > 0 then
		v.speedY = v.speedY - acceleration
	elseif v.speedY < 0 then
		v.speedY = v.speedY + acceleration
	end
	
	if v.speedY <= acceleration and v.speedY >= -acceleration then
		v.speedY = 0
	end
end

function npc.onInitAPI()
	registerEvent(npc, 'onNPCHarm')
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc 