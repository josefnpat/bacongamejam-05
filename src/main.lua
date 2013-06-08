math.randomseed( os.time() )

debug_mode = false

Gamestate = require "ext.gamestate"

states = {}
states.intro = require("state_intro")
states.game = require("state_game")
states.cut = require("state_cut")

fonts = {} 
fonts.horror = love.graphics.newFont("assets/FEASFBRG.ttf",32)
fonts.normal = love.graphics.newFont("assets/EBGaramond-Regular.ttf",24)

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(states.intro)
end

function love.keypressed(key)
  if key == "`" then
    debug_mode = not debug_mode
    if debug_mode then
      print("debug_mode enabled")
    else
      print("debug_mode disabled")
    end
  end
end