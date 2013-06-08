local game = {}

function game:init()
  eye = require("eye")
  parts = require("parts")
  battery = require("battery")
  map = require("map")

  eye.load()
  parts.load()
  battery.load()
  map.load()
  
end

function game:draw()
  love.graphics.setColor(195,195,195)
  love.graphics.rectangle("fill",0,0,160,480)
  love.graphics.setColor(255,255,255)
  eye.draw(map.player.awake)
  parts.draw()
  if map.player.battery == 0 then
    battery.draw(map.player.battery_charge)  
  else
    battery.draw(map.player.battery)
  end
  map.draw()
end

function game:update(dt)
  map.update(dt)
  battery.update(dt)
  eye.update(dt)
end

function game:keypressed(key)
  battery.keypressed(key)
end

return game