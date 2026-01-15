---
name: three-tab-query-response
description: Implement WrenAI-inspired three-tab architecture (Answer/View SQL/Chart) for text-to-SQL applications. Use when building query response interfaces with data tables, SQL display, and chart visualizations. Includes patterns for multi-response threads, chart pinning to dashboard, performance optimization with virtualization, and data caching strategies. Designed for React with Salt DS components, Apache ECharts, and localStorage state management.
---

# Three-Tab Query Response Architecture

This skill provides comprehensive guidance for implementing a three-tab response interface for text-to-SQL applications, based on WrenAI's proven architecture with optimizations for performance and user experience.

## Overview

The three-tab architecture displays SQL query results in three complementary views:
- **Answer Tab**: Data table with summary insights (default view)
- **View SQL Tab**: Generated SQL query with execution metadata
- **Chart Tab**: Data visualization with pinning capability

Each assistant response in a conversation thread gets its own independent three-tab panel, enabling side-by-side comparison of multiple queries.

## Architecture Components

### Core Features
1. **Independent Tab State**: Each response maintains its own tab selection
2. **Lazy Loading**: Chart tab generates visualizations only when clicked
3. **Thread Continuity**: All responses remain visible and interactive
4. **Chart Pinning**: Users can pin charts from any response to a dashboard
5. **Performance Optimization**: Virtual scrolling for long threads
6. **Data Caching**: Smart caching to reduce re-querying

## Tech Stack

This implementation uses:
- **React** with JavaScript and PropTypes
- **Salt DS** components for UI (Tabs, Cards, Buttons, etc.)
- **Apache ECharts** for chart visualizations
- **useLocalStorage** hook for client-side state management
- **Database** for query result caching (optional but recommended)

For detailed mockups and visual specifications, see [references/mockups.md](references/mockups.md) or the [root MOCKUPS.md](../../../MOCKUPS.md).
For technology decisions and patterns, see [references/tech-stack.md](references/tech-stack.md).
For dashboard patterns and best practices, see [references/dashboard-patterns.md](references/dashboard-patterns.md).

## Implementation Workflow

### Step 1: Set Up Base Thread Structure

Create the conversation thread container with virtual scrolling:

```jsx
import { VariableSizeList } from 'react-window';
import { useLocalStorage } from '@/hooks/useLocalStorage';

function ChatThread({ threadId }) {
  const [responses, setResponses] = useLocalStorage(`thread-${threadId}`, []);

  return (
    <div className="chat-thread">
      <VariableSizeList
        height={window.innerHeight - 200}
        itemCount={responses.length}
        itemSize={(index) => responses[index].height || 400}
        width="100%"
      >
        {({ index, style }) => (
          <div style={style}>
            <ResponseMessage
              response={responses[index]}
              isUser={responses[index].role === 'user'}
            />
          </div>
        )}
      </VariableSizeList>

      <ChatInput onSubmit={handleNewQuery} />
    </div>
  );
}
```

**Key Points:**
- Use `react-window` for performance with long threads
- Store responses in localStorage with thread ID as key
- Calculate dynamic heights based on content

### Step 2: Create Three-Tab Response Component

Implement the tabbed interface for assistant responses:

```jsx
import { Tabs, TabPanel } from '@salt-ds/core';
import PropTypes from 'prop-types';

function ThreeTabResponse({ response }) {
  const [activeTab, setActiveTab] = useLocalStorage(
    `response-${response.id}-tab`,
    'answer'
  );
  const [chartGenerated, setChartGenerated] = useLocalStorage(
    `response-${response.id}-chart-generated`,
    false
  );

  const handleTabChange = (newTab) => {
    setActiveTab(newTab);

    // Lazy load chart on first click
    if (newTab === 'chart' && !chartGenerated) {
      generateChart(response.id);
      setChartGenerated(true);
    }
  };

  return (
    <div className="three-tab-response">
      <Tabs value={activeTab} onChange={handleTabChange}>
        <Tab value="answer">Answer</Tab>
        <Tab value="sql">View SQL</Tab>
        <Tab value="chart">Chart</Tab>
      </Tabs>

      <TabPanel value="answer" active={activeTab === 'answer'}>
        <AnswerTab data={response.data} summary={response.summary} />
      </TabPanel>

      <TabPanel value="sql" active={activeTab === 'sql'}>
        <ViewSQLTab sql={response.sql} metadata={response.metadata} />
      </TabPanel>

      <TabPanel value="chart" active={activeTab === 'chart'}>
        {chartGenerated ? (
          <ChartTab
            chartSpec={response.chartSpec}
            data={response.data}
            onPin={() => handlePinChart(response.id)}
          />
        ) : (
          <div>Click to generate chart...</div>
        )}
      </TabPanel>
    </div>
  );
}

ThreeTabResponse.propTypes = {
  response: PropTypes.shape({
    id: PropTypes.string.isRequired,
    data: PropTypes.array.isRequired,
    sql: PropTypes.string.isRequired,
    summary: PropTypes.string,
    metadata: PropTypes.object,
    chartSpec: PropTypes.object,
  }).isRequired,
};
```

**Key Points:**
- Persist tab selection in localStorage per response
- Implement lazy loading for chart generation
- Use Salt DS Tabs component for consistent UI

### Step 3: Implement Answer Tab

Create the data table view with summary insights:

```jsx
import { Table, TableBody, TableCell, TableHead, TableRow } from '@salt-ds/core';

function AnswerTab({ data, summary }) {
  if (!data || data.length === 0) {
    return <div className="empty-state">No results found</div>;
  }

  const columns = Object.keys(data[0]);

  return (
    <div className="answer-tab">
      {/* Data Table */}
      <Table>
        <TableHead>
          <TableRow>
            {columns.map((col) => (
              <TableCell key={col}>{col}</TableCell>
            ))}
          </TableRow>
        </TableHead>
        <TableBody>
          {data.slice(0, 500).map((row, idx) => (
            <TableRow key={idx}>
              {columns.map((col) => (
                <TableCell key={col}>{row[col]}</TableCell>
              ))}
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {/* Summary Insights */}
      {summary && (
        <div className="summary-section">
          <h4>📊 Summary</h4>
          <p>{summary}</p>
        </div>
      )}

      {data.length > 500 && (
        <div className="row-limit-notice">
          Showing first 500 of {data.length.toLocaleString()} rows
        </div>
      )}
    </div>
  );
}

AnswerTab.propTypes = {
  data: PropTypes.arrayOf(PropTypes.object).isRequired,
  summary: PropTypes.string,
};
```

**Alternative: Custom Lightweight Table**

If Salt DS tables are too heavy, create a simple custom table:

```jsx
function LightweightTable({ data }) {
  const columns = Object.keys(data[0]);

  return (
    <div className="data-table">
      <div className="table-header">
        {columns.map(col => (
          <div key={col} className="header-cell">{col}</div>
        ))}
      </div>
      <div className="table-body">
        {data.slice(0, 500).map((row, idx) => (
          <div key={idx} className="table-row">
            {columns.map(col => (
              <div key={col} className="table-cell">{row[col]}</div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
```

### Step 4: Implement View SQL Tab

Display SQL query with syntax highlighting and execution metadata:

```jsx
import { Button, Card } from '@salt-ds/core';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { oneDark } from 'react-syntax-highlighter/dist/esm/styles/prism';

function ViewSQLTab({ sql, metadata }) {
  const [showResults, setShowResults] = useState(false);

  const handleCopySQL = () => {
    navigator.clipboard.writeText(sql);
    // Show toast notification
  };

  return (
    <div className="view-sql-tab">
      <div className="sql-header">
        <h4>Generated SQL Query</h4>
        <div className="actions">
          <Button onClick={handleCopySQL}>Copy SQL</Button>
          <Button onClick={() => {/* Edit SQL */}}>Edit SQL</Button>
        </div>
      </div>

      <SyntaxHighlighter language="sql" style={oneDark}>
        {sql}
      </SyntaxHighlighter>

      {metadata && (
        <Card className="metadata-card">
          <div>ℹ️ Query executed on: {metadata.database}</div>
          <div>⏱️ Execution time: {metadata.executionTime}s</div>
          <div>📊 Rows returned: {metadata.rowCount}</div>
        </Card>
      )}

      <Button onClick={() => setShowResults(!showResults)}>
        {showResults ? 'Hide' : 'View'} Results
      </Button>

      {showResults && <DataPreview sql={sql} />}
    </div>
  );
}

ViewSQLTab.propTypes = {
  sql: PropTypes.string.isRequired,
  metadata: PropTypes.shape({
    database: PropTypes.string,
    executionTime: PropTypes.number,
    rowCount: PropTypes.number,
  }),
};
```

### Step 5: Implement Chart Tab with Apache ECharts

Create chart visualizations with pinning capability:

```jsx
import ReactECharts from 'echarts-for-react';
import { Button } from '@salt-ds/core';

function ChartTab({ chartSpec, data, onPin }) {
  const [isEditing, setIsEditing] = useState(false);

  // Transform data for ECharts
  const option = useMemo(() => {
    if (!chartSpec || !data) return null;

    // Example: Bar chart
    return {
      title: { text: chartSpec.title || 'Query Results' },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: data.map(row => row[chartSpec.xField]),
      },
      yAxis: { type: 'value' },
      series: [{
        name: chartSpec.yField,
        type: chartSpec.type || 'bar', // bar, line, pie, etc.
        data: data.map(row => row[chartSpec.yField]),
      }],
    };
  }, [chartSpec, data]);

  if (!option) {
    return <div>Unable to generate chart</div>;
  }

  return (
    <div className="chart-tab">
      <div className="chart-controls">
        <Button onClick={() => setIsEditing(!isEditing)}>
          Edit Chart
        </Button>
        <Button onClick={() => {/* Regenerate */}}>
          Regenerate
        </Button>
        <Button onClick={onPin} variant="primary">
          📌 Pin to Dashboard
        </Button>
      </div>

      {isEditing && <ChartPropertiesPanel spec={chartSpec} />}

      <ReactECharts
        option={option}
        style={{ height: '400px', width: '100%' }}
        notMerge={true}
        lazyUpdate={true}
      />

      <div className="chart-legend">
        Chart Type: {chartSpec.type || 'bar'}
      </div>
    </div>
  );
}

ChartTab.propTypes = {
  chartSpec: PropTypes.shape({
    title: PropTypes.string,
    type: PropTypes.oneOf(['bar', 'line', 'pie', 'area']),
    xField: PropTypes.string.isRequired,
    yField: PropTypes.string.isRequired,
  }).isRequired,
  data: PropTypes.array.isRequired,
  onPin: PropTypes.func.isRequired,
};
```

### Step 6: Implement Chart Pinning to Dashboard

Handle pinning charts for dashboard persistence:

```jsx
function handlePinChart(responseId) {
  const [pinnedCharts, setPinnedCharts] = useLocalStorage('pinned-charts', []);

  const response = responses.find(r => r.id === responseId);

  const chartData = {
    id: `chart-${Date.now()}`,
    title: response.question,
    chartSpec: response.chartSpec,
    data: response.data,
    sql: response.sql,
    createdAt: new Date().toISOString(),
  };

  setPinnedCharts([...pinnedCharts, chartData]);

  // Show success notification
  showToast('Chart pinned to dashboard!');
}
```

### Step 7: Implement Performance Optimizations

Add data caching and loading states:

```jsx
// Cache hook for query results
function useCachedQuery(responseId, sql) {
  const cacheKey = `query-cache-${responseId}`;
  const [cached, setCached] = useLocalStorage(cacheKey, null);

  const fetchData = async () => {
    // Check cache first
    if (cached && Date.now() - cached.timestamp < 15 * 60 * 1000) {
      return cached.data; // 15 min TTL
    }

    // Execute query
    const freshData = await executeSQL(sql);

    // Store in cache
    setCached({
      data: freshData,
      timestamp: Date.now(),
    });

    return freshData;
  };

  return { fetchData, isCached: !!cached };
}
```

**Loading States:**

```jsx
function ThreeTabResponse({ response }) {
  const [loading, setLoading] = useState(false);
  const { fetchData, isCached } = useCachedQuery(response.id, response.sql);

  useEffect(() => {
    if (!response.data) {
      setLoading(true);
      fetchData()
        .then(data => setResponseData(data))
        .finally(() => setLoading(false));
    }
  }, [response.id]);

  if (loading) {
    return (
      <div className="response-loading">
        <Spinner />
        <p>{isCached ? 'Loading from cache...' : 'Executing query...'}</p>
      </div>
    );
  }

  return <ThreeTabPanel response={response} />;
}
```

## Dashboard Implementation

For displaying pinned charts, see [references/dashboard-patterns.md](references/dashboard-patterns.md).

## Design Decisions

### Why Three Tabs?
- **Answer**: Primary view for data consumption
- **SQL**: Transparency and debugging for power users
- **Chart**: Visual insights for stakeholders

### Why Independent State Per Response?
- Enables comparison across multiple queries
- Preserves user's exploration path
- Avoids tab state conflicts in multi-response threads

### Why Lazy Load Charts?
- Reduces initial load time
- Saves API calls for unused visualizations
- Better performance for text-heavy exploration

### Why Pin Charts Instead of Caching?
WrenAI's philosophy: Users explicitly choose what insights to save. This:
- Reduces clutter (vs auto-caching everything)
- Provides clear data freshness on dashboard
- Separates exploration (threads) from insights (dashboard)

**Our Hybrid Approach:**
- Short TTL cache (15 min) for thread exploration
- Dashboard for long-term saved insights
- Clear "Last refreshed" indicators

## Common Patterns

### Skeleton Loading
Show structure while data loads:

```jsx
function SkeletonTable({ rows = 5, columns = 4 }) {
  return (
    <div className="skeleton-table">
      {[...Array(rows)].map((_, i) => (
        <div key={i} className="skeleton-row">
          {[...Array(columns)].map((_, j) => (
            <div key={j} className="skeleton-cell" />
          ))}
        </div>
      ))}
    </div>
  );
}
```

### Error Handling
Handle query failures gracefully:

```jsx
function ErrorState({ error, onRetry }) {
  return (
    <Card className="error-state">
      <h4>⚠️ Query Failed</h4>
      <p>{error.message}</p>
      {error.sql && (
        <details>
          <summary>View SQL</summary>
          <pre>{error.sql}</pre>
        </details>
      )}
      <Button onClick={onRetry}>Retry Query</Button>
    </Card>
  );
}
```

## Testing Considerations

1. **Test tab state persistence** across page reloads
2. **Test lazy loading** ensures charts only generate once
3. **Test virtual scrolling** with 50+ responses
4. **Test cache expiration** and refresh logic
5. **Test pinning** doesn't duplicate charts on dashboard

## Performance Checklist

- [ ] Virtual scrolling implemented for threads
- [ ] Chart lazy loading on tab click
- [ ] Query result caching (15 min TTL)
- [ ] Skeleton UI during data fetch
- [ ] Debounce chart regeneration
- [ ] Limit table rows to 500
- [ ] Clean up old localStorage entries

## Resources

For comprehensive mockups and visual specifications:
- See [references/mockups.md](references/mockups.md) - All UI mockups and flows

For technical implementation details:
- See [references/tech-stack.md](references/tech-stack.md) - Technology choices and patterns
- See [references/dashboard-patterns.md](references/dashboard-patterns.md) - Dashboard grid implementation
