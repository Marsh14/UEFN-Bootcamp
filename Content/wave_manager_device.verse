using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

wave_manager_device := class(creative_device):

    @editable
    AllSpawners : []npc_spawner_device = array{}

    # 1. Add references to our two critical devices
    @editable
    TownHall : objective_device = objective_device{}
    
    @editable
    EndGameReferee : end_game_device = end_game_device{}

    OnBegin<override>()<suspends>:void=
        Print("Wave Manager Initialized!")
        
        # 2. Tell Verse to listen for the exact moment the Town Hall is destroyed
        TownHall.DestroyedEvent.Subscribe(OnBaseDestroyed)
        
        DisableSpawners(AllSpawners)
        Sleep(5.0)
        
        loop:
            Print("Spawning a new wave!")
            TriggerWave(AllSpawners)
            Sleep(12.0)

    OnBaseDestroyed(Destroyer : agent):void=
        Print("Base destroyed! Game Over.")
        
        # NPCs are not allowed to trigger game-ending devices. 
        # We bypass this by finding the actual player and using them to trigger the defeat screen
        if (ValidPlayer := GetPlayspace().GetPlayers()[0]):
            EndGameReferee.Activate(ValidPlayer)

    TriggerWave(Spawners : []npc_spawner_device):void=
        for (Spawner : Spawners):
            Spawner.Enable()
            Spawner.Spawn()

    DisableSpawners(Spawners : []npc_spawner_device):void=
        for (Spawner : Spawners):
            Spawner.Disable()