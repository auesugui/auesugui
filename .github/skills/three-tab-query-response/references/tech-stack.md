# Technology Stack & Patterns

## Core Technologies

### UI Framework
**React 19 with JavaScript + PropTypes**
- No TypeScript - using PropTypes for runtime type checking
- Functional components with hooks
- Vite for build tooling

### Component Library
**Salt DS (Salt Design System)**
- Components: `Tabs`, `TabPanel`, `Button`, `Card`, `Table`, etc.
- Provides consistent enterprise UI patterns
- Accessible by default

**Key Salt DS Components:**
```jsx
import {
  Tabs,
  TabPanel,
  Button,
  Card,
  Table,
  TableHead,
  TableBody,
  TableRow,
  TableCell,
  Spinner,
} from '@salt-ds/core';
```

### Chart Library
**Apache ECharts**
- Robust charting library with extensive chart types
- Use `echarts-for-react` wrapper for React integration
- Supports bar, line, pie, area, and complex visualizations

**Installation:**
```bash
npm install echarts echarts-for-react
```

**Usage Pattern:**
```jsx
import ReactECharts from 'echarts-for-react';

const option = {
  title: { text: 'Revenue by Region' },
  xAxis: {
    type: 'category',
    data: ['North', 'South', 'East', 'West'],
  },
  yAxis: { type: 'value' },
  series: [{
    data: [2450000, 1890000, 3120000, 2760000],
    type: 'bar',
  }],
};

<ReactECharts option={option} style={{ height: '400px' }} />
```

### Data Grid

**Current: AG Grid** (may replace)
- Heavy package for simple use case
- Consider replacing with custom table or Salt DS Table

**Alternative: Custom Lightweight Table**
```jsx
function DataTable({ data }) {
  if (!data?.length) return <EmptyState />;

  const columns = Object.keys(data[0]);

  return (
    <div className="data-table">
      <div className="table-header">
        {columns.map(col => (
          <div key={col} className="header-cell">
            {col}
          </div>
        ))}
      </div>
      <div className="table-body">
        {data.slice(0, 500).map((row, idx) => (
          <div key={idx} className="table-row">
            {columns.map(col => (
              <div key={col} className="table-cell">
                {row[col]}
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
```

### State Management
**useLocalStorage Hook**
- Custom hook for localStorage persistence
- No Redux or complex state management
- Simple, lightweight pattern

**Hook Implementation:**
```jsx
import { useState, useEffect } from 'prop-types';

function useLocalStorage(key, initialValue) {
  const [value, setValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error('Error loading from localStorage:', error);
      return initialValue;
    }
  });

  useEffect(() => {
    try {
      window.localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      console.error('Error saving to localStorage:', error);
    }
  }, [key, value]);

  return [value, setValue];
}

export default useLocalStorage;
```

**Usage:**
```jsx
const [pinnedCharts, setPinnedCharts] = useLocalStorage('pinned-charts', []);
const [activeTab, setActiveTab] = useLocalStorage('thread-1-response-5-tab', 'answer');
```

### Database (PostgreSQL/MySQL)
**Primary data persistence layer**
- Thread and response storage
- Query result caching with TTL
- User preferences and settings
- Dashboard layout persistence

**Recommended Schema:**
```sql
-- Thread storage
CREATE TABLE threads (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255),
  summary TEXT,
  primary_topic VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  last_accessed TIMESTAMP DEFAULT NOW(),
  is_archived BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_threads_user_id ON threads(user_id);
CREATE INDEX idx_threads_last_accessed ON threads(last_accessed DESC);

-- Response storage
CREATE TABLE thread_responses (
  id SERIAL PRIMARY KEY,
  thread_id INT REFERENCES threads(id) ON DELETE CASCADE,
  role VARCHAR(20) CHECK (role IN ('user', 'assistant')),
  question TEXT,
  sql TEXT,
  metadata JSONB,
  chart_spec JSONB,
  result_count INT,
  execution_time_ms INT,
  was_successful BOOLEAN DEFAULT TRUE,
  error_message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_responses_thread_id ON thread_responses(thread_id);
CREATE INDEX idx_responses_created_at ON thread_responses(created_at DESC);

-- Query result cache (15-minute TTL recommended)
CREATE TABLE query_result_cache (
  response_id INT PRIMARY KEY REFERENCES thread_responses(id) ON DELETE CASCADE,
  data JSONB NOT NULL,
  cached_at TIMESTAMP DEFAULT NOW(),
  ttl_minutes INT DEFAULT 15,
  size_bytes INT
);

CREATE INDEX idx_cache_expiry ON query_result_cache
  ((cached_at + (ttl_minutes * INTERVAL '1 minute')));

-- Scheduled cleanup job (run every hour)
-- DELETE FROM query_result_cache
-- WHERE cached_at + (ttl_minutes * INTERVAL '1 minute') < NOW();

-- Pinned charts (dashboard)
CREATE TABLE pinned_charts (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255),
  description TEXT,
  chart_spec JSONB NOT NULL,
  data JSONB NOT NULL,
  sql TEXT,
  position JSONB, -- { x, y, w, h } for grid layout
  tags TEXT[],
  created_at TIMESTAMP DEFAULT NOW(),
  last_refreshed TIMESTAMP DEFAULT NOW(),
  view_count INT DEFAULT 0
);

CREATE INDEX idx_pinned_charts_user_id ON pinned_charts(user_id);

-- Context tracking (for context drift detection)
CREATE TABLE thread_context (
  thread_id INT PRIMARY KEY REFERENCES threads(id) ON DELETE CASCADE,
  primary_topic TEXT,
  related_entities TEXT[],
  sql_tables_focused TEXT[],
  last_updated TIMESTAMP DEFAULT NOW()
);
```

### Elasticsearch
**Search, discovery, and analytics engine**
- Full-text search across query history
- Semantic search for similar queries
- Thread and chart search
- Query analytics and insights
- Real-time autocomplete suggestions

**Key Indices:**
```javascript
// query-history index
{
  "mappings": {
    "properties": {
      "query_id": { "type": "keyword" },
      "thread_id": { "type": "keyword" },
      "user_id": { "type": "keyword" },
      "question": { "type": "text", "analyzer": "standard" },
      "sql": { "type": "text", "analyzer": "sql_analyzer" },
      "tables_used": { "type": "keyword" },
      "topic_category": { "type": "keyword" },
      "was_successful": { "type": "boolean" },
      "timestamp": { "type": "date" },
      "question_embedding": {
        "type": "dense_vector",
        "dims": 384  // For semantic search
      }
    }
  }
}
```

**Integration Pattern:**
```javascript
// Index queries after successful execution
async function executeAndIndexQuery(query) {
  const result = await executeSQL(query.sql);

  // Save to database
  const response = await db.threadResponses.create({
    thread_id: query.threadId,
    question: query.question,
    sql: query.sql,
    // ... other fields
  });

  // Index in Elasticsearch for search
  await elasticsearch.index({
    index: 'query-history',
    body: {
      query_id: response.id,
      question: query.question,
      sql: query.sql,
      tables_used: extractTables(query.sql),
      timestamp: new Date(),
      // ... other fields
    }
  });

  return result;
}
```

**Search Features Enabled:**
- 🔍 Global search bar for finding past queries
- 💡 "Similar queries" suggestions
- 📊 Query analytics dashboard
- ⚡ Real-time autocomplete
- 🎨 Searchable chart gallery

For detailed implementation, see [elasticsearch-integration.md](elasticsearch-integration.md)

## Performance Patterns

### Virtual Scrolling
**react-window for Long Threads**
```bash
npm install react-window
```

```jsx
import { VariableSizeList } from 'react-window';

function ThreadList({ responses }) {
  const getItemSize = (index) => {
    // Calculate height based on content
    return responses[index].height || 400;
  };

  return (
    <VariableSizeList
      height={window.innerHeight - 200}
      itemCount={responses.length}
      itemSize={getItemSize}
      width="100%"
    >
      {({ index, style }) => (
        <div style={style}>
          <ResponseCard response={responses[index]} />
        </div>
      )}
    </VariableSizeList>
  );
}
```

### Lazy Loading
**Chart Generation on Demand**
```jsx
function ChartTab({ responseId }) {
  const [chartGenerated, setChartGenerated] = useLocalStorage(
    `chart-${responseId}-generated`,
    false
  );

  useEffect(() => {
    if (!chartGenerated) {
      generateChart(responseId).then(() => {
        setChartGenerated(true);
      });
    }
  }, [responseId, chartGenerated]);

  return chartGenerated ? <Chart /> : <Skeleton />;
}
```

### Caching Strategy
**15-Minute TTL for Query Results**
```jsx
function useCachedQuery(responseId, sql) {
  const cacheKey = `query-cache-${responseId}`;
  const [cached, setCached] = useLocalStorage(cacheKey, null);

  const fetchData = async () => {
    // Check cache
    if (cached && Date.now() - cached.timestamp < 15 * 60 * 1000) {
      return cached.data;
    }

    // Fetch fresh data
    const freshData = await executeSQL(sql);

    // Update cache
    setCached({
      data: freshData,
      timestamp: Date.now(),
    });

    return freshData;
  };

  return { fetchData, isCached: !!cached };
}
```

## Additional Dependencies

### Syntax Highlighting
```bash
npm install react-syntax-highlighter
```

```jsx
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { oneDark } from 'react-syntax-highlighter/dist/esm/styles/prism';

<SyntaxHighlighter language="sql" style={oneDark}>
  {sqlQuery}
</SyntaxHighlighter>
```

### Dashboard Grid Layout
```bash
npm install react-grid-layout
```

```jsx
import GridLayout from 'react-grid-layout';
import 'react-grid-layout/css/styles.css';

function Dashboard({ pinnedCharts }) {
  const layout = pinnedCharts.map(chart => ({
    i: chart.id,
    x: chart.position.x,
    y: chart.position.y,
    w: chart.position.w,
    h: chart.position.h,
  }));

  return (
    <GridLayout
      className="layout"
      layout={layout}
      cols={6}
      rowHeight={100}
      width={1200}
      onLayoutChange={handleLayoutChange}
    >
      {pinnedCharts.map(chart => (
        <div key={chart.id}>
          <ChartCard chart={chart} />
        </div>
      ))}
    </GridLayout>
  );
}
```

## File Structure

```
src/
├── components/
│   ├── ChatThread/
│   │   ├── index.jsx
│   │   ├── ChatInput.jsx
│   │   └── ResponseMessage.jsx
│   ├── ThreeTabResponse/
│   │   ├── index.jsx
│   │   ├── AnswerTab.jsx
│   │   ├── ViewSQLTab.jsx
│   │   ├── ChartTab.jsx
│   │   └── TabPanel.jsx
│   ├── Dashboard/
│   │   ├── index.jsx
│   │   ├── DashboardGrid.jsx
│   │   ├── ChartCard.jsx
│   │   └── DashboardHeader.jsx
│   ├── Navigation/
│   │   ├── NavDrawer.jsx
│   │   ├── UserMenu.jsx
│   │   └── ThreadList.jsx
│   └── shared/
│       ├── Skeleton.jsx
│       ├── ErrorState.jsx
│       └── EmptyState.jsx
├── hooks/
│   ├── useLocalStorage.js
│   ├── useCachedQuery.js
│   └── useChartGeneration.js
├── utils/
│   ├── sqlExecutor.js
│   ├── chartGenerator.js
│   └── dataFormatter.js
└── App.jsx
```

## Code Style Guidelines

### PropTypes Usage
Always define PropTypes for components:
```jsx
import PropTypes from 'prop-types';

function ComponentName({ prop1, prop2 }) {
  return <div>{prop1}</div>;
}

ComponentName.propTypes = {
  prop1: PropTypes.string.isRequired,
  prop2: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
  }),
};

ComponentName.defaultProps = {
  prop2: null,
};
```

### Naming Conventions
- Components: PascalCase (`ThreeTabResponse`, `AnswerTab`)
- Hooks: camelCase with `use` prefix (`useLocalStorage`, `useCachedQuery`)
- Utilities: camelCase (`executeSQL`, `formatData`)
- Constants: UPPER_SNAKE_CASE (`MAX_ROWS`, `CACHE_TTL_MS`)

### localStorage Keys
Use consistent naming pattern:
- Thread responses: `thread-{threadId}`
- Tab state: `response-{responseId}-tab`
- Chart generation: `response-{responseId}-chart-generated`
- Query cache: `query-cache-{responseId}`
- Pinned charts: `pinned-charts`

## Testing Strategy

### Component Testing
```jsx
import { render, screen, fireEvent } from '@testing-library/react';
import ThreeTabResponse from './ThreeTabResponse';

test('switches between tabs', () => {
  render(<ThreeTabResponse response={mockResponse} />);

  const answerTab = screen.getByText('Answer');
  const sqlTab = screen.getByText('View SQL');

  fireEvent.click(sqlTab);

  expect(screen.getByText(/Generated SQL Query/i)).toBeInTheDocument();
});

test('lazy loads chart on first click', () => {
  const mockGenerate = jest.fn();
  render(<ThreeTabResponse response={mockResponse} onGenerateChart={mockGenerate} />);

  const chartTab = screen.getByText('Chart');

  fireEvent.click(chartTab);

  expect(mockGenerate).toHaveBeenCalledTimes(1);

  // Click again - should not regenerate
  fireEvent.click(answerTab);
  fireEvent.click(chartTab);

  expect(mockGenerate).toHaveBeenCalledTimes(1);
});
```

### Integration Testing
Test full workflow from query to chart pinning:
1. Submit query
2. Verify Answer tab displays data
3. Switch to SQL tab, verify SQL shown
4. Switch to Chart tab, verify chart generates
5. Pin chart to dashboard
6. Verify chart appears on dashboard

## Performance Targets

- **Initial Thread Load**: < 500ms
- **Tab Switch**: < 100ms (instant)
- **Chart Generation**: < 2s
- **Cache Hit**: < 50ms
- **Virtual Scroll**: 60 FPS with 100+ responses
- **Dashboard Load**: < 1s for 10 pinned charts
