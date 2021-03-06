//校验时间2017-04-25
//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef _MONTECARLO_H
#define _MONTECARLO_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MonteCarlo
  {
private:
   bool              show;//是否展示
   double            GetlChance();
public:
   double            probability_win;
   int               times_test;
   int               times_win;//胜利次数 蒙特卡洛
   int               times_lose;//失败次数 蒙特卡洛
                     MonteCarlo(int param_times_test,double param_probability_win);
   int               GetWinOrLose();
   double            GetAvarageProbabilityWin();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MonteCarlo::MonteCarlo(int param_times_test,double param_probability_win)
  {
   show=false;
   times_test=param_times_test;
   probability_win=param_probability_win;
   MathSrand(GetTickCount());
  }
//+------------------------------------------------------------------+
double MonteCarlo::GetlChance()
  {
   return rand()%10*1000+rand()%10*100+rand()%10*10+rand()%10;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MonteCarlo::GetWinOrLose()
  {
   //万内比较
   if(GetlChance()<round(probability_win*10000))
     {
      return 1;
     }
   else
     {
      return 2;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MonteCarlo::GetAvarageProbabilityWin()
  {
   for(int i=0;i<times_test;i++)
     {
      int res=GetWinOrLose();
      if(res==1)
        {
         times_win++;
        }
      else
        {
         times_lose++;
        }
     }
   return double(times_win)/times_test;
  }
//+------------------------------------------------------------------+
#endif 
//+------------------------------------------------------------------+
