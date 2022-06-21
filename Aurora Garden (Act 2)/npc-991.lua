-- Original script from basegame
-- Edited by LooKiCH (Lukinsky)

local npcManager = require("npcManager")
local particles = require("particles")
local utils = require("npcs/npcutils")

local foo = {}

--***************************************************************************************************
--                                                                                                  *
--              DEFAULTS AND NPC CONFIGURATION                                                      *
--                                                                                                  *
--***************************************************************************************************

local npcID = NPC_ID;

function foo.onInitAPI()
	registerEvent(foo, "onTick", "onTick", false)
	registerEvent(foo, "onDraw", "onDraw", false)
	registerEvent(foo, "onNPCKill", "onNPCKill", false)
	
	npcManager.registerEvent(npcID, foo, "onTickNPC")
	npcManager.registerEvent(npcID, foo, "onTickEndNPC")
end

local fooData = {}

fooData.config = npcManager.setNpcSettings({
	id = npcID, 
	gfxoffsetx = 7,
	gfxwidth = 46, 
	gfxheight = 46, 
	width = 32, 
	height = 46, 
	frames = 4,
	framespeed = 8, 
	framestyle = 2,
	score = 2,
	blocknpc = 0,
	nogravity = 1,
	--lua only
	blowframes = 2
})

npcManager.registerHarmTypes(npcID, 	
{HARM_TYPE_JUMP, HARM_TYPE_FROMBELOW, HARM_TYPE_PROJECTILE_USED, HARM_TYPE_NPC, HARM_TYPE_HELD, HARM_TYPE_TAIL, HARM_TYPE_SPINJUMP, HARM_TYPE_SWORD, HARM_TYPE_LAVA}, 
{[HARM_TYPE_JUMP]=195,
[HARM_TYPE_FROMBELOW]=195,
[HARM_TYPE_PROJECTILE_USED]=195,
[HARM_TYPE_NPC]=195,
[HARM_TYPE_HELD]=195,
[HARM_TYPE_TAIL]=195,
[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5}})

--*********************************************
--                                            *
--              	  FOO      	          	  *
--                                            *
--*********************************************

foo.StateTimers = {128, 230};

local windEffect = Misc.multiResolveFile("p_foo_windy.ini")

foo.SFX_die = Misc.multiResolveFile("foo-die.ogg", "sound\\extended\\foo-die.ogg")
foo.SFX_inhale = Misc.multiResolveFile("foo-inhale.ogg", "sound\\extended\\foo-inhale.ogg")
foo.SFX_exhale = Misc.multiResolveFile("foo-exhale.ogg", "sound\\extended\\foo-exhale.ogg")

local particleList = {}
local repulseList = {}

local anyFoos = false

foo.cloudSpeed = nil
foo.cloudSpread = nil

local function falloff(t)
	return 1
end

function foo:onTickNPC()
	if Defines.levelFreeze or self:mem(0x138, FIELD_WORD) > 0 then return end
	
	local data = self.data._basegame

	if data.__init == nil then
		self.ai1 = 0 --state (idling or blowing)
		self.ai2 = foo.StateTimers[1] --change state timer
		data.__init = true
		data.frame = 0
		
	elseif not self:mem(0x124,FIELD_BOOL) then
		data.__init = nil
	end
	
	if self:mem(0x12A, FIELD_WORD) >= 0 then
		anyFoos = true
	end
	
	if self.ai2 > 0 then
		self.ai2 = self.ai2 - 1
		
		if self.ai1 == 0 and self.ai2 == 40 then
			data.sound_inhale = SFX.play(foo.SFX_inhale)
		end
		
		if self.ai2 == 0 then
			self.ai1 = 1-self.ai1
			self.ai2 = foo.StateTimers[self.ai1 + 1]
			
			if self.ai1 == 1 then
				data.sound_exhale = SFX.play(foo.SFX_exhale)
			end
		end
		
	end
	if self.ai1 == 1 then
		if self:mem(0x12A, FIELD_WORD) <= 0 then
			data.initialized = false
		return
		end
	
		if not data.initialized then
			data.initialized = true
		end
	
		if self.ai3 <= 294 then
			self.ai3 = self.ai3 + 8 -- wind length
		end

		local dir = self.direction
		if dir == -1 then
			self.ai4 = -self.ai3 -- self.ai4 is wind offset from NPC's offset
		elseif dir == 1 then
			self.ai4 = self.width
		end
		local windOffsetX = self.x + self.ai4
		local centerNPC = self.y + self.height * 0.5
		for k,p in ipairs(Player.getIntersecting(windOffsetX, centerNPC - 23, windOffsetX + self.ai3, centerNPC + 23)) do
			p.speedX = p.speedX + dir
			if math.abs(p.speedX) > 10 then
				p.speedX = 10 * dir
			end
		end
		if data.wind == nil then
			data.wind = particles.Emitter(self.x + self.width * 0.5 + 8 * dir, self.y + self.height * 0.5, windEffect)
			
			table.insert(particleList, {npc = self, effect = data.wind})
			
			data.wind:Attach(self, false, true, -1)
			
			if foo.cloudSpeed ~= nil then
			end
			
			if foo.cloudSpread ~= nil then
			end
			
		end
		data.wind.enabled = true
		
	elseif data.wind then
		self.ai3 = 0
		data.wind.enabled = false
	end
end
		
		
function foo.onTick()
	
	anyFoos = false
	
	local i = 1
	while i <= #repulseList do
	
		if repulseList[i][2] > 0 then
			repulseList[i][2] = repulseList[i][2]-1
			i = i+1
		else
		
			for _,v in ipairs(particleList) do
				repulseList[i][1]:removeEmitter(v.effect)
			end
			
			table.remove(repulseList,i)
			
		end
		
	end
end

function foo.onDraw()
	local i = 1
	while i <= #particleList do
	
		particleList[i].effect:Draw(0)
		
		if not particleList[i].npc.isValid or particleList[i].npc.id ~= fooData.config.id then
			particleList[i].effect.enabled = false;
			if particleList[i].effect:Count() == 0 then
				particleList[i].effect:Destroy()
				table.remove(particleList,i)
			else
				i = i+1
			end
		else
			i = i+1
		end
		
	end
end

function foo:onTickEndNPC()
	local data = self.data._basegame
	
	local fs = NPC.config[npcID].frames
	local bfs = NPC.config[npcID].blowframes
	local idle = math.max(0, fs - bfs)
	local blow = math.clamp(bfs, 0, fs)

	if data.frame == nil then data.frame = 0 end
	
	if self.animationTimer == 0 then
		data.frame = data.frame + 1
	end
	
	local animframes = idle
	local gap = blow
	local offset = 0
	if self.ai1 > 0 then
		animframes = blow
		gap = 0
		offset = idle
	end
	
	data.frame = data.frame % animframes
	
	self.animationFrame = utils.getFrameByFramestyle(self, 
	{
		frame = data.frame,
		frames = animframes,
		gap = gap,
		offset = offset
	})
end

function foo.onNPCKill(e,v,r)
	if v.id == npcID and r ~= 9 then
		local data = v.data._basegame
		
		if data.sound_inhale and data.sound_inhale.isValid and data.sound_inhale:isPlaying() then
			data.sound_inhale:Stop()
		end
		
		if data.sound_exhale and data.sound_inhale.isValid and data.sound_exhale:isPlaying() then
			data.sound_exhale:Stop();
		end
		SFX.play(foo.SFX_die)
	end
end

return foo