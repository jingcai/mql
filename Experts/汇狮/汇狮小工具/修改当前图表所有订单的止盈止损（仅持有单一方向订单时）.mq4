//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright   "汇狮学院--网址"
#property link        "http://www.gfxa.com"
#property strict
#property show_inputs
#property icon        "\\Images\\icon\\gfxa.ico"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
input double 止损=0;
input double 止盈=0;
input string 说明="填具体点位，止盈填0订单原止盈不变";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   int buy=0;
   int sell=0;
   bool funswitch=true;
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
      funswitch=false;
      Alert("非同一方向的持仓单，功能取消");
     }
   if(funswitch)
     {
      for(int i=OrdersTotal()-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS))
           {
            if(OrderSymbol()==_Symbol)
              {
               double ordertp=OrderTakeProfit();
               if(止盈!=0){ordertp=止盈;}
               while(!OrderModify(OrderTicket(),OrderOpenPrice(),止损,ordertp,0)==false&&!IsStopped())
                 {
                  Print(GetLastError());
                  Sleep(300);
                 }
              }
           }
        }
     }
  }
//汇狮学院-孙禕韡