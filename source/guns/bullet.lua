local pd <const> = playdate
local gfx <const> = playdate.graphics


Bullet = {}
class('Bullet').extends(gfx.sprite)

function Bullet:init(player, target)
    self.player = player
    self.target = target
    self.speed = 5
    local image = gfx.image.new(4, 4)
    gfx.pushContext(image)
    gfx.fillCircleAtPoint(2, 2, 2)
    gfx.popContext()
    self:moveTo(player.x, player.y)
    self:setImage(image)
    self:add()
end

function Bullet:update()
    if self.target then
        if not self.vx or not self.vy then
            local dx = self.target.x - self.x
            local dy = self.target.y - self.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance > 0 then
                self.vx = (dx / distance) * self.speed
                self.vy = (dy / distance) * self.speed
            else
                self.vx = 0
                self.vy = 0
            end
        end
        self:moveTo(self.x + self.vx, self.y + self.vy)

        local current_dx = self.target.x - self.x
        local current_dy = self.target.y - self.y
        local current_distance = math.sqrt(current_dx * current_dx + current_dy * current_dy)

        if current_distance < 5 or (self.vx * current_dx + self.vy * current_dy) <= 0 then
            self:remove()
            self.target:damage(25)
        end
    else
        self:remove()
    end
end
