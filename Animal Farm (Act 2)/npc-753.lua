local npcManager = require("npcManager")
local id = NPC_ID

local npc = {}

npcManager.setNpcSettings{
	id = id,
	
	width = 32,
	height = 48,
	gfxwidth = 32,
	gfxheight = 48,
	
	frames = 1,
	
	nogravity = true,
	noblockcollision = true,
}

local img

local rad2deg = 180/math.pi

function npc.onDrawNPC(v)
	local data = v.data
	data.scale = data.scale or 1
	data.rot = data.rot or 0
	
	img = img or Graphics.sprites.npc[id].img
	
	local scale = vector(img.width, img.height) * data.scale
	
	Graphics.drawBox{
		texture = img,

		x = v.x + v.width * .5,
		y = v.y + v.height * .5,
		width = scale[1],
		height = scale[2],
		
		rotation = data.rot,
		centered = true,
		
		sceneCoords = true,
		priority = -96,
	}
	
	if data.scale > 0 then
		data.scale = data.scale - 0.01
	else
		data.scale = 0
	end
	
	data.rot = data.rot + ((v.speedX / (0.5 * v.height)) * rad2deg) / data.scale
end

function npc.onTickEndNPC(v)
	v.animationFrame = -1
	
	v.speedY = v.speedY + 0.05
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	npcManager.registerEvent(id, npc, 'onDrawNPC')
end

return npc