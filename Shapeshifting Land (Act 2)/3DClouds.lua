local c = {}

local shader = Shader()
shader:compileFromFile(nil, "3DClouds.frag")

c.priority = -100

local cb = Graphics.CaptureBuffer(800, 600)
local bc = Graphics.CaptureBuffer(800, 600)
function c.onInitAPI()
    registerEvent(c, "onCameraDraw")
end

function c.onCameraDraw()
    cb:captureAt(c.priority)
    bc:captureAt(c.priority-1)

    local sec = Section(player.section)

    if sec.backgroundID == 13 then

    Graphics.drawScreen{
        texture = bc,
        priority = c.priority,
    }

    Graphics.drawScreen{
        texture = cb,
        priority = c.priority,
        shader = shader,
            uniforms = {
                iResolution = vector(800,(camera.y+200000-sec.idx*20000)*(-1),-1);
                iMouse = vector(400,600-16,1,1);
        }
    }
end
end

return c