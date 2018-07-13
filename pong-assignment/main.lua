Paddle = require 'Paddle'
Ball = require 'Ball'


PADDLE_WIDTH = 10
PADDLE_HEIGHT = 40
PADDLE_OFFSET = 10
PADDLE_SPEED = 200

BALL_WIDTH = 10
BALL_HEIGHT = 10
BALL_MIN_SPEED = 100
BALL_MAX_SPEED = 250

SCORE_OFFSET_Y = 20

WINNING_SCORE = 11


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

  -- 'start', 'serve', 'play', 'done'
  gameState = 'start'
  showInfo = false
end


function love.draw ()
  if gameState == 'start' then
    drawStart()
  elseif gameState == 'serve' then
    drawServe()
  elseif gameState == 'done' then
    drawDone()
  end

  players[1]:draw()
  players[2]:draw()

  if gameState == 'serve' or gameState == 'play' then
    ball:draw()
  end

  drawScore()

  if showInfo then
    drawInfo()
  end
end


function serve ()
  ball.dy = math.random(-BALL_MIN_SPEED * 2, BALL_MIN_SPEED * 2)
  if servingPlayer == 1 then
    ball.dx = math.random(BALL_MIN_SPEED, BALL_MIN_SPEED * 2)
  else
    ball.dx = -math.random(BALL_MIN_SPEED, BALL_MIN_SPEED * 2)
  end
end


function love.keypressed (key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'serve' then
      gameState = 'play'
    elseif gameState == 'done' then 
      gameState = 'serve'
      scores = {0, 0}
      if winningPlayer == 1 then
        servingPlayer = 2
      else
        servingPlayer = 1
      end
    end
  elseif key == 'i' then
    showInfo = not showInfo
  end
end


function love.update (dt)
  if gameState == 'serve' then
    serve()
  elseif gameState == 'play' then
    if checkOverlap(players[1], ball) then
      ball.x = 2 * (players[1].x + players[1].width) - ball.x
      tweakBall()
    elseif checkOverlap(players[2], ball) then
      ball.x = 2 * players[2].x - (ball.x + ball.width) - ball.width
      tweakBall()
    end
  end

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

  checkPoint()

  if gameState == 'play' then
    ball:update(dt)
  end

  players[1]:update(dt)
  players[2]:update(dt)
end


function checkOverlap (a, b)
  return (a.x < (b.x + b.width)) and ((a.x + a.width) > b.x)
      and (a.y < (b.y + b.height)) and ((a.y + a.height) > b.y)
end


function tweakBall ()
  ball.dx = -ball.dx * 1.03
  if ball.dy < 0 then
    ball.dy = -math.random(BALL_MIN_SPEED, BALL_MAX_SPEED)
  else
    ball.dy = math.random(BALL_MIN_SPEED, BALL_MAX_SPEED)
  end
end


function resetBall ()
  ball.dx = 0
  ball.dy = 0
  ball.x = (love.graphics.getWidth() - ball.width) / 2
  ball.y = (love.graphics.getHeight() - ball.height) / 2
end


function checkPoint ()
  if ball.x < (players[1].x + players[1].width) then
    scores[2] = scores[2] + 1
    servingPlayer = 1
    resetBall()
    if scores[2] == WINNING_SCORE then
      winningPlayer = 2
      gameState = 'done'
    else
      gameState = 'serve'
    end
  elseif (ball.x + ball.width) > players[2].x then
    scores[1] = scores[1] + 1
    servingPlayer = 2
    resetBall()
    if scores[1] == WINNING_SCORE then
      winningPlayer = 1
      gameState = 'done'
    else
      gameState = 'serve'
    end
  end
end


function drawMessage (line1, line2)
  love.graphics.setFont(fonts.medium)
  love.graphics.printf(line1, 0,
      love.graphics.getHeight() / 2 - 3 * fonts.medium:getHeight(),
      love.graphics.getWidth(), 'center')
  love.graphics.printf(line2, 0,
      love.graphics.getHeight() / 2 + 2 * fonts.medium:getHeight(),
      love.graphics.getWidth(), 'center')
end


function drawStart ()
  drawMessage('Welcome to Pong!', 'Press [Enter] to start!')
end


function drawServe ()
  drawMessage('Player ' .. tostring(servingPlayer) .. '\'s serve!',
      'Press [Enter] to serve!')
end


function drawDone ()
  drawMessage('Player ' .. tostring(servingPlayer) .. ' wins!',
      'Press [Enter] to restart!')
end
  

function drawScore ()
  love.graphics.setFont(fonts.large)
  love.graphics.printf(scores[1], 0, SCORE_OFFSET_Y,
      love.graphics.getWidth() / 2, 'center')
  love.graphics.printf(scores[2], love.graphics.getWidth() / 2, SCORE_OFFSET_Y,
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
