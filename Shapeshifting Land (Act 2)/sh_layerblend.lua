local c = {}

local shaders = {
    Shader(),
    Shader(),
    Shader(),
    Shader(),
    Shader(),
    Shader(),
    Shader(),
    Shader(),
    Shader(),
    Shader(),
}
shaders[1]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_add.frag"))
shaders[2]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_mult.frag"))
shaders[3]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_screen.frag"))
shaders[4]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_dodge.frag"))
shaders[5]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_burn.frag"))
shaders[6]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_diff.frag"))
shaders[7]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_exclude.frag"))
shaders[8]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_subtract.frag"))
shaders[9]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_divide.frag"))
shaders[10]:compileFromFile(nil, Misc.resolveFile("shaders/sh_blend_overlay.frag"))

c.BLEND = {
    ADDITIVE = 1,
    MULTIPLY = 2,
    SCREEN = 3,
    DODGE = 4,
    BURN = 5,
    DIFFERENCE = 6,
    EXCLUSION = 7,
    SUBTRACT = 8,
    DIVIDE = 9,
    OVERLAY = 10,
}

local layers = {}

--Add layers with this. Specify 1 or 2 priorities, a blend mode and the opacity of the layer
function c.addLayer(priority, blend, opacity)
    local low = priority
    local hi = low
    if type(priority) == "table" then
        low = priority[1]
        hi = priority[2]
    end
    if low == nil then
        error("Must specify priority. Matching overloads: (priority) (priority, blend mode) (priority, blend mode, opacity), (low priority, high priority, blend mode, opacity)")
    end

    if low > hi then
        hi, low = low, hi
    end

    low = low - 0.00001

    local layer = {
        low = low,
        high = hi,
        blend = blend or blend.ADDITIVE,
        opacity = opacity or 1
    }

    local inserted = false

    for k,v in ipairs(layers) do
        if v.low < low then
            table.insert(layers, k, layer)
            inserted = true
            break
        end
    end

    if not inserted then
        table.insert(layers, layer)
    end

    return layer
end

function c.addNPCLayers(blend, opacity)
    c.addLayer(-75, blend, opacity) --Background NPCs like vines
    c.addLayer(-55, blend, opacity) --Special NPCs like coins and herbs
    c.addLayer(-50, blend, opacity) --Contained-type NPCs like ice blocks
    c.addLayer(-45, blend, opacity) --All regular NPCs
    c.addLayer(-30, blend, opacity) --Held NPCs
    c.addLayer(-15, blend, opacity) --Foreground NPCs
end

function c.addTerrainLayers(blend, opacity)
    c.addLayer(-95, blend, opacity) --BGBGOs
    c.addLayer(-90, blend, opacity) --Sizeables
    c.addLayer(-85, blend, opacity) --BGOs
    c.addLayer(-80, blend, opacity) --Other BGOs
    c.addLayer(-65, blend, opacity) --Blocks
    c.addLayer(-63, blend, opacity) --Lineguide
    c.addLayer(-20, blend, opacity) --FGOs
    c.addLayer(-10, blend, opacity) --Lava
end

function c.addPlayerLayers(blend, opacity)
    c.addLayer(-70, blend, opacity) --Warping Player
    c.addLayer(-35, blend, opacity) --Clown Car
    c.addLayer(-25, blend, opacity) --Player
end

function c.addEffectLayers(blend, opacity)
    c.addLayer(-60, blend, opacity) --Effects
    c.addLayer(-40, blend, opacity) --Chat Icon
    c.addLayer(-5, blend, opacity) --Foreground Effects
end

local cb = Graphics.CaptureBuffer(800, 600)
local bg = Graphics.CaptureBuffer(800, 600)

function c.onInitAPI()
    registerEvent(c, "onCameraDraw")
end

function c.onCameraDraw()
    for k,v in ipairs(layers) do
        bg:captureAt(v.low)
        cb:captureAt(v.high)

        Graphics.drawScreen{
            texture = bg,
            priority = v.high
        }

        Graphics.drawScreen{
            texture = cb,
            priority = v.high,
            shader = shaders[v.blend],
            uniforms = {
                iBackdrop = bg,
                iOpacity = v.opacity
            }
        }
    end
end

return c