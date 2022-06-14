local scene = {}
scene.lockMovement = true
scene.borders = false

local actor = require 'cutscene/actor'
local cam

function scene.update(cutscene)
	cam = require("handycam")[1]
	
	local toad = actor('exampleActor')
	
	toad:target(cam, 0.5, {
		zoom = 1.5,
	})
	
	Defines.earthquake = 4
	toad:shake(1)
	
	toad:scale(vector(0, -0.5))
	
	Routine.wait(0.25)
	
	Defines.earthquake = 6
	toad:shake(2)
	
	Routine.wait(1)
	
	Defines.earthquake = 8
	
	cam:transition{
		time = 0.32, 
		zoom = 1,
		
		targets = {player},
	}
	
	toad:move(vector(-48, 0), 0.5, 'outElastic')
	
	toad:setAnimation{
		{1, 2},
		{1, 3},
		{1, 2},
		{1, 1},
		
		stop = true,
	}
	
	toad:jump()
	toad:shake(0)
	toad:scale(vector(0, 2), 0.32, 'outBounce')
	toad:rotate(-4, 0.32, 'outBounce')
	
	Routine.wait(0.22)
	
	toad:rotate(4, 0.32, 'inBounce')
	toad:scale(vector(0, -1.255), 0.32, 'inBounce')
	
	Routine.wait(0.75)

	cutscene.stop()
end

function scene.onStop(cutscene)
	local toad = actor('exampleActor')
	
	toad.rotation = 0
	toad.scaleX = 1
	toad.scaleY = 1
	toad.frame = {1, 1}
end

function scene.input()

end

return scene