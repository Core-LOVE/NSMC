local ib = {}
local hud = require 'libs/hud'

function ib.onInputUpdate()
	if player.keys.dropItem == KEYS_PRESSED and player.reservePowerup > 0 then
		local x = ((400 - 26) + (56 - 32) / 2)
		local y = (hud.getOffset() + (56 - 32) / 2)
		
		SFX.play(11)
		
		local dropNpc = NPC.spawn(player.reservePowerup, x + camera.x, y + camera.y)
		dropNpc:mem(0x138, FIELD_WORD, 2)
		
		player.reservePowerup = 0
		player.keys.dropItem = false
	end
end

registerEvent(ib, 'onInputUpdate')
return ib