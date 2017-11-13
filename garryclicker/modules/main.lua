GarryClicker.MoneySuffixes = {
	"Thousand","Million","Billion","Trillion","Quadrillion","Quintillion",
	"Sextillion","Septillion","Octillion","Nonillion","Decillion","Undecillion",
	"Duodecillion","Tredecillion","Quattuordecillion","Quindecillion","Sedecillion","Septendecillion",
	"Octodecillion","Novendecillion","Vigintillion","Unvigintillion","Duovigintillion","Tresvigintillion",
	"Quattuorvigintillion","Quinvigintillion","Sevigintillion","Septevigintillion","Octovigintillion","Novemvigintillion",
	"Trigintillion","Untrigintillion","Duotrigintillion","Trestrigintillion","Quattuortrigintillion","Quintrigintillion",
	"Sestrigintillion","Septentrigintillion","Octotrigintillion","Noventrigintillion","Quadragintillion"
}
GarryClicker.HandleMoney = function(Input)
	local Negative = Input < 0
	Input = math.abs(Input)

	local Paired = false
	for i,v in pairs(GarryClicker.MoneySuffixes) do
		if not (Input >= 10^(3*i)) then
			Input = Input / 10^(3*(i - 1))
			local isComplex = (string.find(tostring(Input),".") and string.sub(tostring(Input),4,4) ~= ".")
			Input = string.sub(tostring(Input),1,(isComplex and 4) or 3) .." ".. (GarryClicker.MoneySuffixes[i-1] or "")
			Paired = true
			break;
		end
	end
	if not Paired then
		local Rounded = math.floor(Input)
		Input = tostring(Rounded)
	end

	if Negative then
		return "(-¢"..(Input)..")"
	end
	return "¢"..(Input)
end
GarryClicker.CreateGUI = function()
	local Pressed = false
	local Increment = 45
	
	hook.Add("Think", "MousePress", function()
		if(input.IsMouseDown(MOUSE_LEFT) == true) then
			if(Pressed == false) then
				local x,y = input.GetCursorPos()
				hook.Call("MouseDown", nil, { x = x, y = y })
				Pressed = true
			end
		else
			Pressed = false
		end
	end)
	
	GarryClicker.Frame = vgui.Create("DFrame")
	GarryClicker.Frame:SetSize(800,800)
	GarryClicker.Frame:SetTitle("")
	GarryClicker.Frame:Center()
	GarryClicker.Frame:MakePopup()
	--y = 270 420; x = 470 620
	GarryClicker.Frame.Paint = function()
		local X,Y = GarryClicker.Frame:LocalToScreen()
		local Condition1 = gui.MouseX() > X + 150 and gui.MouseX() < X + 300
		local Condition2 = gui.MouseY() > Y + 200 and gui.MouseY() < Y + 350
		
		draw.RoundedBox(8, 0, 0, GarryClicker.Frame:GetWide(), GarryClicker.Frame:GetTall(), Color(30, 30, 30, 255))
		draw.RoundedBox(8, 0, 0, GarryClicker.Frame:GetWide(), 30, GarryClicker.DefaultColor)
		

		if Condition1 and Condition2 and Pressed == true then
			draw.RoundedBox(8, 150 - 10, 200 - 10, 170, 170, Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255))
		end
		
		draw.RoundedBox(8, 150, 200, 150, 150, GarryClicker.DefaultColor)
		draw.DrawText("g", "GC_Coolvetica", 195, 200, Color(255, 255, 255, 255))
	end
	GarryClicker.Frame.OnClose = function()
		GarryClicker.Frame:Hide()
		hook.Remove("Think", "Update")
		hook.Remove("Think", "MousePress")
		gui.EnableScreenClicker(false)
	end

	local TitleLabel = vgui.Create("DLabel", GarryClicker.Frame)
	TitleLabel:SetFont("VerdanaSize13")
	TitleLabel:SetSize(GarryClicker.Frame:GetWide(), 23)
	TitleLabel:SetPos(5, 4)
	TitleLabel:SetText("Garry Clicker V2. Welcome, "..LocalPlayer():Nick()..
		". Total Clicks: "..GarryClicker.Stats.TotalClicks)
	
	local MoneyLabel = vgui.Create("DLabel", GarryClicker.Frame)
	MoneyLabel:SetFont("VerdanaSize13")
	MoneyLabel:SetSize(GarryClicker.Frame:GetWide(), 400)
	MoneyLabel:SetPos(10, -125)
	MoneyLabel:SetText("Garries:")
	
	local PeopleLabel = vgui.Create("DLabel", GarryClicker.Frame)
	PeopleLabel:SetFont("VerdanaSize13")
	PeopleLabel:SetSize(GarryClicker.Frame:GetWide(), 700)
	PeopleLabel:SetPos(10, 150)
		
	for k,v in pairs(GarryClicker.People) do
		local ButtonForPerson = vgui.Create("DButton", GarryClicker.Frame)
		ButtonForPerson:SetSize(250, 35)
		ButtonForPerson:SetPos(450, 15 + (Increment * k))
		ButtonForPerson:SetText("Buy "..v.Name.." - ¢"..string.Comma(v.Price))
		ButtonForPerson:SetFont("VerdanaSize13")
		ButtonForPerson:SetColor(Color(255, 255, 255))
		ButtonForPerson.Paint = function()
			draw.RoundedBox(8, 0, 0, ButtonForPerson:GetWide(), ButtonForPerson:GetTall(), GarryClicker.DefaultColor)
			ButtonForPerson:SetText("Buy "..v.Name.." - "..GarryClicker.HandleMoney(math.Round(v.Price)))
		end
		ButtonForPerson.DoClick = function()
			if GarryClicker.Stats.Garries >= v.Price then
				GarryClicker.Stats.Garries = math.Round(GarryClicker.Stats.Garries - v.Price)
				GarryClicker.Stats.GarriesPerSecond = GarryClicker.Stats.GarriesPerSecond + v.Payout
				
				v.Price = math.ceil(v.Price * 1.2)
				v.Amount = v.Amount + 1
				sound.Play( "garrysmod/balloon_pop_cute.wav", LocalPlayer():GetPos() )
			end
		end
	
		local ButtonForPersonX10 = vgui.Create("DButton", GarryClicker.Frame)
		ButtonForPersonX10:SetSize(35, 35)
		ButtonForPersonX10:SetPos(705, 15 + (Increment * k))
		ButtonForPersonX10:SetText("X10")
		ButtonForPersonX10:SetFont("VerdanaSize13")
		ButtonForPersonX10:SetColor(Color(255, 255, 255))
		ButtonForPersonX10.Paint = function()
			draw.RoundedBox(8, 0, 0, ButtonForPersonX10:GetWide(), ButtonForPersonX10:GetTall(), GarryClicker.DefaultColor)
		end
		ButtonForPersonX10.DoClick = function()
			if GarryClicker.Stats.Garries >= v.Price * 10 then
				GarryClicker.Stats.Garries = math.Round(GarryClicker.Stats.Garries - (v.Price * 10))
				GarryClicker.Stats.GarriesPerSecond = GarryClicker.Stats.GarriesPerSecond + (v.Payout * 10)
				
				v.Price = math.ceil(v.Price * 5)
				v.Amount = v.Amount + 10
				sound.Play( "garrysmod/balloon_pop_cute.wav", LocalPlayer():GetPos() )
			end
		end
	
		local ButtonForPersonX50 = vgui.Create("DButton", GarryClicker.Frame)
		ButtonForPersonX50:SetSize(35, 35)
		ButtonForPersonX50:SetPos(710 + 35, 15 + (Increment * k))
		ButtonForPersonX50:SetText("X50")
		ButtonForPersonX50:SetFont("VerdanaSize13")
		ButtonForPersonX50:SetColor(Color(255, 255, 255))
		ButtonForPersonX50.Paint = function()
			draw.RoundedBox(8, 0, 0, ButtonForPersonX50:GetWide(), ButtonForPersonX50:GetTall(), GarryClicker.DefaultColor)
		end
		ButtonForPersonX50.DoClick = function()
			if GarryClicker.Stats.Garries >= v.Price * 100 then
				GarryClicker.Stats.Garries = math.Round(GarryClicker.Stats.Garries - (v.Price * 100))
				GarryClicker.Stats.GarriesPerSecond = GarryClicker.Stats.GarriesPerSecond + (v.Payout * 50)
				
				v.Price = math.ceil(v.Price * 125)
				v.Amount = v.Amount + 50
				sound.Play( "garrysmod/balloon_pop_cute.wav", LocalPlayer():GetPos() )
			end
		end
	end

	GarryClicker.AddGPS()
	
	hook.Add("MouseDown", "Click", function(curpos)
		local X,Y = GarryClicker.Frame:LocalToScreen()
		local Condition1 = gui.MouseX() > X + 150 and gui.MouseX() < X + 300
		local Condition2 = gui.MouseY() > Y + 200 and gui.MouseY() < Y + 350
		
		if Condition1 and Condition2 then
			GarryClicker.Stats.Garries = GarryClicker.Stats.Garries + GarryClicker.Stats.GarriesPerClick
			GarryClicker.Stats.TotalClicks = GarryClicker.Stats.TotalClicks + 1
			
			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
		end
	end)
	
	hook.Add("Think", "Update", function()
		local Text = ""
		TitleLabel:SetText("Garry Clicker V2. Welcome, "..LocalPlayer():Nick()..
			". Total Clicks: "..GarryClicker.Stats.TotalClicks)
		MoneyLabel:SetText("Garries: "..GarryClicker.HandleMoney(GarryClicker.Stats.Garries)..
			"\nGarries Per Second: "..GarryClicker.HandleMoney(GarryClicker.Stats.GarriesPerSecond)..
			"\nGarries Per Click: "..GarryClicker.HandleMoney(GarryClicker.Stats.GarriesPerClick))
		for i,v in pairs(GarryClicker.People) do
			Text = (Text..v.Name..": "..v.Amount.."\n")	
		end
		PeopleLabel:SetText(Text)
	end)
end
GarryClicker.CreateShop = function()
	local StartingPos, Incrementt, A = {180, 50}, 45, 0
	GarryClicker.SFrame = vgui.Create("DFrame")
	GarryClicker.SFrame:SetSize(600,335 + (Incrementt * 6))
	GarryClicker.SFrame:SetTitle("")
	GarryClicker.SFrame:Center()
	GarryClicker.SFrame:MakePopup()
	GarryClicker.SFrame.Paint = function()
		draw.RoundedBox(8, 0, 0, GarryClicker.SFrame:GetWide(), GarryClicker.SFrame:GetTall(), Color(30, 30, 30, 255))
		draw.RoundedBox(8, 0, 0, GarryClicker.SFrame:GetWide(), 30, GarryClicker.DefaultColor)
	end
	GarryClicker.SFrame.OnClose = function()
		GarryClicker.SFrame:Hide()
		hook.Remove("Think", "Update2")
		gui.EnableScreenClicker(false)
	end
	
	local TitleLabel = vgui.Create("DLabel", GarryClicker.SFrame)
	TitleLabel:SetFont("VerdanaSize13")
	TitleLabel:SetSize(GarryClicker.SFrame:GetWide(), 23)
	TitleLabel:SetPos(5, 4)
	TitleLabel:SetText("Garry Clicker V2 Shop")
	
	local DescriptionLabel = vgui.Create("DLabel", GarryClicker.SFrame)
	DescriptionLabel:SetFont("VerdanaSize13")
	DescriptionLabel:SetSize(200, 100)
	DescriptionLabel:SetPos(5, 20)
	
	local BuyNow = vgui.Create("DButton", GarryClicker.SFrame)
	BuyNow:SetFont("VerdanaSize23")
	BuyNow:SetSize(205, 30)
	BuyNow:SetText("Buy now!")
	BuyNow:SetColor(Color(255, 255, 255))
	BuyNow:SetPos(0, 150)
	BuyNow.Paint = function()
		draw.RoundedBox(8, 0, 0, BuyNow:GetWide(), BuyNow:GetTall(), GarryClicker.DefaultColor)	
	end
	BuyNow.DoClick = function()
		local curr = GarryClicker.Upgrades[GarryClicker.Current]
		if GarryClicker.Stats.Garries >= curr.Price then
			GarryClicker.Stats.Garries = GarryClicker.Stats.Garries - curr.Price
			GarryClicker.Current = 1
			
			curr.Bought = true
			curr.OnBuy()
		end
	end
	
	local Speed = vgui.Create("DButton", GarryClicker.SFrame)
	Speed:SetFont("VerdanaSize13")
	Speed:SetSize(205, 30)
	Speed:SetText("Speed Upgrade")
	Speed:SetColor(Color(255, 255, 255))
	Speed:SetPos(0, 210)
	Speed.Paint = function()
		if GarryClicker.Stats.Interval <= 10 then
			GarryClicker.Speed.Max = true
		end
		
		if GarryClicker.Speed.Max == true then
			draw.RoundedBox(8, 0, 0, Speed:GetWide(), Speed:GetTall(), Color(127, 127, 127, 255))
			Speed:SetText("Speed Upgrade - MAXED")
		else
			draw.RoundedBox(8, 0, 0, Speed:GetWide(), Speed:GetTall(), GarryClicker.DefaultColor)
			Speed:SetText("Speed Upgrade - "..GarryClicker.HandleMoney(GarryClicker.Speed.Price))
		end
	end
	Speed.DoClick = function()
		if GarryClicker.Stats.Interval <= 10 then
			GarryClicker.Speed.Max = true
		end
		
		if GarryClicker.Stats.Garries >= GarryClicker.Speed.Price then
			GarryClicker.Stats.Garries = GarryClicker.Stats.Garries - GarryClicker.Speed.Price
			GarryClicker.Speed.OnBuy()
		end
	end

	local Click = vgui.Create("DButton", GarryClicker.SFrame)
	Click:SetFont("VerdanaSize13")
	Click:SetSize(205, 30)
	Click:SetText("Speed Upgrade")
	Click:SetColor(Color(255, 255, 255))
	Click:SetPos(0, 250)
	Click.Paint = function()
		draw.RoundedBox(8, 0, 0, Click:GetWide(), Click:GetTall(), GarryClicker.DefaultColor)
		Click:SetText("Click Upgrade - "..GarryClicker.HandleMoney(GarryClicker.Click.Price))
	end
	Click.DoClick = function()
		if GarryClicker.Stats.Garries >= GarryClicker.Click.Price then
			GarryClicker.Stats.Garries = GarryClicker.Stats.Garries - GarryClicker.Click.Price
			GarryClicker.Click.OnBuy()
		end
	end
	
	for i = 2, #GarryClicker.Upgrades do
		A = A + 1
		if i >= 9 and A >= 9 then
			StartingPos[2] = StartingPos[2] + (Incrementt)
			StartingPos[1] = 180
			A = 1
		end
		
		local v = GarryClicker.Upgrades[i]
		local UpgradeButton = vgui.Create("DButton", GarryClicker.SFrame)
		UpgradeButton:SetSize(40, 40)
		UpgradeButton:SetText(i - 1)
		UpgradeButton:SetPos(StartingPos[1] + (Incrementt * (A)), StartingPos[2] )
		UpgradeButton:SetFont("VerdanaSize23")
		UpgradeButton:SetColor(Color(255, 255, 255))
		UpgradeButton.Paint = function()
			if v.Bought == false then
				UpgradeButton:SetText(i - 1)
				draw.RoundedBox(8, 0, 0, UpgradeButton:GetWide(), UpgradeButton:GetTall(), GarryClicker.DefaultColor)
			else
				UpgradeButton:SetText("X")
				draw.RoundedBox(8, 0, 0, UpgradeButton:GetWide(), UpgradeButton:GetTall(), Color(127, 127, 127, 255))
			end
		end
		UpgradeButton.DoClick = function()
			if v.Bought == false then
				GarryClicker.Current = i
			else return end
		end
	end
	
	hook.Add("Think", "Update2", function()
		local ToGo = ""
		if GarryClicker.Stats.Garries < GarryClicker.Upgrades[GarryClicker.Current].Price then
			ToGo = GarryClicker.HandleMoney(GarryClicker.Upgrades[GarryClicker.Current].Price - GarryClicker.Stats.Garries)
		else
			ToGo = "None!"
		end
		
		DescriptionLabel:SetText("Name: "..GarryClicker.Upgrades[GarryClicker.Current].Name..
			"\nDescription: "..GarryClicker.Upgrades[GarryClicker.Current].Description..
			"\nPrice: "..GarryClicker.HandleMoney(GarryClicker.Upgrades[GarryClicker.Current].Price)..
			"\nGarries Left: \n"..ToGo)
	end)
end
GarryClicker.CreateAscensionGUI = function()
	GarryClicker.AFrame = vgui.Create("DFrame")
	GarryClicker.AFrame:SetSize(300, 100)
	GarryClicker.AFrame:SetTitle("Ascension GUI")
	GarryClicker.AFrame:Center()
	GarryClicker.AFrame:MakePopup()
	GarryClicker.AFrame.Paint = function()
		draw.RoundedBox(8, 0, 0, GarryClicker.AFrame:GetWide(), GarryClicker.AFrame:GetTall(), Color(30, 30, 30, 255))
		draw.RoundedBox(8, 0, 0, GarryClicker.AFrame:GetWide(), 30, GarryClicker.DefaultColor)
	end
	GarryClicker.AFrame.OnClose = function()
		GarryClicker.AFrame:Hide()
		hook.Remove("Think", "Ascension")
		gui.EnableScreenClicker(false)
	end
	
	local Ascend = vgui.Create("DButton", GarryClicker.AFrame)
	Ascend:SetSize(50, 30)
	Ascend:SetText("Ascend")
	Ascend:SetPos(10, 40)
	Ascend:SetFont("VerdanaSize13")
	Ascend:SetColor(Color(255, 255, 255))
	Ascend.Paint = function()
		draw.RoundedBox(8, 0, 0, Ascend:GetWide(), Ascend:GetTall(), GarryClicker.DefaultColor)
	end
	Ascend.DoClick = GarryClicker.Ascensions.OnAscend
	
	local DescLabel = vgui.Create("DLabel", GarryClicker.AFrame)
	DescLabel:SetPos(70, 40)
	DescLabel:SetSize(200, 30)
	DescLabel:SetFont("VerdanaSize13")
	DescLabel:SetColor(Color(255,255,255))
	DescLabel:SetText("label")
	
	hook.Add("Think", "Ascension", function()
		GarryClicker.Ascensions.Gabens2Earn = math.Round(GarryClicker.Stats.Garries / 5e14)
		DescLabel:SetText("If you ascend, you will recieve\n"..GarryClicker.HandleMoney(GarryClicker.Ascensions.Gabens2Earn).." Gabens.")
	end)
end
GarryClicker.ColorMixer = function()
	GarryClicker.CFrame = vgui.Create("DFrame")
	GarryClicker.CFrame:SetSize(200, 200)
	GarryClicker.CFrame:SetTitle("Color Mixer")
	GarryClicker.CFrame:Center()
	GarryClicker.CFrame:MakePopup()
	GarryClicker.CFrame.Paint = function()
		draw.RoundedBox(8, 0, 0, GarryClicker.CFrame:GetWide(), GarryClicker.CFrame:GetTall(), Color(30, 30, 30, 255))
		draw.RoundedBox(8, 0, 0, GarryClicker.CFrame:GetWide(), 30, GarryClicker.DefaultColor)
	end
	GarryClicker.CFrame.OnClose = function()
		GarryClicker.CFrame:Hide()
		hook.Remove("Think", "ColorMixer")
		gui.EnableScreenClicker(false)
	end	
	
	local ColorMixer = vgui.Create("DColorMixer", GarryClicker.CFrame)
	ColorMixer:Dock(FILL)
	ColorMixer:SetColor(GarryClicker.DefaultColor)
	
	hook.Add("Think", "ColorMixer", function()
		GarryClicker.DefaultColor = ColorMixer:GetColor()
	end)
end