//+------------------------------------------------------------------+
//|                                                       盈利清算脚本.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "SunRainWay-微博"
#property link        "http://weibo.com/sunyourway"
#property description "盈利清算脚本"
#property icon        "//Images//icon//清算.ico"
#property version     "1.00"      
#property strict
input double 初始资金=1000;
input double 清算日账户余额=1110;
input double 已缴纳提成费=0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnInit()
  {
//---
   Print("仅供SunYourWay策略客户使用，微博weibo.com/sunyourway");
   double initialmoney=初始资金;
   double balance=清算日账户余额;
   double paid=已缴纳提成费;
   double netprofit=balance-initialmoney;
   Print("清算日利润:",netprofit);
   double profitpercent=netprofit/initialmoney;
   Print("账面盈利:",profitpercent*100,"%");
   double levelratio[6][3];
   levelratio[0][0]=0.0;levelratio[0][1]=0.05;levelratio[0][2]=0.15;
   levelratio[1][0]=0.05;levelratio[1][1]=0.1;levelratio[1][2]=0.2;
   levelratio[2][0]=0.1;levelratio[2][1]=0.15;levelratio[2][2]=0.25;
   levelratio[3][0]=0.15;levelratio[3][1]=0.2;levelratio[3][2]=0.3;
   levelratio[4][0]=0.2;levelratio[4][1]=0.25;levelratio[4][2]=0.35;
   levelratio[5][0]=0.25;levelratio[5][1]=0.3;levelratio[5][2]=0.4;
   double mypayoff=payoff(initialmoney,netprofit,levelratio,paid);
   //Print("已缴纳提成费",paid);
   Print("仅供SunYourWay策略客户使用，微博weibo.com/sunyourway");
  }
//+------------------------------------------------------------------+
double payoff(double money,double profit,double &levelratio[][],double paid)
  {
   double res=0;
   for(int i=0;i<ArrayRange(levelratio,0);i++)
     {
      if(profit<0)
      {
      Print("很遗憾，现在没能给您创造利润,希望在下次清算日能有良好表现~");
      if(paid>0){Print("您缴纳的费用会一直抵扣程序使用至盈利大于该费用为止");}    
      return 0;  
      }
      if(profit>=money*levelratio[i][1])//盈利超过第X档   
        {
         double ratio=levelratio[i][1]-levelratio[i][0];
         double levelpayoff=money*ratio*levelratio[i][2];         
         res+=levelpayoff;
         string details=DoubleToString(levelratio[i][0]*100,0)+"%~"+DoubleToString(levelratio[i][1]*100,0)+"%"+"区间-----------------"+DoubleToString(ratio*100,0)+"%"+"*资金"+DoubleToString(money,2)+"*提成比例"+DoubleToString(levelratio[i][2]*100,0)+"%=";
         Print(details,NormalizeDouble(levelpayoff,1));
        }
      else if(money*levelratio[i][0]<profit&&profit<money*levelratio[i][1])
        {
         double rest=0;
         string details;
         if(i==0)
         {
         rest=profit*levelratio[i][2];
         details=DoubleToString(levelratio[i][0]*100,0)+"%~"+DoubleToString(levelratio[i][1]*100,0)+"%"+"区间-----------------:"+"盈利"+DoubleToString(profit,2)+"*提成比例"+DoubleToString(levelratio[i][2]*100,0)+"%=";

         }
         if(i>=1)
         {
         rest=levelratio[i][2]*(profit-money*levelratio[i-1][1]);
         details=DoubleToString(levelratio[i][0]*100,0)+"%~"+DoubleToString(levelratio[i][1]*100,0)+"%"+"区间-----------------:"+"超出部分"+DoubleToString((profit-money*levelratio[i-1][1]),2)+"*提成比例"+DoubleToString(levelratio[i][2]*100,0)+"%=";
         }
         res+=rest;
         Print(details,rest);
         break;
        }
     }
   double maxlevelprofit=money*levelratio[ArrayRange(levelratio,0)-1][1];
   if(profit>maxlevelprofit)
     {
      double overintervalprofit=profit-maxlevelprofit;
      Print("超过区间的利润=利润-最大区间利润:",profit,"-",maxlevelprofit,"=",overintervalprofit);
      double overintervalpayoff=overintervalprofit*0.5;
      Print("超过区间的提成=",overintervalprofit,"*",50,"%=",DoubleToString(overintervalpayoff,2));
      res+=overintervalpayoff;
     }
   Print("总需支付的提成",DoubleToString(res,2)+"总需支付的提成占总盈利比例",DoubleToString((res/profit)*100,2),"%");
   Print("扣除提成后客户总净盈利:",DoubleToString(profit,2),"-",DoubleToString(res,2),"=",DoubleToString(profit-res,2),"-------净盈利",DoubleToString((profit-res)/money*100,2),"%");
   if(res-paid>=0){Print("还需缴纳的提成=","总需支付的提成-已缴纳提成费:",DoubleToString(res,2),"—",DoubleToString(paid,2),"=",DoubleToString(res-paid,2));}
   else{Print("本次清算日不及上次清算日盈利多，您已缴纳的提成费有余",DoubleToString(paid-res,2),"可继续使用该程序");}
   return res;
  }
//+------------------------------------------------------------------+
