//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - 外部インジケーターエントリー         |
//|                         Copyright 2025                           |
//|                    ナンピン・ゴースト機能なし版                    |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_CUSTOM_INDICATOR_MQH
#define HOSOPI3_TANPOJI_CUSTOM_INDICATOR_MQH

//==================================================================
// 外部インジケーターエントリークラス（MQL4/MQL5共通）
//==================================================================

class CustomIndicatorManager
{
private:
#ifdef __MQL5__
   // インジケーターハンドル（MQL5）
   int m_indicatorHandle;
#endif

   // インジケーターパラメーター配列
   double m_params[10];

   // 前回の条件状態（交差判定用）
   bool m_prevBuyCondition;
   bool m_prevSellCondition;
   bool m_prevBuyExitCondition;
   bool m_prevSellExitCondition;

public:
   // コンストラクタ
   CustomIndicatorManager()
   {
#ifdef __MQL5__
      m_indicatorHandle = INVALID_HANDLE;
#endif
      m_prevBuyCondition = false;
      m_prevSellCondition = false;
      m_prevBuyExitCondition = false;
      m_prevSellExitCondition = false;

      // パラメーター配列を初期化
      m_params[0] = InpParam1;   m_params[1] = InpParam2;
      m_params[2] = InpParam3;   m_params[3] = InpParam4;
      m_params[4] = InpParam5;   m_params[5] = InpParam6;
      m_params[6] = InpParam7;   m_params[7] = InpParam8;
      m_params[8] = InpParam9;   m_params[9] = InpParam10;
   }

   // デストラクタ
   ~CustomIndicatorManager()
   {
#ifdef __MQL5__
      if(m_indicatorHandle != INVALID_HANDLE)
      {
         IndicatorRelease(m_indicatorHandle);
      }
#endif
   }

   // 有効かどうかをチェック
   bool IsEnabled()
   {
      return StringLen(InpIndicatorName) > 0;
   }

   // 初期化
   bool Initialize()
   {
      // インジケーター名が空の場合は初期化しない
      if(!IsEnabled())
         return true;

      // 有効な条件が一つもない場合は初期化しない
      if(!HasAnyEnabledCondition())
         return true;

#ifdef __MQL5__
      // MQL5: カスタムインジケーターのハンドルを取得
      m_indicatorHandle = iCustom(_Symbol, InpCustomTimeframe, InpIndicatorName,
                                  m_params[0], m_params[1], m_params[2], m_params[3], m_params[4],
                                  m_params[5], m_params[6], m_params[7], m_params[8], m_params[9]);

      if(m_indicatorHandle == INVALID_HANDLE)
      {
         Print("インジケーターハンドルの取得に失敗: ", InpIndicatorName);
         return false;
      }
#else
      // MQL4: インジケーターの存在確認のためテスト呼び出し
      ResetLastError();
      double testValue = iCustom(_Symbol, (int)InpCustomTimeframe, InpIndicatorName,
                                 m_params[0], m_params[1], m_params[2], m_params[3], m_params[4],
                                 m_params[5], m_params[6], m_params[7], m_params[8], m_params[9],
                                 0, 0);

      if(GetLastError() != 0)
      {
         Print("インジケーターの読み込みに失敗: ", InpIndicatorName);
         return false;
      }
#endif

      string modeText = "";
      if(InpIndicatorMode == INDICATOR_ENTRY_ONLY)
         modeText = "エントリーのみ";
      else if(InpIndicatorMode == INDICATOR_EXIT_ONLY)
         modeText = "決済のみ";
      else
         modeText = "エントリー＆決済";

      Print("外部インジケーターマネージャーを初期化しました: ", InpIndicatorName, " (", modeText, ")");
      return true;
   }

   // 決済条件をチェック
   void CheckExitConditions()
   {
      // 有効でない場合は処理しない
      if(!IsEnabled())
         return;

      // 有効な条件がない場合は処理しない
      if(!HasAnyEnabledCondition())
         return;

#ifdef __MQL5__
      if(m_indicatorHandle == INVALID_HANDLE)
         return;
#endif

      // 決済処理のみを実行（エントリーは戦略システム経由で実行される）
      if(InpIndicatorMode == INDICATOR_EXIT_ONLY || InpIndicatorMode == INDICATOR_ENTRY_AND_EXIT)
      {
         ProcessExitConditions();
      }
   }

   // 買いエントリーシグナル判定
   bool ShouldBuy()
   {
      if(!IsEnabled())
         return false;

      bool buySignal = false;

      // シグナル条件チェック
      if(InpEnableBuySignal)
      {
         bool signalResult = CheckSignalCondition(InpBuySignalBuffer, true);
         if(signalResult)
         {
            DebugLog("外部インジケーター: 買いシグナル検出 from buffer " + IntegerToString(InpBuySignalBuffer));
         }
         buySignal |= signalResult;
      }

      // 価格条件チェック
      if(InpEnableBuyPrice)
      {
         buySignal |= CheckPriceCondition(InpBuySignalBuffer, InpBuyPriceType, InpBuyPriceCondition);
      }

      // 数値条件チェック
      if(InpEnableBuyValue)
      {
         buySignal |= CheckValueCondition(InpBuySignalBuffer, InpBuyValueThreshold, InpBuyValueCondition);
      }

      // オブジェクト条件チェック
      if(InpEnableBuySignalObject)
      {
         buySignal |= CheckObjectSignal(BuySignalPrefix);
      }

      return buySignal;
   }

   // 売りエントリーシグナル判定
   bool ShouldSell()
   {
      if(!IsEnabled())
         return false;

      bool sellSignal = false;

      // シグナル条件チェック
      if(InpEnableSellSignal)
      {
         bool signalResult = CheckSignalCondition(InpSellSignalBuffer, false);
         if(signalResult)
         {
            DebugLog("外部インジケーター: 売りシグナル検出 from buffer " + IntegerToString(InpSellSignalBuffer));
         }
         sellSignal |= signalResult;
      }

      // 価格条件チェック
      if(InpEnableSellPrice)
      {
         sellSignal |= CheckPriceCondition(InpSellSignalBuffer, InpSellPriceType, InpSellPriceCondition);
      }

      // 数値条件チェック
      if(InpEnableSellValue)
      {
         sellSignal |= CheckValueCondition(InpSellSignalBuffer, InpSellValueThreshold, InpSellValueCondition);
      }

      // オブジェクト条件チェック
      if(InpEnableSellSignalObject)
      {
         sellSignal |= CheckObjectSignal(SellSignalPrefix);
      }

      return sellSignal;
   }

   // インジケーター名を取得
   string GetIndicatorName()
   {
      if(StringLen(InpIndicatorName) == 0)
         return "Custom";

      return InpIndicatorName;
   }

private:
   // 決済条件をチェック
   void ProcessExitConditions()
   {
      // 買いポジションの決済条件をチェック
      bool currentBuyExitCondition = ShouldExitBuy();
      if(currentBuyExitCondition)
      {
         if(position_count(OP_BUY) > 0)
         {
            // 交差条件の場合は前回false→今回trueの時のみ決済
            if(NeedsCrossCheckForExit(true))
            {
               if(!m_prevBuyExitCondition && currentBuyExitCondition)
               {
                  CloseAllPositions(OP_BUY);
                  Print("外部インジケーターシグナルによる買いポジション決済実行");
               }
            }
            else
            {
               // 非交差条件の場合は条件を満たしたら決済
               CloseAllPositions(OP_BUY);
               Print("外部インジケーターシグナルによる買いポジション決済実行");
            }
         }
      }
      m_prevBuyExitCondition = currentBuyExitCondition;

      // 売りポジションの決済条件をチェック
      bool currentSellExitCondition = ShouldExitSell();
      if(currentSellExitCondition)
      {
         if(position_count(OP_SELL) > 0)
         {
            // 交差条件の場合は前回false→今回trueの時のみ決済
            if(NeedsCrossCheckForExit(false))
            {
               if(!m_prevSellExitCondition && currentSellExitCondition)
               {
                  CloseAllPositions(OP_SELL);
                  Print("外部インジケーターシグナルによる売りポジション決済実行");
               }
            }
            else
            {
               // 非交差条件の場合は条件を満たしたら決済
               CloseAllPositions(OP_SELL);
               Print("外部インジケーターシグナルによる売りポジション決済実行");
            }
         }
      }
      m_prevSellExitCondition = currentSellExitCondition;

      // 反対シグナルによる決済（有効な場合のみ）
      if(InpOppositeSignalExit == OPPOSITE_EXIT_ON)
      {
         if(ShouldBuy() && position_count(OP_SELL) > 0)
         {
            CloseAllPositions(OP_SELL);
            Print("[OPPOSITE EXIT] 買いシグナルによる売りポジション決済実行");
         }

         if(ShouldSell() && position_count(OP_BUY) > 0)
         {
            CloseAllPositions(OP_BUY);
            Print("[OPPOSITE EXIT] 売りシグナルによる買いポジション決済実行");
         }
      }
   }

   // 買いポジション決済シグナル判定
   bool ShouldExitBuy()
   {
      bool exitSignal = false;

      // 決済シグナル条件チェック
      if(InpEnableBuyExitSignal)
      {
         bool signalResult = CheckSignalCondition(InpBuyExitBuffer, false);
         exitSignal |= signalResult;
      }

      // 価格条件チェック
      if(InpEnableBuyExitPrice)
      {
         exitSignal |= CheckPriceCondition(InpBuyExitBuffer, InpBuyExitPriceType, InpBuyExitPriceCondition);
      }

      // 数値条件チェック
      if(InpEnableBuyExitValue)
      {
         exitSignal |= CheckValueCondition(InpBuyExitBuffer, InpBuyExitValueThreshold, InpBuyExitValueCondition);
      }

      // オブジェクト条件チェック
      if(InpEnableBuyExitObject)
      {
         exitSignal |= CheckObjectSignal(BuyExitPrefix);
      }

      return exitSignal;
   }

   // 売りポジション決済シグナル判定
   bool ShouldExitSell()
   {
      bool exitSignal = false;

      // 決済シグナル条件チェック
      if(InpEnableSellExitSignal)
      {
         bool signalResult = CheckSignalCondition(InpSellExitBuffer, true);
         exitSignal |= signalResult;
      }

      // 価格条件チェック
      if(InpEnableSellExitPrice)
      {
         exitSignal |= CheckPriceCondition(InpSellExitBuffer, InpSellExitPriceType, InpSellExitPriceCondition);
      }

      // 数値条件チェック
      if(InpEnableSellExitValue)
      {
         exitSignal |= CheckValueCondition(InpSellExitBuffer, InpSellExitValueThreshold, InpSellExitValueCondition);
      }

      // オブジェクト条件チェック
      if(InpEnableSellExitObject)
      {
         exitSignal |= CheckObjectSignal(SellExitPrefix);
      }

      return exitSignal;
   }

   // 交差条件のチェックが必要かどうか（決済用）
   bool NeedsCrossCheckForExit(bool isBuy)
   {
      if(isBuy)
      {
         return (InpEnableBuyExitPrice && (InpBuyExitPriceCondition == PRICE_CONDITION_CROSS ||
                                          InpBuyExitPriceCondition == PRICE_CONDITION_UP_CROSS ||
                                          InpBuyExitPriceCondition == PRICE_CONDITION_DOWN_CROSS)) ||
                (InpEnableBuyExitValue && (InpBuyExitValueCondition == VALUE_CONDITION_CROSS ||
                                          InpBuyExitValueCondition == VALUE_CONDITION_UP_CROSS ||
                                          InpBuyExitValueCondition == VALUE_CONDITION_DOWN_CROSS));
      }
      else
      {
         return (InpEnableSellExitPrice && (InpSellExitPriceCondition == PRICE_CONDITION_CROSS ||
                                           InpSellExitPriceCondition == PRICE_CONDITION_UP_CROSS ||
                                           InpSellExitPriceCondition == PRICE_CONDITION_DOWN_CROSS)) ||
                (InpEnableSellExitValue && (InpSellExitValueCondition == VALUE_CONDITION_CROSS ||
                                           InpSellExitValueCondition == VALUE_CONDITION_UP_CROSS ||
                                           InpSellExitValueCondition == VALUE_CONDITION_DOWN_CROSS));
      }
   }

   // 有効な条件があるかチェック
   bool HasAnyEnabledCondition()
   {
      // エントリー条件
      bool hasEntryCondition = InpEnableBuySignal || InpEnableSellSignal ||
                              InpEnableBuyPrice || InpEnableSellPrice ||
                              InpEnableBuyValue || InpEnableSellValue ||
                              InpEnableBuySignalObject || InpEnableSellSignalObject;

      // 決済条件
      bool hasExitCondition = InpEnableBuyExitSignal || InpEnableSellExitSignal ||
                             InpEnableBuyExitPrice || InpEnableSellExitPrice ||
                             InpEnableBuyExitValue || InpEnableSellExitValue ||
                             InpEnableBuyExitObject || InpEnableSellExitObject;

      // モードに応じて必要な条件をチェック
      if(InpIndicatorMode == INDICATOR_ENTRY_ONLY)
         return hasEntryCondition;
      else if(InpIndicatorMode == INDICATOR_EXIT_ONLY)
         return hasExitCondition;
      else // INDICATOR_ENTRY_AND_EXIT
         return hasEntryCondition || hasExitCondition;
   }

   // シグナル条件チェック
   bool CheckSignalCondition(int buffer, bool isBuy)
   {
      double currentValue = GetIndicatorValue(buffer, InpIndicatorShift);
      double prevValue = GetIndicatorValue(buffer, InpIndicatorShift + 1);

      // シグナル判定パターン
      // 1. EMPTY_VALUEから有効値への変化
      if(prevValue == EMPTY_VALUE && currentValue != EMPTY_VALUE && currentValue != 0)
      {
         return true;
      }

      // 2. 0から正値への変化（買いシグナル）または0から負値への変化（売りシグナル）
      if(isBuy && prevValue <= 0 && currentValue > 0)
      {
         return true;
      }
      if(!isBuy && prevValue >= 0 && currentValue < 0)
      {
         return true;
      }

      // 3. 値が存在する場合（矢印インジケーター等）
      if(currentValue != EMPTY_VALUE && currentValue != 0)
      {
         // 前回値がEMPTY_VALUEまたは0の場合、新規シグナルとして判定
         if(prevValue == EMPTY_VALUE || prevValue == 0)
         {
            return true;
         }
      }

      return false;
   }

   // 価格条件チェック
   bool CheckPriceCondition(int buffer, ENUM_APPLIED_PRICE priceType, ENUM_PRICE_CONDITION_TYPE conditionType)
   {
      double indicatorValue = GetIndicatorValue(buffer, InpIndicatorShift);
      double prevIndicatorValue = GetIndicatorValue(buffer, InpIndicatorShift + 1);

      if(indicatorValue == EMPTY_VALUE || prevIndicatorValue == EMPTY_VALUE)
         return false;

      double price = GetPrice(priceType, InpIndicatorShift);
      double prevPrice = GetPrice(priceType, InpIndicatorShift + 1);

      return CheckPriceConditionLogic(conditionType, price, indicatorValue, prevPrice, prevIndicatorValue);
   }

   // 数値条件チェック
   bool CheckValueCondition(int buffer, double threshold, ENUM_VALUE_CONDITION_TYPE conditionType)
   {
      double indicatorValue = GetIndicatorValue(buffer, InpIndicatorShift);
      double prevIndicatorValue = GetIndicatorValue(buffer, InpIndicatorShift + 1);

      if(indicatorValue == EMPTY_VALUE || prevIndicatorValue == EMPTY_VALUE)
         return false;

      return CheckValueConditionLogic(conditionType, indicatorValue, threshold, prevIndicatorValue, threshold);
   }

   // オブジェクトシグナルチェック
   bool CheckObjectSignal(string prefix)
   {
      datetime barTime = iTime(_Symbol, InpCustomTimeframe, InpIndicatorShift);

      for(int i = ObjectsTotal(0, -1, -1) - 1; i >= 0; i--)
      {
         string objName = ObjectName(0, i, -1, -1);
         if(StringFind(objName, prefix) == 0)
         {
            datetime objTime = (datetime)ObjectGetInteger(0, objName, OBJPROP_TIME);
            if(objTime == barTime)
            {
               double objValue = ObjectGetDouble(0, objName, OBJPROP_PRICE);
               return objValue != 0;
            }
         }
      }

      return false;
   }

   // 価格条件判定関数
   bool CheckPriceConditionLogic(ENUM_PRICE_CONDITION_TYPE conditionType, double price, double indicatorValue, double prevPrice, double prevIndicatorValue)
   {
      switch(conditionType)
      {
         case PRICE_CONDITION_NONE:
            return false;

         case PRICE_CONDITION_CROSS:
            return (prevPrice <= prevIndicatorValue && price > indicatorValue) || (prevPrice >= prevIndicatorValue && price < indicatorValue);

         case PRICE_CONDITION_UP_CROSS:
            return prevPrice <= prevIndicatorValue && price > indicatorValue;

         case PRICE_CONDITION_DOWN_CROSS:
            return prevPrice >= prevIndicatorValue && price < indicatorValue;

         case PRICE_CONDITION_BELOW:
            return price < indicatorValue;

         case PRICE_CONDITION_ABOVE:
            return price > indicatorValue;

         default:
            return false;
      }
   }

   // 数値条件判定関数
   bool CheckValueConditionLogic(ENUM_VALUE_CONDITION_TYPE conditionType, double indicatorValue, double threshold, double prevIndicatorValue, double prevThreshold)
   {
      switch(conditionType)
      {
         case VALUE_CONDITION_NONE:
            return false;

         case VALUE_CONDITION_CROSS:
            return (prevIndicatorValue <= prevThreshold && indicatorValue > threshold) || (prevIndicatorValue >= prevThreshold && indicatorValue < threshold);

         case VALUE_CONDITION_UP_CROSS:
            return prevIndicatorValue <= prevThreshold && indicatorValue > threshold;

         case VALUE_CONDITION_DOWN_CROSS:
            return prevIndicatorValue >= prevThreshold && indicatorValue < threshold;

         case VALUE_CONDITION_BELOW:
            return indicatorValue < threshold;

         case VALUE_CONDITION_ABOVE:
            return indicatorValue > threshold;

         default:
            return false;
      }
   }

   // インジケーター値を取得（MQL4/MQL5共通）
   double GetIndicatorValue(int buffer, int shift)
   {
#ifdef __MQL5__
      double value[1] = {EMPTY_VALUE};
      if(CopyBuffer(m_indicatorHandle, buffer, shift, 1, value) <= 0)
      {
         return EMPTY_VALUE;
      }
      return value[0];
#else
      double value = iCustom(_Symbol, (int)InpCustomTimeframe, InpIndicatorName,
                             m_params[0], m_params[1], m_params[2], m_params[3], m_params[4],
                             m_params[5], m_params[6], m_params[7], m_params[8], m_params[9],
                             buffer, shift);
      return value;
#endif
   }

   // 価格データを取得
   double GetPrice(ENUM_APPLIED_PRICE priceType, int shift)
   {
      switch(priceType)
      {
         case PRICE_OPEN:    return iOpen(_Symbol, InpCustomTimeframe, shift);
         case PRICE_HIGH:    return iHigh(_Symbol, InpCustomTimeframe, shift);
         case PRICE_LOW:     return iLow(_Symbol, InpCustomTimeframe, shift);
         case PRICE_CLOSE:   return iClose(_Symbol, InpCustomTimeframe, shift);
         case PRICE_MEDIAN:  return (iHigh(_Symbol, InpCustomTimeframe, shift) + iLow(_Symbol, InpCustomTimeframe, shift)) / 2;
         case PRICE_TYPICAL: return (iHigh(_Symbol, InpCustomTimeframe, shift) + iLow(_Symbol, InpCustomTimeframe, shift) + iClose(_Symbol, InpCustomTimeframe, shift)) / 3;
         case PRICE_WEIGHTED:return (iOpen(_Symbol, InpCustomTimeframe, shift) + iHigh(_Symbol, InpCustomTimeframe, shift) + iLow(_Symbol, InpCustomTimeframe, shift) + iClose(_Symbol, InpCustomTimeframe, shift)) / 4;
         default:            return iClose(_Symbol, InpCustomTimeframe, shift);
      }
   }
};

// グローバルインスタンス
CustomIndicatorManager g_CustomIndicatorManager;

//==================================================================
// 関数エクスポート
//==================================================================

// 初期化関数
bool InitializeCustomIndicator()
{
   return g_CustomIndicatorManager.Initialize();
}

// 決済条件チェック関数
void ProcessCustomIndicatorExit()
{
   g_CustomIndicatorManager.CheckExitConditions();
}

// 外部インジケーターが有効かどうか
bool IsCustomIndicatorEnabled()
{
   return g_CustomIndicatorManager.IsEnabled();
}

// 外部インジケーターエントリーシグナルチェック関数（戦略システムから呼ばれる）
bool CheckCustomIndicatorSignal(int side)
{
   // エントリーモードがエントリー無効の場合はfalse
   if(InpIndicatorMode == INDICATOR_EXIT_ONLY)
      return false;

   // 有効でない場合はfalse
   if(!g_CustomIndicatorManager.IsEnabled())
      return false;

   // 買い/売りシグナルをチェック
   bool isBuy = (side == 0);

   if(isBuy)
      return g_CustomIndicatorManager.ShouldBuy();
   else
      return g_CustomIndicatorManager.ShouldSell();
}

// インジケーター名を取得
string GetCustomIndicatorName()
{
   return g_CustomIndicatorManager.GetIndicatorName();
}

#endif // HOSOPI3_TANPOJI_CUSTOM_INDICATOR_MQH
