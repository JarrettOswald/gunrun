local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Bullet = {}

class('Bullet').extends(gfx.sprite)

local SPEED <const> = 5

local function initImage(self)
    local image = gfx.image.new(4, 4)
    gfx.pushContext(image)
    gfx.fillCircleAtPoint(2, 2, 2)
    gfx.popContext()
    self:setImage(image)
end

local function handleBulletPath(self)
    self.position = geom.vector2D.new(self.x, self.y)
    self.newPosition = self.position + self.direction
    local actualX, actualY, collisions, numberOfCollisions = self:moveWithCollisions(self.newPosition.x,
    self.newPosition.y)

    if numberOfCollisions > 0 then
        for i = 1, numberOfCollisions do
            local collision = collisions[i]
            local other = collision.other
            if other:getTag() == self.targetType then
                other:damage(50)
                self:moveTo(-1000, -1000)
                self.isCashed = true
                return
            end
        end
    end
end

function Bullet:init()
    initImage(self)
    self:setCollideRect(0, 0, 4, 4)
    self:setTag(TAGS.BULLET)
    self:add()
    self.isCashed = true
end

function Bullet:update()
    if not self.isCashed then
        handleBulletPath(self)
    end
end

function Bullet:setTargetAndGo(gunner, target)
    self:moveTo(gunner.x, gunner.y)
    self.isCashed = false
    self.gunner = gunner
    self.targetType = target:getTag()
    self:setCollidesWithGroups(self.targetType)

    local start = geom.vector2D.new(gunner.x, gunner.y)
    local targetPos = geom.vector2D.new(target.x, target.y)
    self.direction = (targetPos - start):normalized() * SPEED

    pd.timer.performAfterDelay(2000, function()
        if not self.isCashed then
            self:moveTo(-1000, -1000)
            self.isCashed = true
        end
    end)
end
