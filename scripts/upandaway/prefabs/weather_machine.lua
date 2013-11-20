--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function weather_off(inst)
	if GetWorld() and not GetWorld():HasTag("cloudrealm") then
		print "Weather Machine Reset"
		GetSeasonManager():Cycle()
		GetPlayer().components.sanity:DoDelta(-10)
	end
end	


local function DoWeatherPick(inst)
	if GetWorld() then
		weather_id = math.random(1,5)
		GetPlayer().components.sanity:DoDelta(-40)
		if weather_id == 1 then
			print(weather_id)
			GetSeasonManager():StartWinter()
		elseif weather_id == 2 then
			print(weather_id)
			GetSeasonManager():StartSummer()
		elseif weather_id == 3 then
			print(weather_id)
			GetSeasonManager():StartPrecip()
		elseif weather_id == 4 then
			print(weather_id)
			GetSeasonManager():StopPrecip()
		elseif weather_id == 5 then	
			print(weather_id)
			GetSeasonManager():Cycle()
		end	
	end	
end	

local function weather_on(inst)
	if GetWorld() and GetWorld():HasTag("cloudrealm") then
		print "In cloudrealm."
		GetSeasonManager():StartSummer()
		inst:DoPeriodicTask(10, function(inst) GetWorld().components.staticgenerator:Charge() end)
	else 
		print "In another world."
		DoWeatherPick()
	end
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = weather_on
	inst.components.machine.turnofffn = weather_off

	return inst
end

return Prefab ("common/inventory/weather_machine", fn, assets) 
