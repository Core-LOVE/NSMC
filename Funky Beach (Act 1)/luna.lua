local bgos = {}

local function spawnBgos()
	for _,block in Block.iterate(3) do
		local cbgo = #CustomBGO.getIntersecting(block.x - 96, block.y - 96, block.width + 96, block.height + 96) == 0
		local bgo = #BGO.getIntersecting(block.x - 96, block.y - 96, block.x + block.width + 96, block.y + block.height + 96) == 0
		
		if cbgo and bgo and math.random() > 0.25 then
			if block.x % 96 == 0 then
				local id = 2
				local w, h = 64, 180
				
				if math.random() > 0.6 then
					id = 4
					w, h = 32, 60
				end
				
				local x = block.x - w
				local y = block.y - h
				
				if #Block.getIntersecting(x, y, x + w, y + h) <= 2 then
					CustomBGO.spawn(id, x, y + 2)
				end
			else
				local id = 1
				
				if math.random() > 0.5 then
					id = 3
				end
				
				CustomBGO.spawn(id, block.x, block.y - 32)
			end
		else
			if math.random() > 0.5 then
				block:transform(183)
			end
		end
	end
end

local function spawnInsides()
	for k,v in Block.iterate(26) do
		for x = 0, v.width, 32 do
			for y = 0, v.height, 32 do
				local x = v.x + x
				local y = v.y + y
				
				if #Block.getIntersecting(x - 1, y - 1, x + 33, y + 33) == 1 and math.random() > 0.75 then
					local id = 1
					
					if math.random() >= 0.5 then
						id = 87
					end
					
					Block.spawn(id, x, y)
				end
			end
		end
	end
end

function onStart()
	spawnInsides()
	spawnBgos()
end

function onTickEnd()
	local bg = player.sectionObj.background
	local layer = bg:get("water")
	
	layer.uniforms = {
		time = lunatime.tick() / 4,
		intensity = 2
	}
	
	local layer = bg:get("sun")
	
	layer.uniforms.time = lunatime.tick() / 4
	layer.uniforms.intensity = -1
end

local c = camera
local buffer = Graphics.CaptureBuffer(800, 600)
local waveShader = Shader()
waveShader:compileFromFile(nil, Misc.resolveFile("wave.frag"))
local priority = -66

function onDraw()
	buffer:captureAt(priority)
	
	for k,v in ipairs(Liquid.getIntersecting(c.x, c.y, c.x + c.width, c.y + c.height)) do
		Graphics.drawBox{
			texture = buffer,
			
			x = v.x,
			y = v.y,
			sourceX = v.x - c.x,
			sourceY = v.y - c.y,
			sourceWidth = v.width,
			sourceHeight = v.height,
			
			shader = waveShader,
			uniforms = {
				time = lunatime.tick(),
				intensity = 3,
			},
			
			color = Color.white .. 0.5,
			priority = -66,
			sceneCoords = true,
		}
	end
end