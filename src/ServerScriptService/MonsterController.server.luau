local CollectionService = game:GetService("CollectionService")

local MonsterScript = require(script.Parent.MonsterModuleScripts.MonsterScript)
local MonsterAnimate = require(script.Parent.MonsterModuleScripts.MonsterAnimate)

local MONSTER_TAG = "EnemyMonster"

local function onMonsterAdded(monster)
	print("Monster Controller found a monster: " .. monster.Name)
	MonsterScript.StartLogic(monster)
	MonsterAnimate.StartLogic(monster)
end

for _, monster in ipairs(CollectionService:GetTagged(MONSTER_TAG)) do
	task.spawn(function()
		onMonsterAdded(monster)
	end)
end

CollectionService:GetInstanceAddedSignal(MONSTER_TAG):Connect(function(monster)
	task.spawn(function()
		onMonsterAdded(monster)
	end)
end)