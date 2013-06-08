local cut = {}

function cut:init()

  cut.current = 0
  
  faces = {}
  faces.heroine = love.graphics.newImage("assets/faces/heroine-default.png")
  faces.heroine_scared = love.graphics.newImage("assets/faces/heroine-scared.png")
  faces.sibling_scared = love.graphics.newImage("assets/faces/sibling-scared.png")
  faces.horror = love.graphics.newImage("assets/faces/horror-default.png")
  faces.eyes = love.graphics.newImage("assets/faces/eyes.png")
  
  for i,v in pairs(faces) do
    v:setFilter("nearest","nearest")
  end
  
  cut.loopindex = 2

  cut.scenes = {}

  cut.scenes[1] = {
    img = faces.sibling_scared,
    text = "Sis, Help me!"
  }

  cut.scenes[2] = {
    img = faces.eyes,
    text = "<<  >>"
  }

  cut.scenes[3] = {
    img = faces.heroine,
    text = "Ok ..."
  }
  
end

function cut:draw()
  love.graphics.draw(cut.scenes[cut.current].img,0,224,0,4,4)
  love.graphics.setFont(fonts.normal)
  love.graphics.printf(cut.scenes[cut.current].text,32,100,640-64,"center")
end

function cut:enter()
  cut.current = cut.current + 1
  if cut.current > #cut.scenes then
    cut.current = cut.loopindex
  end
end

function cut:keypressed()
  Gamestate.switch(states.game)
end

return cut