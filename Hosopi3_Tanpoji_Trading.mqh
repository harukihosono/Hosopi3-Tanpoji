//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - トレード関数                         |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_TRADING_MQH
#define HOSOPI3_TANPOJI_TRADING_MQH

#include "Hosopi3_Tanpoji_Defines.mqh"
#include "Hosopi3_Tanpoji_Utils.mqh"

//+------------------------------------------------------------------+
//| エントリー実行関数                                                |
//+------------------------------------------------------------------+
bool ExecuteEntry(int type, string comment = "")
{
   // 事前チェック
   if(!IsSpreadOK())
   {
      DebugLog("スプレッドが大きすぎます");
      return false;
   }

   if(!IsEquityOK())
   {
      DebugLog("有効証拠金が不足しています");
      return false;
   }

   // エントリー方向のチェック
   if(type == OP_BUY && EntryMode == MODE_SELL_ONLY)
   {
      DebugLog("BUYエントリーは無効です");
      return false;
   }
   if(type == OP_SELL && EntryMode == MODE_BUY_ONLY)
   {
      DebugLog("SELLエントリーは無効です");
      return false;
   }

   // ポジション保護モードチェック
   int side = (type == OP_BUY) ? 0 : 1;
   if(!IsEntryAllowedByProtectionMode(side))
   {
      DebugLog("ポジション保護モードにより禁止");
      return false;
   }

   // 決済後インターバルチェック
   if(!IsCloseIntervalElapsed(side))
   {
      DebugLog("決済後インターバル中");
      return false;
   }

   // 初回エントリーのみモード：既にポジションがある場合はスキップ
   if(FirstEntryOnly && position_count(type) > 0)
   {
      DebugLog("既にポジションがあるためスキップ");
      return false;
   }

   // ロットサイズ
   double lot = NormalizeLot(InitialLot);

   // コメント生成
   if(comment == "")
   {
      comment = PanelTitle + "_" + ((type == OP_BUY) ? "BUY" : "SELL");
   }

   // エントリー実行
   bool result = false;

#ifdef __MQL5__
   // MQL5のエントリー処理
   g_trade.SetExpertMagicNumber(MagicNumber);
   g_trade.SetTypeFilling(g_FillingMode);
   g_trade.SetDeviationInPoints(Slippage);

   double price = (type == OP_BUY) ? SymbolInfoDouble(Symbol(), SYMBOL_ASK)
                                   : SymbolInfoDouble(Symbol(), SYMBOL_BID);

   double sl = 0, tp = 0;

   // ストップロス設定
   if(EnableStopLoss && StopLossPoints > 0)
   {
      double slPoints = StopLossPoints * Point();
      sl = (type == OP_BUY) ? price - slPoints : price + slPoints;
   }

   // テイクプロフィット設定
   if(EnableTakeProfit && TakeProfitPoints > 0)
   {
      double tpPoints = TakeProfitPoints * Point();
      tp = (type == OP_BUY) ? price + tpPoints : price - tpPoints;
   }

   if(type == OP_BUY)
   {
      result = g_trade.Buy(lot, Symbol(), price, sl, tp, comment);
   }
   else
   {
      result = g_trade.Sell(lot, Symbol(), price, sl, tp, comment);
   }

   if(result)
   {
      DebugLog(StringFormat("エントリー成功: %s, Lot: %.2f, Price: %.5f",
               (type == OP_BUY) ? "BUY" : "SELL", lot, price));
   }
   else
   {
      DebugLog(StringFormat("エントリー失敗: %s, Error: %d",
               (type == OP_BUY) ? "BUY" : "SELL", GetLastError()));
   }

#else
   // MQL4のエントリー処理
   double price = (type == OP_BUY) ? MarketInfo(Symbol(), MODE_ASK)
                                   : MarketInfo(Symbol(), MODE_BID);

   double sl = 0, tp = 0;

   // ストップロス設定
   if(EnableStopLoss && StopLossPoints > 0)
   {
      double slPoints = StopLossPoints * Point;
      sl = (type == OP_BUY) ? price - slPoints : price + slPoints;
   }

   // テイクプロフィット設定
   if(EnableTakeProfit && TakeProfitPoints > 0)
   {
      double tpPoints = TakeProfitPoints * Point;
      tp = (type == OP_BUY) ? price + tpPoints : price - tpPoints;
   }

   int ticket = OrderSend(Symbol(), type, lot, price, Slippage, sl, tp, comment, MagicNumber, 0, clrNONE);

   if(ticket > 0)
   {
      result = true;
      DebugLog(StringFormat("エントリー成功: %s, Lot: %.2f, Ticket: %d",
               (type == OP_BUY) ? "BUY" : "SELL", lot, ticket));
   }
   else
   {
      DebugLog(StringFormat("エントリー失敗: %s, Error: %d",
               (type == OP_BUY) ? "BUY" : "SELL", GetLastError()));
   }
#endif

   return result;
}

//+------------------------------------------------------------------+
//| 指定タイプの全ポジションを決済                                    |
//+------------------------------------------------------------------+
bool CloseAllPositions(int type)
{
   bool result = true;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.PositionType() == (ENUM_POSITION_TYPE)type &&
            g_position.Symbol() == Symbol() &&
            g_position.Magic() == MagicNumber)
         {
            if(!g_trade.PositionClose(g_position.Ticket()))
            {
               result = false;
               DebugLog(StringFormat("ポジション決済失敗: Ticket %d, Error: %d",
                        g_position.Ticket(), GetLastError()));
            }
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
            double closePrice = (type == OP_BUY) ? MarketInfo(Symbol(), MODE_BID)
                                                  : MarketInfo(Symbol(), MODE_ASK);
            if(!OrderClose(OrderTicket(), OrderLots(), closePrice, Slippage, clrNONE))
            {
               result = false;
               DebugLog(StringFormat("ポジション決済失敗: Ticket %d, Error: %d",
                        OrderTicket(), GetLastError()));
            }
         }
      }
   }
#endif

   // 決済後の時間を記録
   if(result)
   {
      if(type == OP_BUY)
         g_BuyClosedTime = TimeCurrent();
      else
         g_SellClosedTime = TimeCurrent();
   }

   return result;
}

//+------------------------------------------------------------------+
//| 全ポジションを決済                                                |
//+------------------------------------------------------------------+
bool CloseAllPositionsBothSides()
{
   bool buyResult = CloseAllPositions(OP_BUY);
   bool sellResult = CloseAllPositions(OP_SELL);
   return buyResult && sellResult;
}

//+------------------------------------------------------------------+
//| 利確処理関数                                                      |
//+------------------------------------------------------------------+
void ProcessTakeProfit()
{
   if(!EnableTakeProfit || TakeProfitPoints <= 0) return;

   double tpPoints = TakeProfitPoints * Point();

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.Symbol() == Symbol() && g_position.Magic() == MagicNumber)
         {
            int type = (int)g_position.PositionType();
            double openPrice = g_position.PriceOpen();
            double currentPrice = (type == OP_BUY) ? SymbolInfoDouble(Symbol(), SYMBOL_BID)
                                                   : SymbolInfoDouble(Symbol(), SYMBOL_ASK);

            double profit = (type == OP_BUY) ? currentPrice - openPrice : openPrice - currentPrice;

            if(profit >= tpPoints)
            {
               g_trade.PositionClose(g_position.Ticket());
               DebugLog(StringFormat("利確決済: Ticket %d, Profit: %.5f", g_position.Ticket(), profit));

               // 決済時間を記録
               if(type == OP_BUY)
                  g_BuyClosedTime = TimeCurrent();
               else
                  g_SellClosedTime = TimeCurrent();
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
            int type = OrderType();
            if(type == OP_BUY || type == OP_SELL)
            {
               double openPrice = OrderOpenPrice();
               double currentPrice = (type == OP_BUY) ? MarketInfo(Symbol(), MODE_BID)
                                                      : MarketInfo(Symbol(), MODE_ASK);

               double profit = (type == OP_BUY) ? currentPrice - openPrice : openPrice - currentPrice;

               if(profit >= tpPoints)
               {
                  OrderClose(OrderTicket(), OrderLots(), currentPrice, Slippage, clrNONE);
                  DebugLog(StringFormat("利確決済: Ticket %d, Profit: %.5f", OrderTicket(), profit));

                  // 決済時間を記録
                  if(type == OP_BUY)
                     g_BuyClosedTime = TimeCurrent();
                  else
                     g_SellClosedTime = TimeCurrent();
               }
            }
         }
      }
   }
#endif
}

//+------------------------------------------------------------------+
//| トレーリングストップ処理関数                                       |
//+------------------------------------------------------------------+
void ProcessTrailingStop()
{
   if(!EnableTrailingStop || TrailingTrigger <= 0) return;

   double triggerPoints = TrailingTrigger * Point();
   double offsetPoints = TrailingOffset * Point();

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.Symbol() == Symbol() && g_position.Magic() == MagicNumber)
         {
            int type = (int)g_position.PositionType();
            double openPrice = g_position.PriceOpen();
            double currentSL = g_position.StopLoss();
            double currentPrice = (type == OP_BUY) ? SymbolInfoDouble(Symbol(), SYMBOL_BID)
                                                   : SymbolInfoDouble(Symbol(), SYMBOL_ASK);

            if(type == OP_BUY)
            {
               double profit = currentPrice - openPrice;
               if(profit >= triggerPoints)
               {
                  double newSL = currentPrice - offsetPoints;
                  if(currentSL < newSL || currentSL == 0)
                  {
                     g_trade.PositionModify(g_position.Ticket(), newSL, g_position.TakeProfit());
                     DebugLog(StringFormat("トレーリングSL更新 (BUY): %.5f -> %.5f", currentSL, newSL));
                  }
               }
            }
            else // SELL
            {
               double profit = openPrice - currentPrice;
               if(profit >= triggerPoints)
               {
                  double newSL = currentPrice + offsetPoints;
                  if(currentSL > newSL || currentSL == 0)
                  {
                     g_trade.PositionModify(g_position.Ticket(), newSL, g_position.TakeProfit());
                     DebugLog(StringFormat("トレーリングSL更新 (SELL): %.5f -> %.5f", currentSL, newSL));
                  }
               }
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
            int type = OrderType();
            if(type == OP_BUY || type == OP_SELL)
            {
               double openPrice = OrderOpenPrice();
               double currentSL = OrderStopLoss();
               double currentPrice = (type == OP_BUY) ? MarketInfo(Symbol(), MODE_BID)
                                                      : MarketInfo(Symbol(), MODE_ASK);

               if(type == OP_BUY)
               {
                  double profit = currentPrice - openPrice;
                  if(profit >= triggerPoints)
                  {
                     double newSL = currentPrice - offsetPoints;
                     if(currentSL < newSL || currentSL == 0)
                     {
                        OrderModify(OrderTicket(), openPrice, newSL, OrderTakeProfit(), 0, clrNONE);
                        DebugLog(StringFormat("トレーリングSL更新 (BUY): %.5f -> %.5f", currentSL, newSL));
                     }
                  }
               }
               else // SELL
               {
                  double profit = openPrice - currentPrice;
                  if(profit >= triggerPoints)
                  {
                     double newSL = currentPrice + offsetPoints;
                     if(currentSL > newSL || currentSL == 0)
                     {
                        OrderModify(OrderTicket(), openPrice, newSL, OrderTakeProfit(), 0, clrNONE);
                        DebugLog(StringFormat("トレーリングSL更新 (SELL): %.5f -> %.5f", currentSL, newSL));
                     }
                  }
               }
            }
         }
      }
   }
#endif
}

//+------------------------------------------------------------------+
//| 最大損失決済処理関数                                              |
//+------------------------------------------------------------------+
void ProcessMaxLossClose()
{
   if(!EnableMaxLossClose || MaxLossAmount <= 0) return;

   double totalProfit = CalculateAllProfit();

   if(totalProfit <= -MaxLossAmount)
   {
      DebugLog(StringFormat("最大損失に達したため全決済: %.2f", totalProfit));
      CloseAllPositionsBothSides();
   }
}

//+------------------------------------------------------------------+
//| トレード管理処理（OnTickから呼び出し）                            |
//+------------------------------------------------------------------+
void ProcessTradeManagement()
{
   // 利確処理
   ProcessTakeProfit();

   // トレーリングストップ処理
   ProcessTrailingStop();

   // 最大損失決済処理
   ProcessMaxLossClose();
}

#endif // HOSOPI3_TANPOJI_TRADING_MQH
