local pd <const> = playdate
local gfx <const> = playdate.graphics

Gun = {}
class('Gun').extends()

local FIRE_COOLDOWN <const> = 500

function Gun:init(player)
    self.player = player
    self.lastFireTime = 0
end

function Gun:fire(point)
    local currentTime = pd.getCurrentTimeMilliseconds()
    if currentTime - self.lastFireTime >= FIRE_COOLDOWN then
        Bullet(self.player, point)
        self.lastFireTime = currentTime
    end
end
