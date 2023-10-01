local XF, G = unpack(select(2, ...))
local LogCategory = 'Config'

XF.Defaults = {
    profile = {
        Logout = {},
        Channels = {},      
        Chat = {
            GChat = {
                Enable = true,
                Faction = true,
                Guild = false,
                Main = true,
                FColor = false,
                CColor = false,
                Color = {
                    Red = 0.251,
                    Green = 1,
                    Blue = 0.251,
                },
                AColor = {
                    Red = 0.216,
                    Green = 0.553,
                    Blue = 0.937,
                },
                HColor = {
                    Red = 0.878,
                    Green = 0,
                    Blue = 0.051,
                },
            },
            Achievement = {
                Enable = true,
                Faction = true,
                Guild = false,
                Main = true,
                FColor = false,
                CColor = false,
                Color = {
                    Red = 0.251,
                    Green = 1,
                    Blue = 0.251,
                },
                AColor = {
                    Red = 0.216,
                    Green = 0.553,
                    Blue = 0.937,
                },
                HColor = {
                    Red = 0.878,
                    Green = 0,
                    Blue = 0.051,
                },
            },
            Login = {
                Enable = true,
                Sound = true,
                Faction = true,
                Guild = true,
                Main = true,
            },
            Channel = {
                Last = true,
                Color = true,
            },
            Crafting = {
                Enable = true,
                GuildOrder = true,
                PersonalOrder = true,
                Faction = true,
                Main = true,
                Guild = true,
                Profession = true,
            },
        },
        Addons = {
            ElvUI = {
                Enable = true,
                ConfederateTag = '[xf:confederate]',
                ConfederateInitialsTag = '[xf:confederate:initials]',
                GuildInitialsTag = '[xf:guild:initials]',
                MainTag = '[xf:main]',
                MainParenthesisTag = '[xf:main:parenthesis]',
                TeamTag = '[xf:team]',
                MemberIcon = '[xf:confederate:icon]',
            },
            Kui = {
                Enable = true,
                Icon = true,
                GuildName = 'Confederate',
                Hide = false,
            },
        },
        DataText = {
            Font = XF.Lib.LSM:GetDefault('font'),
            FontSize = 10,
            Guild = {
                Column = '',
                Label = false,
                GuildName = true,
                Confederate = true,
                MOTD = true,
                Main = true,
                Enable = {                    
                    Achievement = false,
                    Dungeon = false,
                    Faction = true,
                    Guild = true,
                    Level = true,
                    Name = true,
                    Note = false,
                    Profession = true,
                    PvP = false,
                    Race = true,
                    Rank = true,
                    Realm = false,
                    Spec = true,
                    Team = true,
                    Zone = true,
                    Raid = true,
                    Version = false,
                    ItemLevel = false,
                },
                Order = {
                    AchievementOrder = 0,
                    DungeonOrder = 0,
                    FactionOrder = 1,
                    GuildOrder = 6,
                    ItemLevelOrder = 0,
                    LevelOrder = 2,
                    NameOrder = 4,
                    NoteOrder = 0,
                    ProfessionOrder = 11,
                    PvPOrder = 0,
                    RaceOrder = 5,
                    RaidOrder = 8,
                    RankOrder = 9,
                    RealmOrder = 0,
                    SpecOrder = 3,
                    TeamOrder = 7,
                    VersionOrder = 0,
                    ZoneOrder = 10,
                },
                Alignment = {
                    AchievementAlignment = 'Center',
                    FactionAlignment = 'Center',
                    GuildAlignment = 'Left',
                    ItemLevelAlignment = 'Center',
                    LevelAlignment = 'Center',
                    DungeonAlignment = 'Center',
                    NameAlignment = 'Left',
                    NoteAlignment = 'Left',
                    ProfessionAlignment = 'Center',
                    PvPAlignment = 'Center',
                    RaceAlignment = 'Left',
                    RaidAlignment = 'Center',
                    RankAlignment = 'Left',
                    RealmAlignment = 'Left',
                    SpecAlignment = 'Center',
                    TeamAlignment = 'Left',
                    VersionAlignment = 'Center',
                    ZoneAlignment = 'Center',
                },                
                Sort = 'Team',
                Size = 350,
            },
            Link = {
                Label = false,
                Faction = true,
            },
            Metric = {
                Rate = 60,
                Total = false,
                Average = true,
                Error = true,
                Warning = true,
            },
            Orders = {
                Column = '',
                Label = false,
                GuildName = true,
                Confederate = true,
                Main = true,
                Enable = {
                    Guild = true,
                    Profession = true,
                    Item = true,
                    Customer = true,
                },
                Order = {
                    ProfessionOrder = 1,                    
                    CustomerOrder = 3,
                    ItemOrder = 2,
                    GuildOrder = 4,
                },
                Alignment = {
                    ProfessionAlignment = 'Center',
                    ItemAlignment = 'Left',
                    GuildAlignment = 'Left',
                    CustomerAlignment = 'Left',
                },                
                Sort = 'Customer',
                Size = 350,
            },
        },
        Debug = {
            Verbosity = 0,
        },
    }
}