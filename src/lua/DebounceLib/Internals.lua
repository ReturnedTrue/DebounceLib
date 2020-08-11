--// Written by ReturnedTrue and sebi210

--// Constants
local LIB_NAME = "DebounceLib";
local ERR_START = "\n[" .. LIB_NAME .. "] - ";
local WAS_NOT_GIVEN = ERR_START .. "Argument %d of type %s in %s was not given yet is required";
local WRONG_TYPE = ERR_START .. "Argument %d of type %s in %s is the incorrect type of %s";
local WRONG_CLASS = ERR_START .. "Argument %d of class %s in %s is the incorrect class of %s";
local WRONG_CLASS_TYPE = ERR_START .. "Argument %d of class %s in %s is the incorrect type of %s";

--// Variables
local Internals = {
    LibName = LIB_NAME;
    ErrStart = ERR_START;
};

--// Functions
function Internals.TypeCheck(Values, Types, Required, FunctionName)
    for i, Type in ipairs(Types) do
        if (Values[i] ~= nil) then
            if (string.sub(Type, 1, 1) == "i") then
                local Class = string.sub(Type, 2, -1);

                if (typeof(Values[i]) == "Instance") then
                    assert(Values[i]:IsA(Class), string.format(WRONG_CLASS, i, Class, FunctionName, Values[i].ClassName));
                else
                    error(string.format(WRONG_CLASS_TYPE, i, Class, FunctionName, typeof(Values[i])))
                end
            else
                assert(Type == typeof(Values[i]), string.format(WRONG_TYPE, i, Type, FunctionName, typeof(Values[i])));
            end

        elseif (i <= Required) then
            error(string.format(WAS_NOT_GIVEN, i, Type, FunctionName));
        end
    end
end

--// Init
return Internals;