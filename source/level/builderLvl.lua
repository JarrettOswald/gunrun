local pd <const> = playdate
local gfx <const> = playdate.graphics

BuilderLvl = {}
class("BuilderLvl").extends()

local tiles = gfx.imagetable.new("image/level/tiles") or error("nil imagetable")
local TILE_SIZE <const> = 20


function BuilderLvl:init(width, height)
    self.widthBlock = width / TILE_SIZE
    self.heightBlock = height / TILE_SIZE
end

function BuilderLvl:buildLevel()
    local img = gfx.image.new(self.width, self.height)
    gfx.pushContext(img)
end
