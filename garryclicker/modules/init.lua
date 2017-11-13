do
	for i = 1, 96 do
		local Chance = math.random(1, 7)
		local Description = ""
		if Chance == 1 then Description = "Garries per second is\nmultiplied by 4."
		elseif Chance == 2 then Description = "People's payouts are\nmultiplied by 4."
		elseif Chance == 3 then Description = "People's prices are\ndivided by 4."
		elseif Chance == 4 then Description = "People's payouts are\nmultiplied by 10." 
		elseif Chance == 5 then Description = "People's prices are\ndivided by 10." 
		elseif Chance == 6 then Description = "People's payouts are\nmultiplied by 17." 
		else Description = "Per Click is\nmultiplied by 5." end
		
		table.insert(GarryClicker.Upgrades, {
			Name = table.Random(GarryClicker.UpgradeNames),
			Price = 1e6 ^ (i/4.75),
			Bought = false,
			Description = Description,
			OnBuy = GarryClicker.RandomOutcomes[Chance]
		})
	end
end

surface.CreateFont("VerdanaSize13", {
	font = "Verdana",
	extended = false,
	size = 13,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("VerdanaSize23", {
	font = "Verdana",
	extended = false,
	size = 23,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("GC_Coolvetica", {
	font = "coolvetica",
	size = ScreenScale(100)
})

GarryClicker.LoadStats()

concommand.Add("gc_gui", GarryClicker.CreateGUI)
concommand.Add("gc_shop", GarryClicker.CreateShop)
concommand.Add("gc_ascend", GarryClicker.CreateAscensionGUI)
concommand.Add("gc_color", GarryClicker.ColorMixer)
timer.Create("Autosave", 1, 0, GarryClicker.SaveStats)
surface.PlaySound("garrysmod/save_load1.wav")

GarryClicker.Notify("Welcome to Garry Clicker V2, "..LocalPlayer():GetName().."!")
GarryClicker.Notify("To start playing, use the console command 'gc_gui'!")
