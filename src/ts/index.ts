// Written by ReturnedTrue

// Services
const ReplicatedStorage = game.GetService("ReplicatedStorage");

// Constants
const LIB_NAME = "DebounceLib";
const ERR_START = "\n[" + LIB_NAME + "] - ";
const ALREADY_EXISTS = ERR_START + "Event of Name %s already exists";
const DOES_NOT_EXIST = ERR_START + "Event of Name %s doesn't exist";
const DEFAULT_FOLDER_NAME = LIB_NAME + "_Events";
const EVENT_DEFAULT_NAME = "Event_%d";

// Class
export class DebounceLib {
    public readonly folder: Folder;

    constructor(folder?: Folder) {
        if (!folder) {
            const alreadyMade = ReplicatedStorage.FindFirstChild(DEFAULT_FOLDER_NAME) as Folder | undefined;

            if (alreadyMade) {
                folder = alreadyMade;

            } else {
                folder = new Instance("Folder");
                folder.Name = DEFAULT_FOLDER_NAME;
                folder.Parent = ReplicatedStorage;
            }
        }

        this.folder = folder;
    }

    public createEvent(event: RBXScriptSignal, time: number, name?: string) {
        if (name) {
            assert(!this.folder.FindFirstChild(name), ALREADY_EXISTS.format(name));

        } else {
            name = EVENT_DEFAULT_NAME.format(this.folder.GetChildren().size());
        }

        const bindable = new Instance("BindableEvent");
        bindable.Name = name;

        const debounce = new Instance("NumberValue");
        debounce.Name = "Debounce";
        debounce.Parent = bindable;

        const del = new Instance("BindableEvent");
        del.Name = "Delete";
        del.Parent = bindable;

        const connection = event.Connect((...args: unknown[]) => {
            if ((tick() - debounce.Value) >= time) {
                debounce.Value = tick();
                bindable.Fire(...args);
            }
        });

        del.Event.Connect(() => {
            connection.Disconnect();
            bindable.Destroy();
        });

        bindable.Parent = this.folder;

        return bindable.Event;
    }
}

export default DebounceLib;