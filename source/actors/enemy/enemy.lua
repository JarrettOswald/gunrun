local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Enemy = {}

class("Enemy").extends(gfx.sprite)

local ENEMY_WIDTH <const> = 16
local ENEMY_HEIGHT <const> = 16
local MOVE_SPEED <const> = 2

local enemyTable = gfx.imagetable.new("image/enemy/enemy") or error("nil imagetable")

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

function Enemy:init(x, y, player, cashEnemy)
    self.health = 100
    self.player = player
    self.cashEnemy = cashEnemy

    self:setImage(enemyTable:getImage(1))
    self:setCollideRect(0, 0, ENEMY_WIDTH, ENEMY_HEIGHT)
    self:setTag(TAGS.EMENY)
    self:moveTo(x, y)
    self:add()
end

function Enemy:damage(damageAmount)
    self:setImageDrawMode(gfx.kDrawModeInverted)
    pd.timer.performAfterDelay(20, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end)

    self.health = self.health - damageAmount
    if self.health <= 0 then
        self.cashEnemy:removeEnemy(self)
    end
end

function Enemy:update()
    goToActor(self)
end
