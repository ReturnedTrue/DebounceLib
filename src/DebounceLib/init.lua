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

--// Init
return DebounceLib;