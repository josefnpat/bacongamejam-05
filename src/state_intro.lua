require("lovesplash/lovesplash")
require("msssplash/msssplash")

local intro = {}

intro.love = true

function intro:draw()
  if intro.love then
    lovesplash.draw()
  else
    msssplash.draw()
  end
end

function intro:update(dt)
  lovesplash.update(dt)
  if lovesplash.done() then
    intro.love = false
  end
  msssplash.update(dt)
  if msssplash.done() then
    Gamestate.switch(states.cut)
  end
end

function intro:keypressed()
  if intro.love then
    intro.love = false
    lovesplash.stop()
  else
    Gamestate.switch(states.cut)
  end
end

return intro