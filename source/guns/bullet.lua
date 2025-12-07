local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

local SPEED <const> = 5

Bullet = {}
class('Bullet').extends(gfx.sprite)

local function initImage(self)
    local image = gfx.image.new(4, 4)
    gfx.pushContext(image)
    gfx.fillCircleAtPoint(2, 2, 2)
    gfx.popContext()
    self:setImage(image)
end

local function handleBulletPath(self)
    self.distanceCovered = self.distanceCovered + SPEED

    local pointOnLine = self.lineToTarget:pointOnLine(self.distanceCovered)
    local actualX, actualY, collisions, numberOfCollisions = self:moveWithCollisions(pointOnLine.x, pointOnLine.y)

    if numberOfCollisions > 0 then
        for i = 1, numberOfCollisions do
            local collision = collisions[i]
            local other = collision.other

            if other:getTag() == TAGS.EMENY then
                other:damage(50)
                self:remove()
                return
            end
        end
    end

    if self.distanceCovered >= self.lineToTarget:length() then
        self:remove()
    end
end

function Bullet:init(player, point)
    self.player = player
    self.lineToTarget = geom.lineSegment.new(player.x, player.y, point.x, point.y)
    self.distanceCovered = 0

    initImage(self)

    self:setCollideRect(0, 0, 4, 4)
    self:setTag(TAGS.BULLET)
    self:moveTo(player.x, player.y)
    self:add()

    pd.timer.performAfterDelay(2000, function()
        self:remove()
    end)
end

function Bullet:update()
    handleBulletPath(self)
end
