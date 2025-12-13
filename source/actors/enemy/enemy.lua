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
    local dx = self.player.x - self.x
    local dy = self.player.y - self.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 1 then
        local ratio = self.moveSpeed / distance
        self:moveTo(self.x + dx * ratio, self.y + dy * ratio)
    end
end