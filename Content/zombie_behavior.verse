using { /Fortnite.com/AI }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }

# This creates a custom tag that we will assign to your Town Hall
town_hall_tag := class(tag){}

zombie_behavior := class(npc_behavior):

    OnBegin<override>()<suspends>:void=
        # 1. Get the NPC's physical character and its navigation brain
        if:
            Agent := GetAgent[]
            Character := Agent.GetFortCharacter[]
            Navigatable := Character.GetNavigatable[]
            
            # 2. Loop through the generator to convert it into a standard array
            TaggedObjects := for (Obj : FindCreativeObjectsWithTag(town_hall_tag)) do Obj
            
            # Grab the first item (Array indexing can fail, so it stays safely inside the 'if')
            TownHall := TaggedObjects[0]
        then:
            # 3. Extract the physical location (vector3) of the Town Hall
            TargetLocation := TownHall.GetTransform().Translation
            NavTarget := MakeNavigationTarget(TargetLocation)
            
            # 4. Force the zombie to march directly to that location!
            Navigatable.NavigateTo(NavTarget)