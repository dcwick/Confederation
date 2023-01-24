local XFG, G = unpack(select(2, ...))
local ObjectName = 'Config.ChangeLog'

XFG.ChangeLog['4.3.3'] = {
    Improvements = {
        order = 1,
        type = 'group',
        name = XFG.Lib.Locale['IMPROVEMENTS'],
        guiInline = true,
        args = {
            One = {
                order = 1,
                type = 'description',
                fontSize = 'medium',
                name = 'Bumped toc to 100005.',
            },
            Bar1 = {
                order = 2,
                name = '',
                type = 'header'
            },
            Two = {
                order = 3,
                type = 'description',
                fontSize = 'medium',
                name = 'Attempt at hiding the login spam when someone realm transfers.',
            },
            Bar2 = {
                order = 4,
                name = '',
                type = 'header'
            },
            Three = {
                order = 5,
                type = 'description',
                fontSize = 'medium',
                name = 'Better performance on local guild scans. Should see lower memory and CPU fluctuations from XF caused by Blizz spamming GUILD_ROSTER_UPDATE events.',
            },
            Bar3 = {
                order = 6,
                name = '',
                type = 'header'
            },
            Four = {
                order = 7,
                type = 'description',
                fontSize = 'medium',
                name = 'Similarly better performance on BNet friend scans from Blizz spamming BN_FRIEND_INFO_CHANGED.',
            },
        }
    },			
}