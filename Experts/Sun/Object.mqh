//校验时间2017-04-25
//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef _OBJECT_H
#define _OBJECT_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Object
  {
public:
   bool              TextCreate(const long              chart_ID=0,               // chart's ID 
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
                                const long              z_order=0);

   bool              LabelCreate(const long              chart_ID=0,               // chart's ID 
                                 const string            name="Label",             // label name 
                                 const int               sub_window=0,             // subwindow index 
                                 const int               x=0,                      // X coordinate 
                                 const int               y=0,                      // Y coordinate 
                                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                                 const string            text="Label",             // text 
                                 const string            font="Arial",             // font 
                                 const int               font_size=10,             // font size 
                                 const color             clr=clrRed,               // color 
                                 const double            angle=0.0,                // text slope 
                                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                                 const bool              back=false,               // in the background 
                                 const bool              selection=false,          // highlight to move 
                                 const bool              hidden=true,              // hidden in the object list 
                                 const long              z_order=0);               // priority for mouse click 

   bool              HLineCreate(const long            chart_ID=0,        // chart's ID 
                                 const string          name="HLine",      // line name 
                                 const int             sub_window=0,      // subwindow index 
                                 double                price=0,           // line price 
                                 const color           clr=clrRed,        // line color 
                                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style 
                                 const int             width=1,           // line width 
                                 const bool            back=false,        // in the background 
                                 const bool            selection=false,   // highlight to move 
                                 const bool            hidden=true,       // hidden in the object list 
                                 const long            z_order=0);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::TextCreate(const long              chart_ID=0,// chart's ID 
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
//--- reset the error value 
   ResetLastError();
//--- create Text object 
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,": failed to create \"Text\" object! Error code = ",GetLastError());
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
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::LabelCreate(const long              chart_ID=0,// chart's ID 
                         const string            name="Label",             // label name 
                         const int               sub_window=0,             // subwindow index 
                         const int               x=0,                      // X coordinate 
                         const int               y=0,                      // Y coordinate 
                         const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                         const string            text="Label",             // text 
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
//--- reset the error value 
   ResetLastError();
//--- create a text label 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
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
//--- enable (true) or disable (false) the mode of moving the label by mouse 
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
//|                                                                  |
//+------------------------------------------------------------------+
bool Object::HLineCreate(const long            chart_ID=0,// chart's ID 
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
#endif 
//+------------------------------------------------------------------+
