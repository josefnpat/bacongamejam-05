math.randomseed( os.time() )
eye = require("eye")
parts = require("parts")
battery = require("battery")
map = require("map")

fonts = {}
fonts.horror = love.graphics.newFont("assets/FEASFBRG.ttf",32)
fonts.normal = love.graphics.newFont("assets/EBGaramond-Regular.ttf",16)

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
  eye.draw(map.player.awake)
  parts.draw()
  if map.player.battery == 0 then
    battery.draw(map.player.battery_charge)  
  else
    battery.draw(map.player.battery)
  end
  map.draw()
end

function love.update(dt)
  map.update(dt)
  battery.update(dt)
end

function love.keypressed(key)
  battery.keypressed(key)
end