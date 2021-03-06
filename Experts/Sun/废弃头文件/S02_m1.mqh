//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef _S_04_H
#define _S_04_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class S_04
  {
public:
   bool              pre;
   int               period;
   double            x;
   struct            S_04_Line
     {
      double            price;
      int               period;
      double            x;
     };
   int               slow_period;
   long              period_time;
   double            fast_d_all[];
   double            fast_d_avg[];
   long              delta_t[];
   double            delta_s[];
   S_04_Line         upper[];
   S_04_Line         lower[];
                     S_04(int param_period,double param_x);
                    ~S_04(void);
   void              Initial(S_04_Line &param_line[]);
   void              Function(const MqlRates &param_rates[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
S_04::S_04(int param_period,double param_x)
  {
   period=param_period;
   x=param_x;
   ArrayResize(fast_d_all,period);
   ArrayResize(fast_d_avg,period);
   ArrayResize(delta_t,period);
   ArrayResize(delta_s,period);
   ArrayResize(upper,period);
   ArrayResize(lower,period);
   Initial(upper);
   Initial(lower);
   slow_period=1000;
   period_time=period*70;
   pre=period<=0 || x<=0?false:true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
S_04::~S_04(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
S_04::Initial(S_04_Line &param_line[])
  {
   for(int i=0;i<period;i++)
     {
      param_line[i].price=0;
      param_line[i].period=0;
      param_line[i].x=0;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void S_04::Function(const MqlRates &param_rates[])
  {
   Initial(upper);
   Initial(lower);
   const int param_rates_size=ArraySize(param_rates);
   pre=param_rates_size-1-2*period<=0?false:pre;
   if(!pre){Print(param_rates[0].close,"S_04_Function does not work");return;}
//*********************************************************************************************************************************************************************************** 
   double slow_d_all=0;
   double slow_d_avg=0;
   int i_end=slow_period+period;
   for(int i=period;i<i_end;i++)
     {
      slow_d_all+=MathAbs(param_rates[i].close-param_rates[i+1].close);
     }
   slow_d_avg=slow_d_all/slow_period;
//*********************************************************************************************************************************************************************************** 
   ArrayInitialize(fast_d_all,0);
   ArrayInitialize(fast_d_avg,0);
   ArrayInitialize(delta_t,0);
   for(int i=0;i<period;i++)
     {
      int j_start=i+1;
      int j_end=j_start+period;
      for(int j=j_start;j<j_end;j++)
        {
         fast_d_all[i]+=param_rates[j].close-param_rates[j+1].close;
         delta_t[i]+=long(param_rates[j].time-param_rates[j+1].time);
        }
      fast_d_avg[i]=fast_d_all[i]/period;
     }
//*********************************************************************************************************************************************************************************** 
   ArrayInitialize(delta_s,0);
   for(int i=0;i<period;i++)
     {
      delta_s[i]=fast_d_avg[i]/slow_d_avg;
     }
//ArrayPrint(fast_d_avg);
//Print(slow_d_avg);
//ArrayPrint(delta_s);
//*********************************************************************************************************************************************************************************** 
   for(int i=0;i<period;i++)
     {
      if(delta_s[i]>=x)
        {
         if(i==0 && delta_t[i]<period_time)
           {
            upper[i].price=param_rates[i+1].close;
            upper[i].period=period;
            upper[i].x=delta_s[i];
           }
         if(i!=0)
           {
            Initial(upper);
            break;
           }
        }
     }
//*********************************************************************************************************************************************************************************** 
   for(int i=0;i<period;i++)
     {
      if(delta_s[i]<=-x)
        {
         if(i==0 && delta_t[i]<period_time)
           {
            lower[i].price=param_rates[i+1].close;
            lower[i].period=period;
            lower[i].x=delta_s[i];
           }
         if(i!=0)
           {
            Initial(lower);
            break;
           }
        }
     }
//ArrayPrint(upper);
//ArrayPrint(lower);
  }
#endif 
//+------------------------------------------------------------------+
