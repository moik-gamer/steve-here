local CollectionService = game:GetService("CollectionService")

-- 1. Get your MonsterScript module
-- (This assumes MonsterController and MonsterModules are next to each other in ServerScriptService)
local ServerScriptService = game:GetService("ServerScriptService")

-- 🛠️ FIXED: Explicitly path from ServerScriptService down to your files
local MonsterScript = require(ServerScriptService.MonsterModuleScripts.MonsterScript)
local MonsterAnimate = require(ServerScriptService.MonsterModuleScripts.MonsterAnimate)

-- 2. Define the exact tag you used in the Studio Tag Editor
local MONSTER_TAG = "EnemyMonster"

-- 3. Create the function that sets up a monster
local function onMonsterAdded(monster)
	print("Monster Controller found a monster: " .. monster.Name)

	-- This calls the function you just wrote and passes the monster to it!
	MonsterScript.StartLogic(monster)
	MonsterAnimate.StartLogic(monster)
end

-- 🛠️ DIAGNOSTIC FORCE-LOAD
-- This completely bypasses CollectionService to see if the files are syncing
task.spawn(function()
	print("MonsterController diagnostic starting...")
	task.wait(2) -- Give the game world two seconds to load everything

	local physicalMonster = Workspace:FindFirstChild("EnemyMonster")

	if physicalMonster then
		print("FOUND ENEMYMONSTER IN WORKSPACE! Activating logic...")
		onMonsterAdded(physicalMonster)
	else
		warn("CRITICAL: The script looked inside Workspace but could not find any model named exactly 'EnemyMonster'!")
	end
end)