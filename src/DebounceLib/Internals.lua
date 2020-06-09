--// Written by ReturnedTrue and sebi210

--// Constants
local LIB_NAME = "DebounceLib";
local ERR_START = string.format("[%s] - ", LIB_NAME);
local WAS_NOT_GIVEN = ERR_START .. "Argument %d of type %s in %s was not given yet is required!";
local WRONG_TYPE = ERR_START .. "Argument %d of type %s in %s is the incorrect type of %s!";

--// Variables
local Internals = {};

--// Functions
function Internals.TypeCheck(Values, Types, Required, FunctionName)
    for i, Type in ipairs(Types) do
        assert(i <= Required and Values[i] == nil, string.format(WAS_NOT_GIVEN, i, Type, FunctionName, typeof(Values[i])));
        assert(not typeof(Type) == typeof(Values[i]), string.format(WRONG_TYPE, i, Type, FunctionName));
    end
end

--// Init
return Internals;