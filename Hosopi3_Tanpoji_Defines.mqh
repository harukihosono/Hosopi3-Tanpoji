//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - 定義・列挙型・グローバル変数         |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_DEFINES_MQH
#define HOSOPI3_TANPOJI_DEFINES_MQH

//==================================================================
//                    MQL5/MQL4互換定義
//==================================================================
#ifdef __MQL5__
   #define OP_BUY  0
   #define OP_SELL 1
   #define MODE_TRADES 0
   #define SELECT_BY_POS 0
   #define MODE_BID SYMBOL_BID
   #define MODE_ASK SYMBOL_ASK
   #define MODE_LOTSTEP SYMBOL_VOLUME_STEP
   #define MODE_MINLOT SYMBOL_VOLUME_MIN
   #define MODE_MAXLOT SYMBOL_VOLUME_MAX
#endif

//==================================================================
//                        列挙型定義
//==================================================================

// OnOff列挙型
enum ON_OFF {
    OFF_MODE = 0,     // OFF
    ON_MODE = 1       // ON
};

// エントリー方向制御
enum ENTRY_MODE {
    MODE_BUY_ONLY = 0,       // BUYのみ
    MODE_SELL_ONLY = 1,      // SELLのみ
    MODE_BOTH = 2            // BUY & SELL両方
};

// 時間取得方法の列挙型
enum USE_TIMES {
    GMT9,              // WindowsPCの時間を使って計算する
    GMT9_BACKTEST,     // EAで計算された時間を使う（バックテスト用）
    GMT_KOTEI          // サーバータイムがGMT+0で固定されている（バックテスト用）
};

// MA戦略タイプ
enum MA_ENTRY_TYPE {
    MA_ENTRY_DISABLED = 0,   // 無効
    MA_ENTRY_ENABLED = 1     // 有効
};

enum MA_STRATEGY_TYPE {
    MA_GOLDEN_CROSS = 0,     // ゴールデンクロス
    MA_DEAD_CROSS = 1,       // デッドクロス
    MA_PRICE_ABOVE = 2,      // 価格がMA上
    MA_PRICE_BELOW = 3       // 価格がMA下
};

// RSI戦略タイプ
enum RSI_ENTRY_TYPE {
    RSI_ENTRY_DISABLED = 0,  // 無効
    RSI_ENTRY_ENABLED = 1    // 有効
};

enum RSI_STRATEGY_TYPE {
    RSI_OVERSOLD = 0,        // 売られすぎ
    RSI_OVERBOUGHT = 1,      // 買われすぎ
    RSI_CROSS_UP = 2,        // 上抜け
    RSI_CROSS_DOWN = 3       // 下抜け
};

// ボリンジャーバンド戦略タイプ
enum BB_ENTRY_TYPE {
    BB_ENTRY_DISABLED = 0,   // 無効
    BB_ENTRY_ENABLED = 1     // 有効
};

enum BB_STRATEGY_TYPE {
    BB_TOUCH_UPPER = 0,      // 上限タッチ
    BB_TOUCH_LOWER = 1,      // 下限タッチ
    BB_BREAK_UPPER = 2,      // 上限ブレイク
    BB_BREAK_LOWER = 3       // 下限ブレイク
};

// ストキャスティクス戦略タイプ
enum STOCH_ENTRY_TYPE {
    STOCH_ENTRY_DISABLED = 0,  // 無効
    STOCH_ENTRY_ENABLED = 1    // 有効
};

enum STOCH_STRATEGY_TYPE {
    STOCH_OVERSOLD = 0,        // 売られすぎ
    STOCH_OVERBOUGHT = 1,      // 買われすぎ
    STOCH_CROSS_UP = 2,        // ゴールデンクロス
    STOCH_CROSS_DOWN = 3       // デッドクロス
};

// CCI戦略タイプ
enum CCI_ENTRY_TYPE {
    CCI_ENTRY_DISABLED = 0,  // 無効
    CCI_ENTRY_ENABLED = 1    // 有効
};

enum CCI_STRATEGY_TYPE {
    CCI_OVERSOLD = 0,        // 売られすぎ
    CCI_OVERBOUGHT = 1,      // 買われすぎ
    CCI_CROSS_UP = 2,        // 上抜け
    CCI_CROSS_DOWN = 3       // 下抜け
};

// ADX戦略タイプ
enum ADX_ENTRY_TYPE {
    ADX_ENTRY_DISABLED = 0,  // 無効
    ADX_ENTRY_ENABLED = 1    // 有効
};

enum ADX_STRATEGY_TYPE {
    ADX_PLUS_DI_CROSS_MINUS_DI = 0,  // +DI > -DI
    ADX_MINUS_DI_CROSS_PLUS_DI = 1,  // -DI > +DI
    ADX_STRONG_TREND = 2             // 強いトレンド
};

// 条件タイプ
enum CONDITION_TYPE {
    AND_CONDITION = 0,       // AND（すべて満たす）
    OR_CONDITION = 1         // OR（いずれか満たす）
};

// レイアウトパターン
enum LAYOUT_PATTERN {
    LAYOUT_DEFAULT = 0,      // デフォルト (パネル上/テーブル下)
    LAYOUT_SIDE_BY_SIDE = 1, // 横並び (パネル左/テーブル右)
    LAYOUT_TABLE_TOP = 2,    // テーブル優先 (テーブル上/パネル下)
    LAYOUT_COMPACT = 3,      // コンパクト (小さいパネル)
    LAYOUT_CUSTOM = 4        // カスタム (位置を個別指定)
};

// シグナル状態
enum ENUM_SIGNAL_STATE {
   SIGNAL_NONE = 0,    // シグナルなし（グレー）
   SIGNAL_BUY = 1,     // BUYシグナル（青）
   SIGNAL_SELL = 2     // SELLシグナル（赤）
};

//==================================================================
//          外部インジケーターエントリー用列挙型
//==================================================================

// インジケーター使用モード
enum ENUM_INDICATOR_MODE
{
   INDICATOR_ENTRY_ONLY = 0,      // エントリーのみ
   INDICATOR_EXIT_ONLY = 1,       // 決済のみ
   INDICATOR_ENTRY_AND_EXIT = 2   // エントリー＆決済
};

// 価格条件タイプ
enum ENUM_PRICE_CONDITION_TYPE
{
   PRICE_CONDITION_NONE = 0,               // -
   PRICE_CONDITION_CROSS = 1,              // 交差（方向問わず）
   PRICE_CONDITION_UP_CROSS = 2,           // 価格上抜け
   PRICE_CONDITION_DOWN_CROSS = 3,         // 価格下抜け
   PRICE_CONDITION_BELOW = 4,              // 価格下位
   PRICE_CONDITION_ABOVE = 5               // 価格上位
};

// 数値条件タイプ
enum ENUM_VALUE_CONDITION_TYPE
{
   VALUE_CONDITION_NONE = 0,               // -
   VALUE_CONDITION_CROSS = 1,              // 交差（方向問わず）
   VALUE_CONDITION_UP_CROSS = 2,           // 値上抜け
   VALUE_CONDITION_DOWN_CROSS = 3,         // 値下抜け
   VALUE_CONDITION_BELOW = 4,              // 値下位
   VALUE_CONDITION_ABOVE = 5               // 値上位
};

// 反対シグナル決済
enum ENUM_OPPOSITE_SIGNAL_EXIT
{
   OPPOSITE_EXIT_OFF = 0,     // 無効
   OPPOSITE_EXIT_ON = 1       // 有効
};

//==================================================================
//                    タンポジ固定設定（パラメータ削除分）
//==================================================================
#define EnableAutomaticTrading true   // 自動売買は常に有効（GUIで制御）
#define FirstEntryOnly         true   // 単ポジなので常に初回エントリーのみ

//==================================================================
//                        GUI関連定数
//==================================================================
#define PANEL_WIDTH            300      // パネル幅
#define PANEL_HEIGHT           250      // パネル高さ
#define TITLE_HEIGHT           30       // タイトルの高さ
#define BUTTON_WIDTH           120      // ボタン幅
#define BUTTON_HEIGHT          30       // ボタン高さ
#define PANEL_MARGIN           10       // パネル内部マージン
#define PANEL_BORDER_WIDTH     2        // パネル枠線幅
#define STATUS_HEIGHT          20       // ステータス表示の高さ

//==================================================================
//                    ダークモード配色パレット
//==================================================================
#define COLOR_PANEL_BG         C'32,34,37'    // ダークグレー背景色
#define COLOR_PANEL_BORDER     C'60,63,65'    // ミディアムグレー枠線色
#define COLOR_TITLE_BG         C'42,45,48'    // ダークなタイトル背景色
#define COLOR_TITLE_TEXT       C'220,221,222' // 明るいテキスト色
#define COLOR_BUTTON_BUY       C'52,168,83'   // 優しいグリーン（BUYボタン）
#define COLOR_BUTTON_SELL      C'234,67,53'   // 優しいレッド（SELLボタン）
#define COLOR_BUTTON_ACTIVE    C'66,165,245'  // 明るいブルー（アクティブ）
#define COLOR_BUTTON_INACTIVE  C'95,99,104'   // グレー（非アクティブ）
#define COLOR_BUTTON_NEUTRAL   C'138,142,147' // ライトグレー（中立）
#define COLOR_BUTTON_CLOSE_ALL C'251,188,5'   // 優しいオレンジ（全決済ボタン）
#define COLOR_TEXT_LIGHT       C'232,234,237' // 明るいテキスト色
#define COLOR_TEXT_DARK        C'154,160,166' // 中間テキスト色
#define COLOR_TEXT_WHITE       C'255,255,255' // 純白テキスト
#define COLOR_ENTRY_DIRECT     C'66,165,245'  // 直接エントリー（明るいブルー）

//==================================================================
//                    テクニカル指標情報構造体
//==================================================================
struct TechnicalIndicatorInfo
{
   string name;              // 指標名
   bool enabled;             // ON/OFF状態
   ENUM_SIGNAL_STATE buySignal;   // BUYシグナル状態
   ENUM_SIGNAL_STATE sellSignal;  // SELLシグナル状態
};

//==================================================================
//                    グローバル変数宣言
//==================================================================

// 制御フラグ
bool g_AutoTrading = true;           // 自動売買フラグ
bool g_AvgPriceVisible = true;       // 平均取得単価表示制御用フラグ
bool g_PanelMinimized = false;       // パネル最小化状態フラグ
bool g_InfoPanelVisible = true;      // InfoPanel表示フラグ

// 決済関連
datetime g_BuyClosedTime = 0;        // Buy側の決済時間
datetime g_SellClosedTime = 0;       // Sell側の決済時間

// オブジェクト関連
string g_ObjectPrefix = "";          // オブジェクト名プレフィックス
string g_LineNames[20];              // ライン関連のオブジェクト名を保存する配列
int g_LineObjectCount = 0;
string g_PanelNames[100];            // パネル関連のオブジェクト名を保存する配列
int g_PanelObjectCount = 0;

// 複数チャート対応
long g_AccountNumber = 0;            // 口座番号

// パネル・テーブル位置
int g_EffectivePanelX = 0;
int g_EffectivePanelY = 0;
int g_EffectiveTableX = 0;
int g_EffectiveTableY = 0;

// 更新時間
datetime g_LastUpdateTime = 0;

// MQL5用フィリングモード
#ifdef __MQL5__
ENUM_ORDER_TYPE_FILLING g_FillingMode = ORDER_FILLING_FOK;
#endif

#endif // HOSOPI3_TANPOJI_DEFINES_MQH
