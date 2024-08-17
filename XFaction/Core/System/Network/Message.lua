local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'Message'

XFC.Message = XFC.ObjectCollection:newChildConstructor()

--#region Constructors
function XFC.Message:new()
    local object = XFC.Message.parent.new(self)
    object.__name = ObjectName
    object.from = nil
    object.fromUnit = nil
    object.subject = nil
    object.epochTime = nil
    object.data = nil
    object.initialized = false
    object.totalPackets = 1
    object.priority = nil
    return object
end

function XFC.Message:Initialize()
    if(not self:IsInitialized()) then
        self:ParentInitialize()
        self:From(XF.Player.GUID)
        self:FromUnit(XF.Player.Unit)
        self:TimeStamp(XFF.TimeCurrent())
        self:Priority(XF.Enum.Priority.Low)

        for _, target in XFO.Targets:Iterator() do
            if(not target:Equals(XF.Player.Target)) then
                self:Add(target)
            end
        end

        self:IsInitialized(true)
    end
    return self:IsInitialized()
end

function XFC.Message:Deconstructor()
    self:ParentDeconstructor()
    self.from = nil
    self.fromUnit = nil
    self.subject = nil
    self.epochTime = nil
    self.data = nil
    self.totalPackets = 1
    self.priority = nil
end
--#endregion

--#region Properties
function XFC.Message:From(inFrom)
    assert(type(inFrom) == 'string' or inFrom == nil)
    if(inFrom ~= nil) then
        self.from = inFrom
    end
    return self.from
end

function XFC.Message:FromUnit(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name == 'Unit' or inUnit == nil)
    if(inUnit ~= nil) then
        self.fromUnit = inUnit
    end
    return self.fromUnit
end

function XFC.Message:Subject(inSubject)
    assert(type(inSubject) == 'string' or inSubject == nil)
    if(inSubject ~= nil) then
        self.subject = inSubject
    end
    return self.subject
end

function XFC.Message:TimeStamp(inEpochTime)
    assert(type(inEpochTime) == 'number' or inEpochTime == nil)
    if(inEpochTime ~= nil) then
        self.epochTime = inEpochTime
    end
    return self.epochTime
end

function XFC.Message:Data(inData)
    if(inData ~= nil) then
        self.data = inData
    end
    return self.data
end

function XFC.Message:TotalPackets(inTotalPackets)
    assert(type(inTotalPackets) == 'number' or inTotalPackets == nil)
    if(inTotalPackets ~= nil) then
        self.totalPackets = inTotalPackets
    end
    return self.totalPackets
end

function XFC.Message:Priority(inPriority)
    assert(type(inPriority) == 'number' or inPriority == nil)
    if(inPriority ~= nil) then
        self.priority = inPriority
    end
    return self.priority
end
--#endregion

--#region Methods
function XFC.Message:Print()
    XF:DoubleLine(self:ObjectName())
    XF:Debug(self:ObjectName(), '  key (' .. type(self.key) .. '): ' .. tostring(self.key))
    XF:Debug(self:ObjectName(), '  from (' .. type(self.from) .. '): ' .. tostring(self.from))
    XF:Debug(self:ObjectName(), '  totalPackets (' .. type(self.totalPackets) .. '): ' .. tostring(self.totalPackets))
    XF:Debug(self:ObjectName(), '  subject (' .. type(self.subject) .. '): ' .. tostring(self.subject))
    XF:Debug(self:ObjectName(), '  epochTime (' .. type(self.epochTime) .. '): ' .. tostring(self.epochTime))
    XF:Debug(self:ObjectName(), '  priority (' .. type(self.priority) .. '): ' .. tostring(self.priority))
    XF:Debug(self:ObjectName(), '  data (' .. type(self.data) .. '): ' .. tostring(self.data))
    local targets = ''
    for _, target in self:Iterator() do
        targets = targets .. target:Guild():Initials() .. ';'
    end
    XF:Debug(self:ObjectName(), '  remaining targets: ' .. targets)
    XF:SingleLine(self:ObjectName())
end

function XFC.Message:IsMyMessage()
    return self:From() == XF.Player.GUID
end

function XFC.Message:HasTargets()
    return self:Count() > 0
end

function XFC.Message:HasFromUnit()
    return self:FromUnit() ~= nil
end

function XFC.Message:Encode(inBNet)
    assert(type(inBNet) == 'boolean' or inBNet == nil)
    local serialized = self:Serialize()
	local compressed = XF.Lib.Deflate:CompressDeflate(serialized, {level = XF.Settings.Network.CompressionLevel})
    return inBNet and XF.Lib.Deflate:EncodeForPrint(compressed) or XF.Lib.Deflate:EncodeForWoWAddonChannel(compressed)
end

function XFC.Message:Serialize()
    local data = {}

    data.D = self:Data()	
	data.F = self:From()
	data.K = self:Key()
	data.P = self:TotalPackets()
    data.Q = self:Priority()
    data.S = self:Subject()
    data.T = self:TimeStamp()
    data.U = self:HasFromUnit() and self:FromUnit():Serialize() or nil

    local targets = ''
    for _, target in self:Iterator() do
        targets = targets .. ';' .. target:Serialize()
    end
    if(string.len(targets) > 0) then
        data.R = targets
    end

	return pickle(data)
end

function XFC.Message:Decode(inEncoded, inBNet)
    assert(type(inEncoded) == 'string')
    assert(type(inBNet) == 'boolean' or inBNet == nil)

    local decoded = inBNet and XF.Lib.Deflate:DecodeForPrint(inEncoded) or XF.Lib.Deflate:DecodeForWoWAddonChannel(inEncoded)
    local decompressed = XF.Lib.Deflate:DecompressDeflate(decoded)
    self:Deserialize(decompressed)
end

function XFC.Message:Deserialize(inSerial)
    assert(type(inSerial) == 'string')
    local data = unpickle(inSerial)

    self:ParentInitialize()

    self:Data(data.D)
    self:From(data.F)
    self:Key(data.K)
    self:TotalPackets(data.P)
    self:Subject(data.S)
    self:TimeStamp(data.T)
    self:Priority(data.Q)

    local unit = nil
    try(function()
        unit = XFO.Confederate:Pop()
        unit:Deserialize(data.U)
        self:FromUnit(unit)
    end).
    catch(function(err)
        XF:Warn(self:ObjectName(), err)
        XFO.Confederate:Push(unit)        
    end)

    if(data.R ~= nil) then
        local targets = string.Split(data.R, ';')
        for _, target in ipairs(targets) do
            self:Add(XFO.Targets:Get(tonumber(target)))
        end
    end
end

function XFC.Message:IsPingMessage()
    return self:Subject() == XF.Enum.Message.PING
end

function XFC.Message:IsAckMessage()
    return self:Subject() == XF.Enum.Message.ACK
end

function XFC.Message:IsLoginMessage()
    return self:Subject() == XF.Enum.Message.LOGIN
end

function XFC.Message:IsLogoutMessage()
    return self:Subject() == XF.Enum.Message.LOGOUT
end

function XFC.Message:IsDataMessage()
    return self:Subject() == XF.Enum.Message.DATA
end

function XFC.Message:IsGuildChatMessage()
    return self:Subject() == XF.Enum.Message.GCHAT
end

function XFC.Message:IsAchievementMessage()
    return self:Subject() == XF.Enum.Message.ACHIEVEMENT
end

function XFC.Message:IsOrderMessage()
    return self:Subject() == XF.Enum.Message.ORDER
end

function XFC.Message:IsHighPriority()
    return self:Priority() == XF.Enum.Priority.High
end

function XFC.Message:IsMediumPriority()
    return self:Priority() == XF.Enum.Priority.Medium
end

function XFC.Message:IsLowPriority()
    return self:Priority() == XF.Enum.Priority.Low
end
--#endregion