local scene = {}
scene.lockMovement = true
scene.borders = true

local actor = require 'cutscene/actor'

function scene.update(cutscene)
	local toad = actor('exampleActor')
	
	toad:jump()
	
	toad:setAnimation{
		{1, 2},
		{1, 3},
		{1, 2},
		{1, 1},
	}
	
	Routine.wait(2)
	toad:setAnimation{
		{1, 1}
	}
	
	cutscene.stop()
end

function scene.input()

end

return scene