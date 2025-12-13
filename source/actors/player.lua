local pd <const> = playdate
local gfx <const> = pd.graphics
local math <const> = math
local geom <const> = pd.geometry

Player = {}

class('Player').extends(gfx.sprite)

local MOVE_SPEED = 4
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
    self:setCollideRect(2, 0, 12, 16)
    self:setTag(TAGS.PLAYER)
    self:setGroups(TAGS.PLAYER)

    self:moveTo(400, 300)
    self:add()
end

function Player:damage(damageAmount)
    -- todo()
end

local function rotationSprite(self, angle)
    local scaleX = (angle > 0 and angle < 180) and -1 or 1
    if self.lastScaleX ~= scaleX then
        self:setScale(scaleX, 1)
        self.lastScaleX = scaleX
    end
end

local function run(self)
    local angle = pd.getCrankPosition()
    rotationSprite(self, angle)
    local rad = math.rad(angle - 90)

    local dx = math.cos(rad) * MOVE_SPEED
    local dy = math.sin(rad) * MOVE_SPEED

    
    local newX = self.x + dx
    local newY = self.y + dy

    local x = math.max(0, math.min(600, newX))
    local y = math.max(0, math.min(800, newY))
    self:moveTo(x, y)
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
        local point = self.selectEnemy
        self.gun:fire(point)
    end
end

local function moveShield(self)
    self.shield:moveTo(self.x, self.y)
end

function Player:update()
    run(self)
    handleFocus(self)
    selectClosestTarget(self)
    handleInput(self)
    moveShield(self)
    fire(self)
end
