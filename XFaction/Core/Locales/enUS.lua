local L = LibStub('AceLocale-3.0'):NewLocale('XFaction', 'enUS', true, false)

--=========================================================================
-- Generic One Word Translations
--=========================================================================
L['NAME'] = 'Name'
L['RACE'] = 'Race'
L['LEVEL'] = 'Level'
L['REALM'] = 'Realm'
L['GUILD'] = 'Guild'
L['TEAM'] = 'Team'
L['RANK'] = 'Rank'
L['ZONE'] = 'Zone'
L['NOTE'] = 'Note'
L['CLASS'] = 'Class'
L['COVENANT'] = 'Covenant'
L['CONFEDERATE'] = 'Confederate'
L['MOTD'] = 'MOTD'
L['FACTION'] = 'Faction'
L['PROFESSION'] = 'Profession'
L['SPEC'] = 'Spec'
L['ENABLE'] = 'Enable'
L['CHAT'] = 'Chat'
L['ACHIEVEMENT'] = 'Achievement'
L['DATATEXT'] = 'DataText'
L['SUPPORT'] = 'Support'
L['RESOURCES'] = 'Resources'
L['DISCORD'] = 'Discord'
L['GITHUB'] = 'GitHub'
L['DEV'] = 'Development'
L['DESCRIPTION'] = 'Description'
L['GENERAL'] = 'General'
L['DISCLAIMER'] = 'Disclaimer'
L['TRANSLATIONS'] = 'Translations'
L['FAQ'] = 'FAQ'
L['CHANNEL'] = 'Channel'
L['INDEX'] = 'Index'
L['DUNGEON'] = 'Mythic+'
L['ACHIEVEMENT_EARNED'] = 'has earned the achievement'
L['CHAT_LOGOUT'] = 'has gone offline.'
L['EXPLORE'] = 'Explore'
L['VERSION'] = 'Version'
L['MAIN'] = 'Main'
L['LABEL'] = 'Label'
L['LINKS'] = 'Links'
L['PM'] = 'Project Manager'
L['FACTION'] = 'Faction'
L['USAGE'] = 'Usage'
L['EVENT'] = 'Event'
L['FRIEND'] = 'Friend'
L['LINK'] = 'Link'
L['PLAYER'] = 'Player'
L['PROFESSION'] = 'Profession'
L['SOULBIND'] = 'Soulbind'
L['SPEC'] = 'Spec'
L['TARGET'] = 'Target'
L['TEAM'] = 'Team'
L['TIMER'] = 'Timer'
--=========================================================================
-- General (tab) Specific
--=========================================================================
L['GENERAL_DESCRIPTION'] = 'Enable roster visibility and communication between guilds of a confederation, including guilds on other realms and of a different faction.'
L['GENERAL_DISCLAIMER'] = 'This addon is in beta stage and currently only Eternal Kingdom (EK) is being supported:'
L['GENERAL_WHAT'] = 'What is included'
L['GENERAL_GUILD_CHAT'] = '1. Merged guild chat across guilds/realms/factions in the confederate'
L['GENERAL_GUILD_CHAT_ACHIEVEMENT'] = '2. Personal achievements forwarded to confederate members in other guilds'
L['GENERAL_SYSTEM_MESSAGES'] = 'System Messages'
L['GENERAL_SYSTEM_LOGIN'] = '1. Receive notification when player using the addon comes online/offline in the confederate'
L['GENERAL_DATA_BROKERS'] = 'Data Brokers'
L['GENERAL_DTGUILD'] = '1. Guild (X): Full roster visibility in the confederate'
L['GENERAL_DTLINKS'] = '2. Links (X): Visibility of the active BNet links in the confederate used by the addon'
L['GENERAL_DTSOULBIND'] = '3. Soulbind (X): View and change your active soulbind'
L['GENERAL_DTTOKEN'] = '4. WoW Token (X): View current market price of WoW tokens'
--=========================================================================
-- Channel Specific
--=========================================================================
L['CHANNEL_USAGE'] = 'This feature will only work with non-shared profiles or shared profiles with same channel setup'
L['CHANNEL_ENABLE_TOOLTIP'] = 'Force channel order'
L['CHANNEL1'] = 'Channel 1'
L['CHANNEL2'] = 'Channel 2'
L['CHANNEL3'] = 'Channel 3'
L['CHANNEL4'] = 'Channel 4'
L['CHANNEL5'] = 'Channel 5'
L['CHANNEL6'] = 'Channel 6'
L['CHANNEL7'] = 'Channel 7'
L['CHANNEL8'] = 'Channel 8'
L['CHANNEL9'] = 'Channel 9'
L['CHANNEL10'] = 'Channel 10'
--=========================================================================
-- Chat Specific
--=========================================================================
L['CHAT_CCOLOR'] = 'Customize Color'
L['CHAT_CCOLOR_TOOLTIP'] = 'Customize XFaction chat colors.'
L['CHAT_GUILD'] = 'Guild Chat'
L['CHAT_GUILD_TOOLTIP'] = 'See cross realm/faction guild chat'
L['CHAT_FACTION'] = 'Show Faction'
L['CHAT_FACTION_TOOLTIP'] = 'Show the faction icon for the sender'
L['CHAT_FCOLOR'] = 'Factionize Color'
L['CHAT_FCOLOR_TOOLTIP'] = 'Render XFaction chat in faction colors.'
L['CHAT_GUILD_NAME'] = 'Show Guild Name'
L['CHAT_GUILD_NAME_TOOLTIP'] = 'Show the guild short name for the sender'
L['CHAT_MAIN'] = 'Show Main Name'
L['CHAT_MAIN_TOOLTIP'] = 'Show the senders main name if it is an alt'
L['CHAT_FONT_COLOR'] = 'Font Color'
L['CHAT_FONT_ACOLOR'] = 'Alliance Color'
L['CHAT_FONT_HCOLOR'] = 'Horde Color'
L['CHAT_OFFICER'] = 'Officer Chat'
L['CHAT_OFFICER_TOOLTIP'] = 'See cross realm/faction officer chat'
L['CHAT_ACHIEVEMENT_TOOLTIP'] = 'See cross realm/faction individual achievements'
L['CHAT_ONLINE'] = 'Online/Offline'
L['CHAT_ONLINE_TOOLTIP'] = 'Show message for players logging in/out on other realms/faction'
L['CHAT_ONLINE_SOUND'] = 'Play Sound'
L['CHAT_ONLINE_SOUND_TOOLTIP'] = 'Play sound when any confederate member comes online'
L['CHAT_LOGIN'] = 'has come online.'
L['CHAT_LOGOUT'] = 'has gone offline.'
--=========================================================================
-- DataText Specific
--=========================================================================
L['DT_HEADER_CONFEDERATE'] = 'Confederate: |cffffffff%s|r'
L['DT_HEADER_GUILD'] = 'Guild: |cffffffff%s|r'
L['DT_CONFIG_BROKER'] = 'Show Broker Fields'
L['DT_CONFIG_LABEL_TOOLTIP'] = 'Show broker label'
L['DT_CONFIG_FACTION_TOOLTIP'] = 'Show faction counts in broker label'
-------------------------
-- DTGuild (X)
-------------------------
-- Broker name
L['DTGUILD_NAME'] = 'Guild (X)'
-- Config
L['DTGUILD_CONFIG_SORT'] = 'Default Sort Column'
L['DTGUILD_CONFIG_SIZE'] = 'Window Size'
L['DTGUILD_CONFIG_HEADER'] = 'Show Header Fields'
L['DTGUILD_CONFIG_CONFEDERATE_TOOLTIP'] = 'Show name of the confederate'
L['DTGUILD_CONFIG_GUILD_TOOLTIP'] = 'Show name of the current guild'
L['DTGUILD_CONFIG_MOTD_TOOLTIP'] = 'Show guild message-of-the-day'
L['DTGUILD_CONFIG_COLUMN_HEADER'] = 'Show Columns'
L['DTGUILD_CONFIG_COLUMN_ACHIEVEMENT_TOOLTIP'] = 'Show players total achievement points'
L['DTGUILD_CONFIG_COLUMN_COVENANT_TOOLTIP'] = 'Show players covenant icon'
L['DTGUILD_CONFIG_COLUMN_DUNGEON_TOOLTIP'] = 'Show players mythic+ score'
L['DTGUILD_CONFIG_COLUMN_FACTION_TOOLTIP'] = 'Show players faction icon'
L['DTGUILD_CONFIG_COLUMN_GUILD_TOOLTIP'] = 'Show players guild name'
L['DTGUILD_CONFIG_COLUMN_LEVEL_TOOLTIP'] = 'Show players level'
L['DTGUILD_CONFIG_COLUMN_MAIN_TOOLTIP'] = 'Show players main name if on alt'
L['DTGUILD_CONFIG_COLUMN_NOTE_TOOLTIP'] = 'Show players note'
L['DTGUILD_CONFIG_COLUMN_PROFESSION_TOOLTIP'] = 'Show players profession icons'
L['DTGUILD_CONFIG_COLUMN_RACE_TOOLTIP'] = 'Show players race'
L['DTGUILD_CONFIG_COLUMN_RANK_TOOLTIP'] = 'Show players rank'
L['DTGUILD_CONFIG_COLUMN_REALM_TOOLTIP'] = 'Show players realm name'
L['DTGUILD_CONFIG_COLUMN_SPEC_TOOLTIP'] = 'Show players spec icon'
L['DTGUILD_CONFIG_COLUMN_TEAM_TOOLTIP'] = 'Show players team name'
L['DTGUILD_CONFIG_COLUMN_VERSION_TOOLTIP'] = 'Show players XFaction version'
L['DTGUILD_CONFIG_COLUMN_ZONE_TOOLTIP'] = 'Show players current zone'
L['DTGUILD_CONFIG_SORT_TOOLTIP'] = 'Select the default sort column'
L['DTGUILD_CONFIG_SIZE_TOOLTIP'] = 'Select the maximum height of the window before it starts scrolling'
-------------------------
-- DTLinks (X)
-------------------------
-- Broker name
L['DTLINKS_NAME'] = 'Links (X)'
-- Header
L['DTLINKS_HEADER_LINKS'] = 'Active BNet Links: |cffffffff%d|r'
-------------------------
-- DTSoulbind (X)
-------------------------
-- Broker name
L['DTSOULBIND_NAME'] = 'Soulbind (X)'
-- Broker text
L['DTSOULBIND_NO_COVENANT'] = 'No Covenant'
L['DTSOULBIND_NO_SOULBIND'] = '%s No Soulbind'
-- Header
L['DTSOULBIND_ACTIVE'] = '|cffFFFFFF%s: |cff00FF00Active|r'
L['DTSOULBIND_INACTIVE'] = '|cffFFFFFF%s: |cffFF0000Inactive|r'
-- Config
L['DTSOULBIND_CONFIG_CONDUIT'] = 'Show Conduits'
L['DTSOULBIND_CONFIG_CONDUIT_TOOLTIP'] = 'Show active conduit icons'
-- Footer
L['DTSOULBIND_LEFT_CLICK'] = '|cffFFFFFFLeft Click:|r Open Soulbind Frame'
L['DTSOULBIND_RIGHT_CLICK'] = '|cffFFFFFFRight Click:|r Change Soulbind'
-------------------------
-- DTToken (X)
-------------------------
-- Broker name
L['DTTOKEN_NAME'] = 'WoW Token (X)'
--=========================================================================
-- Support Specific
--=========================================================================
L['SUPPORT_UAT'] = 'User Acceptance Testing'
L['DEBUG_PRINT'] = 'Click any button to ad-hoc print that datacollection to _DebugLog'