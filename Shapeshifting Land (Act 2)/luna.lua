--------------------------------------------------
-- Level code
-- Created 21:36 2022-4-1
--------------------------------------------------
require("rain")
require("3DClouds")
require("Chamber")
local sh_layerblend = require("sh_layerblend")

local blastOff = Graphics.loadImageResolved('MarioFall.png')
local count = 0
local scene = 0
local minutes = 0

local soundfx = 0

local textplus = require("textplus")
local font =  textplus.loadFont("textplus/font/2.ini")

sh_layerblend.addLayer(-93,sh_layerblend.BLEND.DODGE)
sh_layerblend.addLayer(4,sh_layerblend.BLEND.DODGE)
-- Run code on level start

-- Run code every frame (~1/65 second)
-- (code will be executed before game logic will be processed)

function onDraw()

    local sec = Section(player.section)

    if scene == 1 then --Blast off
        
        if count >= 128 then
			Graphics.drawBox{
				texture = blastOff,
				
				x = 600 - (count-128),
				y = -32 + (count-128)*2,
				width = 32 - (count-128)/4,
				height = 32 - (count-128)/4,	
				
				rotation = lunatime.tick(),
				priority = -91,
				sceneCoords = false,
			}
		end

    elseif scene == 2 then --Explosion #1
    
        if count <= 192 then
        Graphics.drawCircle{
            x = 400,
            y = 440,
            radius = count*32,
            color = Color.white,
            priority = 5
        }
        end

        if count > 192 and count <= 384 then
            Graphics.drawBox{
                x = 0,
                y = 0,
                width = 800,
                height = 600,
                color = vector((384-(count-192)*2)/(-384),(384-(count-192)*2)/(-384),(384-(count-192)*2)/(-384),-1),
                priority = 4
            }
        end

    elseif scene >= 3 then --Timer

        if sec.backgroundID == 11 then
        local deathCount = Timer.getValue()
    	deathCount = string.format("%02d", deathCount)
        
        if deathCount >= 60 then
            minutes = 1
        else
            minutes = 0
            if deathCount % 60 < 1 then
                if soundfx == 0 then
                    SFX.play("mus_explosion.wav")
                    soundfx = 1
                end
				
                Graphics.drawBox{
                    x = 0,
                    y = 0,
                    width = 800,
                    height = 600,
                    color = Color.white,
                    priority = 8
                }
            end
        end

        if deathCount % 60 >= 0 and minutes >= 0 then
        if deathCount % 60 >= 10 then
        textplus.print{
            text = "0" .. minutes .. ":" .. deathCount % 60,
            
            x = 320,
            y = 104,
            
            xscale = 4,
            yscale = 4,

            font = font,
            priority = 5
        }
    else

        textplus.print{
            text = "0" .. minutes .. ":0" .. deathCount % 60,
            
            x = 320,
            y = 104,
            
            xscale = 4,
            yscale = 4,

            font = font,
            priority = 5
        }
    end
end

elseif scene == 5 then

    count = count + 1

    if count >= 0 and count < 128 then
        Graphics.drawBox{
            x = 0,
            y = 0,
            width = 800,
            height = 600,
            color = Color.white,
            priority = 4
        }
    elseif count >= 128 and count < 256 then
		Graphics.drawBox{
			x = 0,
			y = 0,
			width = 800,
			height = 600,
			color = vector((256-(count-128)*2)/(-256),(256-(count-128)*2)/(-256),(256-(count-128)*2)/(-256),-1),
			priority = 4
		}
	end

end
end

end


function onTick()

    if scene == 1 then

        count = count + 1
        if count >= 256 then
            SFX.play(14)
            Effect.spawn(80, camera.x + 600 - (count-128), camera.y - 32 + (count-128)*2)
            count = -64
        end
    
        if count == -32 then
            triggerEvent("BlastOffEnd")
            count = 0
            scene = 0
        end

    elseif scene == 2 then

        count = count + 1
        if count == 128 then
            require("fire")
            require("rgb")
        end

        if count == 440 then
            Graphics.activateHud(true)
            count = 0
            scene = 3
            Timer.activate(90)
            Timer.hurryTime = 90
            triggerEvent("RUN!")
        end

        if count == 96 then
            Section(2).musicID = 24
            Section(2).musicPath = "Shapeshifting Land (Act 2)/22 Escape.spc"
        end

    elseif scene >= 3 and scene < 5 then

        if player.x >= -152224 and scene == 3 then
            count = -160
            scene = 4
        end

        if scene == 4 and count < 0 then
            count = count + 1

            if count == -112 then
                local pipe1 = Layer.get("pipe1")

                pipe1:hide(true)
                Animation.spawn(757, -152128 + 104, -160384 + 48)
                Animation.spawn(73, -152128 - 16, -160384)
                Animation.spawn(73, -152128 - 16, -160384 + 32)
                Animation.spawn(73, -151968 + 48, -160384)
                Animation.spawn(73, -151968 + 48, -160384 + 32)
                Misc.doPOW()
            elseif count == -80 then
                local pipe2 = Layer.get("pipe2")

                pipe2:hide(true)
                Animation.spawn(757, -151744 + 104, -160384 + 48)
                Animation.spawn(73, -151744 - 16, -160384)
                Animation.spawn(73, -151744 - 16, -160384 + 32)
                Animation.spawn(73, -151584 + 16, -160384)
                Animation.spawn(73, -151584 + 16, -160384 + 32)
                Misc.doPOW()
            elseif count == -48 then
                local pipe3 = Layer.get("pipe3")

                pipe3:hide(true)
                Animation.spawn(757, -151360 + 104, -160384 + 48)
                Animation.spawn(73, -151360 - 16, -160384)
                Animation.spawn(73, -151360 - 16, -160384 + 32)
                Animation.spawn(73, -151200 + 16, -160384)
                Animation.spawn(73, -151200 + 16, -160384 + 32)
                Misc.doPOW()
            end

        end
    elseif scene == 7 then
        Misc.doPOW()
        Graphics.activateHud(true)
        scene = 8
    end
    --Your code here
end

-- Run code when internal event of the SMBX Engine has been triggered
-- eventName - name of triggered event
function onEvent(eventName)

    if eventName == "BlastOff" then
        scene = 1
    elseif eventName == "Explosion" then
        SFX.play("mus_explosion.wav")
        scene = 2
        player.speedX = 0
        Graphics.activateHud(false)
        Section(2).musicID = 0
    elseif eventName == "[END]" then
        Graphics.activateHud(false)
        Timer.activate(0)
        count = 0
        scene = 5
        Section(2).musicID = 0
    elseif eventName == "[END-2]" then
        scene = 7
    end
    --Your code here
end

