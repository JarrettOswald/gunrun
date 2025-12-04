local pd <const> = playdate
local gfx <const> = pd.graphics
local math <const> = math

Player = {}

class('Player').extends(gfx.sprite)

local PLAYER_WIDTH = 8
local PLAYER_HEIGHT = 16
local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240
local MOVE_SPEED = 3
local SEARCH_RADIUS = 50

function Player:init()
    self.lastFireTime = 0
    self.gun = Gun(self)
    self.shield = Shield()
    self.targetIsSelect = false
    self.selectEnemy = {}

    local image = gfx.image.new('image/player')
    self:setImage(image)

    self:moveTo(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    self:add()
end

local function rotationSprite(self, angle)
    local scaleX = (angle > 0 and angle < 180) and -1 or 1
    self:setScale(scaleX, 1)
end

local function run(self, angle)
    local rad = math.rad(angle - 90)

    local xd = math.cos(rad) * MOVE_SPEED
    local yd = math.sin(rad) * MOVE_SPEED

    local newX = self.x + xd
    local newY = self.y + yd

    newX = math.max(PLAYER_WIDTH / 2, math.min(SCREEN_WIDTH - PLAYER_WIDTH / 2, newX))
    newY = math.max(PLAYER_HEIGHT / 2, math.min(SCREEN_HEIGHT - PLAYER_HEIGHT / 2, newY))

    self:moveTo(newX, newY)
end

local function findEnemies(self)
    local enimies = {}

    local sprites = gfx.sprite.querySpritesInRect(
        self.x - SEARCH_RADIUS,
        self.y - SEARCH_RADIUS,
        SEARCH_RADIUS * 2,
        SEARCH_RADIUS * 2
    )

    for _, sprite in ipairs(sprites) do
        if sprite:getTag() == TAGS.EMENY then
            table.insert(enimies, sprite)
        end
    end

    return enimies
end

local function aimEnemies(self, enimies)
    if #enimies > 0 and not self.targetIsSelect then
        self.selectEnemy = enimies[math.random(1, #enimies)]
    end
end

function Player:update()
    local angle = pd.getCrankPosition()

    rotationSprite(self, angle)
    run(self, angle)
    local enimies = findEnemies(self)

    aimEnemies(self, enimies)

    self.shield:moveTo(self.x, self.y)

    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.shield:up()
    end

    print(self.selectEnemy.number)
end
