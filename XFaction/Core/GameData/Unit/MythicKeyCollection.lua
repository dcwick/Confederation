local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'MythicKeyCollection'

XFC.MythicKeyCollection = XFC.ObjectCollection:newChildConstructor()

-- Additional logic exists in Mainline branch

--#region Constructors
function XFC.MythicKeyCollection:new()
    local object = XFC.MythicKeyCollection.parent.new(self)
    object.__name = ObjectName
    return object
end
--#endregion

--#region Methods
function XFC.MythicKeyCollection:Deserialize(inKey)
    if(not self:Contains(inKey)) then
        local mkey = XFC.MythicKey:new()
        mkey:Initialize()
        mkey:Deserialize(inKey)
        self:Add(mkey)
    end
    return self:Get(inKey)
end
--#endregion