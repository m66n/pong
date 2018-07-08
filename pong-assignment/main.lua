push = require 'push'

function love.draw()
  local major, minor, revision, codename = love.getVersion()
  local str = string.format('LÖVE %d.%d.%d - %s', major, minor, revision,
      codename)
  love.graphics.print(str, 20, 20)
end
