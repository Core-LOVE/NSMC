local hud = {}

local p = player

local priority = 5
local offset = SaveData.hudOffset or 24

local starcoinAI
local textplus = require 'textplus'
local font =  textplus.loadFont("textplus/font/2.ini")

local heart = Graphics.loadImageResolved 'graphics/heart.png'
local itembox = Graphics.loadImageResolved 'graphics/itembox.png'
local coin = Graphics.loadImageResolved 'graphics/coin.png'
local starcoin = Graphics.loadImageResolved 'graphics/starcoin.png'

local hud1 = Graphics.loadImageResolved 'graphics/hud1.png'
local hud2 = Graphics.loadImageResolved 'graphics/hud2.png'
local hud3 = Graphics.loadImageResolved 'graphics/hud3.png'
local hud4 = Graphics.loadImageResolved 'graphics/hud4.png'

local name = Level.filename():gsub('%.(%w+)', '')
local act = ""

if name:match('Act (%d+)') then
	act = '(Act ' .. name:match('Act (%d+)') .. ')'
	name = name:gsub('(%s*)%(Act (%d+)%)', '')
end

function hud.getOffset()
	return offset
end

local drawName

do
	local font =  textplus.loadFont("textplus/font/6.ini")
	local opacity = 0
	local state = 0
	
	local dx = -80
	local ac = 4
	
	drawName = function()
		if state == 0 then
			opacity = opacity + 0.05
			
			if opacity > 5 then
				opacity = 5
				state = 1
			end
		else
			if opacity < 0 then
				return
			end
			
			opacity = opacity - 0.1
		end
		
		local y = (offset + hud1.height + hud3.height + 42)
		
		Graphics.drawImageWP(hud4, 0, y, opacity, priority)
		
		y = y - 4
		
		local col = Color.white * opacity
		
		textplus.print{
			text = name,
			
			x = offset + dx,
			y = y,
			
			xscale = 2,
			yscale = 2,
			
			color = col,
			priority = priority,
			font = font,
		}
		
		textplus.print{
			text = act,
			
			x = offset + (dx * 0.5),
			y = y + 18,
			
			xscale = 3,
			yscale = 3,
			
			color = col,
			priority = priority,	
			font = font,
		}	
		
		if ac > 0 then
			dx = dx + ac
			ac = ac - 0.1
		else
			dx = dx + 0.1
		end
	end
end

local function drawLives()
	Graphics.drawImageWP(hud1, offset, offset, priority)
	
	local dx = 6
	
	for i = 0, 2 do
		local col
		
		if i + 1 > p.powerup or p.deathTimer > 0 then
			col = Color.gray .. 0.5
		end
		
		Graphics.drawBox{
			texture = heart,
			
			x = offset + dx,
			y = offset - 6,
			
			priority = priority,
			color = col,
		}
		
		dx = dx + heart.width + 2
	end
end

local function drawScore()
	Graphics.drawImageWP(hud2, 800 - hud2.width - offset, offset, priority)
	
	local count = SaveData._basegame.hud.score
	count = string.format("%08d", count)
	
	textplus.print{
		text = count,
		
		x = 800 - hud2.width - offset - 8,
		y = offset + 8,
		
		xscale = 2,
		yscale = 2,
		
		font = font,
		priority = priority,
	}
end

local function drawBox()
	Graphics.drawImageWP(itembox, 400 - itembox.width * .5, offset, priority)
	
	if p.reservePowerup > 0 then
		if Graphics.sprites.npc[p.reservePowerup].img then
			Graphics.drawBox{
				texture = Graphics.sprites.npc[p.reservePowerup].img, 
				
				x = (400 - itembox.width * .5) + (itembox.width - 32) * 0.5, 
				y = offset + (itembox.height - 32) * 0.5, 
				sourceWidth = 32,
				sourceHeight = 32,
				
				priority = priority
			}
		end
	end
end

local function drawCoins()
	local y = offset + hud1.height + 8
	
	Graphics.drawImageWP(hud3, offset, y, priority)
	Graphics.drawImageWP(coin, offset + 4, y + 2, priority)
	
	local count = SaveData.coins or mem(0x00B2C5A8, FIELD_WORD)
	count = string.format("%03d", count)
	
	textplus.print{
		text = count,
		
		x = offset + 12 + coin.width,
		y = y + 4,
		
		font = font,
		xscale = 2,
		yscale = 2,
		priority = priority,
	}
end

local drawStarcoins
do
	local function validCoin(t, i)
		return t[i] and (t.alive[i])
	end

	drawStarcoins = function()
		if not starcoinAI then return end
		local t = starcoinAI.getLevelList()
		
		if not t then return end
		
		local dx = 0
		local dy = 0
		
		for i = 1, t.maxID do
			local col = {0.5, 0.5, 0.5, 0.5}
			
			if t[i] ~= 0 then
				col = nil
			end
			
			Graphics.drawBox{
				texture = starcoin,
				
				x = offset + dx,
				y = (offset + hud1.height + 12 + hud3.height) + dy,
				
				color = col,
			}
			
			dx = dx + starcoin.width + 2
			
			if i % 5 == 0 then
				dy = dy + starcoin.height + 2
				dx = 0
			end
		end
	end
end

Graphics.overrideHUD(function()
	drawLives()
	drawScore()
	drawBox()
	drawCoins()
	
	drawStarcoins()
	drawName()
end)

function hud.onTickEnd()
	local coins = mem(0x00B2C5A8, FIELD_WORD)
	
	if coins > 0 then
		SaveData.coins = SaveData.coins + coins
		mem(0x00B2C5A8, FIELD_WORD, 0)
		
		if SaveData.coins > 999 then
			SaveData.coins = 0
		end
	end
end

function hud.onInitAPI()
	starcoinAI = require("npcs/ai/starcoin")
	
	registerEvent(hud, 'onTickEnd')
end

return hud