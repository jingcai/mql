//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |

#property copyright   "GFXA"
#property link        "www.gfxa.com"
#property description "GFXA"
#property icon        "gfxa.ico"
#property strict
#property script_show_inputs

int gap=200;
 int hourbars=Bars;
//int hourbars=iBars(NULL,PERIOD_H1)-100;
int hour=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   int ling=(TimeLocal()-TimeCurrent())/3600;
   if(ling<=5)
     {
      hour=5-ling;
        }else{hour=24-(ling-5);
     }
Print(hour);
//if(hour<0){hour+=24;}
   ObjectsDeleteAll();
   if(Digits==4)
     {
      gap=gap/10;
     }
   MqlRates rate[];
   ArraySetAsSeries(rate,true);
   CopyRates(NULL,PERIOD_H1,0,hourbars,rate);
////Print(rate[1].close);
   int usedi=0;
   for(int i=0;i<hourbars;i++)
     {
      if(hour==TimeHour(rate[i].time))
        {
         usedi=i;
         break;
        }
     }
   int no=1;
   for(int i=usedi;i<hourbars-100;i++)
     {
      if(hour==TimeHour(rate[i].time))
        {
         string crname="CR"+rate[i].close+no;
         string orname="OR"+rate[i+23].open+no;
         string ctname="CT"+rate[i].close+no;
         string otname="OT"+rate[i+23].open+no;
         double close=rate[i].close;
         double open=rate[i+23].open;
         RectangleCreate(0,crname,0,rate[i].time,close+gap*Point,rate[i].time+60*60*24,close-gap*Point,clrRed);
         RectangleCreate(0,orname,0,rate[i].time,open+gap*Point,rate[i].time+60*60*24,open-gap*Point,clrBlue);
         TrendCreate(0,ctname,0,rate[i].time,close,rate[i].time+60*60*24,close,clrYellow);
         TrendCreate(0,otname,0,rate[i].time,open,rate[i].time+60*60*24,open,clrYellow);
         if(MathAbs(close-open)<4*gap*Point/9)
           {
            TrendDelete(0,ctname);
            TrendDelete(0,otname);
            TrendCreate(0,ctname+"2",0,rate[i].time,(close+open)/2,rate[i].time+60*60*24,(close+open)/2,clrMagenta);
           }
         no++;
        }
      //i=i+23;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TrendCreate(const long            chart_ID=0,// chart's ID 
                 const string          name="TrendLine",  // line name 
                 const int             sub_window=0,      // subwindow index 
                 datetime              time1=0,           // first point time 
                 double                price1=0,          // first point price 
                 datetime              time2=0,           // second point time 
                 double                price2=0,          // second point price 
                 const color           clr=clrRed,        // line color 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                 const int             width=1,           // line width 
                 const bool            back=false,        // in the background 
                 const bool            selection=false,// highlight to move 
                 const bool            ray_right=false,   // line's continuation to the right 
                 const bool            hidden=true,       // hidden in the object list 
                 const long            z_order=0)         // priority for mouse click 
  {
//--- set anchor points' coordinates if they are not set 
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
//--- reset the error value 
   ResetLastError();
//--- create a trend line by the given coordinates 
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend line! Error code = ",GetLastError());
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
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right 
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution 
   return(true);
  }
//| Move trend line anchor point                                     | 
bool TrendPointChange(const long   chart_ID=0,// chart's ID 
                      const string name="TrendLine", // line name 
                      const int    point_index=0,    // anchor point index 
                      datetime     time=0,           // anchor point time coordinate 
                      double       price=0)          // anchor point price coordinate 
  {
//--- if point position is not set, move it to the current bar having Bid price 
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value 
   ResetLastError();
//--- move trend line's anchor point 
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution 
   return(true);
  }
//| The function deletes the trend line from the chart.              | 

bool TrendDelete(const long   chart_ID=0,// chart's ID 
                 const string name="TrendLine") // line name 
  {
//--- reset the error value 
   ResetLastError();
//--- delete a trend line 
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution 
   return(true);
  }
//| Check the values of trend line's anchor points and set default   | 
//| values for empty ones                                            | 

void ChangeTrendEmptyPoints(datetime &time1,double &price1,
                            datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar 
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value 
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one 
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars 
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one 
      time2=temp[0];
     }
//--- if the second point's price is not set, it is equal to the first point's one 
   if(!price2)
      price2=price1;
  }
//| Create rectangle by the given coordinates                        | 

bool RectangleCreate(const long            chart_ID=0,// chart's ID 
                     const string          name="Rectangle",  // rectangle name 
                     const int             sub_window=0,      // subwindow index  
                     datetime              time1=0,           // first point time 
                     double                price1=0,          // first point price 
                     datetime              time2=0,           // second point time 
                     double                price2=0,          // second point price 
                     const color           clr=clrRed,        // rectangle color 
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines 
                     const int             width=1,           // width of rectangle lines 
                     const bool            fill=true,        // filling rectangle with color 
                     const bool            back=true,        // in the background 
                     const bool            selection=false,// highlight to move 
                     const bool            hidden=false,// hidden in the object list 
                     const long            z_order=0) // priority for mouse click 
  {
//--- set anchor points' coordinates if they are not set 
   ChangeRectangleEmptyPoints(time1,price1,time2,price2);
//--- reset the error value 
   ResetLastError();
//--- create a rectangle by the given coordinates 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- set rectangle color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the style of rectangle lines 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set width of the rectangle lines 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the rectangle for moving 
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
//| Move the rectangle anchor point                                  | 

bool RectanglePointChange(const long   chart_ID=0,// chart's ID 
                          const string name="Rectangle", // rectangle name 
                          const int    point_index=0,    // anchor point index 
                          datetime     time=0,           // anchor point time coordinate 
                          double       price=0)          // anchor point price coordinate 
  {
//--- if point position is not set, move it to the current bar having Bid price 
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value 
   ResetLastError();
//--- move the anchor point 
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution 
   return(true);
  }
//| Delete the rectangle                                             | 

bool RectangleDelete(const long   chart_ID=0,// chart's ID 
                     const string name="Rectangle") // rectangle name 
  {
//--- reset the error value 
   ResetLastError();
//--- delete rectangle 
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution 
   return(true);
  }
//| Check the values of rectangle's anchor points and set default    | 
//| values for empty ones                                            | 

void ChangeRectangleEmptyPoints(datetime &time1,double &price1,
                                datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar 
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value 
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one 
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars 
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one 
      time2=temp[0];
     }
//--- if the second point's price is not set, move it 300 points lower than the first one 
   if(!price2)
      price2=price1-300*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TextCreate(const long              chart_ID=0,               // chart's ID 
                const string            name="Text",              // object name 
                const int               sub_window=0,             // subwindow index 
                datetime                time=0,                   // anchor point time 
                double                  price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                const string            font="Arial",             // font 
                const int               font_size=10,             // font size 
                const color             clr=clrRed,               // color 
                const double            angle=0.0,                // text slope 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                const bool              back=false,               // in the background 
                const bool              selection=false,          // highlight to move 
                const bool              hidden=true,              // hidden in the object list 
                const long              z_order=0)                // priority for mouse click 
  {
//--- set anchor point coordinates if they are not set 
//--- reset the error value 
   ResetLastError();
//--- create Text object 
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set the text 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the object by mouse 
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
