local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry


Skeleton = {}
class("Skeleton").extends(gfx.sprite)

local ENEMY_WIDTH <const> = 16
local ENEMY_HEIGHT <const> = 16
local MOVE_SPEED <const> = 1.5
local FIRE_COOLDOWN <const> = 1500

local skeletonTable = gfx.imagetable.new("image/enemy/enemy") or error("nil imagetable")

function Skeleton:init(x, y, player, cashEnemy)
    self.health = 150
    self.player = player
    self.cashEnemy = cashEnemy
    self.lastFireTime = 0

    self:setImage(skeletonTable:getImage(1, 2))
    self:setCollideRect(0, 0, ENEMY_WIDTH, ENEMY_HEIGHT)
    self:setTag(TAGS.EMENY)
    self:setGroups(TAGS.EMENY)
    self:moveTo(x, y)
    self:add()
end

local function shootToTarget(self)
    local currentTime = pd.getCurrentTimeMilliseconds()
    if currentTime - self.lastFireTime >= FIRE_COOLDOWN then
        Bullet(self, self.player)
        self.lastFireTime = currentTime
    end
end

local function runToTarget(self)
    local playerX, playerY = self.player.x, self.player.y
    local distance = geom.distanceToPoint(self.x, self.y, playerX, playerY)
    local line = geom.lineSegment.new(self.x, self.y, playerX, playerY)
    if distance > 0 then
        local point = line:pointOnLine(MOVE_SPEED)
        self:moveTo(point.x, point.y)
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
    runToTarget(self)
    rotation(self)
    shootToTarget(self)
end
