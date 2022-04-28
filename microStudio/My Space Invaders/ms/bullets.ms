BulletClass = class
 x = 0
 y = 0
 ysteps = 10
 active = false
 
 setactive = function(active)
   this.active=active
 end
 
 getactive = function()
   return active
 end
 
 fire = function(x,y)
   if active == true then
     return
   end   
   this.x=x
   this.y=y
   active = true
   audio.playSound("fire")
 end
 
 move = function()
   if active == false then 
      return
   end
   y=y+ysteps
   if y > 80 then
     active = false
   end   
 end
 
 getx = function()
   return x
 end
  
 gety = function()
   return y
 end
 
 draw = function()
   if active==true then
      screen.drawSprite("b1",x,y,3,3)
   end  
 end
 
end