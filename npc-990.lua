local npc = {}

local id = NPC_ID
local npcManager = require 'npcManager'
local actor = require 'cutscene/actor'

npcManager.setNpcSettings{
	id = id,
	nogravity = true,
}

function npc.onTickNPC(v)
	local data = v.data
	
	if v.despawnTimer <= 0 then 
		if data.actor then
			data.actor:delete()
		end
		
		data.init = nil
		
		return 
	end
	
	local settings = data._settings
	
	if not data.init then
		data.actor = actor.new(settings.name or "exampleToad", {
			parent = v,
		})
		
		if settings.file and settings.file ~= "" then
			
		end
		
		v.friendly = true
		data.init = true
	end
	
	local actor = data.actor
	
	if actor.gravity then
		v.speedY = v.speedY + actor.gravity or 0.26
	end
end

function npc.onDrawNPC(v)
	local data = v.data
	if not data.init then return end
	
	data.actor:draw()
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickNPC')
	npcManager.registerEvent(id, npc, 'onDrawNPC')
end

return npc