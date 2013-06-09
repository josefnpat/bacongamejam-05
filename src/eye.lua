local eye = {}

function eye.load()
  eye.img = {}
  for i = 1,8 do
    eye.img[i] = love.graphics.newImage("assets/eye"..i..".png")
    eye.img[i]:setFilter("nearest","nearest")
  end
end

function eye.draw(perc)
  local cur = math.floor((1-perc)*8)+1
  scale = 2
  love.graphics.draw(eye.img[cur],16,16,0,scale,scale)
end

function eye.update(dt)
  local dec = 1/(15*60)
  
  map.player.awake = map.player.awake + dec*dt
  if map.player.awake > 1 then
    map.player.awake = 1
    states.cut.current = 300
  end
  
end

return eye