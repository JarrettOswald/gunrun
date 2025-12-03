import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/graphics"
import "CoreLibs/ui"

import "actors/player"
import "level/level"
import "actors/enemy"
import "config"
import "guns/bullet"
import "guns/gun"
import "shields/shield"


local pd <const> = playdate
local gfx <const> = playdate.graphics


local lvl = Level()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()

    local fps = pd.getFPS()
    gfx.drawText("FPS: " .. fps, 5, 5)
    gfx.drawText("Count: " .. lvl.enemyCount, 5, 20)
end