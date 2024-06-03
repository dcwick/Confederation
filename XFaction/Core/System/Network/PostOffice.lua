local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'PostOffice'

XFC.PostOffice = XFC.ObjectCollection:newChildConstructor()

--#region Constructors
function XFC.PostOffice:new()
    local object = XFC.PostOffice.parent.new(self)
	object.__name = ObjectName
	return object
end
--#endregion

--#region Methods
function XFC.PostOffice:Add(inMessageKey, inPacketNumber, inData)
    assert(type(inMessageKey) == 'string')
    assert(type(inPacketNumber) == 'number')
    assert(type(inData) == 'string')
    if(not self:Contains(inMessageKey)) then
        self.objects[inMessageKey] = {}
    end
    if(self.objects[inMessageKey][inPacketNumber] == nil) then
        self.objects[inMessageKey][inPacketNumber] = inData
    end
end

function XFC.PostOffice:SegmentMessage(inEncodedData, inMessageKey, inPacketSize)
	assert(type(inEncodedData) == 'string')
	local packets = {}
    local totalPackets = ceil(strlen(inEncodedData) / inPacketSize)
    for i = 1, totalPackets do
        local segment = string.sub(inEncodedData, inPacketSize * (i - 1) + 1, inPacketSize * i)
        segment = tostring(i) .. tostring(totalPackets) .. inMessageKey .. segment
        packets[#packets + 1] = segment
    end
	return packets
end

function XFC.PostOffice:HasAllPackets(inKey, inTotalPackets)
    assert(type(inKey) == 'string')
    assert(type(inTotalPackets) == 'number')
    if(not self:Contains(inKey)) then return false end
    return #self.objects[inKey] == inTotalPackets
end

function XFC.PostOffice:RebuildMessage(inKey, inTotalPackets)
    assert(type(inKey) == 'string')
    local message = ''
    -- Stitch the data back together again
    for _, packet in PairsByKeys(self:Get(inKey)) do
        message = message .. packet
    end
    self:Remove(inKey)
	return message
end

function XFC.PostOffice:IsAddonTag(inTag)
	local addonTag = false
    for _, tag in pairs (XF.Enum.Tag) do
        if(inTag == tag) then
            addonTag = true
            break
        end
    end
	return addonTag
end

function XFC.PostOffice:Receive(inMessageTag, inEncodedMessage, inDistribution, inSender)

    XF:Trace(self:ObjectName(), 'Received %s packet from %s for tag %s', inDistribution, inSender, inMessageTag)

    --#region Ignore message
    -- If not a message from this addon, ignore
    if(not self:IsAddonTag(inMessageTag)) then
        return
    end

    if(inMessageTag == XF.Enum.Tag.LOCAL) then
        XFO.Metrics:Get(XF.Enum.Metric.ChannelReceive):Increment()
        XFO.Metrics:Get(XF.Enum.Metric.Messages):Increment()
    else
        XFO.Metrics:Get(XF.Enum.Metric.BNetReceive):Increment()
        XFO.Metrics:Get(XF.Enum.Metric.Messages):Increment()
    end

    -- Ensure this message has not already been processed
    local packetNumber = tonumber(string.sub(inEncodedMessage, 1, 1))
    local totalPackets = tonumber(string.sub(inEncodedMessage, 2, 2))
    local messageKey = string.sub(inEncodedMessage, 3, 3 + XF.Settings.System.UIDLength - 1)
    local messageData = string.sub(inEncodedMessage, 3 + XF.Settings.System.UIDLength, -1)

    -- Ignore if it's your own message or you've seen it before
    if(XFO.Mailbox:Contains(messageKey)) then
        XF:Trace(self:ObjectName(), 'Ignoring duplicate message [%s]', messageKey)
        return
    end
    --#endregion

    self:Add(messageKey, packetNumber, messageData)
    if(self:HasAllPackets(messageKey, totalPackets)) then
        XF:Debug(self:ObjectName(), 'Received all packets for message [%s]', messageKey)
        local encodedMessage = self:RebuildMessage(messageKey, totalPackets)
        local fullMessage = inMessageTag == XF.Enum.Tag.LOCAL and XFO.Chat:DecodeMessage(encodedMessage) or XFO.BNet:DecodeMessage(encodedMessage)
        try(function ()
            XFO.Mailbox:Process(fullMessage, inMessageTag)
        end).
        finally(function ()
            XFO.Mailbox:Push(fullMessage)
        end)
    end
end
--#endregion