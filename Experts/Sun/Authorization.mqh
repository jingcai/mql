//检查完毕
//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property strict
#ifndef _AUTHORIZE_H
#define _AUTHORIZE_H
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Authorization
  {
private:
   bool              authorized;
   long              decrypt_accountid;
   datetime          decrypt_expiredtime;
   long              time_final;
public:
                     Authorization(string mypin);
                    ~Authorization();
   string            CreatePin(long accountid,datetime expiredtime);
   void              DecryptPin(string pin);
   bool              CheckTime();
   bool              CheckAuthorization();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Authorization::Authorization(string mypin)
  {
   authorized=false;
   decrypt_accountid=0;
   decrypt_expiredtime=0;
   time_final=D'2018.06.01 00:00';
   DecryptPin(mypin);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Authorization::~Authorization()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Authorization::CreatePin(long accountid,datetime expiredtime)
  {
   string res="";
   long longtime=expiredtime;
   string accountstring=IntegerToString(accountid*321-48);
   string accountstring2=IntegerToString(accountid*127+71);
   string longtimestring=IntegerToString(longtime*7-44445611);
   string longtimestring2=IntegerToString(longtime*13-3337831);
   StringConcatenate(res,accountstring,"a",accountstring2,"m",longtimestring,"t",longtimestring2);
   Alert(res);
   return res;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Authorization::DecryptPin(string pin)
  {
   int apos=StringFind(pin,"a");
   int mpos=StringFind(pin,"m");
   int tpos=StringFind(pin,"t");
   string accountpin1=StringSubstr(pin,0,apos);
   string accountpin2=StringSubstr(pin,apos+1,mpos-apos-1);//字母有位置
   string timepin1=StringSubstr(pin,mpos+1,tpos-mpos-1);
   string timepin2=StringSubstr(pin,tpos+1,StringLen(pin)-1-tpos);
   long decryptaccount1=(StringToInteger(accountpin1)+48)/321;
   long decryptaccount2=(StringToInteger(accountpin2)-71)/127;
   bool decryptaccount1mod=(StringToInteger(accountpin1)+48)%321==0;
   bool decryptaccount2mod=(StringToInteger(accountpin2)-71)%127==0;
   long decrypttime1=(StringToInteger(timepin1)+44445611)/7;
   long decrypttime2=(StringToInteger(timepin2)+3337831)/13;
   bool decrypttime1mod=(StringToInteger(timepin1)+44445611)%7==0;
   bool decrypttime2mod=(StringToInteger(timepin2)+3337831)%13==0;
   bool accountequal=false;
   bool timeequal=false;
//如果不为空 空空相等
   if(accountpin1!=""){accountequal=decryptaccount1==decryptaccount2 && decryptaccount1mod && decryptaccount2mod;}
   if(timepin1!=""){timeequal=decrypttime1==decrypttime2 && decrypttime1mod && decrypttime2mod;}
   if(accountequal){decrypt_accountid=decryptaccount1;}
   if(timeequal){decrypt_expiredtime=datetime(decrypttime1);}
   long accountid=AccountInfoInteger(ACCOUNT_LOGIN);
   if(accountid==decrypt_accountid && decrypt_expiredtime!=0)
     {
      authorized=true;
      Print(decrypt_accountid,"账户授权成功,过期时间:",decrypt_expiredtime);
     }
   else
     {
      Print("验证码或存在问题");
     }
  }
//+------------------------------------------------------------------+
bool Authorization::CheckTime(void)
  {
   if(authorized)
     {
      datetime now=TimeCurrent();
      if(now>decrypt_expiredtime)
        {
         authorized=false;
         Print("超过账户的使用期限,请联系更新");
        }
      else if(now>time_final)
        {
         authorized=false;
         Print("超过程序最晚使用期限,请联系更新");
        }
     }
   return authorized;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Authorization::CheckAuthorization(void)
  {
   return authorized;
  }
//+------------------------------------------------------------------+
#endif 
//+------------------------------------------------------------------+
