--// Written by ReturnedTrue and sebi210

--// Dependencies
local ReplicatedStorage = game:GetService("ReplicatedStorage");

--// Modules
local Internals = require(script.Internals);

--// Constants
local FOLDER_DEFAULT_NAME = string.format("%s_Events", Internals.GetLibName());
local EVENT_DEFAULT_NAME = "Event_%d";
local ERR_START = Internals.GetErrStart();
local ALREADY_EXISTS = ERR_START .. "Event of Name %s already exists!";

--// Class
local DebounceLib = {};
DebounceLib.__index = DebounceLib;

--// Class functions
function DebounceLib.init(Folder)
    Internals.TypeCheck({Folder}, {"iFolder"}, 0, "init");

    if (not Folder) then
        if (ReplicatedStorage:FindFirstChild(FOLDER_DEFAULT_NAME)) then
            Folder = ReplicatedStorage[FOLDER_DEFAULT_NAME];
        else
            Folder = Instance.new("Folder");
            Folder.Name = FOLDER_DEFAULT_NAME;
            Folder.Parent = ReplicatedStorage;            
        end
    end

    return setmetatable({
        Folder = Folder;
    }, DebounceLib);
end

function DebounceLib:CreateEvent(Event, Time, Name)
    Internals.TypeCheck({Event, Time, Name}, {"iRBXScriptSignal", "number", "string"}, 2, "GetEvent");

    if (Name) then
        assert(self.Folder:FindFirstChild(Name), string.format(ALREADY_EXISTS, Name));
    else
        Name = string.format(EVENT_DEFAULT_NAME, self.Folder:GetChildren());
    end

    local Bindable = Instance.new("BindableEvent");
    Bindable.Name = Name;

    local Debounce = Instance.new("NumberValue");
    Debounce.Name = "Debounce";
    Debounce.Parent = Bindable;

    Event:Connect(function(...)
        if ((tick() - Debounce.Value) >= Time) then
            Bindable:Fire(...);
        end
    end)

    Bindable.Parent = self.Folder;

    return Bindable.Event;
end

--// Init
return DebounceLib;