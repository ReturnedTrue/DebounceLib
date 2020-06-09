--// Written by ReturnedTrue and sebi210

--// Modules
local Internals = require(script.Internals);

--// Class
local DebounceLib = {};
DebounceLib.__index = DebounceLib;

--// Class functions
function DebounceLib.init()
    return setmetatable({
        Debounces = {};
    }, DebounceLib);
end

function DebounceLib:GetEvent(Event, Time, Name)
    --// TODO
end

function DebounceLib:DestroyDebounce(Key)
    assert(self.Folder:FindFirstChild(Key), "The Key you have entered does not exist!!")
    self.Folder[Key]:FindFirstChild("Debounce").Value = 0;
end

--// Init
return DebounceLib;