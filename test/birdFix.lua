local bird = {}

local bib = require("npcs/ai/birb")
local npcManager = require("npcManager")

function bird.onTickNPC(v)
	local data = v.data
	data.dontMove = data.dontMove or v.dontMove
	
	if v.despawnTimer <= 0 then
		v.dontMove = data.dontMove
		return
	end
end

for id in pairs(bib.ids) do
	npcManager.registerEvent(id, bird, "onTickNPC")
end

return bird