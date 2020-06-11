--// Written by ReturnedTrue and sebi210

--// Constants
local LIB_NAME = "DebounceLib";
local ERR_START = string.format("\n[%s] - ", LIB_NAME);
local WAS_NOT_GIVEN = ERR_START .. "Argument %d of type %s in %s was not given yet is required";
local WRONG_TYPE = ERR_START .. "Argument %d of type %s in %s is the incorrect type of %s";
local WRONG_CLASS = ERR_START .. "Argument %d of class %s in %s is the incorrect class of %s"

--// Variables
local Internals = {};

--// Functions
function Internals.TypeCheck(Values, Types, Required, FunctionName)
    for i, Type in ipairs(Types) do
        if (Values[i] ~= nil) then
            if (string.sub(Type, 1, 1) == "i") then
                assert(Values[i]:IsA(string.sub(Type, 2, -1)), string.format(WRONG_CLASS, i, Type, FunctionName, Values[i].ClassName));
            else
                assert(Type == typeof(Values[i]), string.format(WRONG_TYPE, i, Type, FunctionName, typeof(Values[i])));
            end
            
        elseif (i <= Required) then
            error(string.format(WAS_NOT_GIVEN, i, Type, FunctionName));
        end
    end
end

function Internals.GetLibName()
    return LIB_NAME;
end

function Internals.GetErrStart()
    return ERR_START;
end

--// Init
return Internals;