function love.load ()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  math.randomseed(os.time())

  fonts = {
    ['small'] = love.graphics.newFont('LCD_Solid.ttf', 16),
    ['medium'] = love.graphics.newFont('LCD_Solid.ttf', 32),
    ['large'] = love.graphics.newFont('LCD_Solid.ttf', 64)
  }
  love.graphics.setFont(fonts.small)

  showInfo = false
end


function love.draw ()
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
