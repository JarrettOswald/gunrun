local pd <const> = playdate
local gfx <const> = playdate.graphics
local geom <const> = playdate.geometry

Level = {}

class('Level').extends(gfx.sprite)

local assetsTable = gfx.imagetable.new("image/level/tiles") or error("nil imagetable")

local SPAWN_INTERVAL = 200

local builderLvl = BuilderLvl(400, 400)

function Level:init()
    self.player = Player()
    self.cashEnemy = CashEnemy(self.player)
    self.lastSpawnTime = 10
    self.camera = Camera(self.player)
    self.backgroundSprite = builderLvl:buildLevel()

    self.backgroundSprite:moveTo(-20, -20)
    self.backgroundSprite:add()

    gfx.setBackgroundColor(gfx.kColorBlack)
    gfx.clear()

    self:setZIndex(-1)
    self:add()
end

function Level:spawnEnemy()
    if self.cashEnemy:getCountEnemy() >= 3 then
        return
    end

    if self.lastSpawnTime + SPAWN_INTERVAL < pd.getCurrentTimeMilliseconds() then
        self.cashEnemy:createSkeleton(200, 120)
        self.lastSpawnTime = pd.getCurrentTimeMilliseconds()
    end
end

function Level:update()
    self.cashEnemy:update()
    self:spawnEnemy()
end
