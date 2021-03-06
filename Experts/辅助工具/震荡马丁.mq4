//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
enum  way{BUY=1,SELL=2};
input double input_profit=0.2;//止盈金钱
input double input_ratio=2;//加仓系数
input double input_lot_start=0.01;//首单仓位
input int    gap=50;//小数点最后一位加仓距离
input bool   openfunc=true;//开首单开关
input bool   addfunc=true;//补单开关
input way    inputway=BUY;//首单方向    
double price_up=0;
double price_start=0;
double price_down=0;
int status=0;
int set_magic=333;
string line_up="line_up";
string line_start="line_start";
string line_down="line_down";
double lot=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   EventSetTimer(1);
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
   double p=CloseWhenProfit(input_profit,set_magic);
   if(p>=input_profit)
     {
      price_up=0;
      price_start=0;
      price_down=0;
      status=0;
      return;
     }

//补单
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid>=price_up && status==2 && price_start!=0 && p<input_profit)
     {
      while(!OrderSend(_Symbol,OP_BUY,lot,ask,3,0,0,IntegerToString(set_magic),set_magic) && !IsStopped())
        {
         Print(GetLastError());
        }
      status=0;
     }
   else if(bid<=price_down && status==1 && p<input_profit)
     {
      while(!OrderSend(_Symbol,OP_SELL,lot,bid,3,0,0,IntegerToString(set_magic),set_magic) && !IsStopped())
        {
         Print(GetLastError());
        }
      status=0;
     }
   double lot_max=0;
   datetime first_datetime=D'2500.01.01 00:00:00';
   datetime last_datetime=0;
   if(ObjectFind(0,line_start)>=0)
     {
      ObjectDelete(line_up);
      ObjectDelete(line_start);
      ObjectDelete(line_down);
     }
//--------------------------------------------------------------------------------------------------------------------------------------------检测当前是否有首单
   int cnt=CountMagic(set_magic);
   if(cnt==0)
     {
      if(openfunc)
        {
         int op=inputway;
         if(op==BUY)
           {
            while(!OrderSend(_Symbol,OP_BUY,input_lot_start,SymbolInfoDouble(_Symbol,SYMBOL_ASK),3,0,0,IntegerToString(set_magic),set_magic) && !IsStopped())
              {
               Print(GetLastError());
              }
           }
         else if(op==SELL)
           {
            while(!OrderSend(_Symbol,OP_SELL,input_lot_start,SymbolInfoDouble(_Symbol,SYMBOL_BID),3,0,0,IntegerToString(set_magic),set_magic) && !IsStopped())
              {
               Print(GetLastError());
              }
           }
        }
     }
//--------------------------------------------------------------------------------------------------------------------------------------------检测当前是否有首单
//--------------------------------------------------------------------------------------------------------------------------------------------寻找首尾单
   else
     {
      if(addfunc)
        {
         for(int i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==True)
              {
               if(OrderMagicNumber()==set_magic && OrderSymbol()==_Symbol)
                 {
                  datetime order_opentime=OrderOpenTime();
                  if(order_opentime<first_datetime){first_datetime=order_opentime;}
                  if(lot_max<=OrderLots()){lot_max=OrderLots();}
                  if(order_opentime>last_datetime){last_datetime=order_opentime;}
                 }
              }
           }
         for(int i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==True)
              {
               if(OrderMagicNumber()==set_magic && OrderSymbol()==_Symbol)
                 {
                  if(OrderLots()==input_lot_start && OrderOpenTime()==first_datetime)
                    {
                     price_start=OrderOpenPrice();
                     price_up=OrderOpenPrice()+gap*_Point;
                     price_down=OrderOpenPrice()-gap*_Point;
                     HLineCreate(0,line_up,0,price_up);
                     HLineCreate(0,line_start,0,price_start,clrYellow);
                     HLineCreate(0,line_down,0,price_down);
                    }
                 }
              }
           }
         for(int i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==True)
              {
               if(OrderMagicNumber()==set_magic && OrderSymbol()==_Symbol)
                 {
                  if(lot_max==OrderLots() && last_datetime==OrderOpenTime())
                    {
                     if(OrderType()==OP_BUY)
                       {
                        status=1;
                       }
                     else if(OrderType()==OP_SELL)
                       {
                        status=2;
                       }
                    }
                 }
              }
           }
         lot=lot_max*input_ratio;
        }
     }
//--------------------------------------------------------------------------------------------------------------------------------------------寻找首尾单  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CloseWhenProfit(double profit,int magicnumber)
  {
   double tagprofit=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==True && OrderMagicNumber()==magicnumber && OrderSymbol()==_Symbol)
        {
         tagprofit+=OrderProfit()+OrderCommission()+OrderSwap();//累加求和
        }
     }
   if(tagprofit>=profit)
     {
      CloseOrder("all",magicnumber);
     }
   return tagprofit;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrder(string cmd,int magicnumber)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==True && OrderMagicNumber()==magicnumber && OrderSymbol()==_Symbol)
        {
         if((cmd=="all" || cmd=="sell") && OrderType()==OP_SELL)
           {
            while(!OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(_Symbol,SYMBOL_ASK),0,Yellow) && !IsStopped())
              {
               Print(GetLastError());
              }
           }
         else if((cmd=="all" || cmd=="buy") && OrderType()==OP_BUY)
           {
            while(!OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(_Symbol,SYMBOL_BID),0,Yellow) && !IsStopped())
              {
               Print(GetLastError());
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountMagic(int magicnumber)
  {
   int cnt=0;
   double lot_max=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==True)
        {
         if(OrderMagicNumber()==magicnumber && OrderSymbol()==_Symbol)
           {
            cnt++;
           }
        }
     }
   return cnt;
  }
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,// chart's ID 
                 const string          name="HLine",      // line name 
                 const int             sub_window=0,      // subwindow index 
                 double                price=0,           // line price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selection=false,// highlight to move 
                 const bool            hidden=true,// hidden in the object list 
                 const long            z_order=0) // priority for mouse click 
  {
//--- if the price is not set, set it at the current MarketInfo(symbol,MODE_BID) price level 
   if(!price)
     {
      Print("price is zero,error");
      return(false);
     }
//--- reset the error value 
   ResetLastError();
//--- create a horizontal line 
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price))
     {
      Print(__FUNCTION__,": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse 
//--- when creating a graphical object using ObjectCreate function, the object cannot be 
//--- highlighted and moved by default. Inside this method, selection parameter 
//--- is true by default making it possible to highlight and move the object 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution 
   return(true);
  }
//+------------------------------------------------------------------+
