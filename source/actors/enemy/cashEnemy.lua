local pd <const> = playdate
local gfx <const> = pd.graphics

-- Локализируем глобальные функции для скорости
local sqrt = math.sqrt

CashEnemy = {}
class("CashEnemy").extends(gfx.sprite)

local DISTANCE = 25
local DISTANCE_SQ = DISTANCE * DISTANCE

local activeEnemies = {}

function CashEnemy:init(player)
    self.player = player
    self.enemyCount = 0
    self.lastEnemyCount = -1
    
    self.counterSptrite = gfx.sprite.new()
    self.counterSptrite:setZIndex(1000)
    self.counterSptrite:setIgnoresDrawOffset(true)
    self.counterSptrite:moveTo(50, 50)
    self.counterSptrite:add()
    
    self:add()
end

function CashEnemy:createEnemy(x, y)
    local enemy = Enemy(x, y, self.player, self)
    table.insert(activeEnemies, enemy)
    self.enemyCount = #activeEnemies
    
    return enemy
end

function CashEnemy:removeEnemy(enemy)
    for i = 1, #activeEnemies do
        if activeEnemies[i] == enemy then
            activeEnemies[i] = activeEnemies[#activeEnemies]
            activeEnemies[#activeEnemies] = nil
            break
        end
    end
    
    enemy:remove()
    self.enemyCount = #activeEnemies
end

local function updateCounterDisplay(self)
    if self.enemyCount == self.lastEnemyCount then
        return
    end

    local image = gfx.image.new(100, 20)
    gfx.pushContext(image)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(0, 0, 100, 20, 5)
        gfx.drawText("Enemies: " .. tostring(self.enemyCount), 5, 5)
    gfx.popContext()
    
    self.counterSptrite:setImage(image)
    self.lastEnemyCount = self.enemyCount
end

local function controlEnemy(self)

    local enemies = activeEnemies
    local count = #enemies
    
    if count < 2 then return end

    for i = 1, count - 1 do
        local enemyA = enemies[i]
        local ax, ay = enemyA.x, enemyA.y

        for j = i + 1, count do
            local enemyB = enemies[j]
            local bx, by = enemyB.x, enemyB.y
            
            local dx = bx - ax
            local dy = by - ay
            
            local distSq = dx*dx + dy*dy

            if distSq < DISTANCE_SQ and distSq > 0 then

                local distance = sqrt(distSq)
                
                local overlap = DISTANCE - distance

                local pushFactor = (overlap * 0.5) / distance
                local moveX = dx * pushFactor
                local moveY = dy * pushFactor

                enemyA:moveTo(ax - moveX, ay - moveY)
                enemyB:moveTo(bx + moveX, by + moveY)
                
                ax = ax - moveX
                ay = ay - moveY
            end
        end
    end
end

function CashEnemy:getCountEnemy()
    return self.enemyCount
end

function CashEnemy:update()
    updateCounterDisplay(self)
    controlEnemy(self)
end