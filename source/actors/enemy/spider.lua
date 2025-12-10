local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Spider = {}

class("Spider").extends(Enemy)

local ENEMY_WIDTH <const> = 16
local ENEMY_HEIGHT <const> = 16

local enemyTable = gfx.imagetable.new("image/enemy/enemy") or error("nil imagetable")

function Spider:init(x, y, player, cashEnemy)
    Skeleton.super.init(self, player, cashEnemy)
    self.health = 100
    self.player = player
    self.cashEnemy = cashEnemy
    self.moveSpeed = 3

    self:setImage(enemyTable:getImage(1))
    self:setCollideRect(0, 0, ENEMY_WIDTH, ENEMY_HEIGHT)
    self:moveTo(x, y)
    self:add()
end

function Spider:damage(damageAmount)
    self:setImageDrawMode(gfx.kDrawModeInverted)
    pd.timer.performAfterDelay(20, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end)

    self.health = self.health - damageAmount
    if self.health <= 0 then
        self.cashEnemy:removeEnemy(self)
    end
end

function Spider:update()
    self:runToTarget()
end
