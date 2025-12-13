local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Level = {}

class('Level').extends(gfx.sprite)

local assetsTable = gfx.imagetable.new("image/level/assets") or error("nil imagetable")
local LVL_HEIGHT = 800
local LVL_WIDTH = 600

local SPAWN_INTERVAL = 200

function Level:init()
    self.player = Player()
    self.cashEnemy = CashEnemy(self.player)
    self.lastSpawnTime = 10
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

    gfx.popContext()

    local backgroundSprite = gfx.sprite.new(backgroundImage)
    backgroundSprite:setCenter(0, 0)
    backgroundSprite:setZIndex(-1)
    backgroundSprite:add()
    

    self:moveTo(200, 120)
    self:setZIndex(-1)
end

function Level:spawnEnemy()
    if self.cashEnemy:getCountEnemy() >= 10 then
        return
    end

    if self.lastSpawnTime + SPAWN_INTERVAL < pd.getCurrentTimeMilliseconds() then
        self.cashEnemy:createSkeleton(300, 400)
        self.lastSpawnTime = pd.getCurrentTimeMilliseconds()
    end
end

function Level:update()
    self.cashEnemy:update()
    self:spawnEnemy()
end
