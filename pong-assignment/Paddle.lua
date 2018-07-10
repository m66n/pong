local Element = require 'Element'


local Paddle = setmetatable({}, {__index = Element})
Paddle.__index = Paddle


return Paddle
