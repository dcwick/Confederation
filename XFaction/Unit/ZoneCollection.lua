local XFG, G = unpack(select(2, ...))
local ObjectName = 'ZoneCollection'

ZoneCollection = ObjectCollection:newChildConstructor()

function ZoneCollection:new()
    local object = ZoneCollection.parent.new(self)
	object.__name = ObjectName
	object.zoneByID = {}
    return object
end

function ZoneCollection:Initialize()
	if(not self:IsInitialized()) then
		self:ParentInitialize()

		local lib = LibStub('LibTourist-3.0')
		local zoneIDs = lib:GetMapIDLookupTable()
		local zoneLocale = lib:GetLookupTable()
		local alreadyAdded = {}

		for zoneID, zoneName in pairs (zoneIDs) do
			if(strlen(zoneName) > 0) then
				zoneID = tonumber(zoneID)
				local continentID = lib:GetContinentMapID(zoneID)

				if(not alreadyAdded[zoneName]) then
					if(continentID and tonumber(continentID) == zoneID) then
						continentID = tonumber(continentID)
						if(not XFG.Continents:Contains(zoneName)) then
							local continent = Continent:new()
							continent:Initialize()
							continent:SetKey(zoneName)
							continent:AddID(zoneID)
							continent:SetName(zoneName)
							if(zoneLocale[continent:GetName()]) then
								continent:SetLocaleName(zoneLocale[continent:GetName()])
							end
							XFG.Continents:Add(continent)
							XFG:Info(ObjectName, 'Initialized continent [%s]', continent:GetName())
							alreadyAdded[continent:GetName()] = true
						end

					elseif(not self:Contains(zoneName)) then
						local zone = Zone:new()
						zone:Initialize()
						zone:SetKey(zoneName)
						zone:AddID(zoneID)
						zone:SetName(zoneName)
						if(zoneLocale[zone:GetName()]) then
							zone:SetLocaleName(zoneLocale[zone:GetName()])
						end
						self:Add(zone)
						alreadyAdded[zone:GetName()] = true
					end
				elseif(XFG.Continents:Contains(zoneName)) then
					XFG.Continents:Get(zoneName):AddID(zoneID)
				else
					self:Get(zoneName):AddID(zoneID)
				end
			end
		end

		for _, zone in self:Iterator() do
			local continentID = lib:GetContinentMapID(zone:GetID())
			if(continentID) then
				local continent = XFG.Continents:GetByID(tonumber(continentID))
				if(continent) then
					zone:SetContinent(continent)
				end
			end
		end

		self:AddZone('?')
		self:IsInitialized(true)
	end
end

function ZoneCollection:ContainsByID(inID)
	assert(type(inID) == 'number')
	return self.zoneByID[inID] ~= nil
end

function ZoneCollection:GetByID(inID)
	assert(type(inID) == 'number')
	return self.zoneByID[inID]
end

function ZoneCollection:Add(inZone)
    assert(type(inZone) == 'table' and inZone.__name == 'Zone', 'argument must be Zone object')
	self.parent.Add(self, inZone)
	for _, ID in inZone:IDIterator() do
		self.zoneByID[ID] = inZone
	end
end

function ZoneCollection:AddZone(inZoneName)
	assert(type(inZoneName) == 'string')
	if(not self:Contains(inZoneName)) then
		local zone = Zone:new()
		zone:Initialize()
		zone:SetKey(inZoneName)
		zone:SetName(inZoneName)
		self:Add(zone)
		if(XFG.DebugFlag) then
			XFG:Info(ObjectName, 'Initialized zone [%s]', zone:GetName())
		end
	end
end