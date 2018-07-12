Paddle = require 'Paddle'
Ball = require 'Ball'


PADDLE_WIDTH = 10
PADDLE_HEIGHT = 40
PADDLE_OFFSET = 10
PADDLE_SPEED = 200

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

  drawScore()

  if showInfo then
    drawInfo()
  end
end


function love.keypressed (key)
  if key == 'i' then
    showInfo = not showInfo
  end
end


function love.update (dt)
  if love.keyboard.isDown('w') then
    players[1].dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then
    players[1].dy = PADDLE_SPEED
  else
    players[1].dy  = 0
  end

  if love.keyboard.isDown('up') then
    players[2].dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then
    players[2].dy = PADDLE_SPEED
  else
    players[2].dy  = 0
  end

  players[1]:update(dt)
  players[2]:update(dt)

  ball:update(dt)

  if checkOverlap(players[1], ball) then
    ball.x = 2 * (players[1].x + players[1].width) - ball.x
    ball.dx = -ball.dx
  elseif checkOverlap(players[2], ball) then
    ball.x = 2 * players[2].x - (ball.x + ball.width)
    ball.dx = -ball.dx
  end

  checkPoint()
end


function checkOverlap (a, b)
  return (a.x < (b.x + b.width)) and ((a.x + a.width) > b.x)
      and (a.y < (b.y + b.height)) and ((a.y + a.height) > b.y)
end


function resetBall ()
  ball.dx = 0
  ball.dy = 0
  ball.x = (love.graphics.getWidth() - ball.width) / 2
  ball.y = (love.graphics.getHeight() - ball.height) / 2
end


function checkPoint ()
  if ball.x < (PADDLE_OFFSET + players[1].width) then
    scores[2] = scores[2] + 1
    resetBall()
  elseif ball.x > players[2].x then
    scores[1] = scores[1] + 1
    resetBall()
  end
end


function drawScore ()
  love.graphics.setFont(fonts.large)
  love.graphics.printf(scores[1], 0, SCORE_OFFSET,
      love.graphics.getWidth() / 2, 'center')
  love.graphics.printf(scores[2], love.graphics.getWidth() / 2, SCORE_OFFSET,
      love.graphics.getWidth() / 2, 'center')
end


function drawInfo ()
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
