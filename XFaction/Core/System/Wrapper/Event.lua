local XF, G = unpack(select(2, ...))
local XFC, XFO = XF.Class, XF.Object
local ObjectName = 'Event'

XFC.Event = Object:newChildConstructor()

--#region Constructors
function XFC.Event:new()
    local object = XFC.Event.parent.new(self)
    object.__name = ObjectName
    object.callback = nil
    object.isEnabled = false
    object.inInstance = false
    object.groupDelta = 0
    return object
end
--#endregion

--#region Print
function XFC.Event:Print()
    self:ParentPrint()
    XF:Debug(ObjectName, '  callback (' .. type(self.callback) .. '): ' .. tostring(self.callback))
    XF:Debug(ObjectName, '  isEnabled (' .. type(self.isEnabled) .. '): ' .. tostring(self.isEnabled))
    XF:Debug(ObjectName, '  inInstance (' .. type(self.inInstance) .. '): ' .. tostring(self.inInstance))
    XF:Debug(ObjectName, '  groupDelta (' .. type(self.groupDelta) .. '): ' .. tostring(self.groupDelta))
end
--#endregion

--#region Accessors
function XFC.Event:GetCallback()
    return self.callback
end

function XFC.Event:SetCallback(inCallback)
    assert(type(inCallback) == 'function')
    self.callback = inCallback
end

function XFC.Event:IsEnabled(inBoolean)
    assert(inBoolean == nil or type(inBoolean) == 'boolean', 'argument needs to be nil or boolean')
    if(inBoolean ~= nil) then
        self.isEnabled = inBoolean
    end
	return self.isEnabled
end

function XFC.Event:IsInstance(inBoolean)
    assert(inBoolean == nil or type(inBoolean) == 'boolean', 'argument needs to be nil or boolean')
    if(inBoolean ~= nil) then
        self.inInstance = inBoolean
    end
	return self.inInstance
end

function XFC.Event:IsGroup()
    return self.groupDelta > 0
end

function XFC.Event:GetGroupDelta()
    return self.groupDelta
end

function XFC.Event:SetGroupDelta(inGroupDelta)
    assert(type(inGroupDelta) == 'number')
    self.groupDelta = inGroupDelta
end
--#endregion

--#region Start/Stop
function XFC.Event:Start()
    if(not self:IsEnabled()) then
        self:IsEnabled(true)
        XF:Debug(ObjectName, 'Started event listener [%s] for [%s]', self:GetKey(), self:GetName())
    end
end

function XFC.Event:Stop()
    if(self:IsEnabled()) then
        self:IsEnabled(false)
        XF:Debug(ObjectName, 'Stopped event listener [%s] for [%s]', self:GetKey(), self:GetName())
    end
end
--#endregion