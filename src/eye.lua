eye = {}

function eye.load()
  eye.img = {}
  for i = 1,8 do
    eye.img[i] = love.graphics.newImage("assets/eye"..i..".png")
    eye.img[i]:setFilter("nearest","nearest")
  end
end

function eye.draw(perc)
  local cur = math.floor((1-perc)*7)+1
  scale = 2
  love.graphics.draw(eye.img[cur],16,16,0,scale,scale)
end

return eye