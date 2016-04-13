BindGlobal()

require("stategraphs/commonstates")

local actionhandlers = 
{
    ActionHandler(ACTIONS.GOHOME, "gohome"),
    ActionHandler(ACTIONS.EAT, "eat"),
}


local events=
{
    CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),
}

local states=
{
}

CommonStates.AddWalkStates(states,
{
    walktimeline = {
        TimeEvent(0*FRAMES, PlayFootstep ),
        TimeEvent(12*FRAMES, PlayFootstep ),
    },
})
CommonStates.AddRunStates(states,
{
    runtimeline = {
        TimeEvent(0*FRAMES, PlayFootstep ),
        TimeEvent(10*FRAMES, PlayFootstep ),
    },
})

CommonStates.AddCombatStates(states,
{
    attacktimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/owl/attack") end),
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh") end),
        TimeEvent(20*FRAMES, function(inst) inst.components.combat:DoAttack() end),
    },
    hittimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/owl/hurt") end),
    },
    deathtimeline = 
    {
        TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound("upandaway/creatures/owl/death") end),
    },
})

CommonStates.AddIdle(states)
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4*FRAMES, {"busy"})
CommonStates.AddSimpleActionState(states, "eat", "eat", 10*FRAMES, {"busy"})
CommonStates.AddFrozenStates(states)

    
return StateGraph("owl", states, events, "idle", actionhandlers)

