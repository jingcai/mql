//+------------------------------------------------------------------+
//|                                                         交易成本.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input double lot=1;
input double s=100;
input int    p=50;
int OnInit()
  {
//---
   MathSrand(GetTickCount());
 


//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  int cmd=rand()%100;
  if(OrdersTotal()==0)
  {
  if(cmd<=p-1)
  {OrderSend(NULL,OP_BUY,lot,Ask,0,Ask-s*_Point,Ask+s*_Point);}
  if(cmd>=p)
  {OrderSend(NULL,OP_SELL,lot,Bid,0,Bid+s*_Point,Bid-s*_Point);}  
  }
  }
//+------------------------------------------------------------------+
