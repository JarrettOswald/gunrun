local pd <const> = playdate
local gfx <const> = playdate.graphics

Gun = {}
class('Gun').extends()

local FIRE_COOLDOWN <const> = 500

function Gun:init(player)
    self.player = player
    self.lastFireTime = 0
    self.bullet = Bullet()
end

function Gun:fire(enemy)
    local currentTime = pd.getCurrentTimeMilliseconds()
    if currentTime - self.lastFireTime >= FIRE_COOLDOWN then
        self.bullet:setTargetAndFire(self.player, enemy.x, enemy.y, TAGS.EMENY)
        self.lastFireTime = currentTime
    end
end
