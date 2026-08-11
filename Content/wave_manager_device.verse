using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

wave_manager_device := class(creative_device):

    # A single array to hold every spawner on your map
    @editable
    AllSpawners : []creature_spawner_device = array{}

    # This runs the moment the game starts
    OnBegin<override>()<suspends>:void=
        Print("Wave Manager Initialized!")
        
        # Disable all spawners immediately just in case
        DisableSpawners(AllSpawners)

        # Wait 5 seconds before the very first wave starts
        Sleep(5.0)
        
        # Start the endless wave loop
        loop:
            Print("Spawning a new wave!")
            TriggerWave(AllSpawners)
            
            # Wait exactly 10 seconds before the loop repeats
            Sleep(10.0)

    TriggerWave(Spawners : []creature_spawner_device):void=
        for (Spawner : Spawners):
            # Disabling then immediately enabling forces the device to spit out a new burst of zombies
            Spawner.Disable()
            Spawner.Enable()

    DisableSpawners(Spawners : []creature_spawner_device):void=
        for (Spawner : Spawners):
            Spawner.Disable()