//+------------------------------------------------------------------+
//|                             YURAZ_CreaHistorCSVFromMT5forMT4.mq5 |
//|            Copyright 2010, MetaQuotes Software Corp. (C) & YURAZ |
//|                                            www.masterforex-v.org |
//+------------------------------------------------------------------+
//
// 杨玟噱?CSV 羿殡 桉蝾痂?M1, 黩钺?镳钽痼玷螯 ?祢4.
// ?耦驵脲龛??桃4 ?桉蝾痂?镱 礤觐蝾瘥?镟疣? 磬镳桁屦 ?2010 泐潴,
// 耋耱怏 潲痍??桉蝾痂?觐蜩痤忸??爨?2010 ?叁脲 棱泱耱?2010
// ??徉珏 觐蜩痤忸?MT5 磬犭噱蝰 赅麇耱忮眄? 桉蝾痂

#property copyright "Copyright 2010, MetaQuotes Software Corp. & (C) YURAZ"
#property link      "www.masterforex-v.org"
#property version   "1.00"
#include <Files\File.mqh>
#include <Files\FileTxt.mqh>

string    ExtFileName; // ="XXXXXX_PERIOD.CSV";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void  OnStart()
  {
   CFileTxt     *File;
   MqlRates  rates_array[];
   string sSymbol=Symbol();
   string  sPeriod;
   PeriodToStr(Period(),sPeriod);

   Comment("欣廖依?.. 驿栩?.. ");
// 纛痨桊箦?桁 羿殡?EURUSD1 磬镳桁屦
   ExtFileName=sSymbol;
   StringConcatenate(ExtFileName,sSymbol,"_",sPeriod,".CSV");
   ArraySetAsSeries(rates_array,true);
   int iMaxBar=TerminalInfoInteger(TERMINAL_MAXBARS);
   string format="%G,%G,%G,%G,%d";
   int iCod=CopyRates(sSymbol,Period(),0,iMaxBar,rates_array);
   if(iCod>1)
     {
      File=new CFileTxt;
      if(File==NULL)
        {
         //--- 铠栳赅 耦玟囗? 觌囫襦
         printf("%s (%4d): creating error",__FILE__,__LINE__);
         return;
        }
      // 悟牮?羿殡
      File.Open(ExtFileName,FILE_WRITE,9);
      for(int i=iCod-1; i>0; i--)
        {
         // 纛痨桊钼囗桢 耱痤觇 纛痨囹?
         // 2009.01.05,12:49,1.36770,1.36780,1.36760,1.36760,8
         string sOut=StringFormat("%s",TimeToString(rates_array[i].time,TIME_DATE));
         sOut=sOut+","+TimeToString(rates_array[i].time,TIME_MINUTES);
         sOut=sOut+","+StringFormat(format,
                                    rates_array[i].open,
                                    rates_array[i].high,
                                    rates_array[i].low,
                                    rates_array[i].close,
                                    rates_array[i].tick_volume);
         sOut=sOut+"\n";
         File.WriteString(sOut);
        }
      File.Close();
     }
   Comment("OK. 泐蝾忸... ");
  }
//+------------------------------------------------------------------+
//| 暑礅屦蜞鲮 镥痂钿??耱痤牦                                     |
//+------------------------------------------------------------------+
bool PeriodToStr(ENUM_TIMEFRAMES period,string &strper)
  {
   bool res=true;
//---
   switch(period)
     {
      case PERIOD_MN1 : strper="MN1"; break;
      case PERIOD_W1 :  strper="W1";  break;
      case PERIOD_D1 :  strper="D1";  break;
      case PERIOD_H1 :  strper="H1";  break;
      case PERIOD_H2 :  strper="H2";  break;
      case PERIOD_H3 :  strper="H3";  break;
      case PERIOD_H4 :  strper="H4";  break;
      case PERIOD_H6 :  strper="H6";  break;
      case PERIOD_H8 :  strper="H8";  break;
      case PERIOD_H12 : strper="H12"; break;
      case PERIOD_M1 :  strper="M1";  break;
      case PERIOD_M2 :  strper="M2";  break;
      case PERIOD_M3 :  strper="M3";  break;
      case PERIOD_M4 :  strper="M4";  break;
      case PERIOD_M5 :  strper="M5";  break;
      case PERIOD_M6 :  strper="M6";  break;
      case PERIOD_M10 : strper="M10"; break;
      case PERIOD_M12 : strper="M12"; break;
      case PERIOD_M15 : strper="M15"; break;
      case PERIOD_M20 : strper="M20"; break;
      case PERIOD_M30 : strper="M30"; break;
      default : res=false;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
