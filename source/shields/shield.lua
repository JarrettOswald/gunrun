local pd <const> = playdate
local gfx <const> = playdate.graphics

Shield = {}

class('Shield').extends(gfx.sprite)

local RADIUS <const> = 11
local COOLDOWN <const> = 500
local DURATION <const> = 300

local function createShieldImage()
    local image = gfx.image.new(RADIUS * 2, RADIUS * 2)
    gfx.pushContext(image)
    gfx.drawCircleAtPoint(RADIUS, RADIUS, RADIUS)
    gfx.popContext()
    return image
end

function Shield:init()
    self.lastUpShield = 0

    self:setImage(createShieldImage())

    self:setVisible(false)
    self:add()
end

function Shield:up()
    local currentTime = pd.getCurrentTimeMilliseconds()

    if currentTime - self.lastUpShield >= COOLDOWN then
        self:setVisible(true)
        self.lastUpShield = currentTime

        pd.timer.performAfterDelay(DURATION, function()
            self:setVisible(false)
        end)
    end
end
