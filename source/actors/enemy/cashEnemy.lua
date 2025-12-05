local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

CashEnemy = {}

class("CashEnemy").extends(gfx.sprite)

function CashEnemy:init(player)
    self.player = player
    self.cashEnemy = {}
    self.enemyCount = 0
    
    self:add()
end

function CashEnemy:getEnemy(x, y)
    return Enemy(x, y, self.player)
end


function CashEnemy:controlEnemy()
    local sprites = gfx.sprite.getAllSprites()
    local enemies = {}

    for _, value in ipairs(sprites) do
        if value:getTag() == TAGS.EMENY then
            table.insert(enemies, value)
        end
    end

    self.enemyCount = #enemies

    for i = 1, #enemies - 1, 1 do
        local enemyA = enemies[i]
        for j = i + 1, #enemies, 1 do
            local enemyB = enemies[j]

            local dx = enemyB.x - enemyA.x
            local dy = enemyB.y - enemyA.y

            local distance = geom.distanceToPoint(enemyA.x, enemyA.y, enemyB.x, enemyB.y)

            if distance < 20 and distance > 0 then
                local overlap = 20 - distance
                local offsetX = (dx / distance) * (overlap / 2)
                local offsetY = (dy / distance) * (overlap / 2)

                enemyA:moveTo(enemyA.x - offsetX, enemyA.y - offsetY)
                enemyB:moveTo(enemyB.x + offsetX, enemyB.y + offsetY)
            end
        end
    end
end

function CashEnemy:getCountEnemy()
    return self.enemyCount
end

function CashEnemy:update()
    self:controlEnemy()
end
