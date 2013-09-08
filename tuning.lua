--[[
-- Main tuning file.
--
-- For parameters concerning the internal structure of the mod, which the
-- average user should have no reason to change.
--]]


--[[
-- List here the new tile names, in lowercase.
--
-- All the asset insertion, tile adding, etc. is done automagically by
-- inserting a new entry. Each entry is assumed to have a tile texture, a tile
-- atlas, a noise texture and a minimap noise texture.
--
-- For now, avoid removing entries and/or reordering them, otherwise savedata
-- for new tiles will get messed up (creating a new save will fix it, though).
--]]
NEW_TILES = {"poopcloud"}


-- Number of beans the Shopkeeper has.
-- (should we make it regen with time?)
SHOPKEEPER.NUMBEANS = 3

-- Defining functions in the cfg file should be limited for very simple things,
-- since the environment is very slim.
SHOPKEEPER.IS_A_COW = function(inst)
	return inst.prefab == "beefalo"
end

-- Maximum distance for a cow to be negotiated.
SHOPKEEPER.MAX_COW_DIST = 12


-- In seconds.
-- Note that the static generator only updates itself every 2 seconds, so
-- using too low of a value will give low precision.
STATIC.AVERAGE_UNCHARGED_TIME = 120

STATIC.AVERAGE_CHARGED_TIME = 30

STATIC.COOLDOWN = 20


SHEEP.HEALTH = 100
RAM.HEALTH = 600

SHEEP.DAMAGE = 5
RAM.DAMAGE = 35

-- Radius to find a new target.
RAM.TARGET_DIST= 6

-- Maximum distance to herd when chasing a target.
SHEEP.CHASE_DIST = 10
RAM.CHASE_DIST = 30