--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
	id = npcID,
	--Sprite size
	gfxwidth = 32,
	gfxheight = 32,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 32,
	height = 32,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 2,
	framestyle = 0,
	framespeed = 8, --# frames between frame change
	--Movement speed. Only affects speedX by default.
	speed = 2,
	--Collision-related
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.
	
	luahandlesspeed = true,

	nohurt=false,
	nogravity = true,
	noblockcollision = false,
	nofireball = false,
	noiceball = false,
	noyoshi= false,
	nowaterphysics = false,
	--Various interactions
	jumphurt = false, --If true, spiny-like
	spinjumpsafe = false, --If true, prevents player hurt when spinjumping
	harmlessgrab = false, --Held NPC hurts other NPCs if false
	harmlessthrown = false, --Thrown NPC hurts other NPCs if false

	grabside=false,
	grabtop=false,

	--Identity-related flags. Apply various vanilla AI based on the flag:
	--iswalker = false,
	--isbot = false,
	--isvegetable = false,
	--isshoe = false,
	--isyoshi = false,
	--isinteractable = false,
	--iscoin = false,
	--isvine = false,
	--iscollectablegoal = false,
	--isflying = false,
	--iswaternpc = false,
	--isshell = false,

	--Emits light if the Darkness feature is active:
	--lightradius = 100,
	--lightbrightness = 1,
	--lightoffsetx = 0,
	--lightoffsety = 0,
	--lightcolor = Color.white,

	--Define custom properties below
}

--Applies NPC settings
npcManager.setNpcSettings(sampleNPCSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		--HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		--HARM_TYPE_NPC,
		--HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		--HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		--HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=10,
		--[HARM_TYPE_FROMBELOW]=10,
		--[HARM_TYPE_NPC]=10,
		--[HARM_TYPE_PROJECTILE_USED]=10,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		--[HARM_TYPE_HELD]=10,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below


--Register events
function sampleNPC.onInitAPI()
	npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
	--registerEvent(sampleNPC, "onNPCKill")
end

function sampleNPC.onTickEndNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	--If despawned
	if v.despawnTimer <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		data.initialized = true
		data.horizontalDirection = 0
		data.verticalDirection = 0
		data.bounceHeight = 0
		
		v.height = v.height - 4
		v.y = v.y + 4
		data.sp = NPC.spawn(879, v.x, v.y - 2)
		
		if data._settings.ai == 0 or data._settings.ai == 2 or data._settings.ai == 4 then
			v.speedX = sampleNPCSettings.speed * v.direction
			data.horizontalDirection = v.direction
		elseif data._settings.ai == 1 or data._settings.ai == 3 then
			v.speedY = sampleNPCSettings.speed * v.direction
			data.verticalDirection = v.direction
		elseif data._settings.ai == 5 then
			z = NPC.spawn(207, v.x, v.y)
			z.direction = v.direction
			z.friendly = true
		end
		
		if data._settings.ai == 0 or data._settings.ai == 1 or data._settings.ai == 5 then
			v.noblockcollision = true
		end
		
		v.friendly = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI. This template just jumps when it touches the ground.
	--Text.print(player:mem(0x11C, FIELD_WORD), 100, 100)

	if Colliders.collide(player, v) then
		if player:mem(0x50, FIELD_BOOL) and player.speedY > 0 and player.y > v.y then
		else
			player:harm()
		end
	end
	
	if data._settings.ai == 0 or data._settings.ai == 1 then
		if data.horizontalDirection == 0 and (v.speedX < -.2 or v.speedX > .2) then
			v.speedX = math.clamp(v.speedX + (.05 * -v.direction), -2, 2)
		elseif data.horizontalDirection == 0 and (v.speedX > -.2 or v.speedX < .2) then
			v.speedX = 0
		else
			v.speedX = math.clamp(v.speedX + (.05 * data.horizontalDirection), sampleNPCSettings.speed * -1, sampleNPCSettings.speed)
		end
		
		if data.verticalDirection == 0 and (v.speedY < -.2 or v.speedY > .2) then
			if v.speedY > 0 then
				v.speedY = math.clamp(v.speedY + (-.05), -2, 2)
			else
				v.speedY = math.clamp(v.speedY + (.05), -2, 2)
			end
		elseif data.verticalDirection == 0 and (v.speedY > -.2 or v.speedY < .2) then
			v.speedY = 0
		else
			v.speedY = math.clamp(v.speedY + (.05 * data.verticalDirection), sampleNPCSettings.speed * -1, sampleNPCSettings.speed)
		end
	
		--Text.print(v.speedX, 100, 116)
		-- Text.print(data.verticalDirection, 100, 132)
		
		for k,r in ipairs(BGO.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
			if r.id == 193 or r.id == 195 or r.id == 198 then
				data.horizontalDirection = -1
			elseif r.id == 194 or r.id == 196 or r.id == 197 then
				data.horizontalDirection = 1 
			elseif r.id == 191 or r.id == 192 or r.id == 199 then
				data.horizontalDirection = 0
			end
			
			if r.id == 191 or r.id == 195 or r.id == 196 then
				data.verticalDirection = -1
			elseif r.id == 192 or r.id == 197 or r.id == 198 then
				data.verticalDirection = 1 
			elseif r.id == 193 or r.id == 194 or r.id == 199 then
				data.verticalDirection = 0
			end
		end
	elseif data._settings.ai == 3 then
		if v.collidesBlockBottom then
			v.speedY = -sampleNPCSettings.speed
		elseif v.collidesBlockUp then
			v.speedY = sampleNPCSettings.speed
		end
	elseif data._settings.ai == 4 then
		v.speedY = v.speedY + .2
		if v.collidesBlockBottom then
			v.speedY = data.bounceHeight + .2
		end
		data.bounceHeight = -v.speedY
	elseif data._settings.ai == 5 then
		v.x = z.x
		v.y = z.y
		z.animationFrame = -1
		z.animationTimer = 1
	end
	
	data.sp.x = v.x
	data.sp.y = v.y - 6
end

--Gotta return the library table!
return sampleNPC