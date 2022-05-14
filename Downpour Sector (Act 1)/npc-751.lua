local npc = {}

local id = NPC_ID
local npcManager = require 'npcManager'

local rain = require 'rain'

npcManager.setNpcSettings{
	id = id,
	
	frames = 1,
	
	jumphurt = true,
	nohurt = true,
	
	npcblock = true,
	npcblocktrue = true,
	playerblock = true,
	playerblocktop = true,
	
	noiceball = true,
	noyoshi = true,
	
	nogravity = true,
}

function npc.onTickEndNPC(v)
	if rain.up then
		v.speedY = -4
	else
		v.speedY = 4
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc 