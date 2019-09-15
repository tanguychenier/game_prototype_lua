local largeur
local hauteur

local pad = {}
pad.x = 0
pad.y = 0
pad.largeur = 80
pad.hauteur = 20

local balle = {}
balle.x = 0
balle.y = 0
balle.vx = 0
balle.vy = 0
balle.angle = 0
balle.angleNeutre = 0 - ((math.pi*2) / 2)
balle.vitesse = 0
balle.colle = true
balle.rayon = 10
degre45 = (math.pi*2) / (360/45)

local brique = {}
local niveau = {}

function Demarre()
  pad.y = hauteur - (15/2)
  
  brique.hauteur = 25
  brique.largeur = largeur / 15

  balle.angle = 0 - degre45
  balle.vitesse = 300
  balle.colle = true
  
  for l = 1,6 do
    niveau[l] = {}
    for c = 1,15 do
      niveau[l][c] = 1
    end
  end
end

function love.load()
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  Demarre()
end

function love.update(dt)
  pad.x = love.mouse.getX()
  if pad.x < 0 then pad.x = 0 end
  if pad.x > largeur then pad.x = largeur end
  
  if balle.colle == true then
    balle.x = pad.x
    balle.y = pad.y - (pad.hauteur/2) - (balle.rayon)
  else
    balle.x = balle.x + balle.vx*dt
    balle.y = balle.y + balle.vy*dt
    local c = math.floor((balle.x / brique.largeur)) + 1
    local l = math.floor((balle.y / brique.hauteur)) + 1
    
    if l > 0  and l <= #niveau and c >= 1 and c <= 15 then
      if niveau[l][c] == 1 then
        niveau[l][c] = 0
        balle.vy = 0 - balle.vy
      end
    end
    
    if balle.y > (pad.y - pad.hauteur/2) - balle.rayon then
      local distanceX = math.abs(pad.x - balle.x)
      if distanceX < pad.largeur / 2 then
        balle.vy = 0 - balle.vy
        balle.y = (pad.y - pad.hauteur/2) - balle.rayon
      end
    end
    
    if balle.x > largeur or balle.x < 0 then
      balle.vx = 0 - balle.vx
    end
    if balle.y < 0 then balle.vy = 0 - balle.vy end
    
    if balle.y > hauteur then
      balle.colle = true
    end
  end

end

function love.draw()
  local bx, by = 0,0
  for l = 1,6 do
    bx = 0
    for c = 1,15 do
      if niveau[l][c] == 1 then
        love.graphics.rectangle("fill",bx + 1, by + 1, brique.largeur - 2, brique.hauteur - 2)
      end
      bx = bx + brique.largeur
    end
    by = by + brique.hauteur
  end

  love.graphics.rectangle("fill", pad.x - (pad.largeur/2), pad.y - (pad.hauteur/2), pad.largeur, pad.hauteur)
  love.graphics.circle("fill", balle.x, balle.y, balle.rayon)
end

function love.mousepressed(px, py, pn)
  if balle.colle == true then
    balle.colle = false
    balle.vx = balle.vitesse * math.cos(balle.angle)
    balle.vy = balle.vitesse * math.sin(balle.angle)
  end
end