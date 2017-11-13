GarryClicker.UpgradeNames = {
	"Crowbar","Colt Python Revolver","Bug Bait","Crossbow","Emplacement Gun","Hopper Mine",
	"MK3A2 Grenade","MP7","AR2","Ravenholm Traps","RPG","Sentry Gun",
	"SPAS-12","USP Match","Physcannon","Tau Cannon","Jalopy","Combine's Balls",
	"Jeep","APC","Stun Baton","SLAM","Medkit"
}
GarryClicker.RandomOutcomes = {
	function() GarryClicker.Stats.GarriesPerSecond = GarryClicker.Stats.GarriesPerSecond * 4 end,
	function() for i,v in pairs(GarryClicker.People) do v.Payout = v.Payout * 4	end end,
	function() for i,v in pairs(GarryClicker.People) do v.Price = v.Price / 4 end end,
	function() for i,v in pairs(GarryClicker.People) do v.Payout = v.Payout * 10 end end,
	function() for i,v in pairs(GarryClicker.People) do v.Price = v.Price / 10 end end,
	function() for i,v in pairs(GarryClicker.People) do v.Payout = v.Payout * 17 end end,
	function() GarryClicker.Stats.GarriesPerClick = GarryClicker.Stats.GarriesPerClick * 5 end,
}
GarryClicker.Upgrades = {
	{Name = "Nothing", Price = 0, OnBuy = print, Bought = true, Description = "Click on a button\nto buy something!"}
}
GarryClicker.Speed = {
	Price = 5.0e4,
	OnBuy = function()
		GarryClicker.Speed.Price = GarryClicker.Speed.Price * 1.3
		GarryClicker.Stats.Interval = GarryClicker.Stats.Interval - 10
		GarryClicker.AddGPS()
	end,
	Max = false
}
GarryClicker.Click = {
	Price = 20000,
	OnBuy = function()
		GarryClicker.Click.Price = GarryClicker.Click.Price * 3
		GarryClicker.Stats.GarriesPerClick = GarryClicker.Stats.GarriesPerClick * 2
	end,
}
GarryClicker.AddGPS = function()
	timer.Create("AddGPS", GarryClicker.Stats.Interval / 1000, 0, function()
		GarryClicker.Stats.Garries = GarryClicker.Stats.Garries + GarryClicker.Stats.GarriesPerSecond
	end)	
end