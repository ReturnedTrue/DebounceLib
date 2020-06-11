# Getting Started
From requiring this module you get the 'Lib' object, this has the init method which returns DebounceLib and all of it's methods.


Within init you can pass the Folder you want to hold the events inside, otherwise it will create a 'DebounceLib_Events' Folder in ReplicatedStorage. For example with a Folder within this Script:
```lua
local Lib = require(game:GetService("ReplicatedStorage").DebounceLib);
local DebounceLib = Lib.init(script.Folder);
```

___

# Creating your first event
This very simple, and in this example we're going to use Heartbeat but only make it run every 1 second, we'll also name it 'MyEvent'. Then we can Connect directly on the returned event:
```lua
DebounceLib:CreateEvent(game:GetService("RunService").Heartbeat, 1, "MyEvent"):Connect(function(DeltaTime)
    print("This will only print every 1 second!");
end)
```

___

# Reaching events in other scripts
If your Script is the same type as the one you created the event within, you can actually use it in that Script. Be sure to use WaitForEvent as it may not exist yet, but if you are certain then you can use GetEvent. As an example:
```lua
DebounceLib:WaitForEvent("MyEvent"):Connect(function()
    print("This too will only print every 1 second!");
end)
```

___

# What next?
Be sure to head over to the API-reference to checkout more handy methods. Thank you for using DebounceLib!
