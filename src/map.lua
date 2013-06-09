local map = {}

function map.load()

  map.hit = love.audio.newSource("assets/hit.mp3","static")

  map.x_offset = 160
  map.y_offset = 0
  map.scale = 2

  map.data = love.graphics.newImage("assets/map.png")
  map.data:setFilter("nearest","nearest")

  map.darkness = love.graphics.newImage("assets/darkness.png")
  map.darkness:setFilter("nearest","nearest")

  map.tile = {}
  for i = 1,map.data:getWidth()/16+1 do
    map.tile[i-1] = love.graphics.newQuad( (i-1)*16, 0, 16,16,map.data:getWidth(), 16 )
  end

  map.ents = {}
  map.ents_data = love.graphics.newImage("assets/ents.png")
  map.ents_data:setFilter("nearest","nearest")
  
  for i = 1,4 do
    map.ents[i] = {}
    map.ents[i].face = {}
    map.ents[i].move = {}
    for j = 1,4 do
      map.ents[i].face[j] = love.graphics.newQuad( (j-1)*32   ,(i-1)*16,16,16, map.ents_data:getWidth(), map.ents_data:getHeight()  )
      map.ents[i].move[j] = love.graphics.newQuad( (j-1)*32+16,(i-1)*16,16,16, map.ents_data:getWidth(), map.ents_data:getHeight()  )
    end
  end  

  map.size = 15

  map.player = {
    x = 3,
    y = 3,
    dir = 1,
    img = map.ents[1],
    speed = 3,
    type = "player",
    awake = 0,
    battery = 1,
    battery_charge = 0
  }

  map.room = {}
  map.room_home = {
    ents = {},
    noflashlight = true,
    breadcrumb = 0,
    tiles = {
      {1, 1, 1, 1, 1, 1, 1,0,1},
      {1, 3,10,11, 0, 0, 0,0,1},
      {1, 0,12, 0, 0, 0, 1,0,1,1,1, 1, 1,1},
      {1, 0, 0, 0, 0, 0, 1,0,1,2,0,14, 2,1},
      {1, 13, 0,0, 0, 0, 1,0,0,0,0, 0, 0,1},
      {1, 0, 8, 9,15, 0, 1,0,1,0,0, 0,15,1},
      {1, 1, 1, 1, 1, 1, 1,0,1,1,1, 1, 1,1},
      {1, 0, 8, 9, 0, 0, 1,0,1},
      {1, 0, 0, 0, 0, 0, 1,0,1},
      {1, 0, 0, 0,12, 0, 0,0,1},
      {1, 0,15, 0,10,11, 1,7,1},
      {1, 1, 1, 1, 1, 1, 1,1,1}
    },
  }
  map.room_home.up = map.roomgen("up",map.room_home)
  
  
  map.roomcurrent = map.room_home

end

function map.draw_ent(ent)
  local quad
  local img
  
  if ent.type == "badguy" or ent.type == "player" then

    img = map.ents_data
    if ent.tarx then
      if ent.x%1 > 0.5 then
        quad = ent.img.move[ent.dir]
      else
        quad = ent.img.face[ent.dir]
      end
    elseif ent.tary then
      if ent.y%1 > 0.5 then
        quad = ent.img.move[ent.dir]
      else
        quad = ent.img.face[ent.dir]
      end
    else
      quad = ent.img.face[ent.dir]
    end
  
  elseif ent.type == "part" then
    img = parts.img.data
    quad = parts.data[ent.part].quad
  end

  love.graphics.drawq(
    img,quad,
    (ent.x-1)*16*map.scale+map.x_offset,(ent.y-1)*16*map.scale+map.y_offset,
    0,map.scale,map.scale)
end

map.breadcrumb = 0

function map.roomgen(door,prevroom)
  local room = {}
  map.breadcrumb = map.breadcrumb + 1
  room.breadcrumb = map.breadcrumb
  room[map.dooropposite(door)] = prevroom
  room.tiles = {}
  if debug_mode then
    room.noflashlight = true
  end
  for y = 1,map.size do
    room.tiles[y] = {}
    for x = 1,map.size do
      if map.door(x,y) then
        room.tiles[y][x] = 0
      elseif map.doormat(x,y) then
        room.tiles[y][x] = 0
      elseif x == map.size or y == map.size or x == 1 or y == 1 then
        room.tiles[y][x] = 1
      else
        if math.random(0,5) == 0 then
          room.tiles[y][x] = math.random(1,7)
        else
          room.tiles[y][x] = 0
        end
      end
    end
  end
  
  room.ents = {}
  local maxnumbadguys = math.floor(map.breadcrumb/3)
  if maxnumbadguys > 1 then
    for i = 1,math.random(1,maxnumbadguys) do
      room.ents[i] = map.badguygen(room)
    end
  end
  
  if not parts.haveall() and math.random(0,1) == 0 then
    room.ents[#room.ents+1] = map.partgen(room)
  end
  
  return room
end

function map.badguygen(room)
  local stayaway = 3
  local ent
  repeat
    ent = {
      dir = math.random(1,4),
      x = math.random(1+stayaway,map.size-stayaway),
      y = math.random(1+stayaway,map.size-stayaway),
      img = map.ents[math.random(2,4)],--,#map.ents)],
      type = "badguy",
      speed = 4
    }
  until not map.collide(room,ent.x,ent.y)
  return ent
end

function map.partgen(room)
  local ent
  repeat
    ent = {
      part = parts.random(),
      x = math.random(1,map.size),
      y = math.random(1,map.size),
      type = "part"
    }
  until not map.collide(room,ent.x,ent.y)
  return ent
end

function map.door(x,y)
  if (y == 1) and x == math.floor(map.size/2+0.5) then --up door
    return "up"
  elseif (y == map.size) and x == math.floor(map.size/2+0.5) then --down door
    return "down"
  elseif (x == 1) and y == math.floor(map.size/2+0.5) then --up door
    return "left"
  elseif (x == map.size) and y == math.floor(map.size/2+0.5) then --down door
    return "right"
  end  
end

function map.doormat(x,y)
  if (y == 2) and x == math.floor(map.size/2+0.5) then --up door
    return "up"
  elseif (y == map.size-1) and x == math.floor(map.size/2+0.5) then --down door
    return "down"
  elseif (x == 2) and y == math.floor(map.size/2+0.5) then --up door
    return "left"
  elseif (x == map.size-1) and y == math.floor(map.size/2+0.5) then --down door
    return "right"
  end  
end

function map.draw()
  for j,v in pairs(map.roomcurrent.tiles) do
    for i,w in pairs(v) do
      love.graphics.drawq(map.data,map.tile[w],(i-1)*32+map.x_offset,(j-1)*32+map.y_offset,0,map.scale,map.scale)
    end
  end
  
  for i,ent in pairs(map.roomcurrent.ents) do
    map.draw_ent(ent)
  end

  map.draw_ent(map.player)
  
  if not map.roomcurrent.noflashlight then

    local coff = 16*map.scale/2

    love.graphics.setScissor(map.x_offset,map.y_offset,480,480)
  
    love.graphics.draw(map.darkness,
      map.x_offset + (map.player.x-1)*16*map.scale+coff,map.y_offset + (map.player.y-1)*16*map.scale+coff,
      0,map.scale,map.scale,
      240,240)
  
  
    love.graphics.setScissor()

    local alpha = math.floor((1-map.player.battery)*255)
    love.graphics.setColor(0,0,0,alpha)
    love.graphics.rectangle("fill",map.x_offset,map.y_offset,480,480)
    love.graphics.setColor(255,255,255)
    
    if alpha == 255 then
      love.graphics.setFont(fonts.horror)
      love.graphics.printf("PRESS SPACE TO\nCHARGE YOUR BATTERY.",
        map.x_offset,map.y_offset+240,480,"center")
    end
    
  end

end

function map.collide(room,x,y)
  if room.tiles[y][x] ~= 0 then
    return true
  end
end

function map.update_ent(ent,dt)

  if ent.type == "badguy" or ent.type =="player" then
    local tol = 1/16
    local speed = ent.speed
  
    if ent.tarx then
      if ent.tarx > ent.x then
        ent.x = ent.x + speed*dt
      else
        ent.x = ent.x - speed*dt
      end
      if ent.x - tol < ent.tarx and ent.x + tol > ent.tarx  then
        ent.x = ent.tarx
        ent.tarx = nil
      end
    end

    if ent.tary then
      if ent.tary > ent.y then
        ent.y = ent.y + speed*dt
      else
        ent.y = ent.y - speed*dt
      end
      if ent.y - tol < ent.tary and ent.y + tol > ent.tary  then
        ent.y = ent.tary
        ent.tary = nil
      end
    end
    
    if ent.type ~= "player" and map.dist(ent,map.player) < 1  then
      map.player.awake = map.player.awake + 0.3
      if map.player.awake > 1 then
        map.player.awake = 1
      end
      love.audio.play(map.hit)
      ent._remove = true
    end
    
  elseif ent.type == "part" then

    if ent.x == map.player.tarx and ent.y == map.player.tary then
      parts.data[ent.part].inv = true
      ent._remove = true
      if parts.haveall() then
        states.cut.current = 100
      end
    end
  
  end
end

function map.dist(a,b)
  return math.sqrt( ( a.x - b.x) ^ 2 + (a.y - b.y) ^2 )
end

function map.update(dt)

  if map.roomcurrent.breadcrumb == 0 and parts.haveall() then
    states.cut.current = 200
  end

  for _,ent in pairs(map.roomcurrent.ents) do
    if ent.tarx or ent.tary then
      map.update_ent(ent,dt)
    else

      local tarx, tary = ent.x, ent.y
      if math.random(0,1) == 0 then
        if math.random(0,1) == 0 then
          tarx = ent.x + 1
          ent.dir = 1
        else
          tarx = ent.x - 1
          ent.dir = 3
        end
      else
        if math.random(0,1) == 0 then
          tary = ent.y + 1
          ent.dir = 2
        else
          tary = ent.y - 1
          ent.dir = 4
        end
      end
      
     if not map.collide(map.roomcurrent,tarx,tary) and not map.door(tarx,tary) then
       ent.tarx = tarx
       ent.tary = tary
     end
      
    end
  end

  for i,ent in pairs(map.roomcurrent.ents) do
    if ent._remove then
      table.remove(map.roomcurrent.ents,i)
    end
  end

  local door = map.door(map.player.x,map.player.y)
  if map.player.tarx or map.player.tary then
    map.update_ent(map.player,dt)
  elseif door then

    if map.roomcurrent[door] then
      map.roomcurrent = map.roomcurrent[door]
    else
      local newroom = map.roomgen(door,map.roomcurrent)
      map.roomcurrent[door] = newroom
      map.roomcurrent = map.roomcurrent[door]
    end

    if debug_mode then
      print("Current room: ",map.roomcurrent.breadcrumb)
      for i,v in pairs({"up","down","left","right"}) do
        if map.roomcurrent[v] then
          print(v,map.roomcurrent[v].breadcrumb)
        else
          print(v,"unvisited")
        end
      end
    end
    
    if door == "up" then
      map.player.y = map.size-1
    elseif door == "down" then
      map.player.y = 2    
    elseif door == "right" then
      map.player.x = 2
    elseif door == "left" then
      map.player.x = map.size-1
    end

    if map.roomcurrent == map.room_home and parts.haveall() then
      states.cut.current = 200
    end

    Gamestate.switch(states.cut)
    
  else
   local tarx, tary = map.player.x, map.player.y
   local moving = false
   if love.keyboard.isDown("up") then
     tary = map.player.y - 1
     moving = true
     map.player.dir = 4
   elseif love.keyboard.isDown("down") then
     tary = map.player.y + 1  
     moving = true
     map.player.dir = 2
   elseif love.keyboard.isDown("left") then
     tarx = map.player.x - 1
     moving = true
     map.player.dir = 3
   elseif love.keyboard.isDown("right") then
     tarx = map.player.x + 1  
     moving = true
     map.player.dir = 1
   end
  
   if not map.collide(map.roomcurrent,tarx,tary) and moving then
     map.player.tarx = tarx
     map.player.tary = tary
   end
   
 end
  
end

function map.dooropposite(door)
  if door == "up" then
    return "down"
  elseif door == "down" then
    return "up"
  elseif door == "left" then
    return "right"
  elseif door == "right" then
    return "left"
  end
end

return map
