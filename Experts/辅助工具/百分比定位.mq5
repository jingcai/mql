//+------------------------------------------------------------------+
//|                                                        百分比定位.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
input datetime start_time=D'2000.01.01';
#include            <..\Experts\sun\Base.mqh>
#include            <..\Experts\sun\Object.mqh>
Base base;
Object object;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ObjectsDeleteAll(0);
   double highest=0;
   double lowest=1000000;
   int max_bars=Bars(_Symbol,PERIOD_MN1);
   base.timeframe=PERIOD_MN1;
   base.GetMQL(max_bars-1,0,base.rates);
   for(int i=0;i<ArrayRange(base.rates,0);i++)
     {
      if(base.rates[i].time>=start_time)
        {
         if(highest<base.rates[i].high){highest=base.rates[i].high;}
         if(lowest>base.rates[i].low){lowest=base.rates[i].low;}
        }
     }
   double now=base.rates[0].close;
   double pct=(now-lowest)/(highest-lowest);
   object.HLineCreate(0,"highest",0,highest);
   object.HLineCreate(0,"lowest",0,lowest);
   object.HLineCreate(0,"now",0,now);
   object.LabelCreate(0,"pct",0,0,0,CORNER_RIGHT_UPPER,"pct"+DoubleToString(pct*100,1),"Arail",10,255,0,ANCHOR_RIGHT_UPPER);
   ExpertRemove();
//---
   return(INIT_SUCCEEDED);
  }
void OnTick()
  {
  }
//+---------