local textplus = require 'textplus'

return {
    -- textColor = Color.fromHexRGB(0x303030),
    -- speakerNameColor = Color.fromHexRGB(0x303030),
    typewriterEnabled = true,
    typewriterDelayNormal = 2, -- The usual delay between each character.
    typewriterDelayLong = 8,  -- The extended delay after any of the special delaying characters, listed below.
    typewriterSoundDelay = 4,  -- How long there must between each sound.
	
    borderSize = 16,

    openStartScaleX = 0,
    openStartScaleY = 0,
    openStartOpacity = 0.5,

    speakerNameOnTop = true,
    speakerNameOffsetX = 24,
    speakerNameOffsetY = 4,
    speakerNamePivot = 0,
    speakerNameXScale = 2,
    speakerNameYScale = 2,

    forcedPosEnabled = true,
    forcedPosX = 400,
    forcedPosY = 128,
    forcedPosHorizontalPivot = 0.5,
    forcedPosVerticalPivot = 0,
    minBoxMainHeight = 128,
    useMaxWidthAsBoxWidth = true,
	
    openSpeed = 0.1,
    pageScrollSpeed = 0.075,
	
	font = textplus.loadFont('graphics/font.ini'),
}