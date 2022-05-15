local c = {}

local shader = Shader()
shader:compileFromFile(nil, "Chamber.frag")

c.priority = -92

local cb = Graphics.CaptureBuffer(800, 600)
function c.onInitAPI()
    registerEvent(c, "onCameraDraw")
end

function c.onCameraDraw()
    cb:captureAt(c.priority)
    local sec = Section(player.section)

    if sec.backgroundID == 12 then

        Graphics.drawScreen{
            texture = cb,
            priority = c.priority,
            shader = shader
        }
    else
end
end

return c