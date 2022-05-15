local c = {}

local shader = Shader()
shader:compileFromFile(nil, "saturation.frag")
local count = 0
local countEnd = 0
local add = 0.5
local quake = 0

local cb = Graphics.CaptureBuffer(800, 600)
function c.onInitAPI()
    registerEvent(c, "onDraw")
    registerEvent(c, "onTick")
end

local darkness = require("darkness")

local field = darkness.Create{
    maxlights = 25,
    boundBlendLenght = 64,
    section = 3,
    enabled = true,
    priority = 1,
    ambient = Color.white,
    distanceField = true
}

local playerLight = darkness.Light(0,0,128,1,Color.white)

field:addLight(playerLight)

function c.onTick()

    local sec = Section(player.section)

    if sec.backgroundID == 12 then
        c.priority = -95
        field.ambient = vector(add-0.4,add-0.3,add-0.2,1)
        playerLight.color = vector(1-add,1.1-add,1.2-add,1)
    else
        c.priority = 0
    end

    count = count + 1
    if count == 1 then
    countEnd = 480 + math.random()*128
    end
    if count >= 16 then
    quake = quake - 0.1
    if quake <= 0 then
    quake = 0
    end
    end
    if count >= 64 then
    add = add - 0.005
    if add <= .5 then
    add = .5
    end
end
    if count >= countEnd then
    SFX.play(43)
    add = 1
    quake = 1
    count = 0
    end

end

function c.onDraw()
    Graphics.drawBox{
		x = 0,
		y = 0,
        width = 800,
        height = 600,
        priority = -93,
        color = vector((add-.5),(add-.5),(add-.5),1),
        opacity = 1
    }

if Misc.isPaused() == true then
quake = 0
end

    cb:captureAt(c.priority)

    Graphics.drawScreen{
        texture = cb,
        priority = c.priority,
        shader = shader,

            uniforms = {
                iAdd = add;
                iQuake = quake;
                iRandom = math.random();
                adjustment = 1;
                intensity = 1
        }
    }
end

    playerLight:Attach(player, true)

return c