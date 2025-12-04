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
    self.distanceToTarget = self.distanceToTarget + SPEED
    if self.target == nil then
        self:remove()
    end


    local pointOnLine = self.lineToTarget:pointOnLine(self.distanceToTarget)
    self:moveTo(pointOnLine.x, pointOnLine.y)

    local current_distance = geom.distanceToPoint(self.x, self.y, self.target.x, self.target.y)

    if current_distance < 5 or self.distanceToTarget >= self.lineToTarget:length() then
        self:remove()
        self.target:damage(25)
    end
end

function Bullet:init(player, target)
    self.player = player
    self.target = target
    self.lineToTarget = geom.lineSegment.new(player.x, player.y, target.x, target.y)
    self.distanceToTarget = 0

    initImage(self)
    self:moveTo(player.x, player.y)
    self:add()
end

function Bullet:update()
    handleBulletPath(self)
end
