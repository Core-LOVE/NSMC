local block = {}

local id = BLOCK_ID
local blockManager = require 'blockManager'

local cutscene = require 'cutscene/init'

blockManager.setBlockSettings{
	id = id,
	passthrough = true,
}

function block.onCollideBlock(v, n)
	if not v.isValid or v.isHidden or type(n) ~= "Player" then return end
	
	local settings = v.data._settings
	
	if settings.file then
		cutscene.runFile(settings.file)
	end
	
	v:delete()
end

function block.onInitAPI()
	blockManager.registerEvent(id, block, 'onCollideBlock')
end

return block