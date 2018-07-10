Paddle = require 'Paddle'
Ball = require 'Ball'


PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_OFFSET = 10

BALL_WIDTH = 4
BALL_HEIGHT = 4


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

  ball = Ball.new((love.graphics.getWidth() - BALL_WIDTH) / 2,
      (love.graphics.getHeight() - BALL_HEIGHT) / 2,
      BALL_WIDTH, BALL_HEIGHT)

  showInfo = false
end


function love.draw ()
  players[1]:draw()
  players[2]:draw()
  ball:draw()

  if showInfo then
    info()
  end
end


function love.keypressed (key)
  if key == 'i' then
    showInfo = not showInfo
  end
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
