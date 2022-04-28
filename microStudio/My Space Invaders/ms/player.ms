PlayerClass = class
  x = 0
  y = -80
  
  move = function(x,y)
     this.x=x
     this.y=y
  end

  movedelta = function(xdelta)
     x=x+xdelta
  end

  draw = function()
     screen.drawSprite("ship2",x,y,16,16)         
  end
  
  getx = function()
     return x
  end
  
  gety = function()
     return y
  end
end