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

// Types
type UndefinedBindable = BindableEvent | undefined;
type UndefinedNumberValue = NumberValue | undefined;

// Class
export class DebounceLib {
    private readonly folder: Folder;

    /** 
     * @constructor Create a DebounceLib instance with all the methods
     * @param folder Optional, holds all the debounced events inside
     * @returns The DebounceLib instance which uses the supplied Folder or a default one
    */
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

    /** 
     * @createEvent Create a debounced event from an existing event
     * @param event The existing event to apply a debounce upon
     * @param time The amount of time the debounce should last
     * @param name Optional, the name of the event which can be used in getEvent / waitForEvent
     * @returns An RBXScriptSignal which can be Connected or Waited on
    */
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

    /** 
     * @getEvent Grab an event of the given name, please use waitForEvent if you aren't sure that it'll exist
     * @param name The name of the event
     * @returns An RBXScriptSignal which can be Connected or Waited on
    */
    public getEvent(name: string) {
        return this._getEventInstance(name).Event;
    }

    /** 
     * @waitForEvent Wait for an event of the given name
     * @param name The name of the event
     * @returns An RBXScriptSignal which can be Connected or Waited on
    */
    public waitForEvent(name: string) {
        const found = this.folder.WaitForChild(name) as BindableEvent;

        return found.Event;
    }

    /** 
     * @destroyEvent Destroy an event of the given name which removes all connections
     * @param name The name of the event
    */
    public destroyEvent(name: string) {
        const event = this._getEventInstance(name);
        const del = event.FindFirstChild("Delete") as UndefinedBindable;

        if (del) {
            del.Fire();
        }
    }

    /** 
     * @destroyAllEvents Destroys every event which removes all connections
    */
    public destroyAllEvents() {
        this.folder.GetChildren().forEach((event) => {
            this.destroyEvent(event.Name);
        })
    }

    /** 
     * @resetDebounce Resets the debounce of an event that has the given name, which allows it to run again without any cooldown
     * @param name The name of the event
    */
    public resetDebounce(name: string) {
        const event = this._getEventInstance(name);
        const debounce = event.FindFirstChild("Debounce") as UndefinedNumberValue;

        if (debounce) {
            debounce.Value = 0;
        }
    }

    /** 
     * @resetAllDebounces Resets the debounce of every event, which allows them to run again without any cooldown
    */
    public resetAllDebounces() {
        this.folder.GetChildren().forEach((event) => {
            this.resetDebounce(event.Name);
        })
    }

    private _getEventInstance(name: string) {
        const found = this.folder.FindFirstChild(name) as UndefinedBindable;
        assert(found, DOES_NOT_EXIST.format(name));  

        return found;    
    }
}

export default DebounceLib;