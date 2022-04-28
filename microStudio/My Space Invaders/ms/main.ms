init = function()
  ex=-80
  ey=80
  myEnemy = []
  timer = 0
  
  for i=0 to 4
    myEnemy[i] = new EnemyClass()
    myEnemy[i].move(ex+i*25,ey)
  end
  myPlayer = new PlayerClass()
  myBullete = new BulletClass()
end

checkforhit = function()
 if myBullete.getactive() == true then
    btx=myBullete.getx()
    bty=myBullete.gety()
    for i=0 to 4 
      if myEnemy[i].getactive() == true then
         enx=myEnemy[i].getx()
         eny=myEnemy[i].gety()
         disx=abs(btx-enx)
         disy=abs(bty-eny)
         if (disx < 10) and (disy < 10) then
           return i
         end
      end
    end
 end
 return -1
end

update = function()
  timer = timer+1
  if timer > 10 then
    timer=0
    for i=0 to 4
      myEnemy[i].movedelta(5)
    end
    myBullete.move()
    ishit=checkforhit()
    if ishit > -1 then
      audio.playSound("explode")
      myBullete.setactive(false)
      myEnemy[ishit].setactive(false)
      return
    end
  end
  
  if keyboard.F then
    myBullete.fire(myPlayer.getx(),-70)
  end

  if keyboard.RIGHT then
    myPlayer.movedelta(2)
  elsif keyboard.LEFT then
    myPlayer.movedelta(-2)
  end
end

draw = function()
  screen.clear()
  for i=0 to 4
    myEnemy[i].draw()
  end  
  myBullete.draw()
  myPlayer.draw()
end