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
    Gamestate.switch(states.game)
  end
end

function love.keypressed()
  if intro.love then
    intro.love = false
    lovesplash.stop()
  else
    Gamestate.switch(states.game)
  end
end

return intro