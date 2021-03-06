//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef _S_01_H
#define _S_01_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class S_01
  {
public:
   bool              pre;
   int               period;
   int               line_size;
   struct            S_01_Line
     {
      double            price;
      datetime          time;
     };
   S_01_Line         upper[];
   S_01_Line         lower[];
                     S_01(int param_period,int param_line_size=3);
                    ~S_01(void);
   void              Initial(S_01_Line &param_struct[]);
   void              Function(MqlRates &param_rates[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
S_01::S_01(int param_period,int param_line_size=3)
  {
   period=param_period;
   line_size=param_line_size;
   ArrayResize(upper,line_size);
   ArrayResize(lower,line_size);
   Initial(upper);
   Initial(lower);
   pre=period<=0 || line_size<=0?false:true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
S_01::~S_01(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
S_01::Initial(S_01_Line &param_struct[])
  {
   for(int i=0;i<line_size;i++)
     {
      param_struct[i].price=0;
      param_struct[i].time=0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void S_01::Function(MqlRates &param_rates[])
  {
   Initial(upper);
   Initial(lower);
   const int param_rates_size=ArraySize(param_rates);
   pre=param_rates_size-period*2-10<=0?false:pre;
   if(!pre){Print(param_rates[0].close,"S_01_Function does not work");return;}
//*********************************************************************************************************************************************************************************** 
   int i_srt=period+1;
   int i_end=param_rates_size-period;
//*********************************************************************************************************************************************************************************** 
   int resistance_id=0;
   for(int i=i_srt;i<i_end;i++)
     {
      if(resistance_id>=line_size){break;}
      bool ifpeekhigh=true;
      //left and right
      int j_srt=i+period;
      int j_end=0;
      for(int j=j_srt;j>=j_end;j--)
        {
         if(param_rates[i].high<param_rates[j].high)
           {
            ifpeekhigh=false;
            break;
           }
        }
      if(ifpeekhigh)
        {
         upper[resistance_id].price=param_rates[i].high;
         upper[resistance_id].time=param_rates[i].time;
         resistance_id++;
         i+=period;//因为本身就有++操作
        }
     }
//*********************************************************************************************************************************************************************************** 
   int support_id=0;
   for(int i=i_srt;i<i_end;i++)
     {
      if(support_id>=line_size){break;}
      bool ifpeeklow=true;
      int j_srt=i+period;
      int j_end=0;
      for(int j=j_srt;j>=j_end;j--)
        {
         if(param_rates[i].low>param_rates[j].low)
           {
            ifpeeklow=false;
            break;
           }
        }
      if(ifpeeklow)
        {
         lower[support_id].price=param_rates[i].low;
         lower[support_id].time=param_rates[i].time;
         support_id++;
         i+=period;
        }
     }
//***********************************************************************************************************************************************************************************     
  }
#endif
//+------------------------------------------------------------------+
