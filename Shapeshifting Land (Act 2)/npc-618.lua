local npcManager = require("npcManager")
local bro = require("bro")

local sledgeBros = {}
local npcID = NPC_ID
local broSettings = {
	id = npcID,
	gfxheight = 64,
	gfxwidth = 48,
	height = 64,
	width = 48,
	gfxoffsety = 2,
	frames = 2,
	framestyle = 1,
	speed = 1,
	score = 5,
	holdoffsetx = 8,
	holdoffsety = 20,
	throwoffsetx = 8,
	throwoffsety = 20,
	walkframes = 100,
	jumpframes = 300,
	jumpspeed = 6,
	throwspeedx = 3.4,
	throwspeedy = -8,
	waitframeslow = 256,
	waitframeshigh = 256,
	holdframes = 30,
	throwid = 617,
	quake = true,
	quakeintensity = 15,
	stunframes = 130,
	isheavy = 1,
	followplayer = true
}
npcManager.setNpcSettings(broSettings)

bro.setDefaultHarmTypes(npcID, 264)
bro.register(npcID)

return sledgeBros