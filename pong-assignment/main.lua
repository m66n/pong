Paddle = require 'Paddle'
Ball = require 'Ball'


PADDLE_WIDTH = 10
PADDLE_HEIGHT = 40
PADDLE_OFFSET = 10

BALL_WIDTH = 10
BALL_HEIGHT = 10

SCORE_OFFSET = 20


function love.load ()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  math.randomseed(os.time())

  fonts = {
    ['small'] = love.graphics.newFont('LCD_Solid.ttf', 16),
    ['medium'] = love.graphics.newFont('LCD_Solid.ttf', 32),
    ['large'] = love.graphics.newFont('LCD_Solid.ttf', 64)
  }
  love.graphics.setFont(fonts.small)

  players = {
    Paddle.new(PADDLE_OFFSET,
      (love.graphics.getHeight() - PADDLE_HEIGHT) / 2,
      PADDLE_WIDTH, PADDLE_HEIGHT),
    Paddle.new(love.graphics.getWidth() - PADDLE_OFFSET - PADDLE_WIDTH,
      (love.graphics.getHeight() - PADDLE_HEIGHT) / 2,
      PADDLE_WIDTH, PADDLE_HEIGHT)
  }

  scores = {0, 0}

  servingPlayer = 1
  winningPlayer = 0

  ball = Ball.new((love.graphics.getWidth() - BALL_WIDTH) / 2,
      (love.graphics.getHeight() - BALL_HEIGHT) / 2,
      BALL_WIDTH, BALL_HEIGHT)

  ball.dy = math.random(-50, 50)
  ball.dx = math.random(140, 200)

  showInfo = false
end


function love.draw ()
  players[1]:draw()
  players[2]:draw()
  ball:draw()

  score()

  if showInfo then
    info()
  end
end


function love.keypressed (key)
  if key == 'i' then
    showInfo = not showInfo
  end
end


function love.update (dt)
  ball:update(dt)
end


function score ()
  love.graphics.setFont(fonts.large)
  love.graphics.printf(scores[1], 0, SCORE_OFFSET,
      love.graphics.getWidth() / 2, 'center')
  love.graphics.printf(scores[2], love.graphics.getWidth() / 2, SCORE_OFFSET,
      love.graphics.getWidth() / 2, 'center')
end


function info ()
  local major, minor, revision = love.getVersion()
  local info = string.format('LÖVE %d.%d.%d, %s (%d FPS)', major, minor,
      revision, _VERSION, love.timer.getFPS())

  love.graphics.setFont(fonts.small)
  love.graphics.printf(info, 0,
      love.graphics.getHeight() - fonts.small:getHeight(),
      love.graphics.getWidth(), 'center')
end


function debug (msg)
  love.graphics.setFont(fonts.small)
  love.graphics.printf(msg, 0, 0, love.graphics.getWidth(), 'left')
end
