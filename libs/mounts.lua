local mounts = {}

local plrs = {}

function mounts.getData(p)
	local plr = plrs[p]
	
	if plr then
		plr.data[p] = plr.data[p] or {}
		
		return plr.data[p]
	end
end

function mounts.registerMount(name, args)
	local img = Graphics.loadImageResolved('graphics/' .. name .. '.png')
	
	local args = table.join({texture = img, data = {}}, args or {})
	
	mounts[name] = args
end

function mounts.setMount(p, name)
	if p.mount ~= 0 then return end
	
	p.mount = 4
	
	if mounts[name].sfx then
		SFX.play(mounts[name].sfx)
	end
	
	plrs[p] = mounts[name]
	return true
end

local function clear(v)
	local plr = plrs[v]
	
	if not plr then	return end
	
	plr.data[v] = nil
	v.mount = 0
	plrs[v] = nil
	return true
end

function mounts.clear(p)
	return clear(p)
end

local function define(name)
	mounts[name] = function()
		for k,p in ipairs(Player.get()) do
			local plr = plrs[p]
			if plr then
				local ev = plr[name]
				
				if ev then
					ev(p, plr)
				end
			end
		end
	end
	
	registerEvent(mounts, name)
end

function mounts.onPlayerHarm(e, v)
	local plr = plrs[v]
	
	if not plr then return end
	
	local ev = plr['onPlayerHarm']
	
	if ev then
		ev(v, plr)
	end
	
	local done = mounts.clear(v)
	
	if done then
		v.BlinkTimer = 100
		e.cancelled = true
	end
end

define('onInputUpdate')
define('onDraw')
define('onTick')
define('onTickEnd')

registerEvent(mounts, 'onPlayerHarm')

return mounts