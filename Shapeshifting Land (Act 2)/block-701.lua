local blockmanager = require("blockmanager")
local cp = require("blocks/ai/clearpipe")

local blockID = BLOCK_ID

local img = Graphics.loadImageResolved('block-701a.png')

local block = {}

blockmanager.setBlockSettings({
	id = blockID,
	noshadows = true,
	width = 64,
	height = 32
})

function block.onInitAPI()
	blockmanager.registerEvent(blockID, block, "onCameraDrawBlock")
end

function block.onCameraDrawBlock(blockID)

	if blockID.x >= camera.x - blockID.width and blockID.x <= camera.x + 800 and blockID.y >= camera.y - blockID.height and blockID.y <= camera.y + 600 then
		Graphics.drawImageToSceneWP(img,blockID.x,blockID.y,0.3,-80)
		Graphics.drawImageToSceneWP(img,blockID.x,blockID.y,0.3,-20)
	end
end

-- Up, down, left, right
cp.registerPipe(blockID, "END", "VERT", {true,  true,  false, false})

return block