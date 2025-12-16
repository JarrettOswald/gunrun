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

local function toCash(self)
    self:moveTo(-200, -200)
    self.isCashed = true
end

local function handleBulletPath(self)
    self.position.x = self.x
    self.position.y = self.y

    self.newPosition.x = self.position.x
    self.newPosition.y = self.position.y

    self.newPosition:addVector(self.direction)

    local actualX, actualY, collisions, numberOfCollisions = self:moveWithCollisions(self.newPosition.x,
        self.newPosition.y)

    if numberOfCollisions > 0 then
        for i = 1, numberOfCollisions do
            local collision = collisions[i]
            local other = collision.other
            if other:getTag() == self.targetType then
                other:damage(50)
                toCash(self)
                return
            end
        end
    end

    if self.lastFireTime + self.toCashTimer > pd.getCurrentTimeMilliseconds() then
        toCash(self)
    end
end

function Bullet:init()
    initImage(self)
    self:setCollideRect(0, 0, 4, 4)
    self:setTag(TAGS.BULLET)
    self:add()

    self.isCashed = true
    self.lastFireTime = pd.getCurrentTimeMilliseconds()
    self.toCashTimer = 2000

    self.position = geom.vector2D.new(0, 0)
    self.newPosition = geom.vector2D.new(0, 0)
    self.direction = geom.vector2D.new(0, 0)
end

function Bullet:update()
    if not self.isCashed then
        handleBulletPath(self)
    end
end

function Bullet:setTargetAndFire(gunner, x, y, target)
    self:moveTo(gunner.x, gunner.y)
    self.isCashed = false
    self.gunner = gunner
    self.targetType = target
    self:setCollidesWithGroups(target)

    ---@diagnostic disable-next-line: inject-field
    self.direction.x = x - gunner.x
    ---@diagnostic disable-next-line: inject-field
    self.direction.y = y - gunner.y

    self.direction:normalize()

    self.direction:scale(SPEED)
end
