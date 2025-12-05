local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Enemy = {}

class("Enemy").extends(gfx.sprite)

local ENEMY_WIDTH <const> = 15
local ENEMY_HEIGHT <const> = 15
local MOVE_SPEED <const> = 2

local function createEnemyImage()
    local image = gfx.image.new(ENEMY_WIDTH, ENEMY_HEIGHT)
    gfx.pushContext(image)
    gfx.fillRect(0, 0, ENEMY_WIDTH, ENEMY_HEIGHT)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(3, 3, ENEMY_WIDTH - 6, ENEMY_HEIGHT - 6)
    gfx.popContext()
    return image
end

local function goToActor(self)
    if self.player then
        local playerX, playerY = self.player.x, self.player.y
        local enemyX, enemyY = self.x, self.y

        local distance = geom.distanceToPoint(enemyX, enemyY, playerX, playerY)

        if distance > 0 then
            local dx, dy = playerX - enemyX, playerY - enemyY
            dx, dy = dx / distance, dy / distance
            self:moveTo(enemyX + dx * MOVE_SPEED, enemyY + dy * MOVE_SPEED)
        end
    end
end

function Enemy:init(x, y, player)
    self.number = math.random(1, 999999)
    self.health = 100
    self.player = player

    self:setImage(createEnemyImage())
    self:setCollideRect(0, 0, ENEMY_WIDTH, ENEMY_HEIGHT)
    self:setTag(TAGS.EMENY)
    self:moveTo(x, y)
    self:add()
end

function Enemy:damage(damageAmount)
    self:setImageDrawMode(gfx.kDrawModeXOR)
    pd.timer.performAfterDelay(20, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end)

    self.health = self.health - damageAmount
    if self.health <= 0 then
        self:remove()
    end
end

function Enemy:update()
    goToActor(self)
end
