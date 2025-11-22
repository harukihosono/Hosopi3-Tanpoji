//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - パラメータ定義ファイル               |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_PARAMS_MQH
#define HOSOPI3_TANPOJI_PARAMS_MQH

//+------------------------------------------------------------------+
//|                          入力パラメータ定義                       |
//+------------------------------------------------------------------+

// ======== 基本設定 ========
sinput group "== 1. 基本設定 =="
input int MagicNumber = 99899;                // マジックナンバー
input string PanelTitle = "Hosopi3 タンポジ"; // パネルタイトル
input ENTRY_MODE EntryMode = MODE_BOTH;       // エントリー方向
input double InitialLot = 0.01;               // ロットサイズ
input int MaxSpreadPoints = 2000;             // 最大スプレッド（Point）
input int Slippage = 100;                     // スリッページ（Point）

// ======== 機能制御設定 ========
sinput group "== 2. 機能制御設定 =="
input ON_OFF PositionProtection = OFF_MODE;   // 両建て禁止（OFF=両建て許可、ON=両建て禁止）

// ======== 有効証拠金関連の設定 ========
sinput group "== 3. 有効証拠金設定 =="
input ON_OFF EquityControl_Active = ON_MODE;  // 有効証拠金チェックを有効にする(ON/OFF)
input double MinimumEquity = 10000;           // 最低有効証拠金（この金額未満でエントリー停止）

// ======== TP/SL/トレール設定 ========
sinput group "== 4. TP/SL/トレール設定 =="
input bool EnableTakeProfit = false;          // TP（利確）を有効化
input int TakeProfitPoints = 2000;            // TP幅（Point）
input bool EnableStopLoss = false;            // SL（損切り）を有効化
input int StopLossPoints = 5000;              // SL幅（Point）
input bool EnableTrailingStop = false;        // トレールストップを有効化
input int TrailingTrigger = 1000;             // トレールトリガー（Point）
input int TrailingOffset = 500;               // トレールオフセット（Point）

// ======== 損失額決済機能設定 ========
sinput group "== 5. 損失額決済設定 =="
input bool EnableMaxLossClose = false;        // 損失額決済機能を有効化(ON/OFF)
input double MaxLossAmount = 10000.0;         // 最大損失額（この金額以上の損失で全決済）

// ======== 決済後インターバル設定 ========
sinput group "== 6. 決済後インターバル設定 =="
input bool EnableCloseInterval = false;       // 決済後インターバル機能を有効化
input int CloseInterval = 30;                 // 決済後インターバル（Minutes）

// ======== 時間設定 ========
sinput group "== 7. 時間設定 =="
input USE_TIMES set_time = GMT9;              // 時間取得方法
input int natu = 6;                           // 夏加算時間（バックテスト用）
input int huyu = 7;                           // 冬加算時間（バックテスト用）

// ======== 曜日別エントリー制御 ========
sinput group "== 8. 曜日フィルター =="
input bool EnableDayFilter = false;           // 曜日フィルターを有効化
input bool TradeMonday = true;                // 月曜日取引
input bool TradeTuesday = true;               // 火曜日取引
input bool TradeWednesday = true;             // 水曜日取引
input bool TradeThursday = true;              // 木曜日取引
input bool TradeFriday = true;                // 金曜日取引

// ======== 時間帯別エントリー制御 ========
sinput group "== 9. 時間フィルター =="
input bool EnableTimeFilter = false;          // 時間フィルターを有効化
input int TradeStartHour = 9;                 // 取引開始時間（時）
input int TradeEndHour = 23;                  // 取引終了時間（時）

// ======== 条件設定 ========
sinput group "== 10. エントリー条件設定 =="
input CONDITION_TYPE EntryConditionType = AND_CONDITION; // エントリー条件タイプ

//==================================================================
//                    MA（移動平均線）設定
//==================================================================
sinput group "== 11. MA（移動平均線）設定 =="

// Buy用MA設定
input MA_ENTRY_TYPE MA_Buy_Enabled = MA_ENTRY_DISABLED;  // MA Buy エントリー
input MA_STRATEGY_TYPE MA_Buy_Strategy = MA_GOLDEN_CROSS; // MA Buy 戦略
input ENUM_TIMEFRAMES MA_Buy_Timeframe = PERIOD_CURRENT;       // MA Buy 時間足
input int MA_Buy_FastPeriod = 5;                          // MA Buy 短期期間
input int MA_Buy_SlowPeriod = 20;                         // MA Buy 長期期間
input ENUM_MA_METHOD MA_Buy_Method = MODE_SMA;            // MA Buy 平均化方法

// Sell用MA設定
input MA_ENTRY_TYPE MA_Sell_Enabled = MA_ENTRY_DISABLED; // MA Sell エントリー
input MA_STRATEGY_TYPE MA_Sell_Strategy = MA_DEAD_CROSS; // MA Sell 戦略
input ENUM_TIMEFRAMES MA_Sell_Timeframe = PERIOD_CURRENT;      // MA Sell 時間足
input int MA_Sell_FastPeriod = 5;                         // MA Sell 短期期間
input int MA_Sell_SlowPeriod = 20;                        // MA Sell 長期期間
input ENUM_MA_METHOD MA_Sell_Method = MODE_SMA;           // MA Sell 平均化方法

//==================================================================
//                    RSI設定
//==================================================================
sinput group "== 12. RSI設定 =="

// Buy用RSI設定
input RSI_ENTRY_TYPE RSI_Buy_Enabled = RSI_ENTRY_DISABLED; // RSI Buy エントリー
input RSI_STRATEGY_TYPE RSI_Buy_Strategy = RSI_OVERSOLD;   // RSI Buy 戦略
input ENUM_TIMEFRAMES RSI_Buy_Timeframe = PERIOD_CURRENT;       // RSI Buy 時間足
input int RSI_Buy_Period = 14;                             // RSI Buy 期間
input int RSI_Buy_Level = 30;                              // RSI Buy 閾値

// Sell用RSI設定
input RSI_ENTRY_TYPE RSI_Sell_Enabled = RSI_ENTRY_DISABLED; // RSI Sell エントリー
input RSI_STRATEGY_TYPE RSI_Sell_Strategy = RSI_OVERBOUGHT; // RSI Sell 戦略
input ENUM_TIMEFRAMES RSI_Sell_Timeframe = PERIOD_CURRENT;       // RSI Sell 時間足
input int RSI_Sell_Period = 14;                             // RSI Sell 期間
input int RSI_Sell_Level = 70;                              // RSI Sell 閾値

//==================================================================
//                    ボリンジャーバンド設定
//==================================================================
sinput group "== 13. ボリンジャーバンド設定 =="

// Buy用BB設定
input BB_ENTRY_TYPE BB_Buy_Enabled = BB_ENTRY_DISABLED;   // BB Buy エントリー
input BB_STRATEGY_TYPE BB_Buy_Strategy = BB_TOUCH_LOWER;  // BB Buy 戦略
input ENUM_TIMEFRAMES BB_Buy_Timeframe = PERIOD_CURRENT;       // BB Buy 時間足
input int BB_Buy_Period = 20;                             // BB Buy 期間
input double BB_Buy_Deviation = 2.0;                      // BB Buy 偏差

// Sell用BB設定
input BB_ENTRY_TYPE BB_Sell_Enabled = BB_ENTRY_DISABLED;  // BB Sell エントリー
input BB_STRATEGY_TYPE BB_Sell_Strategy = BB_TOUCH_UPPER; // BB Sell 戦略
input ENUM_TIMEFRAMES BB_Sell_Timeframe = PERIOD_CURRENT;      // BB Sell 時間足
input int BB_Sell_Period = 20;                            // BB Sell 期間
input double BB_Sell_Deviation = 2.0;                     // BB Sell 偏差

//==================================================================
//                    ストキャスティクス設定
//==================================================================
sinput group "== 14. ストキャスティクス設定 =="

// Buy用Stoch設定
input STOCH_ENTRY_TYPE Stoch_Buy_Enabled = STOCH_ENTRY_DISABLED; // Stoch Buy エントリー
input STOCH_STRATEGY_TYPE Stoch_Buy_Strategy = STOCH_OVERSOLD;   // Stoch Buy 戦略
input ENUM_TIMEFRAMES Stoch_Buy_Timeframe = PERIOD_CURRENT;           // Stoch Buy 時間足
input int Stoch_Buy_KPeriod = 5;                                 // Stoch Buy %K期間
input int Stoch_Buy_DPeriod = 3;                                 // Stoch Buy %D期間
input int Stoch_Buy_Slowing = 3;                                 // Stoch Buy スローイング
input int Stoch_Buy_Level = 20;                                  // Stoch Buy 閾値

// Sell用Stoch設定
input STOCH_ENTRY_TYPE Stoch_Sell_Enabled = STOCH_ENTRY_DISABLED; // Stoch Sell エントリー
input STOCH_STRATEGY_TYPE Stoch_Sell_Strategy = STOCH_OVERBOUGHT; // Stoch Sell 戦略
input ENUM_TIMEFRAMES Stoch_Sell_Timeframe = PERIOD_CURRENT;           // Stoch Sell 時間足
input int Stoch_Sell_KPeriod = 5;                                 // Stoch Sell %K期間
input int Stoch_Sell_DPeriod = 3;                                 // Stoch Sell %D期間
input int Stoch_Sell_Slowing = 3;                                 // Stoch Sell スローイング
input int Stoch_Sell_Level = 80;                                  // Stoch Sell 閾値

//==================================================================
//                    CCI設定
//==================================================================
sinput group "== 15. CCI設定 =="

// Buy用CCI設定
input CCI_ENTRY_TYPE CCI_Buy_Enabled = CCI_ENTRY_DISABLED;   // CCI Buy エントリー
input CCI_STRATEGY_TYPE CCI_Buy_Strategy = CCI_OVERSOLD;     // CCI Buy 戦略
input ENUM_TIMEFRAMES CCI_Buy_Timeframe = PERIOD_CURRENT;         // CCI Buy 時間足
input int CCI_Buy_Period = 14;                               // CCI Buy 期間
input int CCI_Buy_Level = -100;                              // CCI Buy 閾値

// Sell用CCI設定
input CCI_ENTRY_TYPE CCI_Sell_Enabled = CCI_ENTRY_DISABLED;  // CCI Sell エントリー
input CCI_STRATEGY_TYPE CCI_Sell_Strategy = CCI_OVERBOUGHT;  // CCI Sell 戦略
input ENUM_TIMEFRAMES CCI_Sell_Timeframe = PERIOD_CURRENT;        // CCI Sell 時間足
input int CCI_Sell_Period = 14;                              // CCI Sell 期間
input int CCI_Sell_Level = 100;                              // CCI Sell 閾値

//==================================================================
//                    ADX設定
//==================================================================
sinput group "== 16. ADX設定 =="

// Buy用ADX設定
input ADX_ENTRY_TYPE ADX_Buy_Enabled = ADX_ENTRY_DISABLED;   // ADX Buy エントリー
input ADX_STRATEGY_TYPE ADX_Buy_Strategy = ADX_PLUS_DI_CROSS_MINUS_DI; // ADX Buy 戦略
input ENUM_TIMEFRAMES ADX_Buy_Timeframe = PERIOD_CURRENT;         // ADX Buy 時間足
input int ADX_Buy_Period = 14;                               // ADX Buy 期間
input int ADX_Buy_Level = 25;                                // ADX Buy 閾値

// Sell用ADX設定
input ADX_ENTRY_TYPE ADX_Sell_Enabled = ADX_ENTRY_DISABLED;  // ADX Sell エントリー
input ADX_STRATEGY_TYPE ADX_Sell_Strategy = ADX_MINUS_DI_CROSS_PLUS_DI; // ADX Sell 戦略
input ENUM_TIMEFRAMES ADX_Sell_Timeframe = PERIOD_CURRENT;        // ADX Sell 時間足
input int ADX_Sell_Period = 14;                              // ADX Sell 期間
input int ADX_Sell_Level = 25;                               // ADX Sell 閾値

//==================================================================
//                    ボラティリティフィルター設定
//==================================================================
sinput group "== 17. ボラティリティフィルター =="
input bool EnableVolatilityFilter = false;    // ボラティリティフィルターを有効化
input ENUM_TIMEFRAMES VolFilter_Timeframe = PERIOD_CURRENT; // ボラティリティ時間足
input int VolFilter_ATRPeriod = 14;           // ATR期間
input double VolFilter_MinATR = 0.0;          // 最小ATR（0=無効）
input double VolFilter_MaxATR = 0.0;          // 最大ATR（0=無効）

//==================================================================
//                    表示設定
//==================================================================
sinput group "== 18. 表示設定 =="
input bool EnablePositionTable = true;        // ポジションテーブル表示を有効化
input bool EnablePriceLabels = true;          // 価格ラベル表示を有効化
input ON_OFF PositionSignDisplay = ON_MODE;   // ポジションサイン表示(ON/OFF)
input ON_OFF AveragePriceLine = ON_MODE;      // 平均取得価格ライン表示(ON/OFF)
input color AveragePriceLineColor = clrPaleTurquoise; // 平均取得価格ライン色
input color TakeProfitLineColor = clrYellow;  // 利確ラインの色
input color StopLossLineColor = clrRed;       // 損切りラインの色

//==================================================================
//                    GUI/レイアウト設定
//==================================================================
sinput group "== 19. GUI/レイアウト設定 =="
input int PanelX = 20;                        // パネルX座標
input int PanelY = 50;                        // パネルY座標
input LAYOUT_PATTERN LayoutPattern = LAYOUT_DEFAULT; // レイアウトパターン
input int CustomPanelX = 20;                  // カスタム: パネルX座標
input int CustomPanelY = 50;                  // カスタム: パネルY座標
input int CustomTableX = 20;                  // カスタム: テーブルX座標
input int CustomTableY = 400;                 // カスタム: テーブルY座標
input string PositionTableTitle = "Position Table"; // テーブルタイトル
input int TableX = 20;                        // テーブルX座標
input int TableY = 400;                       // テーブルY座標
input int UpdateInterval = 1;                 // テーブル更新間隔（秒）

//==================================================================
//                    インジケーターパネル設定
//==================================================================
sinput group "== 20. インジケーターパネル設定 =="
input bool EnableInfoPanel = true;            // インジケーターパネル表示
input int InfoPanelX = 330;                   // インジケーターパネルX座標
input int InfoPanelY = 50;                    // インジケーターパネルY座標

//==================================================================
//                    外部インジケーターエントリー設定
//==================================================================
sinput group "== 21. 外部インジケーター基本設定 =="
input ENUM_INDICATOR_MODE InpIndicatorMode = INDICATOR_ENTRY_ONLY; // インジケーター使用モード
input string InpIndicatorName = "";           // インジケーター名（空=無効）
input ENUM_TIMEFRAMES InpCustomTimeframe = PERIOD_CURRENT; // インジケーターのタイムフレーム
input int InpIndicatorShift = 0;              // インジケーターのシフト
input int InpBuySignalBuffer = 0;             // 買いシグナルバッファ番号
input int InpSellSignalBuffer = 0;            // 売りシグナルバッファ番号

sinput group "== 22. 外部インジケーター決済設定 =="
input int InpBuyExitBuffer = 1;               // 買い決済シグナルバッファ番号
input int InpSellExitBuffer = 1;              // 売り決済シグナルバッファ番号

sinput group "== 23. 外部インジケーターパラメーター =="
input double InpParam1 = 0;                   // インジケーターパラメーター1
input double InpParam2 = 0;                   // インジケーターパラメーター2
input double InpParam3 = 0;                   // インジケーターパラメーター3
input double InpParam4 = 0;                   // インジケーターパラメーター4
input double InpParam5 = 0;                   // インジケーターパラメーター5
input double InpParam6 = 0;                   // インジケーターパラメーター6
input double InpParam7 = 0;                   // インジケーターパラメーター7
input double InpParam8 = 0;                   // インジケーターパラメーター8
input double InpParam9 = 0;                   // インジケーターパラメーター9
input double InpParam10 = 0;                  // インジケーターパラメーター10

sinput group "== 24. エントリーシグナル条件 =="
input bool InpEnableBuySignal = false;        // 買いエントリーシグナルを有効にする
input bool InpEnableSellSignal = false;       // 売りエントリーシグナルを有効にする

sinput group "== 25. 決済シグナル条件 =="
input bool InpEnableBuyExitSignal = false;    // 買いポジション決済シグナルを有効にする
input bool InpEnableSellExitSignal = false;   // 売りポジション決済シグナルを有効にする
input ENUM_OPPOSITE_SIGNAL_EXIT InpOppositeSignalExit = OPPOSITE_EXIT_ON; // 反対シグナルによる決済

sinput group "== 26. エントリー価格条件 =="
input bool InpEnableBuyPrice = false;         // 買いエントリー価格条件を有効にする
input ENUM_APPLIED_PRICE InpBuyPriceType = PRICE_CLOSE; // 買いエントリー価格タイプ
input ENUM_PRICE_CONDITION_TYPE InpBuyPriceCondition = PRICE_CONDITION_NONE; // 買いエントリー価格条件
input bool InpEnableSellPrice = false;        // 売りエントリー価格条件を有効にする
input ENUM_APPLIED_PRICE InpSellPriceType = PRICE_CLOSE; // 売りエントリー価格タイプ
input ENUM_PRICE_CONDITION_TYPE InpSellPriceCondition = PRICE_CONDITION_NONE; // 売りエントリー価格条件

sinput group "== 27. エントリー数値条件 =="
input bool InpEnableBuyValue = false;         // 買いエントリー数値条件を有効にする
input double InpBuyValueThreshold = 70;       // 買いエントリー数値しきい値
input ENUM_VALUE_CONDITION_TYPE InpBuyValueCondition = VALUE_CONDITION_NONE; // 買いエントリー数値条件
input bool InpEnableSellValue = false;        // 売りエントリー数値条件を有効にする
input double InpSellValueThreshold = 30;      // 売りエントリー数値しきい値
input ENUM_VALUE_CONDITION_TYPE InpSellValueCondition = VALUE_CONDITION_NONE; // 売りエントリー数値条件

sinput group "== 28. 決済価格条件 =="
input bool InpEnableBuyExitPrice = false;     // 買いポジション決済価格条件を有効にする
input ENUM_APPLIED_PRICE InpBuyExitPriceType = PRICE_CLOSE; // 買いポジション決済価格タイプ
input ENUM_PRICE_CONDITION_TYPE InpBuyExitPriceCondition = PRICE_CONDITION_NONE; // 買いポジション決済価格条件
input bool InpEnableSellExitPrice = false;    // 売りポジション決済価格条件を有効にする
input ENUM_APPLIED_PRICE InpSellExitPriceType = PRICE_CLOSE; // 売りポジション決済価格タイプ
input ENUM_PRICE_CONDITION_TYPE InpSellExitPriceCondition = PRICE_CONDITION_NONE; // 売りポジション決済価格条件

sinput group "== 29. 決済数値条件 =="
input bool InpEnableBuyExitValue = false;     // 買いポジション決済数値条件を有効にする
input double InpBuyExitValueThreshold = 30;   // 買いポジション決済数値しきい値
input ENUM_VALUE_CONDITION_TYPE InpBuyExitValueCondition = VALUE_CONDITION_NONE; // 買いポジション決済数値条件
input bool InpEnableSellExitValue = false;    // 売りポジション決済数値条件を有効にする
input double InpSellExitValueThreshold = 70;  // 売りポジション決済数値しきい値
input ENUM_VALUE_CONDITION_TYPE InpSellExitValueCondition = VALUE_CONDITION_NONE; // 売りポジション決済数値条件

sinput group "== 30. オブジェクト条件 =="
input bool InpEnableBuySignalObject = false;  // 買いエントリーオブジェクトシグナルを有効にする
input bool InpEnableSellSignalObject = false; // 売りエントリーオブジェクトシグナルを有効にする
input string BuySignalPrefix = "BUY_";        // 買いシグナルオブジェクト名の接頭辞
input string SellSignalPrefix = "SELL_";      // 売りシグナルオブジェクト名の接頭辞
input bool InpEnableBuyExitObject = false;    // 買いポジション決済オブジェクトシグナルを有効にする
input bool InpEnableSellExitObject = false;   // 売りポジション決済オブジェクトシグナルを有効にする
input string BuyExitPrefix = "EXIT_BUY_";     // 買いポジション決済オブジェクト名の接頭辞
input string SellExitPrefix = "EXIT_SELL_";   // 売りポジション決済オブジェクト名の接頭辞

//==================================================================
//                    デバッグ設定
//==================================================================
sinput group "== 31. デバッグ設定 =="
input bool EnableDebugLog = false;            // デバッグログを有効化

#endif // HOSOPI3_TANPOJI_PARAMS_MQH
