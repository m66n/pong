local Element = {}
Element.__index = Element


function Element.new (x, y, width, height)
	local self = setmetatable({
    x = x,
    y = y,
    width = width,
    height = height
  }, Element)
  return self
end


function Element:draw ()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
  

return Element
