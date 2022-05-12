local CBGO = {}

local function isColliding(a,b)
	if ((b.x >= a.x + a.width) or
	   (b.x + b.width <= a.x) or
	   (b.y >= a.y + a.height) or
	   (b.y + b.height <= a.y)) then
		  return false 
	else return true
	   end
end

function CBGO.getIntersecting(x, y, w, h)
	local ret = {}
	
	local zone = {
		x = x,
		y = y,
		width = w,
		height = h,
	}
	
	for k,v in ipairs(CBGO) do
		if isColliding(zone, v) then
			ret[#ret + 1] = v
		end
	end
	
	return ret
end

function CBGO.spawn(id, x, y)
	local v = {
		img = Graphics.sprites.background[id].img,
		
		x = x,
		y = y,
	}
	
	v.width = BGO.config[id].width
	v.height = BGO.config[id].height
	
	CBGO[#CBGO + 1] = v
end

function CBGO.onCameraDraw(idx)
	local c = Camera(idx)
	
	for k,v in ipairs(CBGO) do
		if isColliding(v, c) then
			Graphics.drawImageToSceneWP(v.img, v.x, v.y, -85)
		end
	end
end

function CBGO.onInitAPI()
	registerEvent(CBGO, 'onStart')
	registerEvent(CBGO, 'onCameraDraw')
end

return CBGO