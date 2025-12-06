local pd <const> = playdate
local gfx <const> = pd.graphics
local math <const> = math
local geom <const> = pd.geometry

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
    self.selectEnemy = nil
    self.lastEnemySearchTime = 0
    self.enemySearchInterval = 200

    local image = gfx.image.new('image/player')
    self:setImage(image)

    self:moveTo(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    self:add()
end

local function rotationSprite(self, angle)
    local scaleX = (angle > 0 and angle < 180) and -1 or 1
    if self._lastScaleX ~= scaleX then
        self:setScale(scaleX, 1)
        self._lastScaleX = scaleX
    end
end

local function run(self, angle)
    local arc = geom.arc.new(self.x, self.y, MOVE_SPEED, angle, angle)
    local point = arc:pointOnArc(0)

    rotationSprite(self, angle)

    local clampedX = math.min(math.max(PLAYER_WIDTH / 2, point.x), SCREEN_WIDTH - PLAYER_WIDTH / 2)
    local clampedY = math.min(math.max(PLAYER_HEIGHT / 2, point.y), SCREEN_HEIGHT - PLAYER_HEIGHT / 2)

    self:moveTo(clampedX, clampedY)
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

local function getClosestEnemy(self, enemies)
    local closest = nil
    local minDist = math.huge

    for _, enemy in ipairs(enemies) do
        local dist = geom.distanceToPoint(self.x, self.y, enemy.x, enemy.y)
        if dist < minDist then
            minDist = dist
            closest = enemy
        end
    end
    return closest
end

local function handleFocus(self)
    if self.selectEnemy then
        local disToTarget = geom.distanceToPoint(self.x, self.y, self.selectEnemy.x, self.selectEnemy.y)

        if self.selectEnemy.health <= 0 or disToTarget > SEARCH_RADIUS then
            self.selectEnemy = nil
            self.targetIsSelect = false
            self.lastEnemySearchTime = 0
        end
    end
end

local function selectClosestTarget(self)
    local now = pd.getCurrentTimeMilliseconds()

    if not self.selectEnemy and (now - self.lastEnemySearchTime >= self.enemySearchInterval) then
        local enemies = findEnemies(self)
        self.lastEnemySearchTime = now

        if #enemies > 0 then
            self.selectEnemy = getClosestEnemy(self, enemies)
            self.targetIsSelect = true
        end
    end
end

local function handleInput(self)
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.shield:up()
    end
end

local function fire(self)
    if self.selectEnemy then
        self.gun:fire(self.selectEnemy)
    end
end

local function moveShield(self)
    self.shield:moveTo(self.x, self.y)
end

function Player:update()
    local angle = pd.getCrankPosition()

    run(self, angle)
    handleFocus(self)
    selectClosestTarget(self)
    handleInput(self)
    moveShield(self)
    fire(self)
end
