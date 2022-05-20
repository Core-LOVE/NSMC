local block = {}

local id = BLOCK_ID
local blockManager = require 'blockManager'

local camlock = require 'camlock'
local blockutils = require 'blocks/blockutils'

blockManager.setBlockSettings{
	id = id,
	passthrough = true,
}

function block.onStartBlock(v)
	local y = v.y
	
	local w, h = v.width, v.height
	
	local sectionIdx = blockutils.getBlockSection(v)
	local bounds = Section(sectionIdx).boundary
	
	if y < bounds.top then
		h = h - (y - bounds.top)
		y = bounds.top
	end

	if w < 800 then
		w = 800
	end
	
	return camlock.addZone(v.x, y, w, h, 1 / (v.data._settings.lerp or 1))
end

function block.onInitAPI()
	blockManager.registerEvent(id, block, 'onStartBlock')
end

return block