SaveData.coins = SaveData.coins or 0

local require = function(path)
	return _G.require('libs/' .. path)
end

require 'powerdown'
require 'coyotetime'
require 'warpTransition'
require 'extraNPCProperties'
require 'antizip'

-- game
require 'hud'

-- clases
_G.CustomBGO = require 'bgo'