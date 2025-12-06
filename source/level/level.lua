local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Level = {}

class('Level').extends(gfx.sprite)

local arc = geom.arc.new(200, 120, 120, 0, 360)

local assetsTable = gfx.imagetable.new("image/level/assets") or error("nil imagetable")
local LVL_HEIGHT = 800
local LVL_WIDTH = 600

function Level:init()
    self.player = Player()
    self.cashEnemy = CashEnemy(self.player)
    self.lastSpawnTime = 10
    self.spawnInterval = 200
    self.camera = Camera(self.player)
    self:add()

    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.clear()

    local image = assetsTable:getImage(1, 2) or error("Failed to load image")
    local backgroundImage = gfx.image.new(LVL_WIDTH, LVL_HEIGHT)

    gfx.pushContext(backgroundImage)
    
    for i = 1, LVL_WIDTH, 16 do
        for j = 1, LVL_HEIGHT, 16 do
            image:draw(i, j)
        end
    end

    for i = 1, LVL_HEIGHT, 16 do
        gfx.fillRoundRect(0, i, 16, 16, 5)
    end

    for i = 1, LVL_HEIGHT, 16 do
        gfx.fillRoundRect(LVL_WIDTH - 16, i, 16, 16, 5)
    end


    for i = 1, LVL_WIDTH, 16 do
        gfx.fillRoundRect(i, 0, 16, 16, 5)
    end

    for i = 1, LVL_WIDTH, 16 do
        gfx.fillRoundRect(i, LVL_HEIGHT - 16, 16, 16, 5)
    end

    gfx.popContext()

    local backgroundSprite = gfx.sprite.new(backgroundImage)
    backgroundSprite:setCenter(0, 0)
    backgroundSprite:setZIndex(-1)
    backgroundSprite:add()

    self:moveTo(200, 120)
    self:setZIndex(-1)

    self.cashEnemy:getEnemy(400 / 4 * 1, 120, self.player)
    self.cashEnemy:getEnemy(400 / 4 * 2, 120, self.player)
    self.cashEnemy:getEnemy(400 / 4 * 3, 120, self.player)
end

function Level:spawnEnemy()
    if self.cashEnemy:getCountEnemy() >= 35 then
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
