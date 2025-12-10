local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry


Enemy = {}
class("Enemy").extends(gfx.sprite)

function Enemy:init(player, cashEnemy)
    self.player = player
    self.cashEnemy = cashEnemy
    self.moveSpeed = 0
    self:setTag(TAGS.EMENY)
    self:setGroups(TAGS.EMENY)
end

function Enemy:runToTarget()
    local playerX, playerY = self.player.x, self.player.y
    local position = geom.vector2D.new(self.x, self.y)
    local targetVector = geom.vector2D.new(playerX, playerY)
    local direction = (targetVector - position):normalized() * self.moveSpeed
    local newPosition = position + direction
    self:moveTo(newPosition.x, newPosition.y)
end