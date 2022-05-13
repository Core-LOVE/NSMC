local npc = {}

local id = NPC_ID
local npcManager = require 'npcManager'

local rain = require 'rain'

npcManager.setNpcSettings{
	id = id,
	
	frames = 1,
	
	npcblock = true,
	npcblocktrue = true,
	playerblock = true,
	playerblocktop = true,
	
	noiceball = true,
	noyoshi = true,
	
	nogravity = true,
}

local grav = Defines.npc_grav
	
function npc.onTickEndNPC(v)
	if rain.up then
		v.speedY = v.speedY - grav
	else
		v.speedY = v.speedY + grav
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc 