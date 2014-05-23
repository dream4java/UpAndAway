BindGlobal()

local assets =
{
	--Asset("ANIM", "anim/pineapple_bush.zip"),
}

local prefabs =
{
	"pineapple",
}

local seg_time = TUNING.DAY_SEGS_DEFAULT
local day_segs = 10
local day_time = seg_time * day_segs

TUNING.PINEAPPLE_GROW_TIME =
{
--Empty

    {
    	base=1.5*day_time, 
    	random=0.5*day_time
    },

--Normal

    {
    	base=3*day_time,
    	random=2*day_time
    },

--Growing

    {
    	base=2*day_time, 
    	random=1*day_time
    },

--Ripe

    {
    	base=1*day_time, 
    	random=0.5*day_time
    }
}

local function dig_up(inst, chopper)
	if inst.components.pickable then
		inst.components.lootdropper:SpawnLootPrefab("pineapple")
	end
	inst.components.lootdropper:SpawnLootPrefab("dug_pineapple_bush")	
	inst:Remove()
end

local function growEmpty(inst)
    --inst.AnimState:PlayAnimation("idle_empty")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    if inst.components.pickable then
    	inst:RemoveComponent("pickable")    
    end        
end

local function growNormal(inst)
   -- inst.AnimState:PlayAnimation("idle_normal")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")  
    if inst.components.pickable then
    	inst:RemoveComponent("pickable")    
    end                  
end

local function growGrowing(inst)
    --inst.AnimState:PlayAnimation("idle_growing")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow") 
    if inst.components.pickable then
    	inst:RemoveComponent("pickable")    
    end          
end

--This is for when it's picked ripe.
local function onpickedfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds") 
	--inst.AnimState:PlayAnimation("picking")
	inst:RemoveComponent("pickable")
	inst.components.growable:SetStage(5) 
end

--This is for when it's picked rotten.
local function onharvestfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
	inst:RemoveComponent("pickable")
	--inst.AnimState:PlayAnimation("idle_harvested")
	inst.AnimState:SetMultColour(0,0,0,1)
end	

local function growRipe(inst)
    --inst.AnimState:PlayAnimation("idle_ripe")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    if not inst.components.pickable then
    	inst:AddComponent("pickable")
    	inst.components.pickable.canbepicked = true
    	inst.components.pickable.cycles_left = 1
    	inst.components.pickable.product = "pineapple"
    	inst.components.pickable.onpickedfn = onpickedfn 
	end
    inst.AnimState:SetMultColour(0,255,0,1)          
end

local function growHarvested(inst)
    if inst.components.pickable then
    	--inst.AnimState:PlayAnimation("idle_rotten")
    	inst.AnimState:SetMultColour(255,0,0,1) 
    	inst.components.pickable.product = "wetgoop"
    	inst.components.pickable.onpickedfn = onharvestfn 
   	else 
   		--inst.AnimState:PlayAnimation("idle_harvested")
   		inst.AnimState:SetMultColour(0,0,0,1)
   	end              
end

local growth_stages =
{
    {
    	name="empty", 

    	time = function(inst) 
    		return GetRandomWithVariance(
    			TUNING.PINEAPPLE_GROW_TIME[1].base, 
    			TUNING.PINEAPPLE_GROW_TIME[1].random) 
    	end, 

		fn = function(inst) 
			growEmpty(inst) 
		end,  

		growfn = function(inst) 
			growEmpty(inst) 
		end
    },

    {
    	name="normal", 

    	time = function(inst) 
    		return GetRandomWithVariance(
    			TUNING.PINEAPPLE_GROW_TIME[2].base, 
    			TUNING.PINEAPPLE_GROW_TIME[2].random) 
    	end, 

		fn = function(inst) 
			growNormal(inst) 
		end,  

		growfn = function(inst) 
			growNormal(inst) 
		end 
    },

    {
    	name="growing", 

    	time = function(inst) 
    		return GetRandomWithVariance(
    			TUNING.PINEAPPLE_GROW_TIME[3].base, 
    			TUNING.PINEAPPLE_GROW_TIME[3].random) 
    	end, 

		fn = function(inst) 
			growGrowing(inst) 
		end,  

		growfn = function(inst) 
			growGrowing(inst) 
		end
    },

    {
    	name="ripe", 

    	time = function(inst) 
    		return GetRandomWithVariance(
    			TUNING.PINEAPPLE_GROW_TIME[4].base, 
    			TUNING.PINEAPPLE_GROW_TIME[4].random) 
    	end, 

		fn = function(inst) 
			growRipe(inst) 
		end,  

		growfn = function(inst) 
			growRipe(inst) 
		end 
    },

    {
    	name="harvested", 

    	time = math.random(), 

		fn = function(inst) 
			growHarvested(inst) 
		end,  

		growfn = function(inst) 
			growHarvested(inst) 
		end
    }
}

local function fn(Sim)
	local inst = CreateEntity()
	
	local growth_stage = 1
	if growth_stage and growth_stage == 0 then 
		growth_stage = math.random(1,3) 
	end

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeObstaclePhysics(inst, .2)

	--inst.AnimState:SetBank("pineapple_bush")
	--inst.AnimState:SetBuild("pineapple_bush")

	inst.AnimState:SetBank("grass")
	inst.AnimState:SetBuild("grass1")
	inst.AnimState:PlayAnimation("idle",true)

	inst:AddComponent("inspectable")

	inst:AddComponent("lootdropper")

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(growth_stage)
    inst.components.growable.loopstages = false
    inst.components.growable:StartGrowing()

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)

    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)    

	return inst
end

local function dug_fn(inst)
	inst = CreateEntity()

	return inst
end

return {
	Prefab ("common/pineapple_bush", fn, assets, prefabs),
	Prefab ("common/inventory/dug_pineapple_bush", dug_fn, assets, prefabs) 
}
