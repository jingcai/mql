//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
#include "Base.mqh"
#ifndef _TICK_H
#define _TICK_H


class Tick:public Base
  {
public:
   MqlTick           ticks[];
   int               arraysize;
   int               speedlimit;
   int               tickid;
                     Tick(int myarraysize=10000,int myspeedlimit=10);
                    ~Tick();
   void              GetTick();//记录tick专用
   double            Speed();
   void              Save();
   void              OutPrint();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Tick::Tick(int myarraysize=10000,int myspeedlimit=10)
  {
   tickid=0;
   arraysize=myarraysize;
   ArrayResize(ticks,arraysize);
   speedlimit=myspeedlimit;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Tick::~Tick(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Tick::GetTick()
  {
   if(tickid==arraysize)//装满了就初始化
     {
      tickid=0;
      return;
     }
   if(SymbolInfoTick(symbol,ticks[tickid]))
     {
      ticks[tickid].time_msc=long(GetMicrosecondCount());
      //Print(ticks[tickid].time_msc);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Tick::Speed()
  {
   double res=0;
   if(tickid<1)//装满了就初始化
     {
      return 0;
     }
   double displacement=ND((ticks[tickid].bid-ticks[tickid-1].bid)/point);
//Print("tickid",tickid);
   double time=double(ticks[tickid].time_msc-ticks[tickid-1].time_msc)/1000000;
   res=displacement/time;
   if(MathAbs(res)>speedlimit)
     {
      Print("now",ticks[tickid].bid,"last",ticks[tickid-1].bid,"displacement/time",displacement,"/",time,"=",res);
     }
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//void  Tick::Save()
//  {
//   int filehandle=FileOpen(DoubleToStr(TimeCurrent(),0)+".txt",FILE_WRITE|FILE_CSV);
//   for(int i=0;i<arraysize;i++)
//     {
//      if(array[i]==0){break;}
//      FileWrite(filehandle,array[i]);
//     }
//   FileClose(filehandle);
//  }
//+------------------------------------------------------------------+
#endif 
//+------------------------------------------------------------------+
