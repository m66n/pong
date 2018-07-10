local Element = require 'Element'


local Ball = setmetatable({}, {__index = Element})
Ball.__index = Ball


function Ball.new (x, y, width, height)
  local self = setmetatable(Element.new(x, y, width, height), Ball)
  self.dx = 0
  self.dy = 0
  return self
end


function Ball:update (dt) 
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x < 0 then
    self.x = -self.x
    self.dx = -self.dx
  elseif self.x > love.graphics.getWidth() - self.width then
    self.x = 2 * (love.graphics.getWidth() - self.width) - self.x
    self.dx = -self.dx
  end

  if self.y < 0 then
    self.y = -self.y
    self.dy = -self.dy
  elseif self.y > love.graphics.getHeight() - self.height then
    self.y = 2 * (love.graphics.getHeight() - self.height) - self.y
    self.dy = -self.dy
  end
end


return Ball
