local pd <const> = playdate
local gfx <const> = playdate.graphics

Level = {}

class('Level').extends(gfx.sprite)

function Level:init()
    self.player = Player()
    Enemy(400 / 4 * 1, 120, self.player)
    Enemy(400 / 4 * 2, 120, self.player)
    Enemy(400 / 4 * 3, 120, self.player)
    self.lastSpawnTime = 10
    self.spawnInterval = 2000
    self.enemyCount = 0

    self:add()
end

function Level:spawnEnemy()
    if self.enemyCount >= 5 then
        return
    end

    if self.lastSpawnTime + self.spawnInterval < pd.getCurrentTimeMilliseconds() then
        Enemy(math.random(0,400), 260, self.player)
        self.lastSpawnTime = pd.getCurrentTimeMilliseconds()
    end
end

function Level:update()
    self:spawnEnemy()
    self:controlEnemy()
end

function Level:controlEnemy()
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
            local distance = math.sqrt(dx * dx + dy * dy)

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
