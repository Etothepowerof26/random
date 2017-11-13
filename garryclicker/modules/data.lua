local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

GarryClicker.EncodeData = function(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
GarryClicker.DecodeData = function(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
GarryClicker.DefaultColorToTable = function()
	return {
		r = GarryClicker.DefaultColor.r,
		g = GarryClicker.DefaultColor.g,
		b = GarryClicker.DefaultColor.b
	}
end
GarryClicker.Filename = "garryclickerdatav2.txt"
GarryClicker.SaveStats = function()
	local TablesToSave = {
		GarryClicker.Stats,
		GarryClicker.People,
		GarryClicker.Upgrades,
		GarryClicker.Speed,
		GarryClicker.Click,
		GarryClicker.Ascensions,
		GarryClicker.DefaultColor.r,
		GarryClicker.DefaultColor.g,
		GarryClicker.DefaultColor.b
	}
	TablesToSave = util.TableToJSON(TablesToSave)
	TablesToSave = GarryClicker.EncodeData(TablesToSave)
	
	file.Write("garryclickerdatav2.txt", TablesToSave)
end
GarryClicker.LoadStats = function()
	if not file.Exists("garryclickerdatav2.txt", "DATA") then
		GarryClicker.Notify("Save file not found! Creating new one!")
		GarryClicker.SaveStats()
	else
		local Data = file.Read("garryclickerdatav2.txt")
		Data = GarryClicker.DecodeData(Data)
		Data = util.JSONToTable(Data)
		
		GarryClicker.Notify("GarryClicker save found!")
		GarryClicker.Notify("Size: "..(file.Size("garryclickerdatav2.txt", "DATA")/1000).."KB")
		GarryClicker.Stats = Data[1]
		GarryClicker.People = Data[2]
		for k,v in pairs(GarryClicker.Upgrades) do
			v.Bought = Data[3][k].Bought
		end
		GarryClicker.Speed.Price = Data[4].Price
		GarryClicker.Speed.Max = Data[4].Max
		GarryClicker.Click.Price = Data[5].Price
		GarryClicker.Ascensions.TotalAscensions = Data[6].TotalAscensions
		GarryClicker.Ascensions.GabensEarned = Data[6].GabensEarned
		GarryClicker.DefaultColor = Color(Data[7], Data[8], Data[9])
	end
end
GarryClicker.DefaultColor = Color(0, 127, 255, 255)