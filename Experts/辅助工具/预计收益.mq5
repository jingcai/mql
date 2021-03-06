//+------------------------------------------------------------------+
//|                                                       kalley.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include              <..\Experts\Sun\Value.mqh>
#include              <..\Experts\Sun\MonteCarlo.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input bool montefun=false;
input int  carlotimes=100;
input int trade_times=10;
input double ratio_set=0;
input double ratio_lose=1;
input double odds=1;
input double ratio_win=0;
input double pf=0;
//input double deviation=0;
input double maxloss=0.2;

double lot_money_min;
double kelly_money_total;
int cnt=0;
Value value(true,ratio_lose,odds,pf,ratio_win,ratio_set);
MonteCarlo montecarlo(carlotimes,value.ratio_win);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(cnt>=1){return 1;}
   cnt++;
   if(montefun){Print("模拟次数",carlotimes);}
   Print("每次模拟交易下单数",trade_times);

   double times_win_total=0;
   int times_win_max=0;
   int times_lose_max=0;

   double kelly_theory_res=TesterStatistics(STAT_INITIAL_DEPOSIT);
   double lot_theory_res=TesterStatistics(STAT_INITIAL_DEPOSIT);

   kelly_money_total=0;
   double lot_money_total=0;

   double lot_money_max=0;
   lot_money_min=1000000000;
   double kelly_money_max=0;
   double kelly_money_min=1000000000;


   for(int i=0;i<trade_times;i++)
     {
      kelly_theory_res*=value.value_kelly;
      lot_theory_res*=value.value_set;
     }
   Print("单次凯利值",NormalizeDouble(value.value_kelly,4));
   Print("多次凯利值",NormalizeDouble(MathPow(value.value_kelly,trade_times),4));
   Print("多次凯利结果",NormalizeDouble(kelly_theory_res,4));
   if(ratio_set!=0)
     {
      Print("单次仓位值",value.value_set);
      Print("多次仓位值",NormalizeDouble(MathPow(value.value_set,trade_times),4));
      Print("多次仓位结果",NormalizeDouble(lot_theory_res,4));
     }
//if(deviation!=0)
//  {
//   value.ratio_lose+=deviation;
//   value.pf=(value.ratio_profit*value.ratio_win)/(value.ratio_lose*value.ratio_loss);
//   Print("修正盈利比",value.pf);
//   //value.odds=value.GetOdds();
//   Print("修正赔率",value.odds);
//   value.ratio_kelly=value.GetRatioKelly();
//   Print("修正凯利系数",value.ratio_kelly);
//   value.value_kelly=value.GetValueKelly();
//   Print("修正凯利值",value.value_kelly);
//   kelly_theory_res=TesterStatistics(STAT_INITIAL_DEPOSIT);
//   for(int i=0;i<trade_times;i++)
//     {
//      kelly_theory_res*=value.value_kelly;
//      //lot_theory_res*=value.value_set;
//     }
//   Print("修正多次凯利值",NormalizeDouble(MathPow(value.value_kelly,trade_times),4));
//   Print("修正多次凯利结果",NormalizeDouble(kelly_theory_res,4));
//  }

   if(montefun)
     {
      for(int k=0;k<carlotimes;k++)
        {
         double temp_kelly_money=TesterStatistics(STAT_INITIAL_DEPOSIT);
         double temp_lot_money=TesterStatistics(STAT_INITIAL_DEPOSIT);
         for(int i=0;i<trade_times;i++)
           {
            int chance=montecarlo.GetWinOrLose();
            double temp_kelly_ratio=0;
            double temp_lot_ratio=0;
            if(chance==1)
              {
               times_win_total++;
               temp_kelly_ratio=1+value.ratio_profit*value.ratio_kelly;
               temp_lot_ratio=1+value.ratio_profit*value.ratio_set;
               montecarlo.times_win++;
              }
            else
              {
               temp_kelly_ratio=1-value.ratio_lose*value.ratio_kelly;
               temp_lot_ratio=1-value.ratio_lose*value.ratio_set;
               montecarlo.times_lose++;
              }
            temp_kelly_money*=temp_kelly_ratio;
            temp_lot_money*=temp_lot_ratio;
           }
         if(temp_kelly_money>kelly_money_max){kelly_money_max=temp_kelly_money;}
         if(temp_kelly_money<kelly_money_min){kelly_money_min=temp_kelly_money;}
         if(temp_lot_money>lot_money_max){lot_money_max=temp_lot_money;}
         if(temp_lot_money<lot_money_min){lot_money_min=temp_lot_money;}
         if(montecarlo.times_win>times_win_max){times_win_max=montecarlo.times_win;}
         if(montecarlo.times_lose>times_lose_max){times_lose_max=montecarlo.times_lose;}
         kelly_money_total+=temp_kelly_money;
         lot_money_total+=temp_lot_money;
         montecarlo.times_win=0;
         montecarlo.times_lose=0;;
        }
      Print("平均成功",times_win_total/trade_times);
      Print("最多成功次数",times_win_max);
      Print("最多失败次数",times_lose_max);
      Print("蒙特卡洛模拟凯利金额最大=",NormalizeDouble(kelly_money_max,4));
      Print("蒙特卡洛模拟凯利金额最小=",NormalizeDouble(kelly_money_min,4));
      Print("蒙特卡洛模拟凯利结果平均",NormalizeDouble(kelly_money_total/carlotimes,4));
      if(ratio_set!=0)
        {
         Print("蒙特卡洛模拟设定仓位金额最大=",NormalizeDouble(lot_money_max,4));
         Print("蒙特卡洛模拟设定仓位金额最小=",NormalizeDouble(lot_money_min,4));
         Print("蒙特卡洛模拟仓位结果平均",NormalizeDouble(lot_money_total/carlotimes,4));
        }
     }

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
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   ExpertRemove();
  }
//+------------------------------------------------------------------+
double OnTester()
  {
   double deposit=TesterStatistics(STAT_INITIAL_DEPOSIT);
   //return value.ratio_kelly;
   //return NormalizeDouble(MathPow(value.value_set,trade_times),4);
   return value.value_set;
  }
//+------------------------------------------------------------------+
