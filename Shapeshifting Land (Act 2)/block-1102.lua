local blockmanager = require("blockmanager")
local cp = require("blocks/ai/clearpipe")

local blockID = BLOCK_ID

local img = Graphics.loadImageResolved('block-1102a.png')

local block = {}

blockmanager.setBlockSettings({
	id = blockID,
	noshadows = true,
	width = 64,
	height = 64
})

function block.onInitAPI()
	blockmanager.registerEvent(blockID, block, "onCameraDrawBlock")
end
	
	function block.onCameraDrawBlock(blockID)
	
		if blockID.x >= camera.x - blockID.width and blockID.x <= camera.x + 800 and blockID.y >= camera.y - blockID.height and blockID.y <= camera.y + 600 then
			Sprite.draw{
				texture = img,
				
				x = blockID.x,
				y = blockID.y,
				
				sceneCoords = true,
				height = blockID.height,
				width = blockID.width,
				frames = 1,
				
				priority = -80,
				color = vector(1,1,1,0.3)
			}
		
			Sprite.draw{
				texture = img,
				
				x = blockID.x,
				y = blockID.y,
				
				sceneCoords = true,
				height = blockID.height,
				width = blockID.width,
				frames = 1,
				
				priority = -20,
				color = vector(1,1,1,0.3)
			}
		end
	end

-- Up, down, left, right
cp.registerPipe(blockID, "JUNC", "UP_FULL", {false, true,  true,  true})

return block