math.randomseed( os.time() )
eye = require("eye")
parts = require("parts")
battery = require("battery")
map = require("map")

function love.load()
  eye.load()
  parts.load()
  battery.load()
  map.load()
end

function love.draw()
  love.graphics.setColor(195,195,195)
  love.graphics.rectangle("fill",0,0,160,480)
  love.graphics.setColor(255,255,255)
  eye.draw(0)
  parts.draw()
  battery.draw(1)
  map.draw()
end

function love.update(dt)
  map.update(dt)
end