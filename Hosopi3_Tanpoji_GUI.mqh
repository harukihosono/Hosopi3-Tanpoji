//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - GUI・パネル表示                       |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_GUI_MQH
#define HOSOPI3_TANPOJI_GUI_MQH

#include "Hosopi3_Tanpoji_Defines.mqh"
#include "Hosopi3_Tanpoji_Utils.mqh"
#include "Hosopi3_Tanpoji_Trading.mqh"

//+------------------------------------------------------------------+
//| GUI関連のグローバル変数                                           |
//+------------------------------------------------------------------+
string g_BtnAutoTrade;
string g_BtnBuyEntry;
string g_BtnSellEntry;
string g_BtnCloseBuy;
string g_BtnCloseSell;
string g_BtnCloseAll;
string g_BtnMinimize;
string g_BtnInfoPanel;
string g_LblStatus;
string g_LblProfit;

//+------------------------------------------------------------------+
//| レイアウト位置の計算                                              |
//+------------------------------------------------------------------+
void CalculateLayoutPositions()
{
   switch(LayoutPattern)
   {
      case LAYOUT_DEFAULT:
         g_EffectivePanelX = PanelX;
         g_EffectivePanelY = PanelY;
         g_EffectiveTableX = PanelX;
         g_EffectiveTableY = PanelY + PANEL_HEIGHT + 20;
         break;

      case LAYOUT_SIDE_BY_SIDE:
         g_EffectivePanelX = PanelX;
         g_EffectivePanelY = PanelY;
         g_EffectiveTableX = PanelX + PANEL_WIDTH + 20;
         g_EffectiveTableY = PanelY;
         break;

      case LAYOUT_TABLE_TOP:
         g_EffectivePanelX = PanelX;
         g_EffectivePanelY = PanelY + 200;
         g_EffectiveTableX = PanelX;
         g_EffectiveTableY = PanelY;
         break;

      case LAYOUT_COMPACT:
         g_EffectivePanelX = PanelX;
         g_EffectivePanelY = PanelY;
         g_EffectiveTableX = PanelX;
         g_EffectiveTableY = PanelY + 180;
         break;

      case LAYOUT_CUSTOM:
         g_EffectivePanelX = CustomPanelX;
         g_EffectivePanelY = CustomPanelY;
         g_EffectiveTableX = CustomTableX;
         g_EffectiveTableY = CustomTableY;
         break;
   }
}

//+------------------------------------------------------------------+
//| オブジェクト名の初期化                                            |
//+------------------------------------------------------------------+
void InitializeObjectNames()
{
   g_ObjectPrefix = PanelTitle + "_" + IntegerToString(MagicNumber) + "_";

   g_BtnAutoTrade = g_ObjectPrefix + "BtnAutoTrade";
   g_BtnBuyEntry = g_ObjectPrefix + "BtnBuyEntry";
   g_BtnSellEntry = g_ObjectPrefix + "BtnSellEntry";
   g_BtnCloseBuy = g_ObjectPrefix + "BtnCloseBuy";
   g_BtnCloseSell = g_ObjectPrefix + "BtnCloseSell";
   g_BtnCloseAll = g_ObjectPrefix + "BtnCloseAll";
   g_BtnMinimize = g_ObjectPrefix + "BtnMinimize";
   g_BtnInfoPanel = g_ObjectPrefix + "BtnInfoPanel";
   g_LblStatus = g_ObjectPrefix + "LblStatus";
   g_LblProfit = g_ObjectPrefix + "LblProfit";
}

//+------------------------------------------------------------------+
//| ボタン作成関数                                                    |
//+------------------------------------------------------------------+
bool CreateButton(string name, int x, int y, int width, int height, string text, color bgColor, color textColor)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);

   if(!ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0))
      return false;

   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, ColorDarken(bgColor, 30));
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, name, OBJPROP_FONT, "Meiryo UI");
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);

   SaveObjectName(name, g_PanelNames, g_PanelObjectCount);

   return true;
}

//+------------------------------------------------------------------+
//| ラベル作成関数                                                    |
//+------------------------------------------------------------------+
bool CreateLabel(string name, int x, int y, string text, color textColor, int fontSize = 9)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);

   if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
      return false;

   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, textColor);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
   ObjectSetString(0, name, OBJPROP_FONT, "Meiryo UI");
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);

   SaveObjectName(name, g_PanelNames, g_PanelObjectCount);

   return true;
}

//+------------------------------------------------------------------+
//| 矩形作成関数                                                      |
//+------------------------------------------------------------------+
bool CreateRectangle(string name, int x, int y, int width, int height, color bgColor, color borderColor)
{
   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);

   if(!ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0))
      return false;

   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bgColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, borderColor);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);

   SaveObjectName(name, g_PanelNames, g_PanelObjectCount);

   return true;
}

//+------------------------------------------------------------------+
//| GUI作成                                                           |
//+------------------------------------------------------------------+
void CreateGUI()
{
   CalculateLayoutPositions();
   InitializeObjectNames();

   int x = g_EffectivePanelX;
   int y = g_EffectivePanelY;

   // 最小化状態の場合
   if(g_PanelMinimized)
   {
      CreateMinimizedPanel(x, y);
      return;
   }

   // パネル背景
   CreateRectangle(g_ObjectPrefix + "PanelBG", x, y, PANEL_WIDTH, PANEL_HEIGHT, COLOR_PANEL_BG, COLOR_PANEL_BORDER);

   // タイトルバー
   CreateRectangle(g_ObjectPrefix + "TitleBar", x, y, PANEL_WIDTH, TITLE_HEIGHT, COLOR_TITLE_BG, COLOR_PANEL_BORDER);

   // タイトルテキスト
   CreateLabel(g_ObjectPrefix + "Title", x + 10, y + 8, PanelTitle, COLOR_TITLE_TEXT, 10);

   // 最小化ボタン
   CreateButton(g_BtnMinimize, x + PANEL_WIDTH - 30, y + 3, 25, 24, "-", COLOR_BUTTON_INACTIVE, COLOR_TEXT_WHITE);

   // InfoPanelボタン
   CreateButton(g_BtnInfoPanel, x + PANEL_WIDTH - 58, y + 3, 25, 24, "i",
                g_InfoPanelVisible ? COLOR_BUTTON_ACTIVE : COLOR_BUTTON_INACTIVE, COLOR_TEXT_WHITE);

   int btnY = y + TITLE_HEIGHT + PANEL_MARGIN;

   // 自動売買ボタン
   CreateButton(g_BtnAutoTrade, x + PANEL_MARGIN, btnY, PANEL_WIDTH - 2 * PANEL_MARGIN, BUTTON_HEIGHT,
                g_AutoTrading ? "AUTO: ON" : "AUTO: OFF",
                g_AutoTrading ? COLOR_BUTTON_ACTIVE : COLOR_BUTTON_INACTIVE, COLOR_TEXT_WHITE);

   btnY += BUTTON_HEIGHT + 5;

   // BUY/SELLエントリーボタン
   int halfWidth = (PANEL_WIDTH - 3 * PANEL_MARGIN) / 2;
   CreateButton(g_BtnBuyEntry, x + PANEL_MARGIN, btnY, halfWidth, BUTTON_HEIGHT,
                "BUY", COLOR_BUTTON_BUY, COLOR_TEXT_WHITE);
   CreateButton(g_BtnSellEntry, x + PANEL_MARGIN * 2 + halfWidth, btnY, halfWidth, BUTTON_HEIGHT,
                "SELL", COLOR_BUTTON_SELL, COLOR_TEXT_WHITE);

   btnY += BUTTON_HEIGHT + 5;

   // 決済ボタン
   CreateButton(g_BtnCloseBuy, x + PANEL_MARGIN, btnY, halfWidth, BUTTON_HEIGHT,
                "Close BUY", COLOR_BUTTON_NEUTRAL, COLOR_TEXT_WHITE);
   CreateButton(g_BtnCloseSell, x + PANEL_MARGIN * 2 + halfWidth, btnY, halfWidth, BUTTON_HEIGHT,
                "Close SELL", COLOR_BUTTON_NEUTRAL, COLOR_TEXT_WHITE);

   btnY += BUTTON_HEIGHT + 5;

   // 全決済ボタン
   CreateButton(g_BtnCloseAll, x + PANEL_MARGIN, btnY, PANEL_WIDTH - 2 * PANEL_MARGIN, BUTTON_HEIGHT,
                "CLOSE ALL", COLOR_BUTTON_CLOSE_ALL, COLOR_TEXT_DARK);

   btnY += BUTTON_HEIGHT + 10;

   // ステータス表示
   CreateLabel(g_LblStatus, x + PANEL_MARGIN, btnY, "Status: Ready", COLOR_TEXT_LIGHT, 8);
   btnY += 15;

   // 利益表示
   CreateLabel(g_LblProfit, x + PANEL_MARGIN, btnY, "Profit: 0.00", COLOR_TEXT_LIGHT, 8);

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| 最小化パネル作成                                                  |
//+------------------------------------------------------------------+
void CreateMinimizedPanel(int x, int y)
{
   // 最小化時の小さなパネル
   CreateRectangle(g_ObjectPrefix + "PanelBG", x, y, 100, TITLE_HEIGHT, COLOR_PANEL_BG, COLOR_PANEL_BORDER);
   CreateLabel(g_ObjectPrefix + "Title", x + 5, y + 8, PanelTitle, COLOR_TITLE_TEXT, 8);
   CreateButton(g_BtnMinimize, x + 75, y + 3, 22, 24, "+", COLOR_BUTTON_ACTIVE, COLOR_TEXT_WHITE);

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| GUI更新（キャッシュ使用版）                                        |
//+------------------------------------------------------------------+
void UpdateGUI()
{
   if(g_PanelMinimized) return;

   // 自動売買ボタン状態更新（キャッシュ使用）
   CachedSetText(g_BtnAutoTrade, g_AutoTrading ? "AUTO: ON" : "AUTO: OFF");
   CachedSetBgColor(g_BtnAutoTrade, g_AutoTrading ? COLOR_BUTTON_ACTIVE : COLOR_BUTTON_INACTIVE);

   // InfoPanelボタン状態更新（キャッシュ使用）
   CachedSetBgColor(g_BtnInfoPanel, g_InfoPanelVisible ? COLOR_BUTTON_ACTIVE : COLOR_BUTTON_INACTIVE);

   // ステータス更新（キャッシュ使用）
   int buyCount = position_count(OP_BUY);
   int sellCount = position_count(OP_SELL);
   string status = StringFormat("BUY: %d / SELL: %d", buyCount, sellCount);
   CachedSetText(g_LblStatus, status);

   // 利益更新（キャッシュ使用）
   double totalProfit = CalculateAllProfit();
   string profitText = StringFormat("Profit: %.2f", totalProfit);
   CachedSetText(g_LblProfit, profitText);
   CachedSetColor(g_LblProfit, totalProfit >= 0 ? clrLime : clrRed);

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| GUI削除                                                           |
//+------------------------------------------------------------------+
void DeleteGUI()
{
   DeleteObjectsByPrefix(g_ObjectPrefix);
   g_PanelObjectCount = 0;
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| ボタンクリック処理                                                |
//+------------------------------------------------------------------+
void ProcessButtonClick(string sparam)
{
   // 自動売買トグル
   if(sparam == g_BtnAutoTrade)
   {
      g_AutoTrading = !g_AutoTrading;
      UpdateGUI();
      DebugLog(StringFormat("自動売買: %s", g_AutoTrading ? "ON" : "OFF"));
      return;
   }

   // BUYエントリー
   if(sparam == g_BtnBuyEntry)
   {
      if(ExecuteEntry(OP_BUY, "Manual BUY"))
      {
         DebugLog("手動BUYエントリー成功");
      }
      return;
   }

   // SELLエントリー
   if(sparam == g_BtnSellEntry)
   {
      if(ExecuteEntry(OP_SELL, "Manual SELL"))
      {
         DebugLog("手動SELLエントリー成功");
      }
      return;
   }

   // BUY決済
   if(sparam == g_BtnCloseBuy)
   {
      CloseAllPositions(OP_BUY);
      DebugLog("BUYポジション全決済");
      return;
   }

   // SELL決済
   if(sparam == g_BtnCloseSell)
   {
      CloseAllPositions(OP_SELL);
      DebugLog("SELLポジション全決済");
      return;
   }

   // 全決済
   if(sparam == g_BtnCloseAll)
   {
      CloseAllPositionsBothSides();
      DebugLog("全ポジション決済");
      return;
   }

   // 最小化/展開
   if(sparam == g_BtnMinimize)
   {
      g_PanelMinimized = !g_PanelMinimized;
      DeleteGUI();
      CreateGUI();
      return;
   }

   // InfoPanelトグル
   if(sparam == g_BtnInfoPanel)
   {
      g_InfoPanelVisible = !g_InfoPanelVisible;
      UpdateGUI();
      // InfoPanelの表示/非表示はInfoPanel側で処理
      return;
   }
}

//+------------------------------------------------------------------+
//| ポジションテーブル作成                                            |
//+------------------------------------------------------------------+
void CreatePositionTable()
{
   if(!EnablePositionTable) return;

   int x = g_EffectiveTableX;
   int y = g_EffectiveTableY;
   int rowHeight = 18;
   int colWidths[] = {60, 60, 80, 80};  // Type, Lot, Price, Profit
   int totalWidth = 280;

   // テーブルヘッダー背景
   CreateRectangle(g_ObjectPrefix + "TableHeader", x, y, totalWidth, rowHeight, COLOR_TITLE_BG, COLOR_PANEL_BORDER);

   // ヘッダーラベル
   CreateLabel(g_ObjectPrefix + "TblHdrType", x + 5, y + 3, "Type", COLOR_TEXT_LIGHT, 8);
   CreateLabel(g_ObjectPrefix + "TblHdrLot", x + 65, y + 3, "Lot", COLOR_TEXT_LIGHT, 8);
   CreateLabel(g_ObjectPrefix + "TblHdrPrice", x + 125, y + 3, "Price", COLOR_TEXT_LIGHT, 8);
   CreateLabel(g_ObjectPrefix + "TblHdrProfit", x + 205, y + 3, "Profit", COLOR_TEXT_LIGHT, 8);

   UpdatePositionTable();
}

//+------------------------------------------------------------------+
//| ポジションテーブル更新                                            |
//+------------------------------------------------------------------+
void UpdatePositionTable()
{
   if(!EnablePositionTable) return;

   // 既存の行を削除
   for(int i = 0; i < 20; i++)
   {
      string rowBG = g_ObjectPrefix + "TblRow" + IntegerToString(i);
      string typeLabel = g_ObjectPrefix + "TblType" + IntegerToString(i);
      string lotLabel = g_ObjectPrefix + "TblLot" + IntegerToString(i);
      string priceLabel = g_ObjectPrefix + "TblPrice" + IntegerToString(i);
      string profitLabel = g_ObjectPrefix + "TblProfit" + IntegerToString(i);

      ObjectDelete(0, rowBG);
      ObjectDelete(0, typeLabel);
      ObjectDelete(0, lotLabel);
      ObjectDelete(0, priceLabel);
      ObjectDelete(0, profitLabel);
   }

   int x = g_EffectiveTableX;
   int y = g_EffectiveTableY + 20;  // ヘッダーの下
   int rowHeight = 18;
   int totalWidth = 280;
   int rowIndex = 0;

#ifdef __MQL5__
   for(int i = PositionsTotal() - 1; i >= 0 && rowIndex < 10; i--)
   {
      if(g_position.SelectByIndex(i))
      {
         if(g_position.Symbol() == Symbol() && g_position.Magic() == MagicNumber)
         {
            int type = (int)g_position.PositionType();
            double lot = g_position.Volume();
            double price = g_position.PriceOpen();
            double profit = g_position.Profit() + g_position.Swap();

            DrawTableRow(x, y + rowIndex * rowHeight, rowIndex, type, lot, price, profit);
            rowIndex++;
         }
      }
   }
#else
   for(int i = OrdersTotal() - 1; i >= 0 && rowIndex < 10; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         {
            int type = OrderType();
            if(type == OP_BUY || type == OP_SELL)
            {
               double lot = OrderLots();
               double price = OrderOpenPrice();
               double profit = OrderProfit() + OrderSwap() + OrderCommission();

               DrawTableRow(x, y + rowIndex * rowHeight, rowIndex, type, lot, price, profit);
               rowIndex++;
            }
         }
      }
   }
#endif

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| テーブル行描画                                                    |
//+------------------------------------------------------------------+
void DrawTableRow(int x, int y, int index, int type, double lot, double price, double profit)
{
   int rowHeight = 18;
   int totalWidth = 280;

   string rowBG = g_ObjectPrefix + "TblRow" + IntegerToString(index);
   string typeLabel = g_ObjectPrefix + "TblType" + IntegerToString(index);
   string lotLabel = g_ObjectPrefix + "TblLot" + IntegerToString(index);
   string priceLabel = g_ObjectPrefix + "TblPrice" + IntegerToString(index);
   string profitLabel = g_ObjectPrefix + "TblProfit" + IntegerToString(index);

   // 背景
   color bgColor = (index % 2 == 0) ? COLOR_PANEL_BG : COLOR_TITLE_BG;
   CreateRectangle(rowBG, x, y, totalWidth, rowHeight, bgColor, COLOR_PANEL_BORDER);

   // Type
   string typeStr = (type == OP_BUY) ? "BUY" : "SELL";
   color typeColor = (type == OP_BUY) ? COLOR_BUTTON_BUY : COLOR_BUTTON_SELL;
   CreateLabel(typeLabel, x + 5, y + 3, typeStr, typeColor, 8);

   // Lot
   CreateLabel(lotLabel, x + 65, y + 3, DoubleToString(lot, 2), COLOR_TEXT_LIGHT, 8);

   // Price
   int digits = (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
   CreateLabel(priceLabel, x + 125, y + 3, DoubleToString(price, digits), COLOR_TEXT_LIGHT, 8);

   // Profit
   color profitColor = (profit >= 0) ? clrLime : clrRed;
   CreateLabel(profitLabel, x + 205, y + 3, DoubleToString(profit, 2), profitColor, 8);
}

//+------------------------------------------------------------------+
//| ポジションテーブル削除                                            |
//+------------------------------------------------------------------+
void DeletePositionTable()
{
   DeleteObjectsByPrefix(g_ObjectPrefix + "Tbl");
}

//+------------------------------------------------------------------+
//| 価格ライン表示                                                    |
//+------------------------------------------------------------------+
void DisplayPriceLines()
{
   if(!EnablePriceLabels) return;

   // 平均価格ライン（BUY）
   if(AveragePriceLine == ON_MODE && position_count(OP_BUY) > 0)
   {
      double avgBuy = CalculateAveragePrice(OP_BUY);
      if(avgBuy > 0)
      {
         string lineName = g_ObjectPrefix + "AvgLineBuy";
         if(ObjectFind(0, lineName) < 0)
         {
            ObjectCreate(0, lineName, OBJ_HLINE, 0, 0, avgBuy);
         }
         else
         {
            ObjectSetDouble(0, lineName, OBJPROP_PRICE, avgBuy);
         }
         ObjectSetInteger(0, lineName, OBJPROP_COLOR, AveragePriceLineColor);
         ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_DASH);
         ObjectSetInteger(0, lineName, OBJPROP_WIDTH, 1);
         ObjectSetInteger(0, lineName, OBJPROP_SELECTABLE, false);

         SaveObjectName(lineName, g_LineNames, g_LineObjectCount);
      }
   }
   else
   {
      ObjectDelete(0, g_ObjectPrefix + "AvgLineBuy");
   }

   // 平均価格ライン（SELL）
   if(AveragePriceLine == ON_MODE && position_count(OP_SELL) > 0)
   {
      double avgSell = CalculateAveragePrice(OP_SELL);
      if(avgSell > 0)
      {
         string lineName = g_ObjectPrefix + "AvgLineSell";
         if(ObjectFind(0, lineName) < 0)
         {
            ObjectCreate(0, lineName, OBJ_HLINE, 0, 0, avgSell);
         }
         else
         {
            ObjectSetDouble(0, lineName, OBJPROP_PRICE, avgSell);
         }
         ObjectSetInteger(0, lineName, OBJPROP_COLOR, AveragePriceLineColor);
         ObjectSetInteger(0, lineName, OBJPROP_STYLE, STYLE_DASH);
         ObjectSetInteger(0, lineName, OBJPROP_WIDTH, 1);
         ObjectSetInteger(0, lineName, OBJPROP_SELECTABLE, false);

         SaveObjectName(lineName, g_LineNames, g_LineObjectCount);
      }
   }
   else
   {
      ObjectDelete(0, g_ObjectPrefix + "AvgLineSell");
   }

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| 価格ライン削除                                                    |
//+------------------------------------------------------------------+
void DeletePriceLines()
{
   for(int i = 0; i < g_LineObjectCount; i++)
   {
      if(g_LineNames[i] != "")
         ObjectDelete(0, g_LineNames[i]);
   }
   g_LineObjectCount = 0;
}

#endif // HOSOPI3_TANPOJI_GUI_MQH
