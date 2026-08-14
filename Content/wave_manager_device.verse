using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

wave_manager_device := class(creative_device):

    @editable
    AllSpawners : []npc_spawner_device = array{}

    # 1. Add references to our two critical devices
    @editable
    TownHall : objective_device = objective_device{}
    
    @editable
    EndGameReferee : end_game_device = end_game_device{}

    var Widget : ZombieDefense.WaveUI = ZombieDefense.WaveUI{}

    Message1<localizes> : message = ""
    Message2<localizes> : message = "A new wave is coming..."

    # This runs the moment the game starts
    OnBegin<override>()<suspends>:void=
        Print("Wave Manager Initialized!")
        
        # 2. Tell Verse to listen for the exact moment the Town Hall is destroyed
        TownHall.DestroyedEvent.Subscribe(OnBaseDestroyed)
        
        DisableSpawners(AllSpawners)
        Sleep(5.0)
        
        loop:
            Print("Spawning a new wave!")
            TriggerWave(AllSpawners)
            set Widget.MyMessage = Message2
            Sleep(6.0)
            set Widget.MyMessage = Message1
            Sleep(6.0)

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