# API-reference
Reading this reference is simple, it's very similar to others you've probably seen. For example:
```lua
Class:Method(StringParameter : string, OptionalFolderParameter? : Instance<Folder>) -> ReturnType
```

___

# Lib.init
```lua
Lib.init(Folder? : Instance<Folder>) -> DebounceLib
```

!!! info
    'Lib' is what's returned from require()'ing the module, this init method returns the DebounceLib class.

___

# DebounceLib:CreateEvent
```lua
DebounceLib:CreateEvent(Event : RBXScriptSignal, Time : number, Name? : string) -> RBXScriptSignal
```

!!! Tip
    An RBXScriptSignal, or know as event, has the Connect method so you can directly Connect off of using this method.
    Also, Name defaults to Event_n, with n changing to how many events are in the current Folder.

___

# DebounceLib:GetEvent
```lua
DebounceLib:GetEvent(Name : string) -> RBXScriptSignal
```

!!! warning
    Only use GetEvent if you're definitely certain it exists already, if not please use WaitForEvent below.

___

# DebounceLib:WaitForEvent
```lua
DebounceLib:WaitForEvent(Name : string) -> RBXScriptSignal
```

___

# DebounceLib:DestroyEvent
```lua
DebounceLib:DestroyEvent(Name : string) -> void
```

!!! warning
    Destroying the event disallows you from using it again and Disconnects the Connection.

___

# DebounceLib:DestroyAllEvents
```lua
DebounceLib:DestroyAllEvents() -> void
```

___

# DebounceLib:ResetDebounce
```lua
DebounceLib:ResetDebounce(Name : string) -> void
```

!!! info
    This resets the last time it was used so it can be ran immediately again.

___

# DebounceLib:ResetAllDebounces
```lua
DebounceLib:ResetAllDebounces() -> void
```


