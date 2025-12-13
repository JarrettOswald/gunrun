local pd <const> = playdate
local gfx <const> = pd.graphics
local table_insert = table.insert
local table_remove = table.remove
CashEnemy = {}
class("CashEnemy").extends()

local abs = math.abs
local sort = table.sort

-- Локальные помощники
local function sortByX(a, b)
    return a.x < b.x
end

local function resolveCollisions(enemies)
    local count = #enemies
    if count < 2 then return end
    sort(enemies, sortByX)

    local LIMIT = 25
    local LIMIT_SQ = LIMIT * LIMIT

    for i = 1, count - 1 do
        local enemyA = enemies[i]
        local ax, ay = enemyA.x, enemyA.y

        for j = i + 1, count do
            local enemyB = enemies[j]

            local dx = enemyB.x - ax

            if dx > LIMIT then
                break
            end

            local dy = enemyB.y - ay

            if abs(dy) < LIMIT then
                local distSq = dx * dx + dy * dy

                if distSq < LIMIT_SQ and distSq > 0.001 then
                    local distance = math.sqrt(distSq)

                    local overlap = LIMIT - distance
                    local pushFactor = (overlap * 0.5) / distance

                    local moveX = dx * pushFactor
                    local moveY = dy * pushFactor

                    ax = ax - moveX
                    ay = ay - moveY

                    enemyA:moveTo(ax, ay)
                    enemyB:moveTo(enemyB.x + moveX, enemyB.y + moveY)
                end
            end
        end
    end
end


function CashEnemy:init(player)
    self.player = player
    self.activeEnemies = {}
    self.enemyCount = 0

    self.poolSpiders = {}
    self.poolSkeletons = {}
end

function CashEnemy:update()
    resolveCollisions(self.activeEnemies)
end

function CashEnemy:createSpider(x, y)
    local enemy
    -- 1. Пытаемся достать из пула
    if #self.poolSpiders > 0 then
        enemy = table_remove(self.poolSpiders)
        enemy:moveTo(x, y)
        enemy:add()
    else
        enemy = Spider(x, y, self.player, self)
        enemy.typeName = "Spider"
    end

    table_insert(self.activeEnemies, enemy)
    self.enemyCount = #self.activeEnemies
    return enemy
end

function CashEnemy:createSkeleton(x, y)
    local enemy
    if #self.poolSkeletons > 0 then
        enemy = table_remove(self.poolSkeletons)
        enemy:moveTo(x, y)
        enemy:add()
    else
        enemy = Skeleton(x, y, self.player, self)
        enemy.typeName = "Skeleton"
    end

    table_insert(self.activeEnemies, enemy)
    self.enemyCount = #self.activeEnemies
    return enemy
end

function CashEnemy:createRandomEnemy(x, y)
    if math.random() < 0.5 then
        return self:createSpider(x, y)
    else
        return self:createSkeleton(x, y)
    end
end

function CashEnemy:removeEnemy(enemy)
    local enemies = self.activeEnemies
    local count = #enemies
    for i = 1, count do
        if enemies[i] == enemy then
            enemies[i] = enemies[count]
            enemies[count] = nil

            if enemy.typeName == "Spider" then
                table_insert(self.poolSpiders, enemy)
            elseif enemy.typeName == "Skeleton" then
                table_insert(self.poolSkeletons, enemy)
                enemy.health = 150

            else
                print("Unknown enemy type, not pooling")
            end

            break
        end
    end
    self.enemyCount = #self.activeEnemies
end

function CashEnemy:getCountEnemy()
    return self.enemyCount
end
