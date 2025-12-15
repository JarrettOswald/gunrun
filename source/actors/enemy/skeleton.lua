local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry


Skeleton = {}
class("Skeleton").extends(Enemy)

local ENEMY_WIDTH <const> = 16
local ENEMY_HEIGHT <const> = 16
local FIRE_COOLDOWN <const> = 2000

local skeletonTable = gfx.imagetable.new("image/enemy/enemy") or error("nil imagetable")

function Skeleton:init(x, y, player, cashEnemy)
    Skeleton.super.init(self, player, cashEnemy)
    self.health = 150
    self.lastFireTime = 0
    self.moveSpeed = 1.5
    self.bullet = Bullet()

    self:setImage(skeletonTable:getImage(1, 2))
    self:setCollideRect(2, 2, ENEMY_WIDTH - 4, ENEMY_HEIGHT - 4)
    self:moveTo(x, y)
    self:add()
end

local function shootToTarget(self)
    local dx = self.player.x - self.x
    local dy = self.player.y - self.y
    local distSq = dx * dx + dy * dy
    if distSq < 200 * 200 then
        local currentTime = pd.getCurrentTimeMilliseconds()
        if currentTime - self.lastFireTime >= FIRE_COOLDOWN then
            print(currentTime - self.lastFireTime >= FIRE_COOLDOWN)
            self.bullet:setTargetAndFire(self, self.player)
            self.lastFireTime = currentTime
        end
    end
end

local function rotation(self)
    if self.player.x < self.x then
        self:setScale(1, 1)
    else
        self:setScale(-1, 1)
    end
end

function Skeleton:damage(damageAmount)
    self:setImageDrawMode(gfx.kDrawModeInverted)
    pd.timer.performAfterDelay(20, function()
        self:setImageDrawMode(gfx.kDrawModeCopy)
    end)

    self.health = self.health - damageAmount
    if self.health <= 0 then
        self.cashEnemy:removeEnemy(self)
    end
end

function Skeleton:update()
    self:runToTarget()
    rotation(self)
    shootToTarget(self)
end
