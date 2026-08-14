using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

wave_manager_device := class(creative_device):

    @editable
    AllSpawners : []npc_spawner_device = array{}

    @editable
    TownHall : objective_device = objective_device{}
    
    @editable
    EndGameReferee : end_game_device = end_game_device{}

    @editable
    var ZombiesPerSpawner : int = 2

    OnBegin<override>()<suspends>:void=
        Print("Wave Manager Initialized!")
        TownHall.DestroyedEvent.Subscribe(OnBaseDestroyed)
        
        DisableSpawners(AllSpawners)
        Sleep(5.0)
        
        loop:
            Print("Spawning a new wave!")
            TriggerWave(AllSpawners)
            Sleep(12.0)

    OnBaseDestroyed(Destroyer : agent):void=
        Print("Base destroyed! Game Over.")
        if (ValidPlayer := GetPlayspace().GetPlayers()[0]):
            EndGameReferee.Activate(ValidPlayer)

    # Added <suspends> so we can use Sleep()
    TriggerWave(Spawners : []npc_spawner_device)<suspends>:void=
        for (Spawner : Spawners):
            Spawner.Enable()
            
            for (i := 1..ZombiesPerSpawner):
                Spawner.Spawn()
                Sleep(0.1) # buffer to update internal state
        if(ZombiesPerSpawner < 10):
            set ZombiesPerSpawner = ZombiesPerSpawner + 1

    DisableSpawners(Spawners : []npc_spawner_device):void=
        for (Spawner : Spawners):
            Spawner.Disable()