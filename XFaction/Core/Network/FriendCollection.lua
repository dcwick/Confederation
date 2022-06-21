local XFG, G = unpack(select(2, ...))
local ObjectName = 'FriendCollection'
local LogCategory = 'NCFriend'

FriendCollection = {}

function FriendCollection:new()
    _Object = {}
    setmetatable(_Object, self)
    self.__index = self
    self.__name = ObjectName

    self._Key = nil
	self._Friends = {}
	self._FriendsCount = 0
    self._Initialized = false

    return _Object
end

function FriendCollection:Initialize()
	if(self:IsInitialized() == false) then
		self:SetKey(math.GenerateUID())
		for i = 1, BNGetNumFriends() do
			self:CheckFriend(i)
		end
		self:IsInitialized(true)
	end
	return self:IsInitialized()
end

function FriendCollection:IsInitialized(inBoolean)
	assert(inBoolean == nil or type(inBoolean) == 'boolean', "argument must be nil or boolean")
	if(inBoolean ~= nil) then
		self._Initialized = inBoolean
	end
	return self._Initialized
end

function FriendCollection:Print()
	XFG:DoubleLine(LogCategory)
	XFG:Debug(LogCategory, ObjectName .. " Object")
	XFG:Debug(LogCategory, "  _Key (" .. type(self._Key) .. "): ".. tostring(self._Key))
	XFG:Debug(LogCategory, "  _FriendsCount (" .. type(self._FriendsCount) .. "): ".. tostring(self._FriendsCount))
	XFG:Debug(LogCategory, "  _Initialized (" .. type(self._Initialized) .. "): ".. tostring(self._Initialized))
	for _, _Friend in self:Iterator() do
		_Friend:Print()
	end
end

function FriendCollection:GetKey()
    return self._Key
end

function FriendCollection:SetKey(inKey)
    assert(type(inKey) == 'string')
    self._Key = inKey
    return self:GetKey()
end

function FriendCollection:Contains(inKey)
	assert(type(inKey) == 'number')
	return self._Friends[inKey] ~= nil
end

function FriendCollection:ContainsByFriendIndex(inFriendIndex)
	assert(type(inFriendIndex) == 'number')
	for _, _Friend in self:Iterator() do
		if(_Friend:GetID() == inFriendIndex) then
			return true
		end
	end
	return false
end

function FriendCollection:ContainsByGameID(inGameID)
	assert(type(inGameID) == 'number')
	for _, _Friend in self:Iterator() do
		if(_Friend:GetGameID() == inGameID) then
			return true
		end
	end
	return false
end

function FriendCollection:GetFriend(inKey)
	assert(type(inKey) == 'number')
    return self._Friends[inKey]
end

function FriendCollection:GetFriendByGameID(inGameID)
	assert(type(inGameID) == 'number')
	for _, _Friend in self:Iterator() do
		if(_Friend:GetGameID() == inGameID) then
			return _Friend
		end
	end
end

function FriendCollection:AddFriend(inFriend)
    assert(type(inFriend) == 'table' and inFriend.__name ~= nil and inFriend.__name == 'Friend', "argument must be Friend object")
	if(self:Contains(inFriend:GetKey()) == false) then
		self._FriendsCount = self._FriendsCount + 1
	end
	self._Friends[inFriend:GetKey()] = inFriend
	return self:Contains(inFriend:GetKey())
end

function FriendCollection:RemoveFriend(inKey)
	assert(type(inKey) == 'number')
	if(self:Contains(inKey)) then
		local _Friend = self:GetFriend(inKey)
		XFG.Links:RemoveNode(_Friend:GetName())
		self._FriendsCount = self._FriendsCount - 1
		self._Friends[inKey] = nil		
	end
end

function FriendCollection:Iterator()
	return next, self._Friends, nil
end

function FriendCollection:HasFriends()
    return self._FriendsCount > 0
end

local function IsLink(inAccountInfo)
	if(inAccountInfo.isFriend == true and 
	   inAccountInfo.gameAccountInfo.isOnline == true and 
	   inAccountInfo.gameAccountInfo.clientProgram == "WoW") then

	   	-- There's no need to store if they are not logged into realm/faction we care about
		local _Realm = XFG.Realms:GetRealmByID(inAccountInfo.gameAccountInfo.realmID)

		-- When a player is in Torghast, it will list realm as 0, no character name or faction
		-- Bail out before it causes an exception
		if(_Realm == nil) then return false end

		local _Faction = XFG.Factions:GetFactionByName(inAccountInfo.gameAccountInfo.factionName)
		if(XFG.Targets:Contains(_Realm, _Faction)) then
			return true
		end
	end
	return false
end

function FriendCollection:CheckFriend(inKey)
	local _AccountInfo = C_BattleNet.GetFriendAccountInfo(inKey)
	if(_AccountInfo == nil) then
		XFG:Warn(LogCategory, "Received nothing for [%d]", inKey)
		return
	end

	-- Did they go offline?
    if(self:Contains(_AccountInfo.bnetAccountID)) then
		if(IsLink(_AccountInfo) == false) then
			local _Friend = XFG.Friends:GetFriend(_AccountInfo.bnetAccountID)
			self:RemoveFriend(_Friend:GetKey())
			XFG:Info(LogCategory, "Friend went offline or to unsupported guild [%s:%d:%d:%d]", _Friend:GetTag(), _Friend:GetAccountID(), _Friend:GetID(), _Friend:GetGameID())
			return true
		end

	-- Did they come online on a supported realm/faction?
	elseif(IsLink(_AccountInfo)) then
		local _Realm = XFG.Realms:GetRealmByID(_AccountInfo.gameAccountInfo.realmID)
		local _Faction = XFG.Factions:GetFactionByName(_AccountInfo.gameAccountInfo.factionName)
		local _Target = XFG.Targets:GetTarget(_Realm, _Faction)
		local _NewFriend = Friend:new()
		_NewFriend:SetKey(_AccountInfo.bnetAccountID)
		_NewFriend:SetID(inKey)
		_NewFriend:SetAccountID(_AccountInfo.bnetAccountID)
		_NewFriend:SetGameID(_AccountInfo.gameAccountInfo.gameAccountID)
		_NewFriend:SetAccountName(_AccountInfo.accountName)
		_NewFriend:SetTag(_AccountInfo.battleTag)
		_NewFriend:SetName(_AccountInfo.gameAccountInfo.characterName)
		_NewFriend:SetTarget(_Target)
		self:AddFriend(_NewFriend)
		XFG:Info(LogCategory, "Friend logged into supported guild [%s:%d:%d:%d]", _NewFriend:GetTag(), _NewFriend:GetAccountID(), _NewFriend:GetID(), _NewFriend:GetGameID())
		-- Ping them to see if they're running the addon
		if(XFG.Initialized) then 
			XFG.BNet:PingFriend(_NewFriend) 
		end
		return true
	end
	return false
end

function FriendCollection:CheckFriends()
	local _LinksChanged = false
	for i = 1, BNGetNumFriends() do
		local _Changed = self:CheckFriend(i)
		if(_Changed) then
			_LinksChanged = true
		end
	end
	if(_LinksChanged) then
		XFG.Links:BroadcastLinks()
		XFG.DataText.Links:RefreshBroker()
	end
end

function FriendCollection:CreateBackup()
    XFG.DB.Backup.Friends = {}
    for _, _Friend in self:Iterator() do
        if(_Friend:IsRunningAddon()) then
			table.insert(XFG.DB.Backup.Friends, _Friend:GetKey())
        end
    end
end

function FriendCollection:RestoreBackup()
	if(XFG.DB.Backup == nil or XFG.DB.Backup.Friends == nil) then return end
    for _, _Key in pairs (XFG.DB.Backup.Friends) do
		if(XFG.Friends:Contains(_Key)) then
			local _Friend = XFG.Friends:GetFriend(_Key)
			_Friend:IsRunningAddon(true)
			XFG:Info(LogCategory, "  Restored %s friend information from backup", _Friend:GetTag())
		end
    end
end