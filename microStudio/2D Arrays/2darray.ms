
array2dbase = class
 blist = []
 constructor = function(ccount,value)
   for i=0 to ccount-1
     blist[i] = value
   end
 end

 set = function(c,value)
      blist[c]=value
 end

 get = function(c)
      return blist[c]
 end
end


array2d = class
 alist = []
 constructor = function(rcount,ccount,value)
   for i=0 to rcount-1
     alist[i] = new array2dbase(ccount,value)
   end
 end
 
 set = function(r,c,value)
     alist[r].set(c,value)
 end
 
 get = function(r,c)
      return alist[r].get(c)
 end
end

narray2d = class
 alist = []
 constructor = function(rcount,ccount,value)
   for i=0 to rcount-1
     for j=0 to ccount-1
      alist[[i,j]] = value
     end
   end
 end
 
 set = function(r,c,value)
     alist[[r,c]]=value
 end
 
 get = function(r,c)
      return alist[[r,c]]
 end
end