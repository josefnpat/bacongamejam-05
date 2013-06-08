battery = {}

function battery.load()
  battery.img = {}
  battery.img.bg = love.graphics.newImage("assets/battery_bg.png")
  battery.img.bg:setFilter("nearest","nearest")
  battery.img.data = love.graphics.newImage("assets/battery.png")
  battery.img.data:setFilter("nearest","nearest")
end

function battery.draw(perc)
  local scale = 2
  local x_offset = (160+32)/4
  local y_offset = 160*2+16
  love.graphics.draw(battery.img.bg,x_offset,y_offset,0,scale,scale)
  
  local height = (128-(8+5)*scale)
  local sci = height*(1-perc)
  local in_x = 3*scale
  local in_y = 8*scale
  
  love.graphics.setScissor( x_offset,in_y+y_offset+sci,160,height-sci)
  love.graphics.draw(battery.img.data,x_offset,y_offset,0,scale,scale)
  love.graphics.setScissor()
end

return battery