local parts = {}

function parts.load()
  parts.img = {}
  parts.img.bg = love.graphics.newImage("assets/parts_bg.png")
  parts.img.bg:setFilter("nearest","nearest")
  parts.data = {
    right_arm = {
      x = 44,
      y = 16,
      i = 0,
      inv = debug_mode
    },
    left_arm = {
      x = 4,
      y = 16,
      i = 1,
      inv = debug_mode
    },
    left_leg = {
      x = 12,
      y = 44,
      i = 2,
      inv = debug_mode
    },
    right_leg = {
      x = 36,
      y = 44,
      i = 3,
      inv = debug_mode
    },
    head = {
      x = 24,
      y = 4,
      i = 4,
      inv = debug_mode
    },
    torso = {
      x = 24,
      y = 24,
      i = 5
    }
  }

  parts.data_count = 0
  for i,v in pairs(parts.data) do
    parts.data_count = parts.data_count + 1
  end

  parts.img.data = love.graphics.newImage("assets/parts.png")
  parts.img.data:setFilter("nearest","nearest")
  for i,v in pairs(parts.data) do
    v.quad = love.graphics.newQuad(v.i*16,0,16,16,128,16)
  end
end

function parts.haveall()
  for i,v in pairs(parts.data) do
    if v.inv ~= true then
      return false
    end
  end
  return true
end

function parts.random()
  repeat
    for i,v in pairs(parts.data) do
      if not v.inv and math.random(0,1) == 0 then
        return i
      end
    end
  until false
end

function parts.draw()
  local scale = 2
  local x_offset = 0+16
  local y_offset = 160+16
  love.graphics.draw(parts.img.bg,x_offset,y_offset,0,scale,scale)
  for i,v in pairs(parts.data) do
    if v.inv then
      love.graphics.drawq(parts.img.data,v.quad,x_offset+v.x*scale,y_offset+v.y*scale,0,scale,scale)
    end
  end
end

return parts