local Element = require 'Element'


local Paddle = setmetatable({}, {__index = Element})
Paddle.__index = Paddle


function Paddle.new (x, y, width, height)
  local self = setmetatable(Element.new(x, y, width, height), Paddle)
  self.dy = 0
  self.auto = false
  return self
end


function Paddle:draw ()
  love.graphics.rectangle(self.auto and 'line' or 'fill',
      self.x, self.y, self.width, self.height)
end


function Paddle:update (dt) 
  self.y = self.y + self.dy * dt
  if self.dy < 0 then
    self.y = math.max(0, self.y)
  else
    self.y = math.min(love.graphics.getHeight() - self.height, self.y)
  end
end


return Paddle
