local XFG, G = unpack(select(2, ...))
local ObjectName = 'SystemEvent'

SystemEvent = Object:newChildConstructor()

function SystemEvent:new()
    local object = SystemEvent.parent.new(self)
    object.__name = ObjectName
    return object
end

function SystemEvent:Initialize()
	if(not self:IsInitialized()) then
        self:ParentInitialize()
        XFG.Hooks:Add('ReloadUI', 'ReloadUI', XFG.Handlers.SystemEvent.CallbackReloadUI)
        XFG.Events:Add('Logout', 'PLAYER_LOGOUT', XFG.Handlers.SystemEvent.CallbackLogout, true, true)        
        XFG.Events:Add('LoadScreen', 'PLAYER_ENTERING_WORLD', XFG.Handlers.SystemEvent.CallbackLogin, true, true)
        ChatFrame_AddMessageEventFilter('CHAT_MSG_SYSTEM', XFG.Handlers.SystemEvent.ChatFilter)
        XFG:Info(ObjectName, 'Created CHAT_MSG_SYSTEM event filter')
		self:IsInitialized(true)
	end
end

function SystemEvent:CallbackLogout()
    if(XFG.Cache.UIReload) then 
        -- Backup cache on reload to be restored
        _G.XFCacheDB = XFG.Cache
    else
        local message = nil
        try(function ()        
            message = XFG.Mailbox.Chat:Pop()
            message:Initialize()
            message:SetType(XFG.Settings.Network.Type.BROADCAST)
            message:SetSubject(XFG.Settings.Network.Message.Subject.LOGOUT)
            if(XFG.Player.Unit:IsAlt() and XFG.Player.Unit:HasMainName()) then
                message:SetMainName(XFG.Player.Unit:GetMainName())
            end
            message:SetGuild(XFG.Player.Guild)
            message:SetRealm(XFG.Player.Realm)
            message:SetUnitName(XFG.Player.Unit:GetName())
            message:SetData(' ')
            XFG.Mailbox.Chat:Send(message)
        end).
        catch(function (inErrorMessage)
            XFG.Cache.Errors[#XFG.Cache.Errors + 1] = 'Failed to send logoff message: ' .. inErrorMessage
        end).
        finally(function ()
            _G.XFCacheDB = nil
            XFG.Mailbox.Chat:Push(message)            
        end)
    end    
end

function SystemEvent:CallbackReloadUI()
    XFG.Cache.UIReload = true
end

function SystemEvent:CallbackLogin()
    if(XFG.Channels:HasLocalChannel()) then
        XFG.Channels:SetLast(XFG.Channels:GetLocalChannel():GetKey())
    end
end

function SystemEvent:ChatFilter(inEvent, inMessage, ...)
    if(string.find(inMessage, XFG.Settings.Frames.Chat.Prepend)) then
        inMessage = string.gsub(inMessage, XFG.Settings.Frames.Chat.Prepend, '')
        return false, inMessage, ...
    -- Hide Blizz login/logout messages, we display our own, this is a double notification
    elseif(string.find(inMessage, XFG.Lib.Locale['CHAT_LOGIN'])) then
        return true
    elseif(string.find(inMessage, XFG.Lib.Locale['CHAT_LOGOUT'])) then
        return true
    elseif(string.find(inMessage, XFG.Lib.Locale['CHAT_JOIN_GUILD'])) then
        return true 
    end
    return false, inMessage, ...
end