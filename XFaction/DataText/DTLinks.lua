local XFG, G = unpack(select(2, ...))
local ObjectName = 'DTLinks'
local CombatLockdown = InCombatLockdown

DTLinks = Object:newChildConstructor()
	
function DTLinks:new()
	local object = DTGuild.parent.new(self)
    object.__name = ObjectName
    object.headerFont = nil
	object.regularFont = nil
	object.ldbObject = nil
	object.tooltip = nil
	object.count = 0    
    return object
end

function DTLinks:Initialize()
	if(not self:IsInitialized()) then
		self:ParentInitialize()
		self.ldbObject = XFG.Lib.Broker:NewDataObject(XFG.Lib.Locale['DTLINKS_NAME'], {
			type = 'data source',
			label = XFG.Lib.Locale['DTLINKS_NAME'],
		    OnEnter = function(this) XFG.DataText.Links:OnEnter(this) end,
			OnLeave = function(this) XFG.DataText.Links:OnLeave(this) end,
		})

		self:IsInitialized(true)
	end
	return self:IsInitialized()
end

function DTLinks:SetFont()
	self.headerFont = CreateFont('headerFont')
	self.headerFont:SetFont(XFG.Lib.LSM:Fetch('font', XFG.Config.DataText.Font), XFG.Config.DataText.FontSize)
	self.headerFont:SetTextColor(0.4,0.78,1)
	self.regularFont = CreateFont('regularFont')
	self.regularFont:SetFont(XFG.Lib.LSM:Fetch('font', XFG.Config.DataText.Font), XFG.Config.DataText.FontSize)
	self.regularFont:SetTextColor(255,255,255)
end

function DTLinks:Print()
	if(XFG.DebugFlag) then
		self:ParentPrint()
		XFG:Debug(ObjectName, '  headerFont (' .. type(self.headerFont) .. '): ' .. tostring(self.headerFont))
		XFG:Debug(ObjectName, '  regularFont (' .. type(self.regularFont) .. '): ' .. tostring(self.regularFont))
		XFG:Debug(ObjectName, '  count (' .. type(self.count) .. '): ' .. tostring(self.count))
		XFG:Debug(ObjectName, '  ldbObject (' .. type(self.ldbObject) .. ')')
		XFG:Debug(ObjectName, '  tooltip (' .. type(tooltip) .. ')')
	end
end

function DTLinks:RefreshBroker()
	if(XFG.Initialized) then
		local text = ''
		-- if(XFG.Config.DataText.Link.Label) then
		-- 	text = XFG.Lib.Locale['LINKS'] .. ': '
		-- end

		local names = {}
		local allianceCount = 0
		local hordeCount = 0

		for _, link in XFG.Links:Iterator() do
			if(names[link:GetFromNode():GetName()] == nil) then
				if(link:GetFromNode():GetTarget():GetFaction():GetName() == 'Alliance') then
					allianceCount = allianceCount + 1
				else
					hordeCount = hordeCount + 1
				end
				names[link:GetFromNode():GetName()] = true
			end
			if(names[link:GetToNode():GetName()] == nil) then
				if(link:GetToNode():GetTarget():GetFaction():GetName() == 'Alliance') then
					allianceCount = allianceCount + 1
				else
					hordeCount = hordeCount + 1
				end
				names[link:GetToNode():GetName()] = true
			end
		end

--		if(XFG.Config.DataText.Link.Faction) then
			text = format('%s|cffffffff%d|r \(|cff00FAF6%d|r\|||cffFF4700%d|r\)', text, XFG.Links:GetCount(), allianceCount, hordeCount)
--		else
--			text = format('%s|cffffffff%d|r', text, XFG.Links:GetCount())
--		end
		self.ldbObject.text = text
	end
end

function DTLinks:OnEnter(this)
	if(not XFG.Initialized) then return end
	if(CombatLockdown()) then return end

	local targetCount = XFG.Targets:GetCount() + 1
	
	if XFG.Lib.QT:IsAcquired(ObjectName) then
		self.tooltip = XFG.Lib.QT:Acquire(ObjectName)		
	else
		self.tooltip = XFG.Lib.QT:Acquire(ObjectName, targetCount)
		self.tooltip:SetHeaderFont(self.headerFont)
		self.tooltip:SetFont(self.regularFont)
		self.tooltip:SmartAnchorTo(this)
		self.tooltip:SetAutoHideDelay(XFG.Settings.DataText.AutoHide, this, function() DTLinks:OnLeave() end)
		self.tooltip:EnableMouse(true)
		self.tooltip:SetClampedToScreen(false)
	end

	self.tooltip:Clear()

	local line = self.tooltip:AddLine()
	local guildName = XFG.Confederate:GetName()
	self.tooltip:SetCell(line, 1, format(XFG.Lib.Locale['DT_HEADER_CONFEDERATE'], guildName), self.headerFont, 'LEFT', targetCount)
	line = self.tooltip:AddLine()
	self.tooltip:SetCell(line, 1, format(XFG.Lib.Locale['DTLINKS_HEADER_LINKS'], XFG.Links:GetCount()), self.headerFont, 'LEFT', targetCount)

	line = self.tooltip:AddLine()
	line = self.tooltip:AddLine()
	line = self.tooltip:AddHeader()

	local targetColumn = {}
	local i = 1
	for _, target in XFG.Targets:Iterator() do
		local targetName = format('%s%s', format(XFG.Icons.String, target:GetFaction():GetIconID()), target:GetRealm():GetName())
		self.tooltip:SetCell(line, i, targetName)
		targetColumn[target:GetKey()] = i
		i = i + 1
	end

	line = self.tooltip:AddLine()
	self.tooltip:AddSeparator()
	line = self.tooltip:AddLine()

	if(XFG.Initialized) then
		for _, link in XFG.Links:Iterator() do
			local fromName = format('|cffffffff%s|r', link:GetFromNode():GetName())
			if(link:IsMyLink() and link:GetFromNode():IsMyNode()) then
				fromName = format('|cffffff00%s|r', link:GetFromNode():GetName())
			end

			local toName = format('|cffffffff%s|r', link:GetToNode():GetName())
			if(link:IsMyLink() and link:GetToNode():IsMyNode()) then
				toName = format('|cffffff00%s|r', link:GetToNode():GetName())
			end

			self.tooltip:SetCell(line, targetColumn[link:GetFromNode():GetTarget():GetKey()], fromName, self.regularFont)
			self.tooltip:SetCell(line, targetColumn[link:GetToNode():GetTarget():GetKey()], toName, self.regularFont)
			
			line = self.tooltip:AddLine()
		end
	end

	self.tooltip:Show()
end

function DTLinks:OnLeave()
	if self.tooltip and MouseIsOver(self.tooltip) then
        return
    else
        XFG.Lib.QT:Release(self.tooltip)
        self.tooltip = nil
	end
end