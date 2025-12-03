local pd <const> = playdate
local gfx <const> = playdate.graphics


Gun = {}
class('Gun').extends()

function Gun:init(player)
    self.player = player
    self.fireCooldown = 500
    self.lastFireTime = 0
end

function Gun:fire(target)
    local currentTime = pd.getCurrentTimeMilliseconds()
    if currentTime - self.lastFireTime >= self.fireCooldown then
        Bullet(self.player, target)
        self.lastFireTime = currentTime
    end
end
