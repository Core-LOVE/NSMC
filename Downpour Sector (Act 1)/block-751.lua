local block = {}

local id = BLOCK_ID
local blockManager = require 'blockManager'

local rain = require 'rain'

blockManager.setBlockSettings{
	id = id,
}

function block.onBlockHit(e, v)
	if v.id ~= id then return end
	
	rain.flip()
end

function block.onInitAPI()
	registerEvent(block, 'onBlockHit')
end

return block