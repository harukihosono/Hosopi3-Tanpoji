//+------------------------------------------------------------------+
//|                                            Hosopi3_Tanpoji.mq5   |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025"
#property link      ""
#property version   "2.10"
#property strict
#property description "Hosopi 3 タンポジ - シンプル単ポジションEA"
#property description "ナンピン・ゴースト機能を除外したシンプル版"
#property description "ファイル分割・インジケーターパネル対応版"

//+------------------------------------------------------------------+
//| インクルードファイル                                              |
//+------------------------------------------------------------------+
#include "Hosopi3_Tanpoji_Defines.mqh"
#include "Hosopi3_Tanpoji_Params.mqh"
#include "Hosopi3_Tanpoji_Cache.mqh"
#include "Hosopi3_Tanpoji_Utils.mqh"
#include "Hosopi3_Tanpoji_Trading.mqh"
#include "Hosopi3_Tanpoji_CustomIndicator.mqh"
#include "Hosopi3_Tanpoji_Strategy.mqh"
#include "Hosopi3_Tanpoji_GUI.mqh"
#include "Hosopi3_Tanpoji_InfoPanel.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                    |
//+------------------------------------------------------------------+
int OnInit()
{
   // グローバル変数初期化
   InitializeGlobalVariables();

   // オブジェクト名初期化
   InitializeObjectNames();

   // フィリングモード初期化
   InitializeFillingMode();

   // インジケーターハンドル初期化
   InitializeIndicatorHandles();

   // 外部インジケーター初期化
   if(!InitializeCustomIndicator())
   {
      Print("警告: 外部インジケーターの初期化に失敗しました");
   }

   // GUI作成
   CreateGUI();

   // ポジションテーブル作成
   CreatePositionTable();

   // InfoPanel初期化
   InitializeInfoPanel();

   Print("===========================================");
   Print("Hosopi3 タンポジ EA v2.1 初期化完了");
   Print("マジックナンバー: ", MagicNumber);
   Print("ロットサイズ: ", InitialLot);
   if(IsCustomIndicatorEnabled())
   {
      Print("外部インジケーター: ", GetCustomIndicatorName());
   }
   Print("===========================================");

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // インジケーターハンドル解放
   ReleaseIndicatorHandles();

   // GUI削除
   DeleteGUI();

   // ポジションテーブル削除
   DeletePositionTable();

   // InfoPanel削除
   DeleteInfoPanel();

   // 価格ライン削除
   DeletePriceLines();

   Print("Hosopi3 タンポジ EA 終了");
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   // トレード管理処理（利確・トレーリング・最大損失決済）
   ProcessTradeManagement();

   // 外部インジケーター決済処理
   ProcessCustomIndicatorExit();

   // 自動売買が無効の場合はスキップ
   if(!g_AutoTrading) return;

   // 時間チェック
   if(!IsEntryTimeAllowed()) return;

   // シグナル更新
   UpdateAllSignals();

   // エントリー処理
   ProcessEntryLogic();

   // 価格ライン表示
   DisplayPriceLines();

   // GUI更新（1秒に1回）
   static datetime lastGUIUpdate = 0;
   datetime now = TimeCurrent();
   if(now != lastGUIUpdate)
   {
      lastGUIUpdate = now;
      UpdateGUI();
      UpdatePositionTable();
      UpdateInfoPanel();
   }
}

//+------------------------------------------------------------------+
//| Chart event function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // オブジェクトクリックイベント
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      // InfoPanelのボタンクリック処理
      if(ProcessInfoPanelClick(sparam))
      {
         // メインパネルのInfoPanelボタン状態も更新
         UpdateGUI();
         return;
      }

      // メインパネルのボタンクリック処理
      ProcessButtonClick(sparam);

      // InfoPanelボタンの場合
      if(sparam == g_BtnInfoPanel)
      {
         ToggleInfoPanel();
         UpdateGUI();
      }
   }
}

//+------------------------------------------------------------------+
//| エントリーロジック処理                                            |
//+------------------------------------------------------------------+
void ProcessEntryLogic()
{
   // 有効なインジケーターがない場合はスキップ
   if(GetEnabledIndicatorCount() == 0) return;

   // BUYエントリー判定
   if(EntryMode == MODE_BUY_ONLY || EntryMode == MODE_BOTH)
   {
      if(EvaluateEntryCondition(0))
      {
         // ポジションがない場合、または初回エントリーのみモードがOFFの場合
         if(position_count(OP_BUY) == 0 || !FirstEntryOnly)
         {
            if(ExecuteEntry(OP_BUY, "Signal BUY"))
            {
               DebugLog("シグナルBUYエントリー成功");
            }
         }
      }
   }

   // SELLエントリー判定
   if(EntryMode == MODE_SELL_ONLY || EntryMode == MODE_BOTH)
   {
      if(EvaluateEntryCondition(1))
      {
         // ポジションがない場合、または初回エントリーのみモードがOFFの場合
         if(position_count(OP_SELL) == 0 || !FirstEntryOnly)
         {
            if(ExecuteEntry(OP_SELL, "Signal SELL"))
            {
               DebugLog("シグナルSELLエントリー成功");
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| テスター用関数                                                    |
//+------------------------------------------------------------------+
#ifdef __MQL5__
double OnTester()
{
   double profit = TesterStatistics(STAT_PROFIT);
   double drawdown = TesterStatistics(STAT_BALANCE_DD_RELATIVE);
   double trades = TesterStatistics(STAT_TRADES);

   // カスタム最適化基準
   if(trades < 10) return 0;
   if(drawdown > 50) return 0;

   return profit / (drawdown + 1);
}
#endif
//+------------------------------------------------------------------+
