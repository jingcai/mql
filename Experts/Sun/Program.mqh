//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#ifndef _PROGRAM_H
#define _PROGRAM_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Program
  {
public:
   enum              ENUM_USERMODE{DEVELOPER=-1,TESTER=0,GUEST=1};
   ENUM_USERMODE     mode;
   bool              show;
   string            ea_name;
   bool              auto_trade;
   bool              tester_trade;
   datetime          time_start;
   datetime          time_dead;
                     Program(ENUM_USERMODE param_mode,int param_timer_seconds=30);
                    ~Program();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Program::Program(ENUM_USERMODE param_mode,int param_timer_seconds=30)
  {
   ea_name=MQLInfoString(MQL_PROGRAM_NAME);
   Print(ea_name,"开始初始化");
   mode=param_mode;
   show=mode==DEVELOPER?true:false;
   auto_trade=TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)?true:false;
   tester_trade=MQLInfoInteger(MQL_TESTER)?true:false;
   time_start=TimeCurrent();
   time_dead=D'2020.01.01';
   EventSetTimer(param_timer_seconds);
   if(!tester_trade && !auto_trade){Alert("平台智能交易按钮处于关闭状态");}
   ObjectsDeleteAll(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Program::~Program()
  {
   Print(ea_name,"析构");
   EventKillTimer();
  }
#endif 
//+------------------------------------------------------------------+
