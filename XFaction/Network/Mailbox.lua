local XFG, G = unpack(select(2, ...))
local ObjectName = 'Mailbox'
local LogCategory = 'NMailbox'

Mailbox = {}

function Mailbox:new()
    _Object = {}
    setmetatable(_Object, self)
    self.__index = self
    self.__name = ObjectName

    self._Key = nil
    self._Messages = {}
    self._MessageCount = 0
    self._Initialized = false

    return _Object
end

function Mailbox:Initialize()
	if(self:IsInitialized() == false) then
		self:SetKey(math.GenerateUID())
		self:IsInitialized(true)
	end
	return self:IsInitialized()
end

function Mailbox:IsInitialized(inBoolean)
	assert(inBoolean == nil or type(inBoolean) == 'boolean', "argument must be nil or boolean")
	if(inBoolean ~= nil) then
		self._Initialized = inBoolean
	end
	return self._Initialized
end

function Mailbox:Print()
	XFG:DoubleLine(LogCategory)
	XFG:Debug(LogCategory, ObjectName .. " Object")
	XFG:Debug(LogCategory, "  _Key (" .. type(self._Key) .. "): ".. tostring(self._Key))
	XFG:Debug(LogCategory, "  _MessageCount (" .. type(self._FriendCount) .. "): ".. tostring(self._FriendCount))
	XFG:Debug(LogCategory, "  _Initialized (" .. type(self._Initialized) .. "): ".. tostring(self._Initialized))
	for _, _Message in self:Iterator() do
		_Message:Print()
	end
end

function Mailbox:GetKey()
    return self._Key
end

function Mailbox:SetKey(inKey)
    assert(type(inKey) == 'string')
    self._Key = inKey
    return self:GetKey()
end

function Mailbox:Contains(inKey)
	assert(type(inKey) == 'string')
	return self._Messages[inKey] ~= nil
end

function Mailbox:AddMessage(inKey)
    assert(type(inKey) == 'string')
	if(not self:Contains(inKey)) then
		self._MessageCount = self._MessageCount + 1
	end
	self._Messages[inKey] = GetServerTime()
	return self:Contains(inKey)
end

function Mailbox:RemoveMessage(inKey)
	assert(type(inKey) == 'string')
	if(self:Contains(inKey)) then
		self._Messages[inKey] = nil
		self._MessageCount = self._MessageCount - 1
	end
	return not self:Contains(inKey)
end

function Mailbox:Purge(inEpochTime)
	assert(type(inEpochTime) == 'number')
	for _Key, _InsertTime in self:Iterator() do
		if(_InsertTime < inEpochTime) then
			self:RemoveMessage(_Key)
		end
	end
end

function Mailbox:Iterator()
	return next, self._Messages, nil
end
