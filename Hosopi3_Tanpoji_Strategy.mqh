//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - 戦略・インジケーター                  |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_STRATEGY_MQH
#define HOSOPI3_TANPOJI_STRATEGY_MQH

#include "Hosopi3_Tanpoji_Defines.mqh"

//+------------------------------------------------------------------+
//| インジケーターハンドル（MQL5用）                                  |
//+------------------------------------------------------------------+
#ifdef __MQL5__
// MA用ハンドル
int g_MA_Buy_FastHandle = INVALID_HANDLE;
int g_MA_Buy_SlowHandle = INVALID_HANDLE;
int g_MA_Sell_FastHandle = INVALID_HANDLE;
int g_MA_Sell_SlowHandle = INVALID_HANDLE;

// RSI用ハンドル
int g_RSI_Buy_Handle = INVALID_HANDLE;
int g_RSI_Sell_Handle = INVALID_HANDLE;

// BB用ハンドル
int g_BB_Buy_Handle = INVALID_HANDLE;
int g_BB_Sell_Handle = INVALID_HANDLE;

// Stochastic用ハンドル
int g_Stoch_Buy_Handle = INVALID_HANDLE;
int g_Stoch_Sell_Handle = INVALID_HANDLE;

// CCI用ハンドル
int g_CCI_Buy_Handle = INVALID_HANDLE;
int g_CCI_Sell_Handle = INVALID_HANDLE;

// ADX用ハンドル
int g_ADX_Buy_Handle = INVALID_HANDLE;
int g_ADX_Sell_Handle = INVALID_HANDLE;

// ATR用ハンドル（ボラティリティフィルター）
int g_ATR_Handle = INVALID_HANDLE;
#endif

//+------------------------------------------------------------------+
//| インジケーターシグナル状態                                        |
//+------------------------------------------------------------------+
TechnicalIndicatorInfo g_IndicatorInfo[9]; // MA, RSI, BB, Stoch, CCI, ADX, Custom, VolFilter, Condition

//+------------------------------------------------------------------+
//| インジケーターハンドル初期化                                      |
//+------------------------------------------------------------------+
void InitializeIndicatorHandles()
{
#ifdef __MQL5__
   // MA Buy
   if(MA_Buy_Enabled == MA_ENTRY_ENABLED)
   {
      g_MA_Buy_FastHandle = iMA(Symbol(), MA_Buy_Timeframe, MA_Buy_FastPeriod, 0, MA_Buy_Method, PRICE_CLOSE);
      g_MA_Buy_SlowHandle = iMA(Symbol(), MA_Buy_Timeframe, MA_Buy_SlowPeriod, 0, MA_Buy_Method, PRICE_CLOSE);
   }

   // MA Sell
   if(MA_Sell_Enabled == MA_ENTRY_ENABLED)
   {
      g_MA_Sell_FastHandle = iMA(Symbol(), MA_Sell_Timeframe, MA_Sell_FastPeriod, 0, MA_Sell_Method, PRICE_CLOSE);
      g_MA_Sell_SlowHandle = iMA(Symbol(), MA_Sell_Timeframe, MA_Sell_SlowPeriod, 0, MA_Sell_Method, PRICE_CLOSE);
   }

   // RSI Buy
   if(RSI_Buy_Enabled == RSI_ENTRY_ENABLED)
   {
      g_RSI_Buy_Handle = iRSI(Symbol(), RSI_Buy_Timeframe, RSI_Buy_Period, PRICE_CLOSE);
   }

   // RSI Sell
   if(RSI_Sell_Enabled == RSI_ENTRY_ENABLED)
   {
      g_RSI_Sell_Handle = iRSI(Symbol(), RSI_Sell_Timeframe, RSI_Sell_Period, PRICE_CLOSE);
   }

   // BB Buy
   if(BB_Buy_Enabled == BB_ENTRY_ENABLED)
   {
      g_BB_Buy_Handle = iBands(Symbol(), BB_Buy_Timeframe, BB_Buy_Period, 0, BB_Buy_Deviation, PRICE_CLOSE);
   }

   // BB Sell
   if(BB_Sell_Enabled == BB_ENTRY_ENABLED)
   {
      g_BB_Sell_Handle = iBands(Symbol(), BB_Sell_Timeframe, BB_Sell_Period, 0, BB_Sell_Deviation, PRICE_CLOSE);
   }

   // Stochastic Buy
   if(Stoch_Buy_Enabled == STOCH_ENTRY_ENABLED)
   {
      g_Stoch_Buy_Handle = iStochastic(Symbol(), Stoch_Buy_Timeframe, Stoch_Buy_KPeriod, Stoch_Buy_DPeriod, Stoch_Buy_Slowing, MODE_SMA, STO_LOWHIGH);
   }

   // Stochastic Sell
   if(Stoch_Sell_Enabled == STOCH_ENTRY_ENABLED)
   {
      g_Stoch_Sell_Handle = iStochastic(Symbol(), Stoch_Sell_Timeframe, Stoch_Sell_KPeriod, Stoch_Sell_DPeriod, Stoch_Sell_Slowing, MODE_SMA, STO_LOWHIGH);
   }

   // CCI Buy
   if(CCI_Buy_Enabled == CCI_ENTRY_ENABLED)
   {
      g_CCI_Buy_Handle = iCCI(Symbol(), CCI_Buy_Timeframe, CCI_Buy_Period, PRICE_TYPICAL);
   }

   // CCI Sell
   if(CCI_Sell_Enabled == CCI_ENTRY_ENABLED)
   {
      g_CCI_Sell_Handle = iCCI(Symbol(), CCI_Sell_Timeframe, CCI_Sell_Period, PRICE_TYPICAL);
   }

   // ADX Buy
   if(ADX_Buy_Enabled == ADX_ENTRY_ENABLED)
   {
      g_ADX_Buy_Handle = iADX(Symbol(), ADX_Buy_Timeframe, ADX_Buy_Period);
   }

   // ADX Sell
   if(ADX_Sell_Enabled == ADX_ENTRY_ENABLED)
   {
      g_ADX_Sell_Handle = iADX(Symbol(), ADX_Sell_Timeframe, ADX_Sell_Period);
   }

   // ATR（ボラティリティフィルター）
   if(EnableVolatilityFilter)
   {
      g_ATR_Handle = iATR(Symbol(), VolFilter_Timeframe, VolFilter_ATRPeriod);
   }
#endif

   // インジケーター情報の初期化
   InitializeIndicatorInfo();
}

//+------------------------------------------------------------------+
//| インジケーターハンドル解放                                        |
//+------------------------------------------------------------------+
void ReleaseIndicatorHandles()
{
#ifdef __MQL5__
   if(g_MA_Buy_FastHandle != INVALID_HANDLE) IndicatorRelease(g_MA_Buy_FastHandle);
   if(g_MA_Buy_SlowHandle != INVALID_HANDLE) IndicatorRelease(g_MA_Buy_SlowHandle);
   if(g_MA_Sell_FastHandle != INVALID_HANDLE) IndicatorRelease(g_MA_Sell_FastHandle);
   if(g_MA_Sell_SlowHandle != INVALID_HANDLE) IndicatorRelease(g_MA_Sell_SlowHandle);
   if(g_RSI_Buy_Handle != INVALID_HANDLE) IndicatorRelease(g_RSI_Buy_Handle);
   if(g_RSI_Sell_Handle != INVALID_HANDLE) IndicatorRelease(g_RSI_Sell_Handle);
   if(g_BB_Buy_Handle != INVALID_HANDLE) IndicatorRelease(g_BB_Buy_Handle);
   if(g_BB_Sell_Handle != INVALID_HANDLE) IndicatorRelease(g_BB_Sell_Handle);
   if(g_Stoch_Buy_Handle != INVALID_HANDLE) IndicatorRelease(g_Stoch_Buy_Handle);
   if(g_Stoch_Sell_Handle != INVALID_HANDLE) IndicatorRelease(g_Stoch_Sell_Handle);
   if(g_CCI_Buy_Handle != INVALID_HANDLE) IndicatorRelease(g_CCI_Buy_Handle);
   if(g_CCI_Sell_Handle != INVALID_HANDLE) IndicatorRelease(g_CCI_Sell_Handle);
   if(g_ADX_Buy_Handle != INVALID_HANDLE) IndicatorRelease(g_ADX_Buy_Handle);
   if(g_ADX_Sell_Handle != INVALID_HANDLE) IndicatorRelease(g_ADX_Sell_Handle);
   if(g_ATR_Handle != INVALID_HANDLE) IndicatorRelease(g_ATR_Handle);
#endif
}

//+------------------------------------------------------------------+
//| インジケーター情報初期化                                          |
//+------------------------------------------------------------------+
void InitializeIndicatorInfo()
{
   g_IndicatorInfo[0].name = "MA";
   g_IndicatorInfo[0].enabled = (MA_Buy_Enabled == MA_ENTRY_ENABLED || MA_Sell_Enabled == MA_ENTRY_ENABLED);
   g_IndicatorInfo[0].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[0].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[1].name = "RSI";
   g_IndicatorInfo[1].enabled = (RSI_Buy_Enabled == RSI_ENTRY_ENABLED || RSI_Sell_Enabled == RSI_ENTRY_ENABLED);
   g_IndicatorInfo[1].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[1].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[2].name = "BB";
   g_IndicatorInfo[2].enabled = (BB_Buy_Enabled == BB_ENTRY_ENABLED || BB_Sell_Enabled == BB_ENTRY_ENABLED);
   g_IndicatorInfo[2].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[2].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[3].name = "Stoch";
   g_IndicatorInfo[3].enabled = (Stoch_Buy_Enabled == STOCH_ENTRY_ENABLED || Stoch_Sell_Enabled == STOCH_ENTRY_ENABLED);
   g_IndicatorInfo[3].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[3].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[4].name = "CCI";
   g_IndicatorInfo[4].enabled = (CCI_Buy_Enabled == CCI_ENTRY_ENABLED || CCI_Sell_Enabled == CCI_ENTRY_ENABLED);
   g_IndicatorInfo[4].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[4].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[5].name = "ADX";
   g_IndicatorInfo[5].enabled = (ADX_Buy_Enabled == ADX_ENTRY_ENABLED || ADX_Sell_Enabled == ADX_ENTRY_ENABLED);
   g_IndicatorInfo[5].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[5].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[6].name = "Custom";
   g_IndicatorInfo[6].enabled = IsCustomIndicatorEnabled();
   g_IndicatorInfo[6].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[6].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[7].name = "VolFilter";
   g_IndicatorInfo[7].enabled = EnableVolatilityFilter;
   g_IndicatorInfo[7].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[7].sellSignal = SIGNAL_NONE;

   g_IndicatorInfo[8].name = "=> Entry";
   g_IndicatorInfo[8].enabled = false;  // 判定結果なのでON/OFF表示しない
   g_IndicatorInfo[8].buySignal = SIGNAL_NONE;
   g_IndicatorInfo[8].sellSignal = SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| MA シグナル取得                                                   |
//+------------------------------------------------------------------+
ENUM_SIGNAL_STATE GetMASignal(int side)
{
   if(side == 0 && MA_Buy_Enabled != MA_ENTRY_ENABLED) return SIGNAL_NONE;
   if(side == 1 && MA_Sell_Enabled != MA_ENTRY_ENABLED) return SIGNAL_NONE;

   double fastMA[2], slowMA[2];

#ifdef __MQL5__
   int fastHandle = (side == 0) ? g_MA_Buy_FastHandle : g_MA_Sell_FastHandle;
   int slowHandle = (side == 0) ? g_MA_Buy_SlowHandle : g_MA_Sell_SlowHandle;

   if(fastHandle == INVALID_HANDLE || slowHandle == INVALID_HANDLE) return SIGNAL_NONE;

   if(CopyBuffer(fastHandle, 0, 0, 2, fastMA) < 2) return SIGNAL_NONE;
   if(CopyBuffer(slowHandle, 0, 0, 2, slowMA) < 2) return SIGNAL_NONE;
#else
   ENUM_TIMEFRAMES tf = (side == 0) ? MA_Buy_Timeframe : MA_Sell_Timeframe;
   int fastPeriod = (side == 0) ? MA_Buy_FastPeriod : MA_Sell_FastPeriod;
   int slowPeriod = (side == 0) ? MA_Buy_SlowPeriod : MA_Sell_SlowPeriod;
   ENUM_MA_METHOD method = (side == 0) ? MA_Buy_Method : MA_Sell_Method;

   fastMA[0] = iMA(Symbol(), tf, fastPeriod, 0, method, PRICE_CLOSE, 0);
   fastMA[1] = iMA(Symbol(), tf, fastPeriod, 0, method, PRICE_CLOSE, 1);
   slowMA[0] = iMA(Symbol(), tf, slowPeriod, 0, method, PRICE_CLOSE, 0);
   slowMA[1] = iMA(Symbol(), tf, slowPeriod, 0, method, PRICE_CLOSE, 1);
#endif

   MA_STRATEGY_TYPE strategy = (side == 0) ? MA_Buy_Strategy : MA_Sell_Strategy;
   double price = SymbolInfoDouble(Symbol(), SYMBOL_BID);

   switch(strategy)
   {
      case MA_GOLDEN_CROSS:
         if(fastMA[1] <= slowMA[1] && fastMA[0] > slowMA[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case MA_DEAD_CROSS:
         if(fastMA[1] >= slowMA[1] && fastMA[0] < slowMA[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case MA_PRICE_ABOVE:
         if(price > slowMA[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case MA_PRICE_BELOW:
         if(price < slowMA[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;
   }

   return SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| RSI シグナル取得                                                  |
//+------------------------------------------------------------------+
ENUM_SIGNAL_STATE GetRSISignal(int side)
{
   if(side == 0 && RSI_Buy_Enabled != RSI_ENTRY_ENABLED) return SIGNAL_NONE;
   if(side == 1 && RSI_Sell_Enabled != RSI_ENTRY_ENABLED) return SIGNAL_NONE;

   double rsi[2];

#ifdef __MQL5__
   int handle = (side == 0) ? g_RSI_Buy_Handle : g_RSI_Sell_Handle;
   if(handle == INVALID_HANDLE) return SIGNAL_NONE;
   if(CopyBuffer(handle, 0, 0, 2, rsi) < 2) return SIGNAL_NONE;
#else
   ENUM_TIMEFRAMES tf = (side == 0) ? RSI_Buy_Timeframe : RSI_Sell_Timeframe;
   int period = (side == 0) ? RSI_Buy_Period : RSI_Sell_Period;
   rsi[0] = iRSI(Symbol(), tf, period, PRICE_CLOSE, 0);
   rsi[1] = iRSI(Symbol(), tf, period, PRICE_CLOSE, 1);
#endif

   RSI_STRATEGY_TYPE strategy = (side == 0) ? RSI_Buy_Strategy : RSI_Sell_Strategy;
   int level = (side == 0) ? RSI_Buy_Level : RSI_Sell_Level;

   switch(strategy)
   {
      case RSI_OVERSOLD:
         if(rsi[0] < level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case RSI_OVERBOUGHT:
         if(rsi[0] > level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case RSI_CROSS_UP:
         if(rsi[1] <= level && rsi[0] > level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case RSI_CROSS_DOWN:
         if(rsi[1] >= level && rsi[0] < level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;
   }

   return SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| BB シグナル取得                                                   |
//+------------------------------------------------------------------+
ENUM_SIGNAL_STATE GetBBSignal(int side)
{
   if(side == 0 && BB_Buy_Enabled != BB_ENTRY_ENABLED) return SIGNAL_NONE;
   if(side == 1 && BB_Sell_Enabled != BB_ENTRY_ENABLED) return SIGNAL_NONE;

   double upper[1], lower[1];
   double price = SymbolInfoDouble(Symbol(), SYMBOL_BID);

#ifdef __MQL5__
   int handle = (side == 0) ? g_BB_Buy_Handle : g_BB_Sell_Handle;
   if(handle == INVALID_HANDLE) return SIGNAL_NONE;
   if(CopyBuffer(handle, 1, 0, 1, upper) < 1) return SIGNAL_NONE;
   if(CopyBuffer(handle, 2, 0, 1, lower) < 1) return SIGNAL_NONE;
#else
   ENUM_TIMEFRAMES tf = (side == 0) ? BB_Buy_Timeframe : BB_Sell_Timeframe;
   int period = (side == 0) ? BB_Buy_Period : BB_Sell_Period;
   double deviation = (side == 0) ? BB_Buy_Deviation : BB_Sell_Deviation;
   upper[0] = iBands(Symbol(), tf, period, deviation, 0, PRICE_CLOSE, MODE_UPPER, 0);
   lower[0] = iBands(Symbol(), tf, period, deviation, 0, PRICE_CLOSE, MODE_LOWER, 0);
#endif

   BB_STRATEGY_TYPE strategy = (side == 0) ? BB_Buy_Strategy : BB_Sell_Strategy;

   switch(strategy)
   {
      case BB_TOUCH_UPPER:
         if(price >= upper[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case BB_TOUCH_LOWER:
         if(price <= lower[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case BB_BREAK_UPPER:
         if(price > upper[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case BB_BREAK_LOWER:
         if(price < lower[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;
   }

   return SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| Stochastic シグナル取得                                           |
//+------------------------------------------------------------------+
ENUM_SIGNAL_STATE GetStochSignal(int side)
{
   if(side == 0 && Stoch_Buy_Enabled != STOCH_ENTRY_ENABLED) return SIGNAL_NONE;
   if(side == 1 && Stoch_Sell_Enabled != STOCH_ENTRY_ENABLED) return SIGNAL_NONE;

   double stochK[2], stochD[2];

#ifdef __MQL5__
   int handle = (side == 0) ? g_Stoch_Buy_Handle : g_Stoch_Sell_Handle;
   if(handle == INVALID_HANDLE) return SIGNAL_NONE;
   if(CopyBuffer(handle, 0, 0, 2, stochK) < 2) return SIGNAL_NONE;
   if(CopyBuffer(handle, 1, 0, 2, stochD) < 2) return SIGNAL_NONE;
#else
   ENUM_TIMEFRAMES tf = (side == 0) ? Stoch_Buy_Timeframe : Stoch_Sell_Timeframe;
   int kPeriod = (side == 0) ? Stoch_Buy_KPeriod : Stoch_Sell_KPeriod;
   int dPeriod = (side == 0) ? Stoch_Buy_DPeriod : Stoch_Sell_DPeriod;
   int slowing = (side == 0) ? Stoch_Buy_Slowing : Stoch_Sell_Slowing;
   stochK[0] = iStochastic(Symbol(), tf, kPeriod, dPeriod, slowing, MODE_SMA, 0, MODE_MAIN, 0);
   stochK[1] = iStochastic(Symbol(), tf, kPeriod, dPeriod, slowing, MODE_SMA, 0, MODE_MAIN, 1);
   stochD[0] = iStochastic(Symbol(), tf, kPeriod, dPeriod, slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
   stochD[1] = iStochastic(Symbol(), tf, kPeriod, dPeriod, slowing, MODE_SMA, 0, MODE_SIGNAL, 1);
#endif

   STOCH_STRATEGY_TYPE strategy = (side == 0) ? Stoch_Buy_Strategy : Stoch_Sell_Strategy;
   int level = (side == 0) ? Stoch_Buy_Level : Stoch_Sell_Level;

   switch(strategy)
   {
      case STOCH_OVERSOLD:
         if(stochK[0] < level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case STOCH_OVERBOUGHT:
         if(stochK[0] > level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case STOCH_CROSS_UP:
         if(stochK[1] <= stochD[1] && stochK[0] > stochD[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case STOCH_CROSS_DOWN:
         if(stochK[1] >= stochD[1] && stochK[0] < stochD[0])
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;
   }

   return SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| CCI シグナル取得                                                  |
//+------------------------------------------------------------------+
ENUM_SIGNAL_STATE GetCCISignal(int side)
{
   if(side == 0 && CCI_Buy_Enabled != CCI_ENTRY_ENABLED) return SIGNAL_NONE;
   if(side == 1 && CCI_Sell_Enabled != CCI_ENTRY_ENABLED) return SIGNAL_NONE;

   double cci[2];

#ifdef __MQL5__
   int handle = (side == 0) ? g_CCI_Buy_Handle : g_CCI_Sell_Handle;
   if(handle == INVALID_HANDLE) return SIGNAL_NONE;
   if(CopyBuffer(handle, 0, 0, 2, cci) < 2) return SIGNAL_NONE;
#else
   ENUM_TIMEFRAMES tf = (side == 0) ? CCI_Buy_Timeframe : CCI_Sell_Timeframe;
   int period = (side == 0) ? CCI_Buy_Period : CCI_Sell_Period;
   cci[0] = iCCI(Symbol(), tf, period, PRICE_TYPICAL, 0);
   cci[1] = iCCI(Symbol(), tf, period, PRICE_TYPICAL, 1);
#endif

   CCI_STRATEGY_TYPE strategy = (side == 0) ? CCI_Buy_Strategy : CCI_Sell_Strategy;
   int level = (side == 0) ? CCI_Buy_Level : CCI_Sell_Level;

   switch(strategy)
   {
      case CCI_OVERSOLD:
         if(cci[0] < level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case CCI_OVERBOUGHT:
         if(cci[0] > level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case CCI_CROSS_UP:
         if(cci[1] <= level && cci[0] > level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case CCI_CROSS_DOWN:
         if(cci[1] >= level && cci[0] < level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;
   }

   return SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| ADX シグナル取得                                                  |
//+------------------------------------------------------------------+
ENUM_SIGNAL_STATE GetADXSignal(int side)
{
   if(side == 0 && ADX_Buy_Enabled != ADX_ENTRY_ENABLED) return SIGNAL_NONE;
   if(side == 1 && ADX_Sell_Enabled != ADX_ENTRY_ENABLED) return SIGNAL_NONE;

   double adx[1], plusDI[1], minusDI[1];

#ifdef __MQL5__
   int handle = (side == 0) ? g_ADX_Buy_Handle : g_ADX_Sell_Handle;
   if(handle == INVALID_HANDLE) return SIGNAL_NONE;
   if(CopyBuffer(handle, 0, 0, 1, adx) < 1) return SIGNAL_NONE;
   if(CopyBuffer(handle, 1, 0, 1, plusDI) < 1) return SIGNAL_NONE;
   if(CopyBuffer(handle, 2, 0, 1, minusDI) < 1) return SIGNAL_NONE;
#else
   ENUM_TIMEFRAMES tf = (side == 0) ? ADX_Buy_Timeframe : ADX_Sell_Timeframe;
   int period = (side == 0) ? ADX_Buy_Period : ADX_Sell_Period;
   adx[0] = iADX(Symbol(), tf, period, PRICE_CLOSE, MODE_MAIN, 0);
   plusDI[0] = iADX(Symbol(), tf, period, PRICE_CLOSE, MODE_PLUSDI, 0);
   minusDI[0] = iADX(Symbol(), tf, period, PRICE_CLOSE, MODE_MINUSDI, 0);
#endif

   ADX_STRATEGY_TYPE strategy = (side == 0) ? ADX_Buy_Strategy : ADX_Sell_Strategy;
   int level = (side == 0) ? ADX_Buy_Level : ADX_Sell_Level;

   switch(strategy)
   {
      case ADX_PLUS_DI_CROSS_MINUS_DI:
         if(plusDI[0] > minusDI[0] && adx[0] >= level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case ADX_MINUS_DI_CROSS_PLUS_DI:
         if(minusDI[0] > plusDI[0] && adx[0] >= level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;

      case ADX_STRONG_TREND:
         if(adx[0] >= level)
            return (side == 0) ? SIGNAL_BUY : SIGNAL_SELL;
         break;
   }

   return SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| ボラティリティフィルターチェック                                   |
//+------------------------------------------------------------------+
bool CheckVolatilityFilter()
{
   if(!EnableVolatilityFilter) return true;

   double atr[1];

#ifdef __MQL5__
   if(g_ATR_Handle == INVALID_HANDLE) return true;
   if(CopyBuffer(g_ATR_Handle, 0, 0, 1, atr) < 1) return true;
#else
   atr[0] = iATR(Symbol(), VolFilter_Timeframe, VolFilter_ATRPeriod, 0);
#endif

   // 最小ATRチェック
   if(VolFilter_MinATR > 0 && atr[0] < VolFilter_MinATR)
   {
      g_IndicatorInfo[7].buySignal = SIGNAL_NONE;
      g_IndicatorInfo[7].sellSignal = SIGNAL_NONE;
      return false;
   }

   // 最大ATRチェック
   if(VolFilter_MaxATR > 0 && atr[0] > VolFilter_MaxATR)
   {
      g_IndicatorInfo[7].buySignal = SIGNAL_NONE;
      g_IndicatorInfo[7].sellSignal = SIGNAL_NONE;
      return false;
   }

   g_IndicatorInfo[7].buySignal = SIGNAL_BUY;
   g_IndicatorInfo[7].sellSignal = SIGNAL_SELL;
   return true;
}

//+------------------------------------------------------------------+
//| 全シグナル更新                                                    |
//+------------------------------------------------------------------+
void UpdateAllSignals()
{
   // MA
   g_IndicatorInfo[0].buySignal = GetMASignal(0);
   g_IndicatorInfo[0].sellSignal = GetMASignal(1);

   // RSI
   g_IndicatorInfo[1].buySignal = GetRSISignal(0);
   g_IndicatorInfo[1].sellSignal = GetRSISignal(1);

   // BB
   g_IndicatorInfo[2].buySignal = GetBBSignal(0);
   g_IndicatorInfo[2].sellSignal = GetBBSignal(1);

   // Stochastic
   g_IndicatorInfo[3].buySignal = GetStochSignal(0);
   g_IndicatorInfo[3].sellSignal = GetStochSignal(1);

   // CCI
   g_IndicatorInfo[4].buySignal = GetCCISignal(0);
   g_IndicatorInfo[4].sellSignal = GetCCISignal(1);

   // ADX
   g_IndicatorInfo[5].buySignal = GetADXSignal(0);
   g_IndicatorInfo[5].sellSignal = GetADXSignal(1);

   // 外部インジケーター
   if(IsCustomIndicatorEnabled())
   {
      g_IndicatorInfo[6].buySignal = CheckCustomIndicatorSignal(0) ? SIGNAL_BUY : SIGNAL_NONE;
      g_IndicatorInfo[6].sellSignal = CheckCustomIndicatorSignal(1) ? SIGNAL_SELL : SIGNAL_NONE;
   }

   // ボラティリティフィルター
   CheckVolatilityFilter();

   // 総合判定
   UpdateConditionSignal();
}

//+------------------------------------------------------------------+
//| 総合条件シグナル更新                                              |
//+------------------------------------------------------------------+
void UpdateConditionSignal()
{
   bool buySignal = EvaluateEntryCondition(0);
   bool sellSignal = EvaluateEntryCondition(1);

   g_IndicatorInfo[8].buySignal = buySignal ? SIGNAL_BUY : SIGNAL_NONE;
   g_IndicatorInfo[8].sellSignal = sellSignal ? SIGNAL_SELL : SIGNAL_NONE;
}

//+------------------------------------------------------------------+
//| エントリー条件評価                                                |
//+------------------------------------------------------------------+
bool EvaluateEntryCondition(int side)
{
   // 有効なインジケーターがない場合
   int enabledCount = 0;
   int signalCount = 0;

   // MA
   if((side == 0 && MA_Buy_Enabled == MA_ENTRY_ENABLED) || (side == 1 && MA_Sell_Enabled == MA_ENTRY_ENABLED))
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[0].buySignal : g_IndicatorInfo[0].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // RSI
   if((side == 0 && RSI_Buy_Enabled == RSI_ENTRY_ENABLED) || (side == 1 && RSI_Sell_Enabled == RSI_ENTRY_ENABLED))
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[1].buySignal : g_IndicatorInfo[1].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // BB
   if((side == 0 && BB_Buy_Enabled == BB_ENTRY_ENABLED) || (side == 1 && BB_Sell_Enabled == BB_ENTRY_ENABLED))
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[2].buySignal : g_IndicatorInfo[2].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // Stochastic
   if((side == 0 && Stoch_Buy_Enabled == STOCH_ENTRY_ENABLED) || (side == 1 && Stoch_Sell_Enabled == STOCH_ENTRY_ENABLED))
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[3].buySignal : g_IndicatorInfo[3].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // CCI
   if((side == 0 && CCI_Buy_Enabled == CCI_ENTRY_ENABLED) || (side == 1 && CCI_Sell_Enabled == CCI_ENTRY_ENABLED))
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[4].buySignal : g_IndicatorInfo[4].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // ADX
   if((side == 0 && ADX_Buy_Enabled == ADX_ENTRY_ENABLED) || (side == 1 && ADX_Sell_Enabled == ADX_ENTRY_ENABLED))
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[5].buySignal : g_IndicatorInfo[5].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // 外部インジケーター
   if(IsCustomIndicatorEnabled() && InpIndicatorMode != INDICATOR_EXIT_ONLY)
   {
      enabledCount++;
      ENUM_SIGNAL_STATE signal = (side == 0) ? g_IndicatorInfo[6].buySignal : g_IndicatorInfo[6].sellSignal;
      if(signal != SIGNAL_NONE) signalCount++;
   }

   // 有効なインジケーターがない場合はシグナルなし
   if(enabledCount == 0) return false;

   // ボラティリティフィルターチェック
   if(EnableVolatilityFilter && !CheckVolatilityFilter()) return false;

   // 条件評価
   if(EntryConditionType == AND_CONDITION)
   {
      // AND条件：全て満たす
      return (signalCount == enabledCount);
   }
   else
   {
      // OR条件：いずれか満たす
      return (signalCount > 0);
   }
}

//+------------------------------------------------------------------+
//| インジケーター情報取得                                            |
//+------------------------------------------------------------------+
void GetIndicatorInfo(int index, TechnicalIndicatorInfo &info)
{
   if(index >= 0 && index < 9)
   {
      info = g_IndicatorInfo[index];
   }
}

//+------------------------------------------------------------------+
//| 有効なインジケーター数を取得                                      |
//+------------------------------------------------------------------+
int GetEnabledIndicatorCount()
{
   int count = 0;
   for(int i = 0; i < 8; i++) // Conditionを除く
   {
      if(g_IndicatorInfo[i].enabled) count++;
   }
   return count;
}

#endif // HOSOPI3_TANPOJI_STRATEGY_MQH
