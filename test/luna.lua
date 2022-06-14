local function isColliding(a,b)
   if ((b.x >= a.x + a.width) or
	   (b.x + b.width <= a.x) or
	   (b.y >= a.y + a.height) or
	   (b.y + b.height <= a.y)) then
		  return false 
   else return true
	   end
end

local chat = {}

function onTick()
	for k,v in NPC.iterate() do
		if not v.isHidden and v.msg ~= "" and v.friendly and v.despawnTimer >= 0 then
			local tempLocation = {
				x = v.x,
				y = v.y,
				width = v.width,
				height = v.height,
			}
			
			tempLocation.x = (tempLocation.x - 25)
			tempLocation.y = (tempLocation.y - 25)
			tempLocation.width = (tempLocation.width + 50)		
			tempLocation.height = (tempLocation.height + 50)
			
			chat[v] = chat[v] or 0
			
			if chat[v] > 1 then
				chat[v] = chat[v] - 1
			end
			
			if isColliding(tempLocation, player) then
				if chat[v] <= 1 then
					chat[v] = 3
				else
					chat[v] = 4
				end
				
				if chat[v] == 3 then
					SFX.play(26)
				end
			end
			
			if chat[v] <= 1 then
				chat[v] = 0
			end
		end
	end
end
