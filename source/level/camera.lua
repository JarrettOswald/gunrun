local pd <const> = playdate
local gfx <const> = playdate.graphics

Camera = {}

class('Camera').extends(gfx.sprite)

local SMOOTH = 0.15

function Camera:init(target)
    self.target = target
    self.cameraX = 0
    self.cameraY = 0
    self:add()
end

function Camera:update()
    if self.target then
        local targetX, targetY = self.target:getPosition()
        self.cameraX = self.cameraX + (targetX - self.cameraX) * SMOOTH
        self.cameraY = self.cameraY + (targetY - self.cameraY) * SMOOTH
        gfx.setDrawOffset(-self.cameraX + 200, -self.cameraY + 120)
    end
end
