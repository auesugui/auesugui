# Application Mockups - Text-to-SQL with Three-Tab Architecture

## 1. Landing Page (Initial State)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  [Company Watermark Logo]                                          [🌙 Theme Toggle]   │
└────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────┬─────────────────────────────────────────────────────────────────────────┐
│              │                                                                          │
│              │                     Welcome to Text-to-SQL Assistant                    │
│              │                                                                          │
│              │                 Start by selecting a question template:                 │
│ [Dashboard]  │                                                                          │
│              │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│ [+ New Chat] │  │   📊    │ │   📈    │ │   💰    │ │   👥    │ │   🔍    │ │   📅    │ │
│              │  │ Revenue │ │  Top 10 │ │ Monthly │ │ Active  │ │ Product │ │  YoY    │ │
│──────────────│  │   by    │ │Customer │ │   MRR   │ │  Users  │ │Inventory│ │ Growth  │ │
│              │  │ Region  │ │by Sales │ │  Trend  │ │ Quarter │ │ Status  │ │         │ │
│ Chat Threads │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ │
│ ────────────│                                                                          │
│              │                                                                          │
│ (empty)      │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│──────────────│                                                                          │
│              │                                                                          │
│  ┌────────┐  │                                                                          │
│  │ User   │  │                                                                          │
│  │ Menu   │  │                                                                          │
│  └────┬───┘  │                                                                          │
│       │      │                                                                          │
│  • Database  │                                                                          │
│  • Logout    │                                                                          │
│  • Help/FAQs │                                                                          │
│  • Settings  │                                                                          │
│              │                                                                          │
└──────────────┴─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Chat Thread Interface (After Question Submit)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  [Company Watermark Logo]                                          [🌙 Theme Toggle]   │
└────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────┬─────────────────────────────────────────────────────────────────────────┐
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 👤 You                                              3:45 PM    │    │
│              │  │ Show me total revenue by region for Q4 2023                    │    │
│ [Dashboard]  │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│ [+ New Chat] │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 🤖 Assistant                                        3:45 PM    │    │
│──────────────│  │                                                                 │    │
│              │  │ ┌─────────────────────────────────────────────────────────┐   │    │
│ Chat Threads │  │ │ Answer │ View SQL │ Chart                              │   │    │
│ ────────────│  │ ├─────────────────────────────────────────────────────────┤   │    │
│              │  │ │                                                         │   │    │
│ Revenue Q4   │  │ │  Here's the total revenue by region for Q4 2023:       │   │    │
│   (active)   │  │ │                                                         │   │    │
│              │  │ │  ┌──────────────┬────────────────┐                     │   │    │
│ Top Customers│  │ │  │ Region       │ Total Revenue  │                     │   │    │
│              │  │ │  ├──────────────┼────────────────┤                     │   │    │
│ Inventory    │  │ │  │ North        │ $2,450,000     │                     │   │    │
│              │  │ │  │ South        │ $1,890,000     │                     │   │    │
│              │  │ │  │ East         │ $3,120,000     │                     │   │    │
│              │  │ │  │ West         │ $2,760,000     │                     │   │    │
│              │  │ │  └──────────────┴────────────────┘                     │   │    │
│              │  │ │                                                         │   │    │
│              │  │ │  Total across all regions: $10,220,000                 │   │    │
│              │  │ │                                                         │   │    │
│              │  │ └─────────────────────────────────────────────────────────┘   │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │  💬 Ask a follow-up question...                     [Submit]   │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│──────────────│                                                                          │
│              │                                                                          │
│  ┌────────┐  │                                                                          │
│  │ User   │  │                                                                          │
│  │ Menu   │  │                                                                          │
│  └────┬───┘  │                                                                          │
│       │      │                                                                          │
│  • Database  │                                                                          │
│  • Logout    │                                                                          │
│  • Help/FAQs │                                                                          │
│  • Settings  │                                                                          │
│              │                                                                          │
└──────────────┴─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Three-Tab Architecture - Answer Tab (Default View)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  🤖 Assistant                                                       3:45 PM             │
│                                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐ │
│  │ ▼ Answer │ View SQL │ Chart                                      📌 Pin to Dashboard│ │
│  ├──────────────────────────────────────────────────────────────────────────────────┤ │
│  │                                                                                   │ │
│  │  Here's the total revenue by region for Q4 2023:                                │ │
│  │                                                                                   │ │
│  │  ┌─────────────────────────────────────────────────────────────────────────┐   │ │
│  │  │                         Revenue by Region                                │   │ │
│  │  ├──────────────────────────┬──────────────────────────────────────────────┤   │ │
│  │  │ Region                   │ Total Revenue                                │   │ │
│  │  ├──────────────────────────┼──────────────────────────────────────────────┤   │ │
│  │  │ North America            │ $2,450,000                                   │   │ │
│  │  │ South America            │ $1,890,000                                   │   │ │
│  │  │ East Asia                │ $3,120,000                                   │   │ │
│  │  │ West Europe              │ $2,760,000                                   │   │ │
│  │  └──────────────────────────┴──────────────────────────────────────────────┘   │ │
│  │                                                                                   │ │
│  │  📊 Summary Statistics:                                                          │ │
│  │     • Total Revenue: $10,220,000                                                │ │
│  │     • Highest: East Asia ($3,120,000)                                           │ │
│  │     • Lowest: South America ($1,890,000)                                        │ │
│  │     • Average: $2,555,000                                                       │ │
│  │                                                                                   │ │
│  │  💡 East Asia leads with 30.5% of total Q4 revenue, while South America        │ │
│  │     represents the smallest share at 18.5%.                                     │ │
│  │                                                                                   │ │
│  └──────────────────────────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Three-Tab Architecture - View SQL Tab

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  🤖 Assistant                                                       3:45 PM             │
│                                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐ │
│  │ Answer │ ▼ View SQL │ Chart                                      [Copy SQL] [Edit SQL]│ │
│  ├──────────────────────────────────────────────────────────────────────────────────┤ │
│  │                                                                                   │ │
│  │  Generated SQL Query:                                                            │ │
│  │                                                                                   │ │
│  │  ┌────────────────────────────────────────────────────────────────────────┐     │ │
│  │  │  1  SELECT                                                              │     │ │
│  │  │  2      region,                                                         │     │ │
│  │  │  3      SUM(revenue) AS total_revenue                                   │     │ │
│  │  │  4  FROM                                                                │     │ │
│  │  │  5      sales_data                                                      │     │ │
│  │  │  6  WHERE                                                               │     │ │
│  │  │  7      quarter = 'Q4'                                                  │     │ │
│  │  │  8      AND year = 2023                                                 │     │ │
│  │  │  9  GROUP BY                                                            │     │ │
│  │  │ 10      region                                                          │     │ │
│  │  │ 11  ORDER BY                                                            │     │ │
│  │  │ 12      total_revenue DESC;                                             │     │ │
│  │  └────────────────────────────────────────────────────────────────────────┘     │ │
│  │                                                                                   │ │
│  │  ℹ️ Query executed on: production_db                                            │ │
│  │  ⏱️ Execution time: 0.34s                                                        │ │
│  │  📊 Rows returned: 4                                                             │ │
│  │                                                                                   │ │
│  │  ┌────────────────────────────────────────────────────────────────────────┐     │ │
│  │  │                          [▶ View Results]                               │     │ │
│  │  └────────────────────────────────────────────────────────────────────────┘     │ │
│  │                                                                                   │ │
│  └──────────────────────────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Three-Tab Architecture - Chart Tab

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  🤖 Assistant                                                       3:45 PM             │
│                                                                                         │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐ │
│  │ Answer │ View SQL │ ▼ Chart                          [Edit] [Regenerate] [📌 Pin] │ │
│  ├──────────────────────────────────────────────────────────────────────────────────┤ │
│  │                                                                                   │ │
│  │  Chart Type: Bar Chart                                    🎨 Chart Properties ▼  │ │
│  │                                                                                   │ │
│  │  ┌────────────────────────────────────────────────────────────────────────┐     │ │
│  │  │                    Q4 2023 Revenue by Region                            │     │ │
│  │  │                                                                         │     │ │
│  │  │   $3.5M ┤                                                              │     │ │
│  │  │         │                                                              │     │ │
│  │  │   $3.0M ┤                      ███████                                 │     │ │
│  │  │         │                      ███████                                 │     │ │
│  │  │   $2.5M ┤    ███████           ███████    ███████                      │     │ │
│  │  │         │    ███████           ███████    ███████                      │     │ │
│  │  │   $2.0M ┤    ███████  ███████  ███████    ███████                      │     │ │
│  │  │         │    ███████  ███████  ███████    ███████                      │     │ │
│  │  │   $1.5M ┤    ███████  ███████  ███████    ███████                      │     │ │
│  │  │         │    ███████  ███████  ███████    ███████                      │     │ │
│  │  │   $1.0M ┤    ███████  ███████  ███████    ███████                      │     │ │
│  │  │         │    ███████  ███████  ███████    ███████                      │     │ │
│  │  │   $0.5M ┤    ███████  ███████  ███████    ███████                      │     │ │
│  │  │         │    ███████  ███████  ███████    ███████                      │     │ │
│  │  │     $0  └────┴───────┴────────┴────────┴───────────────────────────   │     │ │
│  │  │          North   South    East      West                              │     │ │
│  │  │         America America   Asia     Europe                             │     │ │
│  │  │                                                                         │     │ │
│  │  └────────────────────────────────────────────────────────────────────────┘     │ │
│  │                                                                                   │ │
│  │  Legend: █ Total Revenue                                                         │ │
│  │                                                                                   │ │
│  └──────────────────────────────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 6. Follow-up Questions - Multiple Three-Tab Responses

**Key Insight: Each response in WrenAI gets its own independent three-tab panel.**

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  [Company Watermark Logo]                                          [🌙 Theme Toggle]   │
└────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────┬─────────────────────────────────────────────────────────────────────────┐
│              │  (Scrollable conversation thread)                                       │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│ [Dashboard]  │  │ 👤 You                                              3:45 PM    │    │
│              │  │ Show me total revenue by region for Q4 2023                    │    │
│ [+ New Chat] │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│──────────────│  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 🤖 Assistant                                        3:45 PM    │    │
│ Chat Threads │  │ ┌─────────────────────────────────────────────────────────┐   │    │
│ ────────────│  │ │ Answer │ View SQL │ Chart                              │   │    │
│              │  │ ├─────────────────────────────────────────────────────────┤   │    │
│ Revenue Q4   │  │ │ Here's the total revenue by region for Q4 2023:        │   │    │
│   (active)   │  │ │ [Data table with 4 regions and revenue...]             │   │    │
│              │  │ │ Total across all regions: $10,220,000                  │   │    │
│ Top Customers│  │ └─────────────────────────────────────────────────────────┘   │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│ Inventory    │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 👤 You                                              3:47 PM    │    │
│              │  │ Which region had the highest growth compared to Q3?            │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 🤖 Assistant                                        3:47 PM    │    │
│              │  │ ┌─────────────────────────────────────────────────────────┐   │    │
│              │  │ │ Answer │ View SQL │ Chart                  [📌 Pin]    │   │    │
│              │  │ ├─────────────────────────────────────────────────────────┤   │    │
│              │  │ │                                                         │   │    │
│              │  │ │ Comparing Q4 2023 to Q3 2023:                          │   │    │
│              │  │ │                                                         │   │    │
│              │  │ │ ┌──────────┬────────────┬────────────┬──────────┐     │   │    │
│              │  │ │ │ Region   │ Q3 Revenue │ Q4 Revenue │ Growth % │     │   │    │
│              │  │ │ ├──────────┼────────────┼────────────┼──────────┤     │   │    │
│              │  │ │ │ North    │ $2,100,000 │ $2,450,000 │ +16.7%   │     │   │    │
│              │  │ │ │ South    │ $1,800,000 │ $1,890,000 │ +5.0%    │     │   │    │
│              │  │ │ │ East     │ $2,500,000 │ $3,120,000 │ +24.8%   │  ← │   │    │
│              │  │ │ │ West     │ $2,400,000 │ $2,760,000 │ +15.0%   │     │   │    │
│              │  │ │ └──────────┴────────────┴────────────┴──────────┘     │   │    │
│              │  │ │                                                         │   │    │
│              │  │ │ 📈 East Asia had the highest growth at +24.8%          │   │    │
│              │  │ │                                                         │   │    │
│              │  │ └─────────────────────────────────────────────────────────┘   │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 👤 You                                              3:49 PM    │    │
│              │  │ Show me a trend chart for East Asia over all 4 quarters       │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │ 🤖 Assistant                                        3:49 PM    │    │
│              │  │ ┌─────────────────────────────────────────────────────────┐   │    │
│              │  │ │ Answer │ View SQL │ Chart                  [📌 Pin]    │   │    │
│──────────────│  │ ├─────────────────────────────────────────────────────────┤   │    │
│              │  │ │                                                         │   │    │
│  ┌────────┐  │  │ │ East Asia Quarterly Revenue Trend - 2023:             │   │    │
│  │ User   │  │  │ │                                                         │   │    │
│  │ Menu   │  │  │ │ Q1: $2,100,000 → Q2: $2,300,000 → Q3: $2,500,000 →    │   │    │
│  └────┬───┘  │  │ │ Q4: $3,120,000                                         │   │    │
│       │      │  │ │                                                         │   │    │
│  • Database  │  │ │ 💡 Strong upward trend with 48.6% YoY growth          │   │    │
│  • Logout    │  │ │                                                         │   │    │
│  • Help/FAQs │  │ └─────────────────────────────────────────────────────────┘   │    │
│  • Settings  │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │  💬 Ask a follow-up question...                     [Submit]   │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
└──────────────┴─────────────────────────────────────────────────────────────────────────┘
```

### How WrenAI Manages State for Follow-ups:

**Answer to your question: YES, each follow-up response generates its own three-tab panel.**

**State Management Pattern:**

1. **Thread-Based Architecture**: The `PromptThread` component maintains an array of messages
2. **Independent Tab States**: Each assistant message has its own `AnswerResult` component
3. **Each `AnswerResult` includes**:
   - Separate Answer/View SQL/Chart tabs
   - Independent tab selection state
   - Lazy loading for Chart tab (generates only when clicked)
4. **Context Awareness**: Follow-up queries maintain context from previous messages in the thread
5. **SQL Evolution**: Each new response can reference previous queries but generates new SQL

**Key Benefits:**
- Users can compare different queries side-by-side
- Each response's tabs remain accessible for reference
- Previous chart visualizations stay visible while asking new questions
- Users can pin charts from any response in the thread

**Example Flow:**
1. User asks initial question → Gets Response #1 with 3 tabs
2. User clicks Chart tab on Response #1 → Chart generates
3. User asks follow-up → Gets Response #2 with its own 3 tabs
4. User can still scroll up and interact with Response #1's tabs
5. User clicks Chart tab on Response #2 → New chart generates independently
6. Both charts remain in the thread for comparison

---

## 7. Dashboard View (Pinned Charts)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  [Company Watermark Logo]                                          [🌙 Theme Toggle]   │
└────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────┬─────────────────────────────────────────────────────────────────────────┐
│              │                                                                          │
│              │  Dashboard                                   [⚙️ Settings] [🔄 Refresh All] │
│              │  ═══════════                                                            │
│ [Dashboard]  │                                                                          │
│   (active)   │  ┌──────────────────────────────┐  ┌──────────────────────────────┐   │
│              │  │ Q4 2023 Revenue by Region ⋮ │  │ Top 10 Customers by Sales ⋮  │   │
│ [+ New Chat] │  │ ┌──────────────────────────┐ │  │ ┌──────────────────────────┐ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│──────────────│  │ │     Bar Chart            │ │  │ │    Horizontal Bar Chart  │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│ Chat Threads │  │ │   [Chart Visualization]  │ │  │ │  [Chart Visualization]   │ │   │
│ ────────────│  │ │                          │ │  │ │                          │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│ Revenue Q4   │  │ └──────────────────────────┘ │  │ └──────────────────────────┘ │   │
│              │  │ Last updated: 5 mins ago     │  │ Last updated: 2 mins ago     │   │
│ Top Customers│  └──────────────────────────────┘  └──────────────────────────────┘   │
│              │                                                                          │
│ Inventory    │  ┌──────────────────────────────┐  ┌──────────────────────────────┐   │
│              │  │ Monthly Recurring Revenue ⋮  │  │ Active Users Trend       ⋮   │   │
│              │  │ ┌──────────────────────────┐ │  │ ┌──────────────────────────┐ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│              │  │ │    Line Chart            │ │  │ │    Area Chart            │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│              │  │ │  [Chart Visualization]   │ │  │ │  [Chart Visualization]   │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│              │  │ └──────────────────────────┘ │  │ └──────────────────────────┘ │   │
│              │  │ Last updated: 10 mins ago    │  │ Last updated: 1 min ago      │   │
│              │  └──────────────────────────────┘  └──────────────────────────────┘   │
│              │                                                                          │
│              │  ┌──────────────────────────────┐                                      │
│              │  │ Product Inventory Status  ⋮  │     [Empty grid slot for           │
│              │  │ ┌──────────────────────────┐ │      future pinned charts]          │
│              │  │ │                          │ │                                      │
│              │  │ │    Donut Chart           │ │                                      │
│              │  │ │                          │ │                                      │
│              │  │ │  [Chart Visualization]   │ │                                      │
│              │  │ │                          │ │                                      │
│              │  │ │                          │ │                                      │
│              │  │ └──────────────────────────┘ │                                      │
│              │  │ Last updated: 15 mins ago    │                                      │
│              │  └──────────────────────────────┘                                      │
│              │                                                                          │
│──────────────│                                                                          │
│              │                                                                          │
│  ┌────────┐  │                                                                          │
│  │ User   │  │                                                                          │
│  │ Menu   │  │                                                                          │
│  └────┬───┘  │                                                                          │
│       │      │                                                                          │
│  • Database  │                                                                          │
│  • Logout    │                                                                          │
│  • Help/FAQs │                                                                          │
│  • Settings  │                                                                          │
│              │                                                                          │
└──────────────┴─────────────────────────────────────────────────────────────────────────┘

Note: Each chart card has a ⋮ (three-dot) menu with options:
  • Edit Chart Properties
  • Refresh Data
  • Toggle Legend
  • Unpin from Dashboard
  • Delete
```

---

## 8. Nav Drawer - Expanded User Menu

```
┌──────────────┐
│              │
│ [Dashboard]  │
│ [+ New Chat] │
│              │
│──────────────│
│              │
│ Chat Threads │
│ ────────────│
│              │
│ Revenue Q4   │
│              │
│ Top Customers│
│              │
│ Inventory    │
│              │
│ MRR Trend    │
│              │
│              │
│              │
│              │
│              │
│              │
│──────────────│
│              │
│  ┌────────┐  │
│  │ User   │▼ │
│  │ Menu   │  │
│  └────────┘  │
│              │
│  ┌──────────┐│
│  │ Database││
│  ├──────────┤│
│  │ ○ prod_db││  ← Selected
│  │ ○ staging││
│  │ ○ dev_db ││
│  │ ○ test   ││
│  └──────────┘│
│              │
│  Logout      │
│  Help / FAQs │
│  Settings    │
│              │
└──────────────┘
```

---

## 9. Nav Drawer - With Dashboard and New Chat Buttons

```
┌──────────────────┐
│                  │
│ ┌──────┬───────┐│
│ │  📊  │  ➕   ││
│ │ Dash │  New  ││
│ │board │  Chat ││
│ └──────┴───────┘│
│                  │
│──────────────────│
│                  │
│ Chat Threads     │
│ ────────────────│
│                  │
│ ○ Revenue Q4     │
│   2023           │
│                  │
│ ● Top Customers  │  ← Active
│   Analysis       │
│                  │
│ ○ Inventory      │
│   Status         │
│                  │
│ ○ MRR Trend      │
│   Report         │
│                  │
│ ○ User Growth    │
│   Q1-Q4          │
│                  │
│                  │
│                  │
│──────────────────│
│                  │
│  ┌────────┐      │
│  │ User   │      │
│  │ Menu   │      │
│  └────┬───┘      │
│       │          │
│  • Database      │
│  • Logout        │
│  • Help/FAQs     │
│  • Settings      │
│                  │
│                  │
│                  │
└──────────────────┘
```

---

## 10. Complete Application Flow

### Flow 1: New User → Landing Page → Chat
```
1. User lands on home page
2. Sees 6 question templates
3. Clicks template or types custom question
4. Page transitions to chat thread interface
5. Response appears with three tabs (Answer shown by default)
6. User can switch between Answer/View SQL/Chart tabs
```

### Flow 2: Generating and Pinning a Chart
```
1. User in chat thread, viewing response
2. Clicks "Chart" tab
3. Chart generates (if first time)
4. User sees chart with [Edit] [Regenerate] [📌 Pin] buttons
5. Clicks "📌 Pin"
6. Chart saved to dashboard
7. Toast notification: "Chart pinned to dashboard"
8. Dashboard button badge shows: [📊 Dashboard (5)]
```

### Flow 3: Viewing Dashboard
```
1. User clicks "Dashboard" button in nav drawer
2. Main area shows grid of pinned charts
3. Each chart is draggable/resizable
4. Each chart has ⋮ menu (edit, refresh, toggle legend, unpin)
5. Header shows [⚙️ Settings] [🔄 Refresh All]
```

### Flow 4: Creating New Chat from Dashboard
```
1. User on dashboard page
2. Clicks "➕ New Chat" button
3. Page transitions to landing page with question templates
4. OR directly to empty chat interface (design choice)
```

---

## 11. Component Hierarchy

```
App
├── Header
│   ├── CompanyWatermark
│   └── ThemeToggle
│
├── MainLayout
│   ├── NavDrawer
│   │   ├── UserMenu
│   │   │   ├── DatabaseSelector
│   │   │   ├── LogoutButton
│   │   │   ├── HelpFAQsLink
│   │   │   └── SettingsLink
│   │   │
│   │   ├── ActionButtons
│   │   │   ├── DashboardButton
│   │   │   └── NewChatButton
│   │   │
│   │   └── ChatThreadsList
│   │       └── ThreadItem (multiple)
│   │
│   └── MainContent
│       ├── LandingPage
│       │   └── QuestionTemplates (6 cards)
│       │
│       ├── ChatThread
│       │   ├── MessageList
│       │   │   ├── UserMessage
│       │   │   └── AssistantMessage
│       │   │       └── ThreeTabPanel
│       │   │           ├── AnswerTab
│       │   │           │   ├── DataTable
│       │   │           │   └── Summary
│       │   │           │
│       │   │           ├── ViewSQLTab
│       │   │           │   ├── CodeBlock
│       │   │           │   ├── QueryMetadata
│       │   │           │   └── ViewResultsButton
│       │   │           │
│       │   │           └── ChartTab
│       │   │               ├── ChartVisualization
│       │   │               ├── ChartControls
│       │   │               └── PinButton
│       │   │
│       │   └── ChatInput
│       │
│       └── Dashboard
│           ├── DashboardHeader
│           └── DashboardGrid
│               └── PinnedChartCard (multiple)
│                   ├── ChartTitle (editable)
│                   ├── ChartVisualization
│                   ├── LastUpdated
│                   └── ActionsMenu
```

---

## Key Implementation Notes for Salt DS

1. **Nav Drawer**: Use Salt `Drawer` or `NavigationItem` components
2. **Tabs**: Use Salt `Tabs` and `TabPanel` components
3. **Cards**: Use Salt `Card` for question templates and pinned charts
4. **Buttons**: Use Salt `Button` with appropriate variants
5. **Input**: Use Salt `Input` with multiline for chat input
6. **Theme Toggle**: Use Salt `Switch` or custom theme provider
7. **Grid Layout**: Use CSS Grid or react-grid-layout with Salt styling
8. **Data Table**: Use Salt `Table` component in Answer tab
9. **Code Block**: Use syntax highlighter in View SQL tab
10. **Charts**: Use charting library (Recharts, Vega-Lite, etc.) styled with Salt tokens

---

## Responsive Considerations

- Nav drawer collapses to hamburger menu on mobile
- Question templates stack vertically on smaller screens
- Dashboard grid adjusts from 2 columns to 1 column on mobile
- Three-tab panel scrolls horizontally on very small screens
- Chat input expands/collapses based on content
