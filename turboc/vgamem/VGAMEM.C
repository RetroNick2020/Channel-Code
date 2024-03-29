/* ************************************************************** */
/* vgamem.c For Turbo C++/C                                       */
/*                                                                */
/* This example program demonstrates how to access vga mode       */
/* 320x200x256 by using a BGI driver and acessing vga memory      */
/* directly.  A custom myputimage function allows you to select   */
/* which color not to display or make transparent.                */
/*                                                                */
/*                                                                */
/* char balls and balls.xgf was created by exporting the image    */
/* from Raster Master as Turbo C putimage array and putimage file */
/* Get Raster Master for Windows from                             */
/* https://github.com/RetroNick2020/raster-master                 */
/* ************************************************************** */

#include <stdio.h>
#include <alloc.h>
#include <graphics.h>

unsigned char balls[1030] = {
          0x1F,0x00,0x1F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x3F,0x3F,0x3F,0x3F,0x3F,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3F,0x3F,0x3E,
          0x3E,0x3E,0x3E,0x3E,0x3F,0x3F,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x29,0x29,0x29,0x29,0x29,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x3F,0x3F,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,
          0x3E,0x3F,0x3F,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x29,0x2A,
          0x2A,0x2A,0x2A,0x2A,0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x3F,
          0x3F,0x3E,0x3E,0x3E,0x3D,0x3D,0x3D,0x3E,0x3E,0x3E,0x3F,0x3F,
          0x00,0x00,0x00,0x00,0x00,0x29,0x2A,0x2A,0x2B,0x2B,0x2B,0x2A,
          0x2A,0x29,0x00,0x00,0x00,0x00,0x00,0x3F,0x3E,0x3E,0x3D,0x3D,
          0x3D,0x3D,0x3D,0x3D,0x3D,0x3E,0x3E,0x3F,0x00,0x00,0x00,0x00,
          0x29,0x2A,0x2B,0x2B,0x2C,0x2C,0x2C,0x2B,0x2B,0x2A,0x29,0x00,
          0x00,0x00,0x3F,0x3E,0x3E,0x3E,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,
          0x3D,0x3E,0x3E,0x3E,0x3F,0x00,0x00,0x29,0x2A,0x2A,0x2B,0x2C,
          0x2C,0x2C,0x2C,0x2C,0x2B,0x2A,0x2A,0x29,0x00,0x00,0x3F,0x3E,
          0x3E,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3E,0x3E,
          0x3F,0x00,0x00,0x29,0x2A,0x2B,0x2C,0x2C,0x2C,0x2C,0x2C,0x2C,
          0x2C,0x2B,0x2A,0x29,0x00,0x00,0x3F,0x3E,0x3E,0x3D,0x3D,0x3D,
          0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3E,0x3E,0x3F,0x00,0x00,0x29,
          0x2A,0x2B,0x2C,0x2C,0x2C,0x2C,0x2C,0x2C,0x2C,0x2B,0x2A,0x29,
          0x00,0x00,0x3F,0x3E,0x3E,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,
          0x3D,0x3D,0x3E,0x3E,0x3F,0x00,0x00,0x29,0x2A,0x2B,0x2C,0x2C,
          0x2C,0x2C,0x2C,0x2C,0x2C,0x2B,0x2A,0x29,0x00,0x00,0x3F,0x3E,
          0x3E,0x3E,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3E,0x3E,0x3E,
          0x3F,0x00,0x00,0x29,0x2A,0x2A,0x2B,0x2C,0x2C,0x2C,0x2C,0x2C,
          0x2B,0x2A,0x2A,0x29,0x00,0x00,0x00,0x3F,0x3E,0x3E,0x3D,0x3D,
          0x3D,0x3D,0x3D,0x3D,0x3D,0x3E,0x3E,0x3F,0x00,0x00,0x00,0x00,
          0x29,0x2A,0x2B,0x2B,0x2C,0x2C,0x2C,0x2B,0x2B,0x2A,0x29,0x00,
          0x00,0x00,0x00,0x3F,0x3F,0x3E,0x3E,0x3E,0x3D,0x3D,0x3D,0x3E,
          0x3E,0x3E,0x3F,0x3F,0x00,0x00,0x00,0x00,0x00,0x29,0x2A,0x2A,
          0x2B,0x2B,0x2B,0x2A,0x2A,0x29,0x00,0x00,0x00,0x00,0x00,0x00,
          0x3F,0x3F,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3E,0x3F,0x3F,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x29,0x2A,0x2A,0x2A,0x2A,0x2A,
          0x29,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3F,0x3F,0x3E,
          0x3E,0x3E,0x3E,0x3E,0x3F,0x3F,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x29,0x29,0x29,0x29,0x29,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x3F,0x3F,0x3F,0x3F,0x3F,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
          0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};



struct s_vga {
       unsigned char vgamem[200][320];
};

struct  s_vga far *myvga = (struct s_vga far*) 0xA0000000L;


void myputimage(int x, int y, unsigned char *image,int transcol)
{
  int c,i,j,width,height;

  width=(image[1] << 8) + image[0]+1;
  height=(image[3] << 8) + image[2]+1;
  c=4;

  for(j=0;j<height;j++){
    for(i=0;i<width;i++){
      if (image[c]!=transcol) myvga->vgamem[(j+y)][(i+x)]=image[c];
      c++;
    }
  }
}

void drawbars()
{
  int i;
  for(i=0;i<32;i++){
   setfillstyle(SOLID_FILL,i);
   bar(0,70+i,200,70+i);
  }
}

void main()
{
  unsigned char *imgBuf;
  FILE *F;
  int driver;
  int mode   = 0;
  unsigned int size;

  F=fopen("balls.xgf","rb");
  size=filelength(fileno(F));
  imgBuf = malloc(size);
  fread(imgBuf,size,1,F);
  fclose(F);

  driver=installuserdriver("svga256",NULL);
  initgraph(&driver, &mode, "");
  setfillstyle(SOLID_FILL,BLUE);
  bar(0,0,getmaxx(),getmaxy());
  drawbars();
  putimage(10,60,imgBuf,COPY_PUT);
  myputimage(100,60,imgBuf,0);

  free(imgBuf);
  getch();
  closegraph();
  getch();
}