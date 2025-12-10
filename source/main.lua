import "CoreLibs/sprites"
import "CoreLibs/animator"
import "CoreLibs/graphics"
import "CoreLibs/ui"

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
import "config/config"
import "config/sceneManager"


local pd <const> = playdate
local gfx <const> = playdate.graphics

SCENE_MANAGER = SceneManager()

SCENE_MANAGER:switchScene(Level)

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pd.drawFPS(0, 0)
end
