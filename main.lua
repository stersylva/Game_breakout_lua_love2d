Timer = require('hump/timer')

require "types"

DeadBrick = require("entidades/dead_brick")
Ball      = require("entidades/ball")
Paddle    = require("entidades/paddle")
Brick     = require("entidades/brick")

-- configuração

local config = {
    maxXVelocity = 500.0,
    paddleXVelocityFactor = 500.0
}

-- variaveis

local deadBricks
local bricks
local ball
local paddle

-- pontos de entrada

function love.load()
    math.randomseed(os.time())
    generateWorld()

    background = love.graphics.newImage("Imagens/fundo.jpg")
    love.mouse.setVisible(false) --Oculta o cursor do mouse para deoxar a tela limpa de qualquer coisa fora do jogo

end

function love.update(dt)
    Timer.update(dt)

    -- carrega tijolos mortos
    for deadBrick, _ in pairs(deadBricks) do
        deadBrick:update(dt)
    end

    -- move a pá
    paddle:update(dt)

    -- move a bola
    ball:update(dt)

    -- olha se colidiu com a parede
    if ball.rect:collidesWith(paddle.rect) then
        if ball.oldRect:isFullyBelow(paddle.rect) or ball.oldRect:isFullyAbove(paddle.rect) then
            paddleMiddle, _ = paddle.rect:middle()
            ballMiddle, _   = ball.rect:middle()
            local factor = (ballMiddle - paddleMiddle) / paddle.rect.size.width / 2
            ball.velocityVector.x = ball.velocityVector.x + factor * config.paddleXVelocityFactor
            if ball.velocityVector.x > config.maxXVelocity then
                ball.velocityVector.x = config.maxXVelocity
            elseif ball.velocityVector.x < -config.maxXVelocity then
                ball.velocityVector.x = -config.maxXVelocity
            end

            ball.velocityVector.y = - ball.velocityVector.y
            ball:collidedVertically()
        elseif ball.oldRect:isFullyLeft(paddle.rect) or ball.oldRect:isFullyRight(paddle.rect) then
            ball.velocityVector.x = - ball.velocityVector.x
            ball:collidedHorizontally()
        end
    end

    -- verifica a colisão com a parede
    if ball.rect:left() < 0 then
        ball.rect.origin.x    = - ball.rect.origin.x
        ball.velocityVector:invertX()
        ball:collidedHorizontally()
    elseif ball.rect:right() > love.graphics.getWidth() then
        ball.rect.origin.x    = love.graphics.getWidth() - (ball.rect:right() - love.graphics.getWidth())
        ball.velocityVector:invertX()
        ball:collidedHorizontally()
    end
    if ball.rect:top() < 0 then
        ball.rect.origin.y    = - ball.rect.origin.y
        ball.velocityVector:invertY()
        ball:collidedVertically()
    elseif ball.rect:bottom() > love.graphics.getHeight() then

        love.load()
    end

    -- verifica se colidiu com o tijolo
    for brick, _ in pairs(bricks) do
        if ball.rect:collidesWith(brick.rect) then
            bricks[brick] = nil
            local x, y   = brick.rect.origin.x, brick.rect.origin.y
            local w, h   = brick.rect.size.width, brick.rect.size.height
            local fx, fy = ball.rect.origin.x - ball.oldRect.origin.x, ball.rect.origin.y - ball.oldRect.origin.y
            deadBrick = DeadBrick.new(x, y, w, h, fx, fy)
            deadBrick:onDeath(function(deadBrick) deadBricks[deadBrick] = nil end)
            deadBricks[deadBrick] = true

            if ball.oldRect:isFullyBelow(brick.rect) or ball.oldRect:isFullyAbove(brick.rect) then
                ball:collidedVertically()
                ball.velocityVector.y = - ball.velocityVector.y
            elseif ball.oldRect:isFullyLeft(brick.rect) or ball.oldRect:isFullyRight(brick.rect) then
                ball:collidedHorizontally()
                ball.velocityVector.x = - ball.velocityVector.x
            end
        end
    end
end

function love.draw()
    -- plano de fundo
    love.graphics.draw(background, 10,10)

    -- tijolos
    for brick, _ in pairs(bricks) do
        brick:render()
    end

    -- tijolos mortos
    for deadBrick, _ in pairs(deadBricks) do
        deadBrick:render()
    end

    -- bola
    ball:render()

    -- pa
    paddle:render()
end


function generateWorld()
    -- tijolos mortos
    deadBricks = {}

    local rectToFill = Rect.new(50, 50, love.graphics.getWidth() - 50,90)
    local brickSize = Size.new(60,30)
    local brickSpacing = Size.new(10, 10)
    bricks = {}
    local x = rectToFill:left()
    while x < rectToFill:right() - brickSize.width - brickSpacing.width do
        local y = rectToFill:top()
        while y < rectToFill:bottom() - brickSize.height - brickSpacing.height do
            brick = Brick.new(x, y, brickSize.width, brickSize.height)
            bricks[brick] = true
            y = y + brickSize.height + brickSpacing.height
        end
        x = x + brickSize.width + brickSpacing.width
    end

    -- bola
    ball = Ball.new(love.graphics.getWidth()/2 - 40, 400, 10, 10, 60, 300)

    -- pa
    paddle = Paddle.new(360, 560, 120, 20)
end
