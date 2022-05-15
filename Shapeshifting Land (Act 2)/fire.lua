local c = {}

local shader = Shader()
shader:compileFromFile(nil, "fire.frag")

c.priority = 1

local gradient = Graphics.loadImageResolved('Gradient.png')
local cb = Graphics.CaptureBuffer(800, 600)
function c.onInitAPI()
    registerEvent(c, "onCameraDraw")
end

function c.onCameraDraw()
    cb:captureAt(c.priority)
    local sec = Section(player.section)

    if sec.backgroundID == 11 then

        if lunatime.tick() % 16 == 0 then

            Animation.spawn(756, camera.x + math.random()*800, camera.y)
            if math.random() <= 0.25 then
                Animation.spawn(754, camera.x + math.random()*800, camera.y)
            elseif math.random() > 0.25 and math.random() <= 0.5 then
                Animation.spawn(755, camera.x + math.random()*800, camera.y)
            end
        end

        Sprite.draw{
            texture = gradient,
            x = 400,
            y = 600,
    
            align = Sprite.align.BOTTOM,
    
            width = 800,
            height = 128 + math.abs(math.sin(lunatime.tick()/20)*64),
            color = vector(1,0.25,0.25,0.875),
            priority = -3
        }
    
        Sprite.draw{
            texture = gradient,
            x = 400,
            y = 600,
    
            align = Sprite.align.BOTTOM,
    
            width = 800,
            height = 128 + math.abs(math.sin(lunatime.tick()/20)*64),
            color = vector(1,0.25,0.25,0.875),
            priority = -91
        }

    Graphics.drawScreen{
        texture = cb,
        priority = c.priority,
        shader = shader
    }
end
end

return c