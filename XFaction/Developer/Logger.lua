local XFG, G = unpack(select(2, ...))
local FormatSet = false
local VerbosityLabel = {'ERR~', 'WARN~', 'OK~', '', ''}

local function Format()
	if FormatSet == false and DLAPI and DLAPI.GetFormat and DLAPI.IsFormatRegistered then
		local fmt = DLAPI.IsFormatRegistered(DLAPI.GetFormat(XFG.Name))
		if fmt and fmt.colWidth then
			fmt.colWidth = { 0.05, 0.12, 0.1, 0.03, 1 - 0.05 - 0.12 - 0.1 - 0.03, }
			FormatSet = true
		end
	end
end

local function Log(inLevel, inSubCategory, ...)
	if(XFG.Verbosity >= inLevel) then
		local status, res = pcall(format, ...)
		if status then
			Format()
			if DLAPI then 
				DLAPI.DebugLog(XFG.Name, format('%s%s~%d~%s', VerbosityLabel[inLevel], inSubCategory, inLevel, res)) 
			end
		end
	end
end

function XFG:Error(inSubCategory, ...)
	Log(1, inSubCategory, ...)
	Log(1, inSubCategory, debugstack())
	if(XFG.Metrics ~= nil) then
		XFG.Metrics:Get(XFG.Enum.Metric.Error):Increment()
	end
end

function XFG:Warn(inSubCategory, ...)
	Log(2, inSubCategory, ...)
	Log(2, inSubCategory, debugstack())
	if(XFG.Metrics ~= nil) then
		XFG.Metrics:Get(XFG.Enum.Metric.Warning):Increment()
	end
end

function XFG:Info(inSubCategory, ...)
	Log(3, inSubCategory, ...)
end

function XFG:Debug(inSubCategory, ...)
	Log(4, inSubCategory, ...)
end

function XFG:Trace(inSubCategory, ...)
	Log(5, inSubCategory, ...)
end

local function TableToString(t, l, k)
	local ResultSet
	if type(t) == 'table' then
		ResultSet = string.format('%s%s:', string.rep(' ', l*2), tostring(k))
		for k, v in pairs(t) do
			ResultSet = ResultSet .. '\n' .. TableToString(v, l+1, k)
		end
	else
		ResultSet = string.format('%s%s:%s', string.rep(' ', l*2), tostring(k), tostring(t))
	end
	return ResultSet
end

function XFG:DataDumper(inSubCategory, ...)
	Log(4, inSubCategory, TableToString(..., 1, 'root'))
end

function XFG:SingleLine(inSubCategory)
	Log(4, inSubCategory, '-------------------------------------')
end

function XFG:DoubleLine(inSubCategory)
	Log(4, inSubCategory, '=====================================')
end