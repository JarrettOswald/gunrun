import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/graphics"
import "CoreLibs/ui"

import "level/builderLvl"
import "config/config"
import "actors/enemy/enemy"
import "actors/player"
import "level/level"
import "actors/enemy/spider"
import "actors/enemy/skeleton"
import "actors/enemy/cashEnemy"
import "guns/bullet"
import "guns/gun"
import "shields/shield"
import "level/camera"
import "config/sceneManager"

local pd <const> = playdate
local gfx <const> = playdate.graphics

SCENE_MANAGER = SceneManager()

SCENE_MANAGER:switchScene(Level)

local function memUsage()
    gfx.setDrawOffset(0, 0)

    local memUsage = math.floor(collectgarbage("count"))
    local text = "Mem: " .. memUsage .. " KB"

    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 20, 110, 20)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawText(text, 5, 22)
end

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pd.drawFPS(0, 0)

    memUsage()
end
