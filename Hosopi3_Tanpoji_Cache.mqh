//+------------------------------------------------------------------+
//|          Hosopi 3 タンポジ - キャッシュシステム                   |
//|                         Copyright 2025                           |
//|              ELDRA2より移植した高速化キャッシュ機構               |
//+------------------------------------------------------------------+
#ifndef HOSOPI3_TANPOJI_CACHE_MQH
#define HOSOPI3_TANPOJI_CACHE_MQH

//==================================================================
//                    オブジェクトキャッシュシステム
//==================================================================

// オブジェクトプロパティキャッシュ構造体
struct ObjectCache {
   string name;
   string text;
   color textColor;
   double price;
   int bgcolor;
   datetime time;
   bool visible;
   bool isDirty;
   datetime lastUpdate;
};

// キャッシュ管理クラス
class CObjectCacheManager {
private:
   ObjectCache m_cache[];
   int m_cacheSize;
   int m_maxCacheSize;
   datetime m_cacheTimeout;

   int FindCacheIndex(const string &name) {
      static string lastNames[10];
      static int lastIndexes[10];
      static int cacheCount = 0;

      for(int i = 0; i < 10 && i < cacheCount; i++) {
         if(lastNames[i] == name && lastIndexes[i] < m_cacheSize &&
            lastIndexes[i] >= 0 && m_cache[lastIndexes[i]].name == name) {
            return lastIndexes[i];
         }
      }

      for(int i = m_cacheSize - 1; i >= 0; i--) {
         if(m_cache[i].name == name) {
            int pos = cacheCount % 10;
            lastNames[pos] = name;
            lastIndexes[pos] = i;
            if(cacheCount < 10) cacheCount++;
            return i;
         }
      }
      return -1;
   }

   void AddToCache(const string &name) {
      if(m_cacheSize >= m_maxCacheSize) {
         if(m_cacheSize > 1) {
            for(int i = 0; i < m_cacheSize - 1; i++) {
               m_cache[i] = m_cache[i + 1];
            }
         }
         m_cacheSize--;
      }

      ArrayResize(m_cache, m_cacheSize + 1);
      m_cache[m_cacheSize].name = name;
      m_cache[m_cacheSize].isDirty = false;
      m_cache[m_cacheSize].lastUpdate = TimeCurrent();
      m_cacheSize++;
   }

public:
   CObjectCacheManager() {
      m_cacheSize = 0;
      m_maxCacheSize = 200;
      m_cacheTimeout = 30;
      ArrayResize(m_cache, m_maxCacheSize);
   }

   ~CObjectCacheManager() {
      ArrayResize(m_cache, 0);
   }

   bool SetObjectText(const string &name, const string &text) {
      int index = FindCacheIndex(name);
      if(index >= 0) {
         if(m_cache[index].text == text && !m_cache[index].isDirty)
            return true;

         m_cache[index].text = text;
         m_cache[index].lastUpdate = TimeCurrent();
      } else {
         AddToCache(name);
         index = m_cacheSize - 1;
         m_cache[index].text = text;
      }

      return ObjectSetString(0, name, OBJPROP_TEXT, text);
   }

   bool SetObjectColor(const string &name, color clr) {
      int index = FindCacheIndex(name);
      if(index >= 0) {
         if(m_cache[index].textColor == clr && !m_cache[index].isDirty)
            return true;

         m_cache[index].textColor = clr;
         m_cache[index].lastUpdate = TimeCurrent();
      } else {
         AddToCache(name);
         index = m_cacheSize - 1;
         m_cache[index].textColor = clr;
      }

      return ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   }

   bool SetObjectBgColor(const string &name, color clr) {
      int index = FindCacheIndex(name);
      if(index >= 0) {
         if(m_cache[index].bgcolor == (int)clr && !m_cache[index].isDirty)
            return true;

         m_cache[index].bgcolor = (int)clr;
         m_cache[index].lastUpdate = TimeCurrent();
      } else {
         AddToCache(name);
         index = m_cacheSize - 1;
         m_cache[index].bgcolor = (int)clr;
      }

      return ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr);
   }

   bool SetObjectPrice(const string &name, double price) {
      int index = FindCacheIndex(name);
      if(index >= 0) {
         if(MathAbs(m_cache[index].price - price) < Point() * 0.1 && !m_cache[index].isDirty)
            return true;

         m_cache[index].price = price;
         m_cache[index].lastUpdate = TimeCurrent();
      } else {
         AddToCache(name);
         index = m_cacheSize - 1;
         m_cache[index].price = price;
      }

      return ObjectSetDouble(0, name, OBJPROP_PRICE, price);
   }

   void ClearCache() {
      m_cacheSize = 0;
      ArrayResize(m_cache, 0);
   }

   void InvalidateObject(const string &name) {
      int index = FindCacheIndex(name);
      if(index >= 0) {
         m_cache[index].isDirty = true;
      }
   }
};

// グローバルキャッシュマネージャーインスタンス
CObjectCacheManager g_objectCache;

// ヘルパー関数
void CachedSetText(string name, string text) {
   g_objectCache.SetObjectText(name, text);
}

void CachedSetColor(string name, color clr) {
   g_objectCache.SetObjectColor(name, clr);
}

void CachedSetBgColor(string name, color clr) {
   g_objectCache.SetObjectBgColor(name, clr);
}

void CachedSetPrice(string name, double price) {
   g_objectCache.SetObjectPrice(name, price);
}

//==================================================================
//                    ポジションキャッシュシステム
//==================================================================

#ifdef __MQL5__

struct PositionCacheEntry {
   ulong ticket;
   string symbol;
   ENUM_POSITION_TYPE type;
   double volume;
   double openPrice;
   double sl;
   double tp;
   double profit;
   datetime openTime;
   string comment;
   int magic;
   bool valid;
   datetime lastUpdate;
};

class CPositionCache {
private:
   PositionCacheEntry m_cache[];
   int m_cacheSize;
   datetime m_lastFullUpdate;
   int m_buyCount;
   int m_sellCount;

public:
   CPositionCache() {
      m_cacheSize = 0;
      m_lastFullUpdate = 0;
      m_buyCount = -1;
      m_sellCount = -1;
      ArrayResize(m_cache, 50);
   }

   ~CPositionCache() {
      ArrayResize(m_cache, 0);
   }

   void UpdateCache() {
      datetime currentTime = TimeCurrent();

      if(currentTime == m_lastFullUpdate)
         return;

      int total = PositionsTotal();

      if(ArraySize(m_cache) < total) {
         ArrayResize(m_cache, total + 10);
      }

      m_cacheSize = 0;
      m_buyCount = 0;
      m_sellCount = 0;

      for(int i = 0; i < total; i++) {
         ulong ticket = PositionGetTicket(i);
         if(ticket > 0) {
            if(PositionSelectByTicket(ticket)) {
               ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
               string posSymbol = PositionGetString(POSITION_SYMBOL);
               int posMagic = (int)PositionGetInteger(POSITION_MAGIC);

               if(posSymbol == Symbol() && posMagic == MagicNumber) {
                  m_cache[m_cacheSize].ticket = ticket;
                  m_cache[m_cacheSize].symbol = posSymbol;
                  m_cache[m_cacheSize].type = posType;
                  m_cache[m_cacheSize].volume = PositionGetDouble(POSITION_VOLUME);
                  m_cache[m_cacheSize].openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
                  m_cache[m_cacheSize].sl = PositionGetDouble(POSITION_SL);
                  m_cache[m_cacheSize].tp = PositionGetDouble(POSITION_TP);
                  m_cache[m_cacheSize].profit = PositionGetDouble(POSITION_PROFIT);
                  m_cache[m_cacheSize].openTime = (datetime)PositionGetInteger(POSITION_TIME);
                  m_cache[m_cacheSize].comment = PositionGetString(POSITION_COMMENT);
                  m_cache[m_cacheSize].magic = posMagic;
                  m_cache[m_cacheSize].valid = true;
                  m_cache[m_cacheSize].lastUpdate = currentTime;

                  if(posType == POSITION_TYPE_BUY) {
                     m_buyCount++;
                  } else if(posType == POSITION_TYPE_SELL) {
                     m_sellCount++;
                  }

                  m_cacheSize++;
               }
            }
         }
      }

      m_lastFullUpdate = currentTime;
   }

   int GetPositionCount(int type) {
      UpdateCache();
      if(type == OP_BUY) return m_buyCount;
      if(type == OP_SELL) return m_sellCount;
      return m_buyCount + m_sellCount;
   }

   int GetCacheSize() {
      return m_cacheSize;
   }

   bool GetCachedPosition(int index, PositionCacheEntry &entry) {
      if(index >= 0 && index < m_cacheSize) {
         entry = m_cache[index];
         return true;
      }
      return false;
   }

   void ClearCache() {
      m_cacheSize = 0;
      m_lastFullUpdate = 0;
      m_buyCount = -1;
      m_sellCount = -1;
   }
};

CPositionCache g_positionCache;

int CachedPositionCount(int type) {
   return g_positionCache.GetPositionCount(type);
}

#else

// MQL4用ダミー（従来の方法を使用）
int CachedPositionCount(int type) {
   return position_count(type);
}

#endif

#endif // HOSOPI3_TANPOJI_CACHE_MQH
