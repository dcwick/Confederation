local XF, G = unpack(select(2, ...))
local ObjectName = 'Config.ChangeLog'

XF.ChangeLog['5.3.5'] = {
    Improvements = {
        order = 2,
        type = 'group',
        name = XF.Lib.Locale['IMPROVEMENTS'],
        guiInline = true,
        args = {
            Keys = {
                order = 1,
                type = 'description',
                fontSize = 'medium',
                name = 'Updated Ace3 libraries to alpha versions',
            },
        },
    },		
}