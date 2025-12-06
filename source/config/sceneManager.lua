local pd <const> = playdate
local gfx <const> = pd.graphics


SceneManager = {}
class('SceneManager').extends()

function SceneManager:switchScene(scene, ...)
    self.newScene = scene
    self.sceneArgs = ...
    self:loadNewScene()
end

function SceneManager:loadNewScene()
    self:cleanupScene()
    self.newScene(self.sceneArgs)
end

function SceneManager:cleanupScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0, 0)
end

function SceneManager:removeAllTimers()
    local timers = pd.timer.allTimers()
    for _, timer in ipairs(timers) do
        timer:remove()
    end
end
