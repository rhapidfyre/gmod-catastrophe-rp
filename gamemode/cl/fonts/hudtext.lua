  
 local function CreateFonts()
surface.CreateFont("HUDText0", {
	font		= "TargetID",
	extended 	= false,
	size 		= 24,
	weight 		= 250,
	blursize 	= 0,
	scanlines 	= 1,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("HUDText0b", {
	font		= "TargetID",
	extended 	= false,
	size 		= 24,
	weight 		= 500,
	blursize 	= 3,
	scanlines 	= 1,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= true,
	outline 	= false,
}) 
surface.CreateFont("HUDText1", {
	font		= "CenterPrintText",
	extended 	= false,
	size 		= 72,
	weight 		= 500,
	blursize 	= 6,
	scanlines 	= 2,
	antialias 	= false,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= true,
	outline 	= true,
}) 
surface.CreateFont("HUDText2", {
	font		= "CenterPrintText",
	extended 	= false,
	size 		= 72,
	weight 		= 250,
	blursize 	= 0,
	scanlines 	= 1,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= true,
	outline 	= true,
})
surface.CreateFont("HUDText3", {
	font		= "Trebuchet18",
	extended 	= false,
	size 		= 48,
	weight 		= 1000,
	blursize 	= 1,
	scanlines 	= 2,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
})
surface.CreateFont("DeathText1", {
	font		= "TargetID",
	extended 	= false,
	size 		= 32,
	weight 		= 1000,
	blursize 	= 1,
	scanlines 	= 2,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
})
surface.CreateFont("DeathText2", {
	font		= "TargetID",
	extended 	= false,
	size 		= 16,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("FloatText1", {
	font		= "Trebuchet18",
	extended 	= false,
	size 		= 12,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("FloatText2", {
	font		= "ChatFont",
	extended 	= false,
	size 		= 12,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
})
surface.CreateFont("FloatText3", {
	font		= "halflife2",
	extended 	= false,
	size 		= 48,
	weight 		= 2000,
	blursize 	= 1,
	scanlines 	= 2,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("GameTitle", {
	font		= "ChatFont",
	extended 	= false,
	size 		= 64,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("GameHeader1", {
	font		= "ChatFont",
	extended 	= false,
	size 		= 16,
	weight 		= 500,
	blursize 	= 4,
	scanlines 	= 2,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= true,
	outline 	= false,
}) 
surface.CreateFont("GameHeader2", {
	font		= "ChatFont",
	extended 	= false,
	size 		= 16,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= true,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("MenuTitle", {
	font		= "ChatFont",
	extended 	= false,
	size 		= 48,
	weight 		= 500,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
}) 
surface.CreateFont("MenuHint", {
	font		= "Trebuchet18",
	extended 	= false,
	size 		= 24,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
})
surface.CreateFont("MenuDescription", {
	font		= "HudHintTextLarge",
	extended 	= false,
	size 		= 16,
	weight 		= 1000,
	blursize 	= 0,
	scanlines 	= 0,
	antialias 	= true,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= false,
	additive 	= false,
	outline 	= false,
})
end

CreateFonts()
hook.Add("InitPostEntity", "CatastropheFonts", CreateFonts)