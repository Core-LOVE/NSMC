local fireworks = Shader()
fireworks:compileFromFile(nil, "fireworks.frag")

local screensize = vector(800, 600)
local fireworksImg = Graphics.loadImageResolved 'fireworks.png'

function onDraw()
	Graphics.drawBox{
		texture = fireworksImg,
		
		x = 0,
		y = 600,
		height = -1200,
		width = 1600,
		
		shader = fireworks,
		
		uniforms = {
			-- iResolution = screensize,
			iTime = lunatime.tick() * 0.01,
		},
		
		priority = -100.5,
	}
end