GarryClicker.Ascensions = {
	Gabens2Earn = 0,
	GabensEarned = 0,
	TotalAscensions = 0,
	OnAscend = function()
		GarryClicker.Ascensions.TotalAscensions = GarryClicker.Ascensions.TotalAscensions + 1
		GarryClicker.Ascensions.GabensEarned = GarryClicker.Ascensions.GabensEarned + GarryClicker.Ascensions.Gabens2Earn
		
		local GabenGain = GarryClicker.Ascensions.GabensEarned * 1.05
		local Disadvantage = GarryClicker.Ascensions.TotalAscensions / 2 + 1
		
		GarryClicker.Stats = {
			Garries = 0,
			GarriesPerClick = 1,
			GarriesPerSecond = 0,
			TotalClicks = 0,
			Interval = 1000
		}
		GarryClicker.People = {
			{Name = "Kleiner", Amount = 0, Price = 15 * Disadvantage, Payout = 1 + GabenGain},
			{Name = "Freeman", Amount = 0, Price = 100 * Disadvantage, Payout = 10 + GabenGain},
			{Name = "Alyx", Amount = 0, Price = 1100 * Disadvantage, Payout = 80 + GabenGain},
			{Name = "Chell", Amount = 0, Price = 1.2e4 * Disadvantage, Payout = 470 + GabenGain},
			{Name = "Barney", Amount = 0, Price = 1.3e5 * Disadvantage, Payout = 2600 + GabenGain},
			{Name = "Breen", Amount = 0, Price = 1.4e6 * Disadvantage, Payout = 14000 + GabenGain},
			{Name = "Eli", Amount = 0, Price = 2.0e7 * Disadvantage, Payout = 78000 + GabenGain},
			{Name = "GMan", Amount = 0, Price = 3.3e8 * Disadvantage, Payout = 440000 + GabenGain},
			{Name = "Police", Amount = 0, Price = 5.1e9 * Disadvantage, Payout = 2600000 + GabenGain},
			{Name = "Combine", Amount = 0, Price = 7.5e10 * Disadvantage, Payout = 16000000 + GabenGain},
			{Name = "Vortigaunt", Amount = 0, Price = 1.0e11 * Disadvantage, Payout = 100000000 + GabenGain},
			{Name = "Advisor", Amount = 0, Price = 1.0e12 * Disadvantage, Payout = 1000000000 + GabenGain}
		}
		GarryClicker.Speed = {
			Price = 5.0e4 * Disadvantage,
			OnBuy = function()
				GarryClicker.Speed.Price = GarryClicker.Speed.Price * 1.3
				GarryClicker.Stats.Interval = GarryClicker.Stats.Interval - 10
				GarryClicker.AddGPS()
			end,
			Max = false
		}
		GarryClicker.Click = {
			Price = 20000 * Disadvantage,
			OnBuy = function()
				GarryClicker.Click.Price = GarryClicker.Click.Price * 3
				GarryClicker.Stats.GarriesPerClick = GarryClicker.Stats.GarriesPerClick * 2
			end,
		}
		GarryClicker.Upgrades = {
			{Name = "Nothing", Price = 0, OnBuy = print, Bought = true, Description = "Click on a button\nto buy something!"}
		}
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
					Price = 1e6 ^ (i/4.75) * Disadvantage,
					Bought = false,
					Description = Description,
					OnBuy = GarryClicker.RandomOutcomes[Chance]
				})
			end
		end
		
		GarryClicker.Notify("You have ascended into ascension "..GarryClicker.Ascensions.TotalAscensions.." with "..GarryClicker.HandleMoney(GarryClicker.Ascensions.Gabens2Earn).." Gabens!")
		GarryClicker.Notify("Your total Gabens: "..GarryClicker.HandleMoney(GarryClicker.Ascensions.GabensEarned))
		surface.PlaySound("garrysmod/save_load1.wav")
	end
}
GarryClicker.AscensionsHook = hook.Add("Think", "AscensionHook", function()
	GarryClicker.Ascensions.Gabens = math.Round(GarryClicker.Stats.Garries/5e15)
end)