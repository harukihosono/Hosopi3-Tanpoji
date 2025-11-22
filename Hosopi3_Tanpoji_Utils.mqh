//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - ユーティリティ関数                    |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_UTILS_MQH
#define HOSOPI3_TANPOJI_UTILS_MQH

#include "Hosopi3_Tanpoji_Defines.mqh"

//+------------------------------------------------------------------+
//| MQL4/MQL5 互換性のための定義                                      |
//+------------------------------------------------------------------+
#ifdef __MQL5__
   #include <Trade\Trade.mqh>
   #include <Trade\PositionInfo.mqh>
   #include <Trade\OrderInfo.mqh>
   CTrade         g_trade;
   CPositionInfo  g_position;
   COrderInfo     g_order;
#endif

//+------------------------------------------------------------------+
//| グローバル変数初期化                                              |
//+------------------------------------------------------------------+
void InitializeGlobalVariables()
{
   // フラグ初期化
   g_AutoTrading = true;
   g_AvgPriceVisible = true;
   g_PanelMinimized = false;
   g_InfoPanelVisible = true;

   // オブジェクトカウンター初期化
   g_LineObjectCount = 0;
   g_PanelObjectCount = 0;

   // 時間関連初期化
   g_LastUpdateTime = 0;
   g_BuyClosedTime = 0;
   g_SellClosedTime = 0;
}

//+------------------------------------------------------------------+
//| ポジション数をカウントする関数                                    |
//+------------------------------------------------------------------+
int position_count(int type)
{
   int count = 0;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.PositionType() == (ENUM_POSITION_TYPE)type &&
            g_position.Symbol() == Symbol() &&
            g_position.Magic() == MagicNumber)
         {
            count++;
         }
      }
   }
#else
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderType() == type && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
            count++;
         }
      }
   }
#endif

   return count;
}

//+------------------------------------------------------------------+
//| マジックナンバーに関係なく全ポジション数をカウントする関数         |
//+------------------------------------------------------------------+
int position_count_all(int type)
{
   int count = 0;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.PositionType() == (ENUM_POSITION_TYPE)type &&
            g_position.Symbol() == Symbol())
         {
            count++;
         }
      }
   }
#else
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderType() == type && OrderSymbol() == Symbol())
         {
            count++;
         }
      }
   }
#endif

   return count;
}

//+------------------------------------------------------------------+
//| 時間計算関数                                                      |
//+------------------------------------------------------------------+
datetime calculate_time()
{
   if(set_time == GMT9)
   {
      return TimeGMT() + 60 * 60 * 9;
   }
   if(set_time == GMT9_BACKTEST)
   {
      return GetJapanTime();
   }
   if(set_time == GMT_KOTEI)
   {
      return TimeCurrent() + 60 * 60 * 9;
   }
   return 0;
}

//+------------------------------------------------------------------+
//| 日本時間取得関数                                                  |
//+------------------------------------------------------------------+
datetime GetJapanTime()
{
   datetime now = TimeCurrent();
   datetime summer = now + 60 * 60 * natu;
   datetime winter = now + 60 * 60 * huyu;

   if(is_summer())
   {
      return summer;
   }
   return winter;
}

//+------------------------------------------------------------------+
//| サマータイムチェック関数                                           |
//+------------------------------------------------------------------+
bool is_summer()
{
   datetime now = TimeCurrent();

#ifdef __MQL5__
   MqlDateTime dt;
   TimeToStruct(now, dt);
   int month = dt.mon;
   int day = dt.day;
   int year = dt.year;
   int dayOfWeek = dt.day_of_week;
#else
   int month = TimeMonth(now);
   int day = TimeDay(now);
   int year = TimeYear(now);
   int dayOfWeek = TimeDayOfWeek(now);
#endif

   if(month < 3 || month > 11)
   {
      return false;
   }
   if(month > 3 && month < 11)
   {
      return true;
   }

   // アメリカのサマータイムは3月の第2日曜日から11月の第1日曜日まで
   if(month == 3)
   {
      // 3月の第2日曜日を計算
      string dateStr = StringFormat("%d.%d.1", year, month);
      datetime firstDay = StringToTime(dateStr);

#ifdef __MQL5__
      MqlDateTime firstDayDt;
      TimeToStruct(firstDay, firstDayDt);
      int firstDayOfWeek = firstDayDt.day_of_week;
#else
      int firstDayOfWeek = TimeDayOfWeek(firstDay);
#endif

      int firstSunday = (7 - firstDayOfWeek) % 7 + 1;
      int secondSunday = firstSunday + 7;

      if(day >= secondSunday)
      {
         return true;
      }
      return false;
   }
   if(month == 11)
   {
      // 11月の第1日曜日を計算
      string dateStr = StringFormat("%d.%d.1", year, month);
      datetime firstDay = StringToTime(dateStr);

#ifdef __MQL5__
      MqlDateTime firstDayDt;
      TimeToStruct(firstDay, firstDayDt);
      int firstDayOfWeek = firstDayDt.day_of_week;
#else
      int firstDayOfWeek = TimeDayOfWeek(firstDay);
#endif

      int firstSunday = (7 - firstDayOfWeek) % 7 + 1;

      if(day < firstSunday)
      {
         return true;
      }
      return false;
   }

   return false;
}

//+------------------------------------------------------------------+
//| オブジェクト名を保存                                               |
//+------------------------------------------------------------------+
void SaveObjectName(string name, string &nameArray[], int &counter)
{
   if(counter < ArraySize(nameArray))
   {
      nameArray[counter] = name;
      counter++;
   }
}

//+------------------------------------------------------------------+
//| 色を暗くする                                                      |
//+------------------------------------------------------------------+
color ColorDarken(color clr, int percent)
{
   // 色を分解・合成するための関数
   int r = (clr & 0xFF0000) >> 16;
   int g = (clr & 0x00FF00) >> 8;
   int b = (clr & 0x0000FF);

   // 各色成分を暗く
   r = MathMax(0, r - percent);
   g = MathMax(0, g - percent);
   b = MathMax(0, b - percent);

   // 色を再構成
   return((color)((r << 16) + (g << 8) + b));
}

//+------------------------------------------------------------------+
//| 時間範囲内かをチェック                                           |
//+------------------------------------------------------------------+
bool IsInTimeRange(int current, int start, int end)
{
   // 開始・終了が同じ = 24時間有効
   if(start == end) return true;

   // 通常パターン (開始 < 終了)
   if(start < end) return (current >= start && current < end);

   // 日をまたぐパターン (開始 > 終了)
   return (current >= start || current < end);
}

//+------------------------------------------------------------------+
//| 曜日フィルターチェック関数                                        |
//+------------------------------------------------------------------+
bool IsDayAllowed()
{
   if(!EnableDayFilter) return true;

   datetime jpTime = calculate_time();

#ifdef __MQL5__
   MqlDateTime dt;
   TimeToStruct(jpTime, dt);
   int dayOfWeek = dt.day_of_week;
#else
   int dayOfWeek = TimeDayOfWeek(jpTime);
#endif

   switch(dayOfWeek)
   {
      case 1: return TradeMonday;
      case 2: return TradeTuesday;
      case 3: return TradeWednesday;
      case 4: return TradeThursday;
      case 5: return TradeFriday;
      default: return false; // 土日は取引しない
   }
}

//+------------------------------------------------------------------+
//| 時間フィルターチェック関数                                        |
//+------------------------------------------------------------------+
bool IsTimeAllowed()
{
   if(!EnableTimeFilter) return true;

   datetime jpTime = calculate_time();

#ifdef __MQL5__
   MqlDateTime dt;
   TimeToStruct(jpTime, dt);
   int hour = dt.hour;
#else
   int hour = TimeHour(jpTime);
#endif

   return IsInTimeRange(hour, TradeStartHour, TradeEndHour);
}

//+------------------------------------------------------------------+
//| エントリー時間チェック関数（曜日+時間）                           |
//+------------------------------------------------------------------+
bool IsEntryTimeAllowed()
{
   return IsDayAllowed() && IsTimeAllowed();
}

//+------------------------------------------------------------------+
//| ポジション保護モードの確認関数                                    |
//+------------------------------------------------------------------+
bool IsEntryAllowedByProtectionMode(int side)
{
   // 保護モードがOFFの場合は常に許可
   if(PositionProtection == OFF_MODE)
      return true;

   // 保護モードがONの場合、反対側のポジションがあれば禁止
   int oppositeType = (side == 0) ? OP_SELL : OP_BUY;

   // リアルポジションのチェック
   int realCount = position_count(oppositeType);

   // 反対側にポジションがある場合は禁止
   if(realCount > 0)
   {
      return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//| 決済後インターバルチェック関数                                    |
//+------------------------------------------------------------------+
bool IsCloseIntervalElapsed(int side)
{
   // 決済後インターバル機能が無効の場合は常に許可
   if(!EnableCloseInterval || CloseInterval <= 0)
      return true;

   datetime currentTime = TimeCurrent();

   if(side == 0) // Buy側のチェック
   {
      if(g_BuyClosedTime > 0)
      {
         // 経過時間を計算
         int elapsedMinutes = (int)((currentTime - g_BuyClosedTime) / 60);

         // インターバル時間が経過していない場合
         if(elapsedMinutes < CloseInterval)
         {
            return false;
         }

         // インターバル時間が経過したのでリセット
         g_BuyClosedTime = 0;
      }
   }
   else // Sell側のチェック
   {
      if(g_SellClosedTime > 0)
      {
         // 経過時間を計算
         int elapsedMinutes = (int)((currentTime - g_SellClosedTime) / 60);

         // インターバル時間が経過していない場合
         if(elapsedMinutes < CloseInterval)
         {
            return false;
         }

         // インターバル時間が経過したのでリセット
         g_SellClosedTime = 0;
      }
   }

   return true;
}

//+------------------------------------------------------------------+
//| 平均取得価格計算関数（リアルポジションのみ）                       |
//+------------------------------------------------------------------+
double CalculateAveragePrice(int type)
{
   double totalLots = 0;
   double weightedPrice = 0;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.PositionType() == (ENUM_POSITION_TYPE)type &&
            g_position.Symbol() == Symbol() &&
            g_position.Magic() == MagicNumber)
         {
            totalLots += g_position.Volume();
            weightedPrice += g_position.PriceOpen() * g_position.Volume();
         }
      }
   }
#else
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderType() == type && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
            totalLots += OrderLots();
            weightedPrice += OrderOpenPrice() * OrderLots();
         }
      }
   }
#endif

   if(totalLots > 0)
      return weightedPrice / totalLots;
   else
      return 0;
}

//+------------------------------------------------------------------+
//| 合計利益計算関数                                                  |
//+------------------------------------------------------------------+
double CalculateTotalProfit(int type)
{
   double totalProfit = 0.0;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionSelectByTicket(PositionGetTicket(i)))
      {
         if(PositionGetSymbol(i) == Symbol() && PositionGetInteger(POSITION_MAGIC) == MagicNumber)
         {
            if((int)PositionGetInteger(POSITION_TYPE) == type)
            {
               totalProfit += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
            }
         }
      }
   }
#else
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
            if(OrderType() == type)
            {
               totalProfit += OrderProfit() + OrderSwap() + OrderCommission();
            }
         }
      }
   }
#endif

   return totalProfit;
}

//+------------------------------------------------------------------+
//| 全体の利益を計算                                                  |
//+------------------------------------------------------------------+
double CalculateAllProfit()
{
   return CalculateTotalProfit(OP_BUY) + CalculateTotalProfit(OP_SELL);
}

//+------------------------------------------------------------------+
//| 最後のエントリー時間を取得する関数                                |
//+------------------------------------------------------------------+
datetime GetLastEntryTime(int type)
{
   datetime lastTime = 0;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.PositionType() == (ENUM_POSITION_TYPE)type &&
            g_position.Symbol() == Symbol() &&
            g_position.Magic() == MagicNumber)
         {
            if(g_position.Time() > lastTime)
               lastTime = g_position.Time();
         }
      }
   }
#else
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderType() == type && OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
            if(OrderOpenTime() > lastTime)
               lastTime = OrderOpenTime();
         }
      }
   }
#endif

   return lastTime;
}

//+------------------------------------------------------------------+
//| プレフィックスでオブジェクト削除                                   |
//+------------------------------------------------------------------+
void DeleteObjectsByPrefix(string prefix)
{
   int total = ObjectsTotal(0);
   for(int i = total - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i);
      if(StringFind(name, prefix) == 0)
      {
         ObjectDelete(0, name);
      }
   }
}

//+------------------------------------------------------------------+
//| ロットサイズの正規化                                              |
//+------------------------------------------------------------------+
double NormalizeLot(double lot)
{
#ifdef __MQL5__
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double lotMin = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
   double lotMax = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
#else
   double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   double lotMin = MarketInfo(Symbol(), MODE_MINLOT);
   double lotMax = MarketInfo(Symbol(), MODE_MAXLOT);
#endif

   // ロットステップに合わせて正規化
   lot = MathRound(lot / lotStep) * lotStep;
   if(lot < lotMin) lot = lotMin;
   if(lot > lotMax) lot = lotMax;

   return lot;
}

//+------------------------------------------------------------------+
//| スプレッドチェック関数                                            |
//+------------------------------------------------------------------+
bool IsSpreadOK()
{
#ifdef __MQL5__
   long spreadPoints = SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
#else
   int spreadPoints = (int)MarketInfo(Symbol(), MODE_SPREAD);
#endif

   return (spreadPoints <= MaxSpreadPoints);
}

//+------------------------------------------------------------------+
//| 有効証拠金チェック関数                                            |
//+------------------------------------------------------------------+
bool IsEquityOK()
{
   if(EquityControl_Active == OFF_MODE) return true;

   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   return (equity >= MinimumEquity);
}

//+------------------------------------------------------------------+
//| デバッグログ出力関数                                              |
//+------------------------------------------------------------------+
void DebugLog(string message)
{
   if(EnableDebugLog)
   {
      Print("[DEBUG] ", message);
   }
}

//+------------------------------------------------------------------+
//| MQL5用フィリングモード取得                                        |
//+------------------------------------------------------------------+
#ifdef __MQL5__
ENUM_ORDER_TYPE_FILLING GetFillingMode()
{
   long fillType = SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);

   if((fillType & SYMBOL_FILLING_FOK) != 0)
      return ORDER_FILLING_FOK;
   if((fillType & SYMBOL_FILLING_IOC) != 0)
      return ORDER_FILLING_IOC;

   return ORDER_FILLING_RETURN;
}
#endif

//+------------------------------------------------------------------+
//| 初期化時にフィリングモードを設定                                  |
//+------------------------------------------------------------------+
void InitializeFillingMode()
{
#ifdef __MQL5__
   g_FillingMode = GetFillingMode();
#endif
}

#endif // HOSOPI3_TANPOJI_UTILS_MQH
