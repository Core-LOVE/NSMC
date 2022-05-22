SaveData.coins = SaveData.coins or 0

local require = function(path)
	return _G.require('libs/' .. path)
end

require 'powerdown'
require 'coyotetime'
require 'warpTransition'
require 'extraNPCProperties'
require 'antizip'
require 'playerphysicspatch'

-- game
require 'hud'
require 'mounts'

-- fixes
require 'fix/itemboxFix'

-- global
_G.littleDialogue = require 'littleDialogue'
littleDialogue.loadTranslations()
littleDialogue.language = 'rus'
littleDialogue.registerStyle("smc", require("style"))
littleDialogue.defaultStyleName = "smc"

-- clases
_G.CustomBGO = require 'bgo'

Player.setCostume(CHARACTER_MARIO,"SMW-Mario")