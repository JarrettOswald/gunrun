local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Level = {}

class('Level').extends(gfx.sprite)

local arc = geom.arc.new(200, 120, 120, 0, 360)

function Level:init()
    self.player = Player()
    self.cashEnemy = CashEnemy(self.player)
    self.lastSpawnTime = 10
    self.spawnInterval = 500
    self.camera = Camera(self.player)

    self:add()

    local image = gfx.image.new('image/level/background') or error("Failed to load image")

    self:setImage(image)
    self:moveTo(200, 120)
    self:setZIndex(-1)
    
    self.cashEnemy:getEnemy(400 / 4 * 1, 120, self.player)
    self.cashEnemy:getEnemy(400 / 4 * 2, 120, self.player)
    self.cashEnemy:getEnemy(400 / 4 * 3, 120, self.player)
end

function Level:spawnEnemy()
    if self.cashEnemy:getCountEnemy() >= 5 then
        return
    end

    if self.lastSpawnTime + self.spawnInterval < pd.getCurrentTimeMilliseconds() then
        local point = arc:pointOnArc(math.random(0, math.floor(arc:length())))
        self.cashEnemy:getEnemy(point.x, point.y)
        self.lastSpawnTime = pd.getCurrentTimeMilliseconds()
    end
end

function Level:update()
    self:spawnEnemy()
end
