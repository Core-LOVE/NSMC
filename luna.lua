require 'libs/init'

function onStart()
	mem(0x00B2C5AC,FIELD_FLOAT, 99)
	
	if player.powerup == 1 then
		player.powerup = 2
	end
end