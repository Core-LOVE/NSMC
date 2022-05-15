local c = {}

local shader = Shader()
shader:compileFromFile(nil, "rgb.frag")

c.priority = 6

local pi = math.pi
local cb = Graphics.CaptureBuffer(800, 600)
function c.onInitAPI()
    registerEvent(c, "onTick")
end

function c.onTick()
    cb:captureAt(c.priority)

    local sec = Section(player.section)

    if sec.backgroundID == 11 then
    Graphics.drawScreen{
        texture = cb,
        priority = c.priority,
        shader = shader,

            uniforms = {
                resolution = vector(800,600);
                delta = vector(math.sin(math.random()*pi*2)*math.random()*3,math.sin(math.random()*pi*2)*math.random()*3);
                lenght = math.sin(math.random()*pi*2)*math.random()*10;
                time = lunatime.tick();
                intensity = math.random()*math.abs(math.sin(lunatime.tick()/200))*0.01
        }
    }
end
end

return c