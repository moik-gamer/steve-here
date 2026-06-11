local CollectionService = game:GetService("CollectionService")

-- 1. Get your MonsterScript module
-- (This assumes MonsterController and MonsterModules are next to each other in ServerScriptService)
local MonsterScript = require(script.Parent.MonsterModules.MonsterScript)
local MonsterAnimate = require(script.Parent.MonsterModules.MonsterAnimate)

-- 2. Define the exact tag you used in the Studio Tag Editor
local MONSTER_TAG = "EnemyMonster"

-- 3. Create the function that sets up a monster
local function onMonsterAdded(monster)
	print("Monster Controller found a monster: " .. monster.Name)

	-- This calls the function you just wrote and passes the monster to it!
	MonsterScript.StartLogic(monster)
	MonsterAnimate.StartLogic(monster)
end

-- 4. Start logic for all monsters already in the Workspace when the game begins
for _, monster in ipairs(CollectionService:GetTagged(MONSTER_TAG)) do
	-- Using task.spawn ensures that if one monster has an error, 
	-- it doesn't break the rest of the monsters.
	task.spawn(function()
		onMonsterAdded(monster)
	 end)
end

-- 5. Automatically start logic for any NEW monsters that spawn later
CollectionService:GetInstanceAddedSignal(MONSTER_TAG):Connect(function(monster)
	task.spawn(function()
		onMonsterAdded(monster)
	end)
end)