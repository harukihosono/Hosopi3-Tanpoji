//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - インジケーターパネル                   |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_INFOPANEL_MQH
#define HOSOPI3_TANPOJI_INFOPANEL_MQH

#include "Hosopi3_Tanpoji_Defines.mqh"
#include "Hosopi3_Tanpoji_Strategy.mqh"

//+------------------------------------------------------------------+
//| InfoPanel定数                                                     |
//+------------------------------------------------------------------+
#define INFO_PANEL_WIDTH       280
#define INFO_PANEL_ROW_HEIGHT  20
#define INFO_PANEL_HEADER      25
#define INFO_PANEL_MARGIN      5

//+------------------------------------------------------------------+
//| InfoPanelクラス                                                   |
//+------------------------------------------------------------------+
class CInfoPanelManager
{
private:
   string m_prefix;
   int m_x;
   int m_y;
   int m_indicatorCount;
   bool m_visible;

public:
   CInfoPanelManager();
   ~CInfoPanelManager();

   void Initialize(string prefix, int x, int y);
   void Create();
   void Update();
   void Delete();
   void SetVisible(bool visible);
   bool IsVisible() { return m_visible; }

private:
   void CreateBackground();
   void CreateHeader();
   void CreateIndicatorRows();
   void UpdateIndicatorRow(int index, TechnicalIndicatorInfo &info);
   color GetSignalColor(ENUM_SIGNAL_STATE signal);
   string GetSignalText(ENUM_SIGNAL_STATE signal);
};

//+------------------------------------------------------------------+
//| コンストラクタ                                                    |
//+------------------------------------------------------------------+
CInfoPanelManager::CInfoPanelManager()
{
   m_prefix = "";
   m_x = 0;
   m_y = 0;
   m_indicatorCount = 9;
   m_visible = true;
}

//+------------------------------------------------------------------+
//| デストラクタ                                                      |
//+------------------------------------------------------------------+
CInfoPanelManager::~CInfoPanelManager()
{
   Delete();
}

//+------------------------------------------------------------------+
//| 初期化                                                            |
//+------------------------------------------------------------------+
void CInfoPanelManager::Initialize(string prefix, int x, int y)
{
   m_prefix = prefix + "InfoPanel_";
   m_x = x;
   m_y = y;
   m_visible = g_InfoPanelVisible;
}

//+------------------------------------------------------------------+
//| パネル作成                                                        |
//+------------------------------------------------------------------+
void CInfoPanelManager::Create()
{
   if(!EnableInfoPanel || !m_visible) return;

   CreateBackground();
   CreateHeader();
   CreateIndicatorRows();

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| 背景作成                                                          |
//+------------------------------------------------------------------+
void CInfoPanelManager::CreateBackground()
{
   string name = m_prefix + "BG";

   int height = INFO_PANEL_HEADER + (m_indicatorCount * INFO_PANEL_ROW_HEIGHT) + INFO_PANEL_MARGIN * 2;

   if(ObjectFind(0, name) >= 0)
      ObjectDelete(0, name);

   ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, INFO_PANEL_WIDTH);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, COLOR_PANEL_BG);
   ObjectSetInteger(0, name, OBJPROP_BORDER_COLOR, COLOR_PANEL_BORDER);
   ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
   ObjectSetInteger(0, name, OBJPROP_BACK, false);
}

//+------------------------------------------------------------------+
//| ヘッダー作成                                                      |
//+------------------------------------------------------------------+
void CInfoPanelManager::CreateHeader()
{
   // ヘッダー背景
   string headerBG = m_prefix + "HeaderBG";
   if(ObjectFind(0, headerBG) >= 0)
      ObjectDelete(0, headerBG);

   ObjectCreate(0, headerBG, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, headerBG, OBJPROP_XDISTANCE, m_x);
   ObjectSetInteger(0, headerBG, OBJPROP_YDISTANCE, m_y);
   ObjectSetInteger(0, headerBG, OBJPROP_XSIZE, INFO_PANEL_WIDTH);
   ObjectSetInteger(0, headerBG, OBJPROP_YSIZE, INFO_PANEL_HEADER);
   ObjectSetInteger(0, headerBG, OBJPROP_BGCOLOR, COLOR_TITLE_BG);
   ObjectSetInteger(0, headerBG, OBJPROP_BORDER_COLOR, COLOR_PANEL_BORDER);
   ObjectSetInteger(0, headerBG, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, headerBG, OBJPROP_SELECTABLE, false);

   // タイトル
   string titleLabel = m_prefix + "Title";
   if(ObjectFind(0, titleLabel) >= 0)
      ObjectDelete(0, titleLabel);

   ObjectCreate(0, titleLabel, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, titleLabel, OBJPROP_XDISTANCE, m_x + INFO_PANEL_MARGIN);
   ObjectSetInteger(0, titleLabel, OBJPROP_YDISTANCE, m_y + 6);
   ObjectSetString(0, titleLabel, OBJPROP_TEXT, "Indicators");
   ObjectSetInteger(0, titleLabel, OBJPROP_COLOR, COLOR_TITLE_TEXT);
   ObjectSetInteger(0, titleLabel, OBJPROP_FONTSIZE, 9);
   ObjectSetString(0, titleLabel, OBJPROP_FONT, "Arial Bold");
   ObjectSetInteger(0, titleLabel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, titleLabel, OBJPROP_SELECTABLE, false);

   // 閉じるボタン
   string closeBtn = m_prefix + "CloseBtn";
   if(ObjectFind(0, closeBtn) >= 0)
      ObjectDelete(0, closeBtn);

   ObjectCreate(0, closeBtn, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, closeBtn, OBJPROP_XDISTANCE, m_x + INFO_PANEL_WIDTH - 25);
   ObjectSetInteger(0, closeBtn, OBJPROP_YDISTANCE, m_y + 2);
   ObjectSetInteger(0, closeBtn, OBJPROP_XSIZE, 22);
   ObjectSetInteger(0, closeBtn, OBJPROP_YSIZE, 20);
   ObjectSetString(0, closeBtn, OBJPROP_TEXT, "X");
   ObjectSetInteger(0, closeBtn, OBJPROP_COLOR, COLOR_TEXT_WHITE);
   ObjectSetInteger(0, closeBtn, OBJPROP_BGCOLOR, COLOR_BUTTON_INACTIVE);
   ObjectSetInteger(0, closeBtn, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, closeBtn, OBJPROP_FONTSIZE, 8);
   ObjectSetInteger(0, closeBtn, OBJPROP_SELECTABLE, false);

   // ヘッダーラベル（Indicator, ON/OFF, BUY, SELL）
   int labelY = m_y + INFO_PANEL_HEADER + 2;

   string hdrName = m_prefix + "HdrName";
   if(ObjectFind(0, hdrName) >= 0) ObjectDelete(0, hdrName);
   ObjectCreate(0, hdrName, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, hdrName, OBJPROP_XDISTANCE, m_x + 5);
   ObjectSetInteger(0, hdrName, OBJPROP_YDISTANCE, labelY);
   ObjectSetString(0, hdrName, OBJPROP_TEXT, "Name");
   ObjectSetInteger(0, hdrName, OBJPROP_COLOR, COLOR_TEXT_DARK);
   ObjectSetInteger(0, hdrName, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, hdrName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, hdrName, OBJPROP_SELECTABLE, false);

   string hdrStatus = m_prefix + "HdrStatus";
   if(ObjectFind(0, hdrStatus) >= 0) ObjectDelete(0, hdrStatus);
   ObjectCreate(0, hdrStatus, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, hdrStatus, OBJPROP_XDISTANCE, m_x + 90);
   ObjectSetInteger(0, hdrStatus, OBJPROP_YDISTANCE, labelY);
   ObjectSetString(0, hdrStatus, OBJPROP_TEXT, "Status");
   ObjectSetInteger(0, hdrStatus, OBJPROP_COLOR, COLOR_TEXT_DARK);
   ObjectSetInteger(0, hdrStatus, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, hdrStatus, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, hdrStatus, OBJPROP_SELECTABLE, false);

   string hdrBuy = m_prefix + "HdrBuy";
   if(ObjectFind(0, hdrBuy) >= 0) ObjectDelete(0, hdrBuy);
   ObjectCreate(0, hdrBuy, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, hdrBuy, OBJPROP_XDISTANCE, m_x + 160);
   ObjectSetInteger(0, hdrBuy, OBJPROP_YDISTANCE, labelY);
   ObjectSetString(0, hdrBuy, OBJPROP_TEXT, "BUY");
   ObjectSetInteger(0, hdrBuy, OBJPROP_COLOR, COLOR_BUTTON_BUY);
   ObjectSetInteger(0, hdrBuy, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, hdrBuy, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, hdrBuy, OBJPROP_SELECTABLE, false);

   string hdrSell = m_prefix + "HdrSell";
   if(ObjectFind(0, hdrSell) >= 0) ObjectDelete(0, hdrSell);
   ObjectCreate(0, hdrSell, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, hdrSell, OBJPROP_XDISTANCE, m_x + 220);
   ObjectSetInteger(0, hdrSell, OBJPROP_YDISTANCE, labelY);
   ObjectSetString(0, hdrSell, OBJPROP_TEXT, "SELL");
   ObjectSetInteger(0, hdrSell, OBJPROP_COLOR, COLOR_BUTTON_SELL);
   ObjectSetInteger(0, hdrSell, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, hdrSell, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, hdrSell, OBJPROP_SELECTABLE, false);
}

//+------------------------------------------------------------------+
//| インジケーター行作成                                              |
//+------------------------------------------------------------------+
void CInfoPanelManager::CreateIndicatorRows()
{
   for(int i = 0; i < m_indicatorCount; i++)
   {
      TechnicalIndicatorInfo info;
      GetIndicatorInfo(i, info);

      int rowY = m_y + INFO_PANEL_HEADER + 18 + (i * INFO_PANEL_ROW_HEIGHT);

      // 行背景
      string rowBG = m_prefix + "RowBG" + IntegerToString(i);
      if(ObjectFind(0, rowBG) >= 0) ObjectDelete(0, rowBG);
      ObjectCreate(0, rowBG, OBJ_RECTANGLE_LABEL, 0, 0, 0);
      ObjectSetInteger(0, rowBG, OBJPROP_XDISTANCE, m_x + 2);
      ObjectSetInteger(0, rowBG, OBJPROP_YDISTANCE, rowY);
      ObjectSetInteger(0, rowBG, OBJPROP_XSIZE, INFO_PANEL_WIDTH - 4);
      ObjectSetInteger(0, rowBG, OBJPROP_YSIZE, INFO_PANEL_ROW_HEIGHT - 2);
      ObjectSetInteger(0, rowBG, OBJPROP_BGCOLOR, (i % 2 == 0) ? COLOR_PANEL_BG : COLOR_TITLE_BG);
      ObjectSetInteger(0, rowBG, OBJPROP_BORDER_TYPE, BORDER_FLAT);
      ObjectSetInteger(0, rowBG, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, rowBG, OBJPROP_SELECTABLE, false);

      // インジケーター名（外部インジケーターの場合は実際の名前を表示）
      string displayName = info.name;
      if(i == 6 && IsCustomIndicatorEnabled())
      {
         displayName = GetCustomIndicatorName();
         // 長い名前は切り詰め
         if(StringLen(displayName) > 10)
            displayName = StringSubstr(displayName, 0, 8) + "..";
      }

      string nameLabel = m_prefix + "Name" + IntegerToString(i);
      if(ObjectFind(0, nameLabel) >= 0) ObjectDelete(0, nameLabel);
      ObjectCreate(0, nameLabel, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, nameLabel, OBJPROP_XDISTANCE, m_x + 5);
      ObjectSetInteger(0, nameLabel, OBJPROP_YDISTANCE, rowY + 3);
      ObjectSetString(0, nameLabel, OBJPROP_TEXT, displayName);
      ObjectSetInteger(0, nameLabel, OBJPROP_COLOR, COLOR_TEXT_LIGHT);
      ObjectSetInteger(0, nameLabel, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, nameLabel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, nameLabel, OBJPROP_SELECTABLE, false);

      // ON/OFF状態
      string statusLabel = m_prefix + "Status" + IntegerToString(i);
      if(ObjectFind(0, statusLabel) >= 0) ObjectDelete(0, statusLabel);
      ObjectCreate(0, statusLabel, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, statusLabel, OBJPROP_XDISTANCE, m_x + 90);
      ObjectSetInteger(0, statusLabel, OBJPROP_YDISTANCE, rowY + 3);
      ObjectSetString(0, statusLabel, OBJPROP_TEXT, info.enabled ? "ON" : "OFF");
      ObjectSetInteger(0, statusLabel, OBJPROP_COLOR, info.enabled ? clrLime : clrGray);
      ObjectSetInteger(0, statusLabel, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, statusLabel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, statusLabel, OBJPROP_SELECTABLE, false);

      // BUYシグナル
      string buyLabel = m_prefix + "Buy" + IntegerToString(i);
      if(ObjectFind(0, buyLabel) >= 0) ObjectDelete(0, buyLabel);
      ObjectCreate(0, buyLabel, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, buyLabel, OBJPROP_XDISTANCE, m_x + 160);
      ObjectSetInteger(0, buyLabel, OBJPROP_YDISTANCE, rowY + 3);
      ObjectSetString(0, buyLabel, OBJPROP_TEXT, GetSignalText(info.buySignal));
      ObjectSetInteger(0, buyLabel, OBJPROP_COLOR, GetSignalColor(info.buySignal));
      ObjectSetInteger(0, buyLabel, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, buyLabel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, buyLabel, OBJPROP_SELECTABLE, false);

      // SELLシグナル
      string sellLabel = m_prefix + "Sell" + IntegerToString(i);
      if(ObjectFind(0, sellLabel) >= 0) ObjectDelete(0, sellLabel);
      ObjectCreate(0, sellLabel, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, sellLabel, OBJPROP_XDISTANCE, m_x + 220);
      ObjectSetInteger(0, sellLabel, OBJPROP_YDISTANCE, rowY + 3);
      ObjectSetString(0, sellLabel, OBJPROP_TEXT, GetSignalText(info.sellSignal));
      ObjectSetInteger(0, sellLabel, OBJPROP_COLOR, GetSignalColor(info.sellSignal));
      ObjectSetInteger(0, sellLabel, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, sellLabel, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, sellLabel, OBJPROP_SELECTABLE, false);
   }
}

//+------------------------------------------------------------------+
//| インジケーター行更新（キャッシュ使用版）                           |
//+------------------------------------------------------------------+
void CInfoPanelManager::UpdateIndicatorRow(int index, TechnicalIndicatorInfo &info)
{
   // ON/OFF状態更新（キャッシュ使用）
   string statusLabel = m_prefix + "Status" + IntegerToString(index);
   if(ObjectFind(0, statusLabel) >= 0)
   {
      CachedSetText(statusLabel, info.enabled ? "ON" : "OFF");
      CachedSetColor(statusLabel, info.enabled ? clrLime : clrGray);
   }

   // BUYシグナル更新（キャッシュ使用）
   string buyLabel = m_prefix + "Buy" + IntegerToString(index);
   if(ObjectFind(0, buyLabel) >= 0)
   {
      CachedSetText(buyLabel, GetSignalText(info.buySignal));
      CachedSetColor(buyLabel, GetSignalColor(info.buySignal));
   }

   // SELLシグナル更新（キャッシュ使用）
   string sellLabel = m_prefix + "Sell" + IntegerToString(index);
   if(ObjectFind(0, sellLabel) >= 0)
   {
      CachedSetText(sellLabel, GetSignalText(info.sellSignal));
      CachedSetColor(sellLabel, GetSignalColor(info.sellSignal));
   }
}

//+------------------------------------------------------------------+
//| パネル更新                                                        |
//+------------------------------------------------------------------+
void CInfoPanelManager::Update()
{
   if(!EnableInfoPanel || !m_visible) return;

   // シグナル更新
   UpdateAllSignals();

   // 各行の更新
   for(int i = 0; i < m_indicatorCount; i++)
   {
      TechnicalIndicatorInfo info;
      GetIndicatorInfo(i, info);
      UpdateIndicatorRow(i, info);
   }

   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| パネル削除                                                        |
//+------------------------------------------------------------------+
void CInfoPanelManager::Delete()
{
   int total = ObjectsTotal(0);
   for(int i = total - 1; i >= 0; i--)
   {
      string name = ObjectName(0, i);
      if(StringFind(name, m_prefix) == 0)
      {
         ObjectDelete(0, name);
      }
   }
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| 表示/非表示設定                                                   |
//+------------------------------------------------------------------+
void CInfoPanelManager::SetVisible(bool visible)
{
   m_visible = visible;
   g_InfoPanelVisible = visible;

   if(visible)
   {
      Create();
   }
   else
   {
      Delete();
   }
}

//+------------------------------------------------------------------+
//| シグナル色取得                                                    |
//+------------------------------------------------------------------+
color CInfoPanelManager::GetSignalColor(ENUM_SIGNAL_STATE signal)
{
   switch(signal)
   {
      case SIGNAL_BUY:  return COLOR_BUTTON_BUY;
      case SIGNAL_SELL: return COLOR_BUTTON_SELL;
      default:          return clrGray;
   }
}

//+------------------------------------------------------------------+
//| シグナルテキスト取得                                              |
//+------------------------------------------------------------------+
string CInfoPanelManager::GetSignalText(ENUM_SIGNAL_STATE signal)
{
   switch(signal)
   {
      case SIGNAL_BUY:  return "YES";
      case SIGNAL_SELL: return "YES";
      default:          return "-";
   }
}

//+------------------------------------------------------------------+
//| グローバルInfoPanelマネージャー                                   |
//+------------------------------------------------------------------+
CInfoPanelManager g_InfoPanelManager;

//+------------------------------------------------------------------+
//| InfoPanel初期化                                                   |
//+------------------------------------------------------------------+
void InitializeInfoPanel()
{
   g_InfoPanelManager.Initialize(g_ObjectPrefix, InfoPanelX, InfoPanelY);
   if(EnableInfoPanel && g_InfoPanelVisible)
   {
      g_InfoPanelManager.Create();
   }
}

//+------------------------------------------------------------------+
//| InfoPanel更新                                                     |
//+------------------------------------------------------------------+
void UpdateInfoPanel()
{
   g_InfoPanelManager.Update();
}

//+------------------------------------------------------------------+
//| InfoPanel削除                                                     |
//+------------------------------------------------------------------+
void DeleteInfoPanel()
{
   g_InfoPanelManager.Delete();
}

//+------------------------------------------------------------------+
//| InfoPanel表示トグル                                               |
//+------------------------------------------------------------------+
void ToggleInfoPanel()
{
   g_InfoPanelManager.SetVisible(!g_InfoPanelManager.IsVisible());
}

//+------------------------------------------------------------------+
//| InfoPanelボタンクリック処理                                       |
//+------------------------------------------------------------------+
bool ProcessInfoPanelClick(string sparam)
{
   // 閉じるボタンクリック
   if(StringFind(sparam, "InfoPanel_CloseBtn") >= 0)
   {
      ToggleInfoPanel();
      return true;
   }
   return false;
}

#endif // HOSOPI3_TANPOJI_INFOPANEL_MQH
