//+------------------------------------------------------------------+ 
//|                                              TestLoadHistory.mq5 | 
//|                        Copyright 2009, MetaQuotes Software Corp. | 
//|                                              https://www.mql5.com | 
//+------------------------------------------------------------------+ 
#property copyright "2009, MetaQuotes Software Corp." 
#property link      "https://www.mql5.com" 
#property version   "1.02" 
#property script_show_inputs 
//--- 输入参量 
//input string          InpLoadedSymbol="NZDUSD";   // 被加载的交易品种 
input ENUM_TIMEFRAMES InpLoadedPeriod=PERIOD_D1;  // 被加载的周期 
input datetime        InpStartDate=D'2000.01.01'; // 开始日期 
//+------------------------------------------------------------------+ 
//| 脚本程序启动函数                                                   | 
//+------------------------------------------------------------------+ 
void OnStart() 
  { 
   Print("Start load",_Symbol+","+GetPeriodName(InpLoadedPeriod),"from",InpStartDate); 
//--- 
   int res=CheckLoadHistory(_Symbol,InpLoadedPeriod,InpStartDate); 
   switch(res) 
     { 
      case -1 : Print("Unknown symbol ",_Symbol);             break; 
      case -2 : Print("Requested bars more than max bars in chart"); break; 
      case -3 : Print("Program was stopped");                        break; 
      case -4 : Print("Indicator shouldn't load its own data");      break; 
      case -5 : Print("Load failed");                                break; 
      case  0 : Print("Loaded OK");                                  break; 
      case  1 : Print("Loaded previously");                          break; 
      case  2 : Print("Loaded previously and built");                break; 
      default : Print("Unknown result"); 
     } 
//--- 
   datetime first_date; 
   SeriesInfoInteger(_Symbol,InpLoadedPeriod,SERIES_FIRSTDATE,first_date); 
   int bars=Bars(_Symbol,InpLoadedPeriod); 
   Print("First date ",first_date," - ",bars," bars"); 
//--- 
  } 
//+------------------------------------------------------------------+ 
//|                                                                  | 
//+------------------------------------------------------------------+ 
int CheckLoadHistory(string symbol,ENUM_TIMEFRAMES period,datetime start_date) 
  { 
   datetime first_date=0; 
   datetime times[100]; 
//--- 检测交易品种 & 周期 
   if(symbol==NULL || symbol=="") symbol=Symbol(); 
   if(period==PERIOD_CURRENT)     period=Period(); 
//--- 检测市场报价是否选定了交易品种 
   if(!SymbolInfoInteger(symbol,SYMBOL_SELECT)) 
     { 
      if(GetLastError()==ERR_MARKET_UNKNOWN_SYMBOL) return(-1); 
      SymbolSelect(symbol,true); 
     } 
//--- 检测数据是否存在 
   SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date); 
   if(first_date>0 && first_date<=start_date) return(1); 
//--- 如果是指标的话不需要加载自己的数据 
   if(MQL5InfoInteger(MQL5_PROGRAM_TYPE)==PROGRAM_INDICATOR && Period()==period && Symbol()==symbol) 
      return(-4); 
//--- 第二尝试 
   if(SeriesInfoInteger(symbol,PERIOD_M1,SERIES_TERMINAL_FIRSTDATE,first_date)) 
     { 
      //--- 有建立时间序列加载的数据 
      if(first_date>0) 
        { 
         //--- 强制创建时间序列 
         CopyTime(symbol,period,first_date+PeriodSeconds(period),1,times); 
         //--- 检测日期 
         if(SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date)) 
            if(first_date>0 && first_date<=start_date) return(2); 
        } 
     } 
//--- 图表中来自程序端选项的最大柱 
   int max_bars=TerminalInfoInteger(TERMINAL_MAXBARS); 
//--- 加载交易品种历史记录信息 
   datetime first_server_date=0; 
   while(!SeriesInfoInteger(symbol,PERIOD_M1,SERIES_SERVER_FIRSTDATE,first_server_date) && !IsStopped()) 
      Sleep(5); 
//--- 为加载确定开始日期 
   if(first_server_date>start_date) start_date=first_server_date; 
   if(first_date>0 && first_date<first_server_date) 
      Print("Warning: first server date ",first_server_date," for ",symbol, 
            " does not match to first series date ",first_date); 
//--- 逐步地加载数据 
   int fail_cnt=0; 
   while(!IsStopped()) 
     { 
      //--- 等待建立时间序列 
      while(!SeriesInfoInteger(symbol,period,SERIES_SYNCHRONIZED) && !IsStopped()) 
         Sleep(5); 
      //--- 要求建成的柱 
      int bars=Bars(symbol,period); 
      if(bars>0) 
        { 
         if(bars>=max_bars) return(-2); 
         //--- 请求初始日期 
         if(SeriesInfoInteger(symbol,period,SERIES_FIRSTDATE,first_date)) 
            if(first_date>0 && first_date<=start_date) return(0); 
        } 
      //--- 复制部分强制数据加载 
      int copied=CopyTime(symbol,period,bars,100,times); 
      if(copied>0) 
        { 
         //--- 数据检测 
         if(times[0]<=start_date)  return(0); 
         if(bars+copied>=max_bars) return(-2); 
         fail_cnt=0; 
        } 
      else 
        { 
         //--- 失败尝试少于100 
         fail_cnt++; 
         if(fail_cnt>=100) return(-5); 
         Sleep(10); 
        } 
     } 
//--- 停止 
   return(-3); 
  } 
//+------------------------------------------------------------------+ 
//| 返回该周期的字符串值                                                | 
//+------------------------------------------------------------------+ 
string GetPeriodName(ENUM_TIMEFRAMES period) 
  { 
   if(period==PERIOD_CURRENT) period=Period(); 
//--- 
   switch(period) 
     { 
      case PERIOD_M1:  return("M1"); 
      case PERIOD_M2:  return("M2"); 
      case PERIOD_M3:  return("M3"); 
      case PERIOD_M4:  return("M4"); 
      case PERIOD_M5:  return("M5"); 
      case PERIOD_M6:  return("M6"); 
      case PERIOD_M10: return("M10"); 
      case PERIOD_M12: return("M12"); 
      case PERIOD_M15: return("M15"); 
      case PERIOD_M20: return("M20"); 
      case PERIOD_M30: return("M30"); 
      case PERIOD_H1:  return("H1"); 
      case PERIOD_H2:  return("H2"); 
      case PERIOD_H3:  return("H3"); 
      case PERIOD_H4:  return("H4"); 
      case PERIOD_H6:  return("H6"); 
      case PERIOD_H8:  return("H8"); 
      case PERIOD_H12: return("H12"); 
      case PERIOD_D1:  return("Daily"); 
      case PERIOD_W1:  return("Weekly"); 
      case PERIOD_MN1: return("Monthly"); 
     } 
//--- 
   return("unknown period"); 
  }
 

