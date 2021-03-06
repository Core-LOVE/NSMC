local npcManager = require("npcManager")
local bro = require("bro")

local hammerBros = {}
local npcID = NPC_ID
local broSettings = {
	id = npcID,
	gfxheight = 48,
	gfxwidth = 32,
	height = 48,
	width = 32,
	gfxoffsety = 2,
	frames = 2,
	framestyle = 1,
	speed = 1,
	score = 5,
	holdoffsetx = 0,
	holdoffsety = 16,
	throwoffsetx = 0,
	throwoffsety = 16,
	walkframes = 100,
	jumpframes = 300,
	jumpspeed = 7,
	throwspeedx = 3.4,
	throwspeedy = -8,
	waitframeslow = 256,
	waitframeshigh = 256,
	holdframes = 30,
	throwid = 617,
	quake = false,
	stunframes = 0,
	quakeintensity = 0,
	followplayer = true,
	noiceball = false,
	nofireball = false
}
npcManager.setNpcSettings(broSettings)
bro.setDefaultHarmTypes(npcID, 263)
bro.register(npcID)

return hammerBros