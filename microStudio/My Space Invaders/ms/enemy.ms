EnemyClass = class
  x = 0
  y = 0
  LEFT = 1
  RIGHT = 2
  direction = 0
  active = true
  
  constructor = function()
    direction = LEFT 
  end
  
  move = function(x,y)
          this.x=x
          this.y=y
  end

  movedelta = function(xdelta)
    if direction == LEFT then
       x=x-xdelta
       if x < -100 then 
          y=y-20
          direction=RIGHT
       end    
    elsif direction == RIGHT then
       x=x+xdelta
       if x > 100 then
          y=y-20
          direction=LEFT
       end          
    end
  end

  draw = function()
     if active == true then
        screen.drawSprite("enemy2",x,y,16,16)         
     end    
  end
  
  getx = function()
     return x
  end
  
  gety = function()
     return y
  end
  
  setactive = function(active)
   this.active=active
  end
 
  getactive = function()
   return active
  end
  
end
