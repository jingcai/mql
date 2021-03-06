//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
input double 止损=0;
void OnStart()
  {
//---
   int buy=0;
   int sell=0;
   if(!IsExpertEnabled()){Alert("没有打开智能交易的开关");return;}
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==_Symbol)
           {
            if(OrderType()==OP_BUY){buy++;}
            if(OrderType()==OP_SELL){sell++;}
           }
        }
     }
   if(buy>=1 && sell>=1)
     {
      Alert("非同一方向的持仓单，功能取消");
      return;
     }
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==_Symbol)
           {
            if(OrderType()==OP_BUY)
              {
               if(止损<Bid&&止损!=0)
                 {
                  while(OrderModify(OrderTicket(),OrderOpenPrice(),止损,OrderTakeProfit(),0)==false)
                    {
                     Print(GetLastError());
                     Sleep(300);
                    }
                  while(OrderSend(_Symbol,OP_SELLSTOP,OrderLots(),止损,3,0,0,NULL,382828)<0&&!IsStopped())
                    {
                     Print(GetLastError());
                     Sleep(300);
                    }
                 }
               else
                 {
                  Alert("止损设置不合理");return;
                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(止损>Ask)
                 {
                  while(OrderModify(OrderTicket(),OrderOpenPrice(),止损,OrderTakeProfit(),0)==false)
                    {
                     Print(GetLastError());
                     Sleep(300);
                    }
                  while(OrderSend(_Symbol,OP_BUYSTOP,OrderLots(),止损,3,0,0,NULL,382828)<0&&!IsStopped())
                    {
                     Print(GetLastError());
                     Sleep(300);
                    }
                 }
               else
                 {
                  Alert("止损设置不合理");return;
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
