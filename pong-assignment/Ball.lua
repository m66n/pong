local Element = require 'Element'


local Ball = setmetatable({}, {__index = Element})
Ball.__index = Ball


return Ball
