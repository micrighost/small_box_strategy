//+------------------------------------------------------------------+
//|                                                   小箱型策略.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include  <classpack.mqh>
ClassPack CPack ;



//策略說明:
//假設三根bar就可以構成一個橋接和兩個箱型
//透過偏移第一根bar來跟第三根bar比對，如果相互沒有重疊，即視為兩個箱型，而中間第二根視為橋接
//在上述基礎之下，在第四根bar開盤進場(讓第三根描寫完，用以確定第2根bar是橋接)
//停損在第一根bar的高點(視第一根bar的高點為前一個箱型的頂)
//停利在第三根bar的高點(視第三根bar的低點為現在箱型的頂)
//
//
//參數:
//MA1 最高價 向後偏移2 
//MA1 最低價 向後偏移2  


double ma1_high_shift2_values[];              //裝iMA值的陣列
double ma1_high_shift2_handle;                //iMA指標的句柄

double ma1_low_shift2_values[];               //裝iMA值的陣列
double ma1_low_shift2_handle;                 //iMA指標的句柄


double ma1_high_values[];                     //裝iMA值的陣列
double ma1_high_handle;                       //iMA指標的句柄

double ma1_low_values[];                      //裝iMA值的陣列
double ma1_low_handle;                        //iMA指標的句柄


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
   //--- 創建iMA指標
   ma1_high_shift2_handle = iMA(NULL,PERIOD_CURRENT,1,2,MODE_SMA,PRICE_HIGH); //週期1，偏移2  
   
   //--- 創建iMA指標
   ma1_low_shift2_handle = iMA(NULL,PERIOD_CURRENT,1,2,MODE_SMA,PRICE_LOW);   //週期1，偏移2   
   
   //--- 創建iMA指標
   ma1_high_handle = iMA(NULL,PERIOD_CURRENT,1,0,MODE_SMA,PRICE_HIGH);        //週期1
   
   //--- 創建iMA指標
   ma1_low_handle = iMA(NULL,PERIOD_CURRENT,1,0,MODE_SMA,PRICE_LOW);          //週期1  

   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---


   //--- 用當前iMA的值填充ma1_high_shift2_values[]數組
   //--- 啟動位置為1(因為我們在第四根bar往回看，所以要往前一根才是第三根bar)(創建指標時偏移過了，所以直接根第三根bar比對)
   //--- 複製1個元素
   CopyBuffer(ma1_high_shift2_handle,0,1,1,ma1_high_shift2_values);     //ma1_high_shift2_values[0]為第一根bar的高點，也是前箱的高點
   
   
   
   //--- 用當前iMA的值填充ma1_low_shift2_values[]數組
   //--- 啟動位置為1(因為我們在第四根bar往回看，所以要往前一根才是第三根bar)(創建指標時偏移過了，所以直接根第三根bar比對)
   //--- 複製1個元素
   CopyBuffer(ma1_low_shift2_handle,0,1,1,ma1_low_shift2_values);       //ma1_low_shift2_values[0]為第一根bar的低點，也是前箱的低點
   
   
   
   //--- 用當前iMA的值填充ma1_high_values[]數組
   //--- 啟動位置為1(因為我們在第四根bar往回看，所以要往前一根才是第三根bar)
   //--- 複製1個元素
   CopyBuffer(ma1_high_handle,0,1,1,ma1_high_values);                   //ma1_high_values[0]為第三根bar的高點，也是現在箱子的高點
   
   
   
   //--- 用當前iMA的值填充ma1_low_values[]數組
   //--- 啟動位置為1(因為我們在第四根bar往回看，所以要往前一根才是第三根bar)
   //--- 複製1個元素
   CopyBuffer(ma1_low_handle,0,1,1,ma1_low_values);                     //ma1_low_values[0]為第三根bar的低點，也是現在箱子的低點
   

   
   
   
   if(PositionsTotal() == 0){                                                      //如果沒有單
      if(CPack.isnewbar() == true){                                                //如果第四根bar形成
         if(ma1_low_values[0] > ma1_high_shift2_values[0]){ //如果第三根bar的低點大於第一根bar的高點，可以確定兩個箱型成立，且為多頭排列
            trade.Buy(0.01,NULL,0,ma1_high_shift2_values[0],ma1_high_values[0]);   //停損為第一根bar高點，停利為第三根bar高點
         }      
         if(ma1_high_values[0] < ma1_low_shift2_values[0]){ //如果第三根bar的高點小於第一根bar的低點，可以確定兩個箱型成立，且為空頭排列
            trade.Sell(0.01,NULL,0,ma1_low_shift2_values[0],ma1_low_values[0]);    //停損為第一根bar低點，停利為第三根bar低點
         }       
      }
   }   

 
   
  }

