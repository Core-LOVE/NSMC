local oldY
local sectionId = 1
local particles = API.load("particles");

local effect = particles.Emitter(0, 0, Misc.resolveFile("particles/p_rain.ini"));
effect:AttachToCamera(Camera.get()[1]);

function onCameraUpdate(idx)
    if (player.section == sectionId or player.section == 2) then
    effect:Draw(-98.36);
    end
    if not (player.section == sectionId or player.section == 2) then return end

    local c = Camera(idx)

    oldY = oldY or c.y

    if oldY < c.y then
        c.y = oldY
    end

    oldY = c.y

    local p = Player(idx)

    if player.forcedState ~= 0 or player.forcedTimer > 0 then return end

    if p then
        if (p.y > c.y + c.height + p.height + 16) and p.deathTimer <= 0 then
            p:kill()
        end
    end
end
