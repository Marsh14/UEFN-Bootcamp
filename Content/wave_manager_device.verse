using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

wave_manager_device := class(creative_device):

    # The @editable tag makes these arrays visible in the UEFN Details Panel
    @editable
    NorthSpawners : []creature_spawner_device = array{}
    
    @editable
    SouthSpawners : []creature_spawner_device = array{}

    # This runs the moment the game starts
    OnBegin<override>()<suspends>:void=
        Print("Wave Manager Initialized!")
        
        # Disable all spawners immediately just in case
        DisableSpawners(NorthSpawners)
        DisableSpawners(SouthSpawners)

        # Wait 5 seconds then start wave
        Sleep(5.0)
        TriggerWave(NorthSpawners)

    TriggerWave(Spawners : []creature_spawner_device):void=
        for (Spawner : Spawners):
            # Turns spawner on
            Spawner.Enable()
            

    DisableSpawners(Spawners : []creature_spawner_device):void=
        for (Spawner : Spawners):
            Spawner.Disable()