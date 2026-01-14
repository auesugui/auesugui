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

## 11. WrenAI Performance & Data Persistence Analysis

### **Question 1: Does WrenAI optimize rendering for long threads?**

**Answer: NO - WrenAI uses simple rendering without optimization.**

**Current Implementation:**
- **No virtualization** - All responses render simultaneously in the DOM
- **No pagination** - Entire conversation history loads at once
- **No lazy loading** - Every response component mounts immediately
- **Simple iteration** - Uses basic `.map()` over responses array
- **Only scroll management** - Auto-scrolls to bottom after new messages

**Performance Impact:**
```
Thread with 3 responses:   ~9 components (3 × 3 tabs)
Thread with 10 responses:  ~30 components
Thread with 50 responses:  ~150 components (POTENTIAL LAG)
```

**Recommendation for Your App:**
Implement one of these optimizations to prevent lag:

1. **React Window/Virtualized List** (Recommended)
   - Only renders visible responses + buffer
   - Constant DOM size regardless of thread length
   - Example: `react-window` or `react-virtuoso`

2. **Pagination with "Load More"**
   - Show last 10-20 responses by default
   - "Load earlier messages" button at top
   - Good for UX but requires state management

3. **Collapse Old Responses**
   - Auto-collapse responses after 10+ messages
   - Show summary card instead of full tabs
   - Users can expand if needed

**Example with react-window:**
```javascript
import { VariableSizeList } from 'react-window';

<VariableSizeList
  height={windowHeight}
  itemCount={responses.length}
  itemSize={getResponseHeight} // Dynamic based on content
  width="100%"
>
  {({ index, style }) => (
    <div style={style}>
      <ResponseWithTabs response={responses[index]} />
    </div>
  )}
</VariableSizeList>
```

---

### **Question 2: How does WrenAI handle data when returning to historical threads?**

**Answer: Hybrid approach - Chart specs are cached, but query results are REFETCHED.**

**What's Stored in Database:**

✅ **Persisted (Immediate load):**
- Thread metadata (id, summary, timestamp)
- User questions
- Generated SQL statements
- **Chart specifications** (chartType, chartSchema as JSON)
- Answer text content
- Breakdown steps
- Error states

❌ **NOT Persisted (Must refetch):**
- Actual query result data (table rows)
- Chart data values
- Preview data

**Data Flow When Opening Historical Thread:**

```
User clicks thread → GraphQL query:
  ↓
THREAD query fetches:
  {
    id, responses {
      question ✅ (instant)
      sql ✅ (instant)
      chartDetail {
        chartType ✅ (instant)
        chartSchema ✅ (instant)
      }
      answerDetail {
        content ✅ (instant)
      }
    }
  }
  ↓
User sees: Questions, SQL, empty chart placeholders
  ↓
Frontend automatically triggers:
  - previewData(responseId) for each response
  ↓
Backend executes:
  - queryService.preview(response.sql) ← LIVE QUERY
  ↓
User sees: Data populates in tables/charts
```

**Actual Implementation from WrenAI Code:**

```typescript
// askingService.ts - previewData method
public async previewData(responseId: number, limit?: number) {
  const response = await this.repository.findResponseById(responseId);
  const project = await this.projectService.getCurrentProject();
  const mdl = await this.mdlService.getLatestDeployedManifest();

  // Executes LIVE SQL query - NO CACHE
  const data = await this.queryService.preview(response.sql, {
    project,
    manifest: mdl,
    limit,
  });

  return data;
}
```

**What This Means for Users:**

| Scenario | What Happens | User Experience |
|----------|--------------|-----------------|
| Open historical thread | Chart skeletons show immediately, then data loads ~1-2s | ⚠️ Brief loading state |
| Switch between threads | Each thread refetches all data | ⚠️ Repeated wait times |
| Network is slow | Stuck on loading spinners | ⚠️ Poor experience |
| Database is large | Slower query execution | ⚠️ Can be 5-10s+ |

---

### **Recommendations for Your Application**

**Option 1: Cache Query Results (Recommended)**

Store actual query results in database with TTL (time-to-live):

```sql
CREATE TABLE query_result_cache (
  response_id INT PRIMARY KEY,
  data JSONB NOT NULL,
  cached_at TIMESTAMP DEFAULT NOW(),
  ttl_minutes INT DEFAULT 60,
  CONSTRAINT fk_response FOREIGN KEY (response_id) REFERENCES thread_responses(id)
);

-- Auto-delete expired cache
CREATE INDEX idx_cache_expiry ON query_result_cache
  ((cached_at + (ttl_minutes * INTERVAL '1 minute')));
```

**Benefits:**
- Instant load for recent threads
- Configurable freshness (5min, 1hr, 24hr)
- Reduces database load
- Better user experience

**Implementation:**
```javascript
async function getPreviewData(responseId) {
  // Check cache first
  const cached = await db.query(
    `SELECT data FROM query_result_cache
     WHERE response_id = $1
     AND cached_at + (ttl_minutes * INTERVAL '1 minute') > NOW()`,
    [responseId]
  );

  if (cached.rows.length > 0) {
    return cached.rows[0].data; // Instant return
  }

  // Cache miss - execute query
  const freshData = await executeSQL(response.sql);

  // Store in cache
  await db.query(
    `INSERT INTO query_result_cache (response_id, data, ttl_minutes)
     VALUES ($1, $2, $3)
     ON CONFLICT (response_id) DO UPDATE SET data = $2, cached_at = NOW()`,
    [responseId, JSON.stringify(freshData), 60]
  );

  return freshData;
}
```

**Option 2: Apollo Cache with Custom Policy**

Configure longer cache retention for preview data:

```javascript
import { InMemoryCache } from '@apollo/client';

const cache = new InMemoryCache({
  typePolicies: {
    Query: {
      fields: {
        previewData: {
          // Cache for 10 minutes
          merge: false,
          keyArgs: ['where', ['responseId']],
          read(existing, { args }) {
            if (existing && Date.now() - existing.timestamp < 600000) {
              return existing.data;
            }
            return undefined; // Cache miss
          }
        }
      }
    }
  }
});
```

**Option 3: Skeleton UI with Progressive Enhancement**

Show useful content immediately while data loads:

```jsx
<ResponseCard>
  <Question>{response.question}</Question>
  <Tabs>
    <AnswerTab>
      {answerLoading ? (
        <SkeletonTable rows={5} />
      ) : (
        <DataTable data={answerData} />
      )}
    </AnswerTab>
    <SQLTab>
      <CodeBlock code={response.sql} /> {/* Instant */}
    </SQLTab>
    <ChartTab>
      {chartLoading ? (
        <ChartSkeleton type={response.chartType} />
      ) : (
        <Chart spec={response.chartSchema} data={chartData} />
      )}
    </ChartTab>
  </Tabs>
</ResponseCard>
```

**Option 4: Smart Caching Strategy**

Implement tiered caching:

```
Level 1: Browser memory (Apollo cache) - 5 min
Level 2: LocalStorage - 1 hour
Level 3: Database cache - 24 hours
Level 4: Live query - Fallback
```

---

### **Performance Optimization Summary**

| Issue | WrenAI Approach | Your App Should Consider |
|-------|----------------|--------------------------|
| **Long threads** | No optimization (all render) | Virtual scrolling or pagination |
| **Data refetch** | Every time (no cache) | Cache with TTL (1hr recommended) |
| **Chart load** | Lazy (on tab click) | ✅ Keep this - good pattern |
| **Network errors** | Basic error handling | Retry logic + offline indicators |
| **Large datasets** | 500 row limit | Same, or implement server-side pagination |

---

## 12. Component Hierarchy

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
