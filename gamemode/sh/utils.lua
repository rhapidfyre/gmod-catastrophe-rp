--[[
	Credit: [GOTR]Mechwarrior001
]]

local function CheckExt(File, Prc, Exts)
	if ((not istable(Exts)) or tobool(Exts[string.GetExtensionFromFilename(File)])) then
		Prc(File)
	end
end

local function ProcDirs(Dir, Prc, Path)
	local Files, Dirs = file.Find(Dir.."/*", Path)

	if (istable(Files) and (#Files > 0)) then
		for _, File in ipairs(Files) do
			CheckExt(Dir.."/"..File, Prc, Exts)
		end
	end

	if (istable(Dirs) and (#Dirs > 0)) then
		table.RemoveByValue(Dirs, "/")

		for _, Subdir in ipairs(Dirs) do
			ProcDirs(Dir.."/"..Subdir, Prc, Path)
		end
	end
end

local function PDTAssert(Predicate, Message)
	if tobool(Predicate) then
		error(Message, 3)
	end
end

--[[
	ProcDirTree

	Process Directory Tree
	Finds all files in a directory tree and passes their file path as an argument to the specified function

	string Dir		- Directory to parse
	string Path		- Engine mount path
	function Prc	- Function to pass filepaths to
	table Exts		- Optional table containing a whitelist of file extensions to process; Syntax is in the form of: { ["ext"] = true, }
--]]
function ProcDirTree(Dir, Path, Prc, Exts)
	PDTAssert(not isstring(Dir), "String expected for directory argument to ProcDirTree")
	PDTAssert(not isstring(Path), "String expected for engine path argument to ProcDirTree")
	PDTAssert(not isfunction(Prc), "Function expected for processor argument to ProcDirTree")
	PDTAssert((Exts ~= nil) and (not istable(Exts)), "Table or nil expected for whitelist argument to ProcDirTree")

	local Files, Dirs = file.Find(Dir.."/*", Path)
	table.RemoveByValue(Dirs, "/")

	for _, File in ipairs(Files) do
		CheckExt(Dir.."/"..File, Prc, Exts)
	end

	for _, Dir2 in ipairs(Dirs) do
		ProcDirs(Dir.."/"..Dir2, Prc, Path)
	end
end
