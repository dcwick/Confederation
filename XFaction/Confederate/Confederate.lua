local XFG, G = unpack(select(2, ...))

Confederate = ObjectCollection:newChildConstructor()

function Confederate:new()
    local _Object = Confederate.parent.new(self)
	_Object.__name = 'Confederate'
	_Object._CountByTarget = {}
    _Object._Objects = {}
	_Object._GuildInfo = nil
    _Object._ModifyGuildInfo = nil
    return _Object
end

function Confederate:Initialize()
	if(not self:IsInitialized()) then
        self:CanModifyGuildInfo(CanEditGuildInfo())
        self:IsInitialized(true)
	end
	return self:IsInitialized()
end

function Confederate:GetUnitByName(inName)
    assert(type(inName) == 'string')
    for _, _Unit in self:Iterator() do
        if(_Unit:GetName() == inName) then
            return _Unit
        end
    end
end

function Confederate:AddUnit(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name ~= nil and inUnit.__name == 'Unit', 'argument must be Unit object')
    
    self:AddObject(inUnit)
    XFG.DataText.Guild:RefreshBroker()
    if(inUnit:IsPlayer()) then
        XFG.Player.Unit = inUnit
    end

    local _Target = XFG.Targets:GetTargetByRealmFaction(inUnit:GetRealm(), inUnit:GetFaction())
    if(self._CountByTarget[_Target:GetKey()] == nil) then
        self._CountByTarget[_Target:GetKey()] = 0
    end
    self._CountByTarget[_Target:GetKey()] = self._CountByTarget[_Target:GetKey()] + 1

    return true
end

function Confederate:OfflineUnits(inEpochTime)
    assert(type(inEpochTime) == 'number')
    for _, _Unit in self:Iterator() do
        if(_Unit:IsPlayer() == false and _Unit:GetTimeStamp() < inEpochTime) then
            self:RemoveUnit(_Unit:GetKey())
        end
    end
end

function Confederate:RemoveUnit(inKey)
    assert(type(inKey) == 'string')
    if(self:Contains(inKey)) then
        local _Unit = self:GetObject(inKey)
        self:RemoveObject(inKey)
        XFG.DataText.Guild:RefreshBroker()
        if(XFG.Nodes:Contains(_Unit:GetName())) then
            XFG.Nodes:RemoveNode(XFG.Nodes:GetObject(_Unit:GetName()))
        end
        local _Target = XFG.Targets:GetTargetByRealmFaction(_Unit:GetRealm(), _Unit:GetFaction())
        self._CountByTarget[_Target:GetKey()] = self._CountByTarget[_Target:GetKey()] - 1      
    end
end

function Confederate:CreateBackup()
    try(function ()
        XFG.DB.Backup = {}
        XFG.DB.Backup.Confederate = {}
        for _UnitKey, _Unit in self:Iterator() do
            if(_Unit:IsRunningAddon() and not _Unit:IsPlayer()) then
                XFG.DB.Backup.Confederate[_UnitKey] = {}
                local _SerializedData = XFG:SerializeUnitData(_Unit)
                XFG.DB.Backup.Confederate[_UnitKey] = _SerializedData
            end
        end
    end).
    catch(function (inErrorMessage)
        table.insert(XFG.DB.Errors, 'Failed to create confederate backup before reload: ' .. inErrorMessage)
    end)
end

function Confederate:RestoreBackup()
    if(XFG.DB.Backup == nil or XFG.DB.Backup.Confederate == nil) then return end
    for _, _Data in pairs (XFG.DB.Backup.Confederate) do
        try(function ()
            local _UnitData = XFG:DeserializeUnitData(_Data)
            if(self:AddUnit(_UnitData)) then
                XFG:Info(self:GetObjectName(), '  Restored %s unit information from backup', _UnitData:GetUnitName())
            end
        end).
        catch(function (inErrorMessage)
            XFG:Warn(self:GetObjectName(), 'Failed to restore confederate unit: ' .. inErrorMessage)
        end)
    end
end

function Confederate:GetCountByTarget(inTarget)
    assert(type(inTarget) == 'table' and inTarget.__name ~= nil and inTarget.__name == 'Target', 'argument must be Target object')
    return self._CountByTarget[inTarget:GetKey()] or 0
end

function Confederate:CanModifyGuildInfo(inBoolean)
    assert(inBoolean == nil or type(inBoolean) == 'boolean', 'argument needs to be nil or boolean')
    if(inBoolean ~= nil) then
        self._ModifyGuildInfo = inBoolean
    elseif(not self:IsInitialized()) then
        self:Initialize()
    end
    return self._ModifyGuildInfo
end

function Confederate:SaveGuildInfo()
    if(self:CanModifyGuildInfo()) then
        try(function ()
            local _GuildInfo = C_Club.GetClubInfo(XFG.Player.Guild:GetID())
            local _NewGuildInfo = ''
            for _, _Line in ipairs(string.Split(_GuildInfo.description, '\n')) do
                if(not string.find(_Line, 'XF')) then
                    _NewGuildInfo = _NewGuildInfo .. _Line .. '\n'
                end
            end

            local _XFInfo = ''

            _XFInfo = _XFInfo .. 'XFn:' .. XFG.Confederate:GetName() .. ':' .. XFG.Confederate:GetKey() .. '\n'
            _XFInfo = _XFInfo .. 'XFc:' .. XFG.Outbox:GetLocalChannel():GetName() .. ':' .. XFG.Outbox:GetLocalChannel():GetPassword() .. '\n'
            _XFInfo = _XFInfo .. 'XFa:' .. XFG.Settings.Confederate.AltRank .. '\n'

            for _, _Guild in XFG.Guilds:Iterator() do
                _XFInfo = _XFInfo .. 'XFg:' .. 
                          _Guild:GetRealm():GetID() .. ':' ..
                          _Guild:GetFaction():GetID() .. ':' ..
                          _Guild:GetName() .. ':' ..
                          _Guild:GetInitials() .. '\n'
            end

            for _, _Team in XFG.Teams:Iterator() do
                if(XFG.Settings.Confederate.DefaultTeams[_Team:GetKey()] == nil and XFG.Settings.Teams[_Team:GetKey()] == nil) then
                    _XFInfo = _XFInfo .. 'XFt:' .. _Team:GetKey() .. ':' .. _Team:GetName() .. '\n'
                end
            end

            _XFInfo = string.sub(_XFInfo, 1, -2)

            if(XFG.Config.Setup.Confederate.Compression) then
                -- Serialize and compress XFaction data
                local _Serialized = XFG:Serialize(_XFInfo)
	            local _Compressed = XFG.Lib.Deflate:EncodeForPrint(XFG.Lib.Deflate:CompressDeflate(_Serialized, {level = XFG.Settings.Network.CompressionLevel}))
                _NewGuildInfo = _NewGuildInfo .. 'XF:' .. _Compressed .. ':XF'
            else
                _NewGuildInfo = _NewGuildInfo .. _XFInfo
            end
            --SetGuildInfoText(_NewGuildInfo)
            XFG:Debug(self:GetObjectName(), 'Set new guild information: ' .. _NewGuildInfo)
        end).
        catch(function (inErrorMessage)
            XFG:Warn(self:GetObjectName(), 'Failed to save guild information: ' .. inErrorMessage)
        end)
    end
end