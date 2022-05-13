local cutscene = {}

_G.CUTSCENE_NONE = 0
_G.CUTSCENE_RUNS = 1
_G.CUTSCENE_STOPS = 2

cutscene.state = CUTSCENE_NONE

local border

do
	local y = 0 

	border = function(state)
		if state == CUTSCENE_RUNS then
			if y < 36 then
				y = y + 2
			end
		else
			if y > 0 then
				y = y - 4
			end	
		end
		
		Graphics.drawBox{
			x = 0,
			y = 0,
			width = 800,
			height = y,
			
			color = Color.black,
			priority = 4,
		}
		
		Graphics.drawBox{
			x = 0,
			y = 600,
			width = 800,
			height = -y,
			
			color = Color.black,
			priority = 4,
		}
		
		if y <= 0 and state == CUTSCENE_STOPS then
			y = 0
			return true
		end
	end
end

local function ifnil(args, name)
	if args[name] == nil then
		args[name] = true
	end
end

function cutscene.run(args)
	if cutscene.state ~= CUTSCENE_NONE then return end
	
	for k,v in pairs(args) do
		cutscene[k] = v
	end
	
	if args.update then
		Routine.run(args.update, cutscene)
	end
	
	local borders = args.borders

	if borders then
		if type(borders) == 'function' then
			cutscene.border = borders
		else
			cutscene.border = border
		end
	end
	
	ifnil(args, 'noHud')
	
	Graphics.activateHud(not args.noHud)
	
 	cutscene.state = CUTSCENE_RUNS
end

function cutscene.stop()
	cutscene.lockMovement = nil
	cutscene.update = nil
	
	cutscene.state = CUTSCENE_STOPS
	Graphics.activateHud(true)
end

function cutscene.runFile(name)
	local file = loadfile(Misc.resolveFile(name))

	cutscene.run(file() or {})
end

function cutscene.onInputUpdate()
	if not cutscene.lockMovement then return end
	
	for name in pairs(player.keys) do
		player.keys[name] = false
	end
end

function cutscene.onCameraDraw()
	if not cutscene.border then return end
	
	local clear = cutscene.border(cutscene.state)
	if clear then
		cutscene.state = CUTSCENE_NONE
		cutscene.border = nil
	end
end

function cutscene.onInitAPI()
	registerEvent(cutscene, 'onInputUpdate')
	registerEvent(cutscene, 'onCameraDraw')
end

return cutscene