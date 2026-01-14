# Application Mockups - Text-to-SQL with Three-Tab Architecture

## 1. Landing Page (Initial State)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  [Company Watermark Logo]                                          [🌙 Theme Toggle]   │
└────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────┬─────────────────────────────────────────────────────────────────────────┐
│              │                                                                          │
│  ┌────────┐  │                     Welcome to Text-to-SQL Assistant                    │
│  │ User   │  │                                                                          │
│  │ Menu   │  │                 Start by selecting a question template:                 │
│  └────┬───┘  │                                                                          │
│       │      │  ┌──────────────────────────┐  ┌──────────────────────────┐            │
│  • Database  │  │                          │  │                          │            │
│  • Logout    │  │  📊 Show total revenue   │  │  📈 Top 10 customers    │            │
│  • Help/FAQs │  │     by region            │  │     by sales            │            │
│  • Settings  │  │                          │  │                          │            │
│              │  └──────────────────────────┘  └──────────────────────────┘            │
│──────────────│                                                                          │
│              │  ┌──────────────────────────┐  ┌──────────────────────────┐            │
│ [Dashboard]  │  │                          │  │                          │            │
│              │  │  💰 Monthly recurring    │  │  👥 Active users         │            │
│ [+ New Chat] │  │     revenue trend        │  │     this quarter         │            │
│              │  │                          │  │                          │            │
│──────────────│  └──────────────────────────┘  └──────────────────────────┘            │
│              │                                                                          │
│ Chat Threads │  ┌──────────────────────────┐  ┌──────────────────────────┐            │
│ ────────────│  │                          │  │                          │            │
│              │  │  🔍 Product inventory    │  │  📅 Year-over-year       │            │
│ (empty)      │  │     status               │  │     growth               │            │
│              │  │                          │  │                          │            │
│              │  └──────────────────────────┘  └──────────────────────────┘            │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
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
│  ┌────────┐  │  ┌────────────────────────────────────────────────────────────────┐    │
│  │ User   │  │  │ 👤 You                                              3:45 PM    │    │
│  │ Menu   │  │  │ Show me total revenue by region for Q4 2023                    │    │
│  └────┬───┘  │  └────────────────────────────────────────────────────────────────┘    │
│       │      │                                                                          │
│  • Database  │  ┌────────────────────────────────────────────────────────────────┐    │
│  • Logout    │  │ 🤖 Assistant                                        3:45 PM    │    │
│  • Help/FAQs │  │                                                                 │    │
│  • Settings  │  │ ┌─────────────────────────────────────────────────────────┐   │    │
│              │  │ │ Answer │ View SQL │ Chart                              │   │    │
│──────────────│  │ ├─────────────────────────────────────────────────────────┤   │    │
│              │  │ │                                                         │   │    │
│ [Dashboard]  │  │ │  Here's the total revenue by region for Q4 2023:       │   │    │
│              │  │ │                                                         │   │    │
│ [+ New Chat] │  │ │  ┌──────────────┬────────────────┐                     │   │    │
│              │  │ │  │ Region       │ Total Revenue  │                     │   │    │
│──────────────│  │ │  ├──────────────┼────────────────┤                     │   │    │
│              │  │ │  │ North        │ $2,450,000     │                     │   │    │
│ Chat Threads │  │ │  │ South        │ $1,890,000     │                     │   │    │
│ ────────────│  │ │  │ East         │ $3,120,000     │                     │   │    │
│              │  │ │  │ West         │ $2,760,000     │                     │   │    │
│ Revenue Q4   │  │ │  └──────────────┴────────────────┘                     │   │    │
│   (active)   │  │ │                                                         │   │    │
│              │  │ │  Total across all regions: $10,220,000                 │   │    │
│ Top Customers│  │ │                                                         │   │    │
│              │  │ └─────────────────────────────────────────────────────────┘   │    │
│ Inventory    │  └────────────────────────────────────────────────────────────────┘    │
│              │                                                                          │
│              │                                                                          │
│              │                                                                          │
│              │  ┌────────────────────────────────────────────────────────────────┐    │
│              │  │  💬 Ask a follow-up question...                     [Submit]   │    │
│              │  └────────────────────────────────────────────────────────────────┘    │
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

## 6. Dashboard View (Pinned Charts)

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│  [Company Watermark Logo]                                          [🌙 Theme Toggle]   │
└────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────┬─────────────────────────────────────────────────────────────────────────┐
│              │                                                                          │
│  ┌────────┐  │  Dashboard                                          [⚙️ Settings] [🔄 Refresh All] │
│  │ User   │  │  ═══════════                                                            │
│  │ Menu   │  │                                                                          │
│  └────┬───┘  │  ┌──────────────────────────────┐  ┌──────────────────────────────┐   │
│       │      │  │ Q4 2023 Revenue by Region ⋮ │  │ Top 10 Customers by Sales ⋮  │   │
│  • Database  │  │ ┌──────────────────────────┐ │  │ ┌──────────────────────────┐ │   │
│  • Logout    │  │ │                          │ │  │ │                          │ │   │
│  • Help/FAQs │  │ │     Bar Chart            │ │  │ │    Horizontal Bar Chart  │ │   │
│  • Settings  │  │ │                          │ │  │ │                          │ │   │
│              │  │ │   [Chart Visualization]  │ │  │ │  [Chart Visualization]   │ │   │
│──────────────│  │ │                          │ │  │ │                          │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│ [Dashboard]  │  │ └──────────────────────────┘ │  │ └──────────────────────────┘ │   │
│   (active)   │  │ Last updated: 5 mins ago     │  │ Last updated: 2 mins ago     │   │
│              │  └──────────────────────────────┘  └──────────────────────────────┘   │
│ [+ New Chat] │                                                                          │
│              │  ┌──────────────────────────────┐  ┌──────────────────────────────┐   │
│──────────────│  │ Monthly Recurring Revenue ⋮  │  │ Active Users Trend       ⋮   │   │
│              │  │ ┌──────────────────────────┐ │  │ ┌──────────────────────────┐ │   │
│ Chat Threads │  │ │                          │ │  │ │                          │ │   │
│ ────────────│  │ │    Line Chart            │ │  │ │    Area Chart            │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│ Revenue Q4   │  │ │  [Chart Visualization]   │ │  │ │  [Chart Visualization]   │ │   │
│              │  │ │                          │ │  │ │                          │ │   │
│ Top Customers│  │ │                          │ │  │ │                          │ │   │
│              │  │ └──────────────────────────┘ │  │ └──────────────────────────┘ │   │
│ Inventory    │  │ Last updated: 10 mins ago    │  │ Last updated: 1 min ago      │   │
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
└──────────────┴─────────────────────────────────────────────────────────────────────────┘

Note: Each chart card has a ⋮ (three-dot) menu with options:
  • Edit Chart Properties
  • Refresh Data
  • Toggle Legend
  • Unpin from Dashboard
  • Delete
```

---

## 7. Nav Drawer - Expanded User Menu

```
┌──────────────┐
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
│──────────────│
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
└──────────────┘
```

---

## 8. Nav Drawer - With Dashboard and New Chat Buttons

```
┌──────────────────┐
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
│──────────────────│
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
└──────────────────┘
```

---

## 9. Complete Application Flow

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

## 10. Component Hierarchy

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
