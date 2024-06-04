local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'ChannelCollection'

XFC.ChannelCollection = XFC.ObjectCollection:newChildConstructor()

--#region Constructors
function XFC.ChannelCollection:new()
    local object = XFC.ChannelCollection.parent.new(self)
	object.__name = ObjectName
	object.localChannel = nil
	object.guildChannel = nil
    return object
end

function XFC.ChannelCollection:Initialize()
	if(not self:IsInitialized()) then
		self:ParentInitialize()
        
		if(XF.Player.Realm:GetGuildCount() > 1) then
			if(XF.Cache.Channel.Name ~= nil and XF.Cache.Channel.Password ~= nil) then
				try(function ()
					XFF.ChatJoinChannel(XF.Cache.Channel.Name, XF.Cache.Channel.Password)
					XF:Info(self:ObjectName(), 'Joined confederate channel [%s]', XF.Cache.Channel.Name)
				end).
				catch(function (err)
					XF:Error(self:ObjectName(), err)
				end)
			end

			XFO.Events:Add({
				name = 'ChannelLeft', 
				event = 'CHAT_MSG_CHANNEL_LEAVE', 
				callback = XFO.Channels.CallbackUnitLeftChannel, 
				instance = true
			})

			XFO.Events:Add({
				name = 'ChannelChange', 
				event = 'CHAT_MSG_CHANNEL_NOTICE', 
				callback = XFO.Channels.CallbackSync,
				groupDelta = 3,
				instance = true
			})

			XFO.Events:Add({
				name = 'ChannelColor', 
				event = 'UPDATE_CHAT_COLOR', 
				callback = XFO.Channels.CallbackUpdateColor, 
				instance = true
			})
		end

		local channel = XFC.Channel:new()
		channel:Initialize()
		channel:Name('GUILD')
		channel:Key('GUILD')
		self:Add(channel)

		self:IsInitialized(true)
	end
end
--#endregion

--#region Properties
function XFC.ChannelCollection:LocalChannel(inChannel)
    assert(type(inChannel) == 'table' and inChannel.__name == 'Channel' or inChannel == nil)
	if(inChannel ~= nil) then
    	self.localChannel = inChannel
	end
	return self.localChannel
end

function XFC.ChannelCollection:GuildChannel(inChannel)
    assert(type(inChannel) == 'table' and inChannel.__name == 'Channel' or inChannel == nil)
	if(inChannel ~= nil) then
    	self.guildChannel = inChannel
	end
	return self.guildChannel
end
--#endregion

--#region Methods
function XFC.ChannelCollection:Print()
	self:ParentPrint()
	XF:Debug(self:ObjectName(), '  localChannel (' .. type(self.localChannel) .. ')')
	XF:Debug(self:ObjectName(), '  guildChannel (' .. type(self.guildChannel) .. ')')
	if(self:HasLocalChannel()) then self:LocalChannel():Print() end
end

function XFC.ChannelCollection:Get(inKey)
	assert(type(inKey) == 'number' or type(inKey) == 'string')
	if(type(inKey) == 'string') then
		return self.parent.Get(self, inKey)
	end
	for _, channel in self:Iterator() do
		if(channel:ID() == inKey) then
			return channel
		end
	end
end

function XFC.ChannelCollection:SetLast(inKey)
	if(not XF.Config.Chat.Channel.Last) then return end
	if(not self:Contains(inKey)) then return end
	
	local channel = self:Get(inKey)
	for i = channel:ID() + 1, XF.Settings.Network.Channel.Total do
		local nextChannel = self:Get(i)
		-- Blizzard swap channel API does not work with community channels, so have to ignore them
		if(nextChannel ~= nil and not nextChannel:IsCommunity()) then
			XF:Debug(self:ObjectName(), 'Swapping [%d:%s] and [%d:%s]', channel:ID(), channel:Name(), nextChannel:ID(), nextChannel:Name()) 
			XFF.ChatSwapChannels(channel:ID(), i)
			nextChannel:ID(channel:ID())
			channel:ID(i)
		end
	end
end

function XFC.ChannelCollection:HasLocalChannel()
    return self.localChannel ~= nil
end

function XFC.ChannelCollection:VoidLocalChannel()
    self.localChannel = nil
end

function XFC.ChannelCollection:CallbackUnitLeftChannel(_, _, _, _, _, _, _, _, channelName, _, _, guid)
	local self = XFO.Channels
	if(self:HasLocalChannel()) then
		if(self:LocalChannel():Key() == channelName and XFO.Confederate:Contains(guid)) then
			local unit = XFO.Confederate:Get(guid)
			if(unit:IsOnline() and not unit:IsSameGuild()) then
				XF:Info(self:ObjectName(), 'Guild member logout via event: ' .. unit:UnitName())
                XFO.SystemFrame:DisplayLogout(unit:Name())
				XFO.Confederate:UnitOffline(guid)
			end
		end
	end	
end

function XFC.ChannelCollection:RemoveAll()
	for _, channel in self:Iterator() do
		if(not channel:IsGuild()) then
			self:Remove(channel:Key())
		end
	end
end

function XFC.ChannelCollection:CallbackSync()
	local self = XFO.Channels
	try(function ()
		self:RemoveAll()
		self:VoidLocalChannel()
		local channels = {XFF.ChatGetChannels()}
		for i = 1, #channels, 3 do
			local channelID, channelName, disabled = channels[i], channels[i+1], channels[i+2]
			local channelInfo = XFF.ChatGetChannelInfo(channelName)
			local channel = XFC.Channel:new()
			channel:Key(channelName)
			channel:Name(channelName)
			channel:ID(channelID)
			channel:IsCommunity(channelInfo.channelType == Enum.PermanentChatChannelType.Communities)
			channel:SetColor()
			self:Add(channel)
			if(channel:Name() == XF.Cache.Channel.Name) then
				self:LocalChannel(channel)
			end
		end

		if(XFO.Channels:HasLocalChannel()) then
			XFO.Channels:SetLast(XFO.Channels:LocalChannel():Key())
		end
	end).
	catch(function (err)
		XF:Warn(self:ObjectName(), err)
	end)
end

function XFC.ChannelCollection:CallbackUpdateColor(inChannel, inR, inG, inB)
	local self = XFO.Channels
	try(function ()
		if(inChannel) then
			local channelID = tonumber(inChannel:match("(%d+)$"))
			local channel = self:Get(channelID)
			if(channel ~= nil) then
				if(XF.Config.Channels[channel:Name()] == nil) then
					XF.Config.Channels[channel:Name()] = {}
				end
				XF.Config.Channels[channel:Name()].R = inR
				XF.Config.Channels[channel:Name()].G = inG
				XF.Config.Channels[channel:Name()].B = inB
				XF:Trace(self:ObjectName(), 'Captured new RGB [%f:%f:%f] for channel [%s]', inR, inG, inB, channel:Name())
			end
		end
	end).
	catch(function (err)
		XF:Error(self:ObjectName(), err)
	end)
end
--#endregion