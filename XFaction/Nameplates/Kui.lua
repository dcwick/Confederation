local XFG, G = unpack(select(2, ...))
local ObjectName = 'KuiNameplate'
local LogCategory = 'NPKui'

KuiNameplate = Nameplate:newChildConstructor()

function KuiNameplate:new()
    local _Object = KuiNameplate.parent.new(self)
    self._Kui = nil
    self.__name = ObjectName
    return _Object
end

function KuiNameplate:Initialize()
    if(not self:IsInitialized()) then
        self._Kui = KuiNameplates:NewPlugin(XFG.Title)

        function self._Kui:Show(inPlateFrame)
            inPlateFrame:StripTextures()

            if(XFG.Config and XFG.Config.Nameplates.Kui.Enable) then
                local _GUID = UnitGUID(inPlateFrame.unit)  
                if(XFG.Confederate:Contains(_GUID)) then
                    if(XFG.Config.Nameplates.Kui.GuildName == 'Confederate') then
                        inPlateFrame.state.guild_text = XFG.Confederate:GetName()
                    end

                    if(XFG.Config.Nameplates.Kui.Icon) then
                        local _Texture = inPlateFrame:CreateTexture()
                        _Texture:SetTexture(1981967)
                        _Texture:SetTexCoord(0.2216796875, 0.2451171875, 0.947265625, 0.994140625);
                        _Texture:SetHeight(17)
                        _Texture:SetWidth(17)
                        _Texture:SetPoint('LEFT', inPlateFrame.NameText, 'RIGHT')
                        inPlateFrame.XFaction = _Texture
                    end
                end
            end
        end

        self._Kui:RegisterMessage('Show')

        self:IsInitialized(true)
	end
	return self:IsInitialized()
end

function KuiNameplate:StripIcons()
    for _, _Frame in pairs (C_NamePlate.GetNamePlates()) do
        if(_Frame and _Frame.unitFrame) then
			local _Plate = _Frame.unitFrame
            _Plate:StripTextures()
        end
    end
end