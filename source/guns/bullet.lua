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
    local actualX, actualY, collisions, numberOfCollisions = self:moveWithCollisions(self.position.x, self.position.y)

    if numberOfCollisions > 0 then
        for i = 1, numberOfCollisions do
            local collision = collisions[i]
            local other = collision.other

            if other:getTag() == self.targetType then
                other:damage(50)
                self:remove()
                return
            end
        end
    end

end

function Bullet:init(gunner, target)
    self.position = geom.vector2D.new(gunner.x, gunner.y)
    self.targetPosition = geom.vector2D.new(target.x, target.y)

    self.direction = (self.targetPosition - self.position):normalized() * SPEED

    self.targetType = target:getTag()
    self:setCollidesWithGroups(self.targetType)

    self.gunner = gunner

    initImage(self)

    self:setCollideRect(0, 0, 4, 4)
    self:setTag(TAGS.BULLET)
    self:moveTo(gunner.x, gunner.y)
    self:add()

    pd.timer.new(3000, function() self:remove() end)
end

function Bullet:update()
    self.position = self.position + self.direction
    handleBulletPath(self)
end
