init = function()
  count = 5
  
  array1 = new array2d(10,10,0)
  array2 = new narray2d(10,10,11)
  

  array1.set(1,1,75)
//  print("array=")//
//  print(array1.get(1,1))


  testfunc()
  array2.set(1,1,11)
  print(array2.get(1,1))
end

update = function()
end

draw = function()
  screen.clear("blue")
  screen.drawSprite("face1",10,10,32,32)
end

testfunc = function()
  print("test func")
  
 //if count == then print("short if")
  
  if count == 5 then
     print("count is 5")
  elsif count == 4 then
     print("count is 4")
  end
  
end



