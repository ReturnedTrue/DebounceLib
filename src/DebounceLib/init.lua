--// Written by ReturnedTrue and sebi210

--// Dependencies
local ReplicatedStorage = game:GetService("ReplicatedStorage");

--// Modules
local Internals = require(script.Internals);

--// Constants
local FOLDER_DEFAULT_NAME = string.format("%s_Events", Internals.GetLibName());
local EVENT_DEFAULT_NAME = "Event_%d";
local ERR_START = Internals.GetErrStart();
local ALREADY_EXISTS = ERR_START .. "Event of Name %s already exists";
local DOES_NOT_EXIST = ERR_START .. "Event of Name %s doesn't exist";

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
    Internals.TypeCheck({Event, Time, Name}, {"RBXScriptSignal", "number", "string"}, 2, "GetEvent");

    if (Name) then
        assert(not self.Folder:FindFirstChild(Name), string.format(ALREADY_EXISTS, Name));
    else
        Name = string.format(EVENT_DEFAULT_NAME, #self.Folder:GetChildren());
    end

    local Bindable = Instance.new("BindableEvent");
    Bindable.Name = Name;

    local Debounce = Instance.new("NumberValue");
    Debounce.Name = "Debounce";
    Debounce.Parent = Bindable;

    local Delete = Instance.new("BindableEvent");
    Delete.Name = "Delete";
    Delete.Parent = Bindable;

    local Connection = Event:Connect(function(...)
        if ((tick() - Debounce.Value) >= Time) then
            Debounce.Value = tick();
            Bindable:Fire(...);
        end
    end)

    Delete.Event:Connect(function()
        Connection:Disconnect();
        Bindable:Destroy();
    end)

    Bindable.Parent = self.Folder;

    return Bindable.Event;
end

function DebounceLib:GetEvent(Name)
    Internals.TypeCheck({Name}, {"string"}, 1, "GetEvent");
    assert(self.Folder:FindFirstChild(Name), string.format(DOES_NOT_EXIST, Name));
    
    return self.Folder[Name].Event;
end

function DebounceLib:DestroyEvent(Name)
    Internals.TypeCheck({Name}, {"string"}, 1, "DestroyEvent");
    assert(self.Folder:FindFirstChild(Name), string.format(DOES_NOT_EXIST, Name));
    
    local Delete = self.Folder[Name]:FindFirstChild("Delete");

    if (Delete) then
        Delete:Fire();
    end
end

function DebounceLib:DestroyAllEvents()
    for _, Event in ipairs(self.Folder:GetChildren()) do
        self:DestroyEvent(Event.Name);
    end
end

function DebounceLib:ResetDebounce(Name)
    Internals.TypeCheck({Name}, {"string"}, 1, "ResetDebounce");
    assert(self.Folder:FindFirstChild(Name), string.format(DOES_NOT_EXIST, Name));

    self.Folder[Name].Debounce.Value = 0;
end

function DebounceLib:ResetAllDebounces()
    for _, Event in ipairs(self.Folder:GetChildren()) do
        self:ResetDebounce(Event.Name);
    end
end

--// Init
return DebounceLib;