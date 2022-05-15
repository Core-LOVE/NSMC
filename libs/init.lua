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

-- fixes
require 'fix/itemboxFix'

-- global
_G.littleDialogue = require 'littleDialogue'
littleDialogue.loadTranslations()
littleDialogue.language = 'rus'

-- clases
_G.CustomBGO = require 'bgo'