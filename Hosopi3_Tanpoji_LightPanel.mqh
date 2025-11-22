//+------------------------------------------------------------------+
//|                                   Hosopi3_Tanpoji_LightPanel.mqh |
//|                         Copyright 2025                           |
//|                    軽量パネル - Comment()ベース                   |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_LIGHTPANEL_MQH
#define HOSOPI3_TANPOJI_LIGHTPANEL_MQH

//+------------------------------------------------------------------+
//| 軽量パネル更新                                                    |
//+------------------------------------------------------------------+
void UpdateLightPanel()
{
   string info = "=== Hosopi3 Tanpoji ===\n";
   info += "AUTO: " + (g_AutoTrading ? "ON" : "OFF") + "\n";
   info += "---------------------\n";

   // ポジション集計
   int buyCount = 0, sellCount = 0;
   double buyProfit = 0, sellProfit = 0;
   double buyLots = 0, sellLots = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != Symbol()) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;

      double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
      long posType = PositionGetInteger(POSITION_TYPE);
      double lots = PositionGetDouble(POSITION_VOLUME);

      if(posType == POSITION_TYPE_BUY)
      {
         buyCount++;
         buyProfit += profit;
         buyLots += lots;
      }
      else if(posType == POSITION_TYPE_SELL)
      {
         sellCount++;
         sellProfit += profit;
         sellLots += lots;
      }
   }

   // ポジション表示
   info += StringFormat("BUY:  %d  %.2f  %+.0f\n", buyCount, buyLots, buyProfit);
   info += StringFormat("SELL: %d  %.2f  %+.0f\n", sellCount, sellLots, sellProfit);
   info += StringFormat("TOTAL: %+.0f\n", buyProfit + sellProfit);
   info += "---------------------\n";

   // インジケーター状態（g_IndicatorInfo配列を使用）
   info += "== Indicators ==\n";

   // MA (index 0)
   if(g_IndicatorInfo[0].enabled)
      info += "MA:    " + SigText(g_IndicatorInfo[0].buySignal) + " / " + SigText(g_IndicatorInfo[0].sellSignal) + "\n";

   // RSI (index 1)
   if(g_IndicatorInfo[1].enabled)
      info += "RSI:   " + SigText(g_IndicatorInfo[1].buySignal) + " / " + SigText(g_IndicatorInfo[1].sellSignal) + "\n";

   // BB (index 2)
   if(g_IndicatorInfo[2].enabled)
      info += "BB:    " + SigText(g_IndicatorInfo[2].buySignal) + " / " + SigText(g_IndicatorInfo[2].sellSignal) + "\n";

   // Stoch (index 3)
   if(g_IndicatorInfo[3].enabled)
      info += "Stoch: " + SigText(g_IndicatorInfo[3].buySignal) + " / " + SigText(g_IndicatorInfo[3].sellSignal) + "\n";

   // CCI (index 4)
   if(g_IndicatorInfo[4].enabled)
      info += "CCI:   " + SigText(g_IndicatorInfo[4].buySignal) + " / " + SigText(g_IndicatorInfo[4].sellSignal) + "\n";

   // ADX (index 5)
   if(g_IndicatorInfo[5].enabled)
      info += "ADX:   " + SigText(g_IndicatorInfo[5].buySignal) + " / " + SigText(g_IndicatorInfo[5].sellSignal) + "\n";

   // Custom (index 6)
   if(g_IndicatorInfo[6].enabled)
      info += "Custom:" + SigText(g_IndicatorInfo[6].buySignal) + " / " + SigText(g_IndicatorInfo[6].sellSignal) + "\n";

   Comment(info);
}

//+------------------------------------------------------------------+
//| シグナル文字列                                                    |
//+------------------------------------------------------------------+
string SigText(ENUM_SIGNAL_STATE sig)
{
   if(sig == SIGNAL_BUY) return "BUY";
   if(sig == SIGNAL_SELL) return "SELL";
   return "-";
}

//+------------------------------------------------------------------+
//| パネルクリア                                                      |
//+------------------------------------------------------------------+
void ClearLightPanel()
{
   Comment("");
}

#endif
