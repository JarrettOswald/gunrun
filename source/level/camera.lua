local pd <const> = playdate
local gfx <const> = playdate.graphics

Camera = {}

class('Camera').extends(gfx.sprite)


function Camera:init(target)
    self.target = target
    self:add()
end


function Camera:update()
    if self.target then
        local targetX, targetY = self.target:getPosition()
        gfx.setDrawOffset(-targetX + 200, -targetY + 120)
    end
end