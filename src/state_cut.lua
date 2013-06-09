local cut = {}

function cut:init()
  
  faces = {}
  faces.heroine = love.graphics.newImage("assets/faces/heroine-default.png")
  faces.heroine_scared = love.graphics.newImage("assets/faces/heroine-scared.png")
  faces.sibling_scared = love.graphics.newImage("assets/faces/sibling-scared.png")
  faces.horror = love.graphics.newImage("assets/faces/horror-default.png")
  faces.eyes = love.graphics.newImage("assets/faces/eyes.png")
  
  for i,v in pairs(faces) do
    v:setFilter("nearest","nearest")
  end
  
  cut.current = 1

  cut.scenes = {}

  cut.scenes[1] = {
    img = faces.sibling_scared,
    text = "Sis, Help Me!",
    next = 2,
  }

  cut.scenes[2] = {
    img = faces.horror,
    text = "<< INTO THE DEPTHS OF NEZPERDIAN  >>\n"..
           "<< FOLLOW IF YOU DARE, MORTAL. >>\n",
    next = 3,
    ret = true
  }

  cut.scenes[3] = {
    img = faces.heroine,
    text = "Boy, I'm glad I brought this crank flashlight.",
    next = 4,
    ret = true
  }

  cut.scenes[4] = {
    img = faces.heroine,
    text = "I seem to be slowly waking up ...",
    next = 5,
    ret = true
  }
  
  cut.scenes[5] = {
    img = faces.heroine,
    text = "I need to find all my brother's pieces ...",
    next = 6,
    ret = true
  }
  
  cut.scenes[6] = {
    img = faces.heroine,
    text = "This maze must be in a differet dimension ...",
    next = 7,
    ret = true
  }
  
  cut.scenes[7] = {
    img = faces.heroine_scared,
    text = "Woah, I think I heard something!",
    next = 3,
    ret = true
  }

  cut.scenes[100] = {
    img = faces.heroine,
    text = "I have all of his pieces.\n"..
           "I should head back how.\n"..
           "I hope I remeber how to get back.",
    next = 101,
    ret = true
  }
  
  cut.scenes[101] = {
    img = faces.heroine_scared,
    text = "I need to hurry!",
    next = 102,
    ret = true
  }
  
  cut.scenes[102] = {
    img = faces.horror,
    text = "<< I WAIT BEHIND THE WALL. >>",
    next = 103,
    ret = true
  }
  
  cut.scenes[103] = {
    img = faces.heroine_scared,
    text = "Is this the right way?",
    next = 104,
    ret = true
  }
  
  cut.scenes[104] = {
    img = faces.horror,
    text = "<< NOTHING BUT CHAOS >>\n"..
           "<< TIME WILL DEVOUR YOU. >>",
    next = 101,
    ret = true
  }
  
  cut.scenes[200] = {
    img = faces.heroine,
    text = "Surely I'm safe in my room...\n"..
           "Now how do I put him back together?",
    next = 201,
  }
  
  cut.scenes[201] = {
    img = faces.heroine_scared,
    text = "Maybe if I just sew them back on ...",
    next = 202,
  }
  
  cut.scenes[202] = {
    img = faces.heroine,
    text = "It's working! It's working!",
    next = 203,
  }
  
  cut.scenes[203] = {
    img = faces.sibling_scared,
    text = "Sis, you saved me!",
    next = 204
  }
  
  cut.scenes[204] = {
    img = faces.sibling_scared,
    text ="<< You saved me! >>",
    next = 205
  }
  
  cut.scenes[205] = {
    img = faces.horror,
    text = "<< YOU SAVED ME >>",
    next = 206
  }

  cut.scenes[206] = {
    img = faces.horror,
    text = "<< THANKS FOR PLAYING! >>\n"..
           "<< VISIT >>\n<< MISSINGSENTINELSOFTWARE.COM >>\n<< FOR MORE! >>",
    next = 206
  }
  
  cut.scenes[300] = {
    img = faces.eyes,
    text = "*Yaaaawwwn*\n",
    next = 301
  }
  
  cut.scenes[301] = {
    img = faces.eyes,
    text = "What a horrible nightmare ...",
    next = 302
  }

  cut.scenes[302] = {
    img = faces.heroine_scared,
    text = "Wait, where's my brother?",
    next = 206
  }
  
end

function cut:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.draw(cut.scenes[cut.current].img,0,224,0,4,4)
  love.graphics.setFont(fonts.normal)
  love.graphics.printf(cut.scenes[cut.current].text,32,100,640-64,"center")
end

function cut:leave()
  cut.current = cut.scenes[cut.current].next
end

function cut:keypressed()
  if cut.scenes[cut.current].ret then
  Gamestate.switch(states.game)
  else
    cut:leave()
  end
end

return cut