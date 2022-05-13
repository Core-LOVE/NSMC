local rain = {}
rain.up = false

local effects = {
	Particles.Emitter(0, 0, "rain.ini", 8),
	Particles.Emitter(0, 0, "rain.ini", 8),
}

for _, effect in ipairs(effects) do
	effect:AttachToCamera(camera)
end

do
	local effect = effects[2]
	
	effect.enabled = false
	effect:setParam("speedY", "-1000:-100")
	effect:setParam("yOffset", 550)
end

function rain.onDraw()
	for _, effect in ipairs(effects) do
		effect:Draw()
	end
end

function rain.flip()
	rain.up = not rain.up
	
	for _, effect in ipairs(effects) do
		effect.enabled = not effect.enabled
	end
end

function rain.onInitAPI()
	registerEvent(rain, 'onDraw')
end

return rain