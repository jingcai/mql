//校验时间2017-04-25
//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef _VALUE_H
#define _VALUE_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Value
  {
private:
   bool              show;//是否展示
   double            GetPF();
   double            GetWinRatio();
public:
   double            pf;//盈利比
   double            odds;//赔率
   double            ratio_win;//胜率
   double            ratio_lose;//败率
   double            ratio_profit;//净盈率
   double            ratio_loss;//净损率
   double            ratio_set;//设定仓位
   double            ratio_kelly;//凯利仓位
   double            value_set;//设定值
   double            value_kelly;//凯利值
public:
                     Value(bool show,double param_ratio_loss,double param_odds,double param_pf,double param_ratio_win=0,double param_set_ratio=0);
   double            GetRatioKelly();
   double            GetValueKelly();
   double            GetValueSet();
   //成功率和赔率影响盈利比  
   //赔率的基数影响凯利 基数*N  仓位大小/N   不影响凯利值
   //(bq-p)/b  q-(1-q)/b 胜率越高仓位越大 赔率越小仓位越大  
  };
//+------------------------------------------------------------------+
Value::Value(bool param_show,double param_ratio_loss,double param_odds,double param_pf,double param_ratio_win=0,double param_set_ratio=0)
  {
   show=param_show;
   ratio_loss=param_ratio_loss;
   odds=param_odds;
   ratio_profit=ratio_loss*odds;
   if(param_ratio_win!=0 && param_pf!=0)
     {
      if(MathAbs(param_ratio_win-GetWinRatio())>=0.01 || MathAbs(param_pf-GetPF())>=0.01)
        {
         Print("盈利比和胜率存在冲突");
         return;
        }
     }
   if(param_pf!=0)
     {
      pf=param_pf;
      ratio_win=GetWinRatio();
     }
   if(param_ratio_win!=0)
     {
      ratio_win=param_ratio_win;
      pf=GetPF();
     }
   ratio_lose=1-ratio_win;
   ratio_kelly=GetRatioKelly();
   value_kelly=GetValueKelly();
   if(param_set_ratio!=0)
     {
      ratio_set=param_set_ratio;
      value_set=GetValueSet();
     }
   if(show)
     {
      Print("净盈率",NormalizeDouble(ratio_profit,6));
      Print("净损率",NormalizeDouble(ratio_loss,6));
      Print("赔率",NormalizeDouble(odds,6));
      Print("盈利比",NormalizeDouble(pf,6));
      Print("赢率",NormalizeDouble(ratio_win,6));
      Print("凯利系数",NormalizeDouble(ratio_kelly,6));
      Print("凯利值",NormalizeDouble(value_kelly,6));
      if(ratio_set!=0)
        {
         Print("设定系数",NormalizeDouble(ratio_set,6));
         Print("设定值",NormalizeDouble(value_set,6));
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Value::GetPF()
  {
   return ratio_win*odds/(1-ratio_win);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Value::GetWinRatio()
  {
   return pf/(pf+odds);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Value::GetRatioKelly()
  {
   return (ratio_win*ratio_profit-ratio_lose*ratio_loss)/(ratio_profit*ratio_loss);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Value::GetValueKelly()
  {
   return MathPow(1+MathAbs(ratio_kelly)*ratio_profit,ratio_win)*MathPow(1-MathAbs(ratio_kelly)*ratio_loss,ratio_lose);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Value::GetValueSet()
  {
   return MathPow(1+ratio_set*ratio_profit,ratio_win)*MathPow(1-ratio_set*ratio_loss,ratio_lose);
  }
//+------------------------------------------------------------------+
#endif 
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//double Value::GetOdds()
//  {
//   return pf/ratio_win-pf;
//  }
//double Value::GetRatioKelly()
//  {
//   //if(ratio_win==0 || ratio_loss==0 || pf==0){return 0;}
//   return (ratio_win*ratio_profit-ratio_lose*ratio_loss)/(ratio_profit*ratio_loss);
//  }
//double Value::GetValueKelly()
//  {
////return MathPow(1+MathAbs(ratio_kelly)*ratio_profit,ratio_win)*MathPow(1-MathAbs(ratio_kelly)*ratio_loss,ratio_lose);
////return MathPow(ratio_win*(odds+1),ratio_win)*MathPow((odds+1)*ratio_lose/odds,ratio_lose);//正值
//   return pf>1?MathPow(ratio_win*(odds+1),ratio_win)*MathPow(ratio_lose*(1+1/odds),ratio_lose):MathPow(1+MathAbs(ratio_kelly)*ratio_profit,ratio_win)*MathPow(1-MathAbs(ratio_kelly)*ratio_loss,ratio_lose);
//  }
