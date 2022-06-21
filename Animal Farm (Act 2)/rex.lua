-------------------------------
--      CUSTOM REX NPCS      --
--        by MrDoubleA       --
--    Please give credit!    --
-------------------------------
--  Chasing Rexes originally --
-- made in Super Mario World --
--       by RussianMan       --
-------------------------------
--  Dry Rex sprites and idea --
--        by wuffaló         --
-------------------------------
--   Part of the Dry Rex's   --
--      code taken from      --
--   drybones.lua by Enjl    --
-------------------------------

-- INSTALLATION
-- To make these NPCs actually work, just put this line of code in your luna.lua file:
-- "local rex = require("rex")"

local npcManager = require("npcManager")

rex = {}
rex.ids = {
	-- Edit this table to change the ids. Changing the two vanilla NPCs doesn't do much.
	squashed = 163,
	normal   = 162,
	pararex  = 751,
	
	-- chase_squashed = 752,
	-- chase_normal   = 753,
	-- chase_pararex  = 754,
	
	-- dry_squashed = 755,
	-- dry_normal   = 756,
	-- dry_pararex  = 757,
}

rex.customIDs = {
	rex.ids.pararex,
	
	rex.ids.chase_squashed,
	rex.ids.chase_normal,
	rex.ids.chase_pararex,
	
	rex.ids.dry_squashed,
	rex.ids.dry_normal,
	rex.ids.dry_pararex,
}

-- Put all your settings here!
-- Death effects are also here.
local settings = {
	shared = {
		npcblock = false,
		npcblocktop = false,
		playerblock = false,
		playerblocktop = false,
		
		jumphurt = false,
		spinjumpsafe = false,
		harmlessgrab = false,
		harmlessthrown = false,
	},
	[rex.ids.pararex] = {
		gfxwidth = 64,
		gfxheight = 64,
		width = 32,
		height = 64,
		gfxoffsetx = 0,
		gfxoffsety = 2,
		
		frames = 2,
		framestyle = 1,
		framespeed = 8,
		
		speed = 1,
		jumpheight = 8,
		iswalker = true,
		turnTo = rex.ids.normal,
		
		deathEffect = {id = 86, xoffset=1, yoffset=1},
	},
	
	-- [rex.ids.chase_squashed] = {
		-- gfxwidth = 32,
		-- gfxheight = 32,
		-- width = 32,
		-- height = 32,
		-- gfxoffsetx = 0,
		-- gfxoffsety = 2,
		
		-- frames = 2,
		-- framestyle = 1,
		-- framespeed = 8,
		
		-- speed = 1,
		-- chasingAcceleration = 0.25,
		-- chasingMaxSpeed = 5,
		
		-- stompEffect = 751,
		-- deathEffect = 752,
	-- },
	-- [rex.ids.chase_normal] = {
		-- gfxwidth = 40,
		-- gfxheight = 64,
		-- width = 32,
		-- height = 64,
		-- gfxoffsetx = 0,
		-- gfxoffsety = 2,
		
		-- frames = 2,
		-- framestyle = 1,
		-- framespeed = 8,
		
		-- speed = 1,
		-- chasingAcceleration = 0.15,
		-- chasingMaxSpeed = 4,
		-- turnTo = rex.ids.chase_squashed,
		
		-- deathEffect = 753,
	-- },
	-- [rex.ids.chase_pararex] = {
		-- gfxwidth = 64,
		-- gfxheight = 64,
		-- width = 32,
		-- height = 64,
		-- gfxoffsetx = 0,
		-- gfxoffsety = 2,
		
		-- frames = 2,
		-- framestyle = 1,
		-- framespeed = 8,
		
		-- speed = 1,
		-- jumpheight = 4,
		-- chasingAcceleration = 0.15,
		-- chasingMaxSpeed = 8,
		-- turnTo = rex.ids.chase_normal,
		
		-- deathEffect = 753,
	-- },
	
	-- [rex.ids.dry_squashed] = {
		-- gfxwidth = 48,
		-- gfxheight = 32,
		-- width = 32,
		-- height = 32,
		-- gfxoffsetx = 0,
		-- gfxoffsety = 2,
		
		-- frames = 2,
		-- framestyle = 1,
		-- framespeed = 8,
		
		-- speed = 1.5,
		-- nofireball = true,
		-- recoverTime = 325,
		-- recoverTurnTo = rex.ids.dry_normal,
		-- stompSFX = 57,
		-- dry = true,
		
		-- deathEffect = 754,
	-- },
	-- [rex.ids.dry_normal] = {
		-- gfxwidth = 40,
		-- gfxheight = 64,
		-- width = 32,
		-- height = 64,
		-- gfxoffsetx = 0,
		-- gfxoffsety = 2,
		
		-- frames = 2,
		-- framestyle = 1,
		-- framespeed = 8,
		
		-- speed = 1,
		-- nofireball = true,
		-- iswalker = true,
		-- turnTo = rex.ids.dry_squashed,
		-- dry = true,
		
		-- deathEffect = 755,
	-- },
	-- [rex.ids.dry_pararex] = {
		-- gfxwidth = 64,
		-- gfxheight = 64,
		-- width = 32,
		-- height = 64,
		-- gfxoffsetx = 0,
		-- gfxoffsety = 2,
		
		-- frames = 2,
		-- framestyle = 1,
		-- framespeed = 8,
		
		-- speed = 1,
		-- nofireball = true,
		-- iswalker = true,
		-- jumpheight = 8,
		-- turnTo = rex.ids.dry_normal,
		-- dry = true,
		
		-- deathEffect = 755,
	-- },
}

function rex.onInitAPI()
	local err = ""
	for _,v in ipairs(rex.customIDs) do
		if settings[v] then
			npcManager.registerDefines(v,{NPC.HITTABLE})
			npcManager.setNpcSettings(table.join({id = v},table.join(settings.shared,settings[v])))
			npcManager.registerHarmTypes(v,
				{
					HARM_TYPE_JUMP,
					HARM_TYPE_FROMBELOW,
					HARM_TYPE_NPC,
					HARM_TYPE_PROJECTILE_USED,
					HARM_TYPE_LAVA,
					HARM_TYPE_HELD,
					HARM_TYPE_TAIL,
					HARM_TYPE_SPINJUMP,
					HARM_TYPE_OFFSCREEN,
					HARM_TYPE_SWORD
				}, 
				{
					[HARM_TYPE_JUMP]            = settings[v].stompEffect,
					[HARM_TYPE_FROMBELOW]       = settings[v].deathEffect,
					[HARM_TYPE_NPC]             = settings[v].deathEffect,
					[HARM_TYPE_PROJECTILE_USED] = settings[v].deathEffect,
					[HARM_TYPE_LAVA]            = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
					[HARM_TYPE_HELD]            = settings[v].deathEffect,
					[HARM_TYPE_TAIL]            = settings[v].deathEffect,
					[HARM_TYPE_SPINJUMP]        = 10,
				}
			)
			npcManager.registerEvent(v,rex,"onTickEndNPC")
		else
			err = err.. tostring(v).. ", "
		end
	end
	if err ~= "" then
		error("NPC ID(s) in rex.customIDs without settings: ".. string.sub(err,1,string.len(err) - 2))
	end
	registerEvent(rex,"onNPCKill")
	registerEvent(rex,"onNPCHarm")
end

function changeSize(v,width,height)
	if width == v.width and height == v.height then return end
	local data = v.data
	v.x = (v.x + (v.width / 2)) - (width / 2)
	v.width = width
	
	v.y = (v.y + v.height) - height
	v.height = height
end

function nearestPlayer(x,y)
	if Player.count() == 1 then
		return player
	else
		local c
		for _,v in ipairs(Player.get()) do
			if c then
				local x2,y2 = (v.x + (v.width / 2)) - x,(v.y + (v.height / 2)) - y
				local x3,y3 = (c.x + (c.width / 2)) - x,(c.y + (c.height / 2)) - y
				if math.abs(x2) + math.abs(y2) < math.abs(x3) + math.abs(y3) then
					c = v
				end
			else
				c = v
			end
		end
		return c
	end
end

function rex.onNPCKill(eventObj,v,killReason)
	local s = npcManager.getNpcSettings(v.id)
	local dry = (s.recoverTime and s.recoverTurnTo)
	if  (s.turnTo or (s.recoverTime and s.recoverTurnTo))
	and (killReason == HARM_TYPE_JUMP) then
		local newSettings = npcManager.getNpcSettings(s.turnTo)
		eventObj.cancelled = true
		if (s.recoverTime and s.recoverTurnTo) then
			local data = v.data
			
			Audio.playSFX(s.stompSFX)
			data.recoverTime = 0
			v.friendly = true
		else
			changeSize(v,newSettings.width,newSettings.height)
			v:transform(s.turnTo)
		end
	end
end

function rex.onTickEndNPC(v)
	local data = v.data
	local s = npcManager.getNpcSettings(v.id)
		
	if v:mem(0x12A, FIELD_WORD) <= 0 and not s.dry
	or v:mem(0x12C, FIELD_WORD) >  0
	or v:mem(0x136, FIELD_BOOL)
	or v:mem(0x138, FIELD_WORD) >  0
	or Defines.levelFreeze
	then return end
	
	-- Dry Rex data stuff
	if s.dry then
		if (data.friendly == nil) then
			data.friendly = v.friendly
		end
		if v:mem(0x12A, FIELD_WORD) <= 0 then
			data.recoverTime = nil
			v.friendly = data.friendly or false
			return
		end
	end
	
	-- Pararex stuff
	if v.collidesBlockBottom and s.jumpheight then
		v.speedY = -s.jumpheight
	end
	
	-- Chasing Rex stuff
	if s.chasingMaxSpeed and s.chasingAcceleration then
		local nearest = nearestPlayer(v.x + (v.width / 2),v.y + (v.height / 2))
		local distanceFromPlayerX = (nearest.x + (nearest.width / 2)) - (v.x + (v.width / 2))
		if distanceFromPlayerX > 8 then
			v.speedX = v.speedX + s.chasingAcceleration
		elseif distanceFromPlayerX < 8 then
			v.speedX = v.speedX - s.chasingAcceleration
		else
			if v.speedX > 0 then
				v.speedX = v.speedX - s.chasingAcceleration
				if v.speedX < 0 then
					v.speedX = 0
				end
			elseif v.speedX < 0 then
				v.speedX = v.speedX + s.chasingAcceleration
				if v.speedX > 0 then
					v.speedX = 0
				end
			end
		end
		if v.speedX > s.chasingMaxSpeed then
			v.speedX = s.chasingMaxSpeed
		elseif v.speedX < -s.chasingMaxSpeed then
			v.speedX = -s.chasingMaxSpeed
		end
		if v:mem(0x120,FIELD_BOOL) and (v.collidesBlockBottom or v:mem(0x22,FIELD_WORD) ~= 0) then
			v.speedY = -3
		end
	end
	
	-- Dry Rex stuff
	if (s.recoverTime and s.recoverTurnTo) and data.recoverTime then
		v.speedX = 0
		data.recoverTime = data.recoverTime + 1
		
		if data.recoverTime <= 16 or data.recoverTime >= s.recoverTime - 16 then
			v.animationFrame = (s.frames*2)
		else
			v.animationFrame = (s.frames*2) + 1
		end
		if v.direction == DIR_RIGHT then
			v.animationFrame = v.animationFrame + 2
		end
		
		if data.recoverTime >= s.recoverTime then
			data.recoverTime = nil
			v.friendly = data.friendly or false
			
			local newSettings = npcManager.getNpcSettings(s.recoverTurnTo)
			changeSize(v,newSettings.width,newSettings.height)
			v:transform(s.recoverTurnTo)
		end
	elseif (s.recoverTime and s.recoverTurnTo) then
		v.speedX = v.direction * 1.25
	end
end

return rex