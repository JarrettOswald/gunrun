local pd <const> = playdate
local gfx <const> = playdate.graphics

BuilderLvl = {}
class("BuilderLvl").extends()

local tiles = gfx.imagetable.new("image/level/tiles") or error("nil imagetable")

local tilesMap = {
    [1] = tiles:getImage(2, 2), -- Угол верх-лево
    [2] = tiles:getImage(3, 2), -- Стена верх
    [3] = tiles:getImage(4, 2), -- Угол верх-право
    [4] = tiles:getImage(2, 3), -- Стена лево
    [5] = tiles:getImage(3, 3), -- (Не используется в коробке)
    [6] = tiles:getImage(4, 3), -- Стена право
    [7] = tiles:getImage(2, 4), -- Угол низ-лево
    [8] = tiles:getImage(3, 4), -- Стена низ
    [9] = tiles:getImage(4, 4), -- Угол низ-право
    [0] = tiles:getImage(3, 3), -- Пол
}

local TILE_SIZE <const> = 20


function BuilderLvl:init(width, heights)
    self.width = width
    self.heights = heights
end

function BuilderLvl:buildLevel()
    local bgImg = gfx.image.new(self.width, self.heights)

    gfx.pushContext(bgImg)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, self.width, self.heights)

    for y = 0, (self.heights / TILE_SIZE) - 1 do
        for x = 0, (self.width / TILE_SIZE) - 1 do
            local tileType = 0

            -- Определяем тип тайла в зависимости от позиции
            if y == 0 and x == 0 then
                tileType = 1 -- Угол верх-лево
            elseif y == 0 and x == (self.width / TILE_SIZE) - 1 then
                tileType = 3 -- Угол верх-право
            elseif y == (self.heights / TILE_SIZE) - 1 and x == 0 then
                tileType = 7 -- Угол низ-лево
            elseif y == (self.heights / TILE_SIZE) - 1 and x == (self.width / TILE_SIZE) - 1 then
                tileType = 9 -- Угол низ-право
            elseif y == 0 then
                tileType = 2 -- Стена верх
            elseif y == (self.heights / TILE_SIZE) - 1 then
                tileType = 8 -- Стена низ
            elseif x == 0 then
                tileType = 4 -- Стена лево
            elseif x == (self.width / TILE_SIZE) - 1 then
                tileType = 6 -- Стена право
            else
                tileType = 0 -- Пол
            end

            local tileImage = tilesMap[tileType]
            if tileImage then
                tileImage:draw(x * TILE_SIZE, y * TILE_SIZE)
            end
        end
    end
    gfx.popContext()

    local backgroundSprite = gfx.sprite.new(bgImg)
    backgroundSprite:setCenter(0, 0)
    backgroundSprite:setZIndex(-100)
    backgroundSprite:setUpdatesEnabled(false)

    return backgroundSprite
end
