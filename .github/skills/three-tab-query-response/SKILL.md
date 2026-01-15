---
name: three-tab-query-response
description: Implement WrenAI-inspired three-tab architecture (Answer/View SQL/Chart) for text-to-SQL applications. Use when building query response interfaces with data tables, SQL display, and chart visualizations. Includes patterns for multi-response threads, chart pinning to dashboard, context drift detection and handling, performance optimization with virtualization, and data caching strategies. Designed for React with Salt DS components, Apache ECharts, and localStorage state management.
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
5. **Context Drift Detection**: Intelligent detection and guidance when users switch topics
6. **Performance Optimization**: Virtual scrolling for long threads
7. **Data Caching**: Smart caching to reduce re-querying

## Tech Stack

This implementation uses:
- **React** with JavaScript and PropTypes
- **Salt DS** components for UI (Tabs, Cards, Buttons, etc.)
- **Apache ECharts** for chart visualizations
- **useLocalStorage** hook for client-side state management
- **Database** for query result caching (optional but recommended)

**Reference Documentation:**
- [references/mockups.md](references/mockups.md) or [root MOCKUPS.md](../../../MOCKUPS.md) - Visual specifications and UI flows
- [references/tech-stack.md](references/tech-stack.md) - Technology decisions and patterns
- [references/dashboard-patterns.md](references/dashboard-patterns.md) - Dashboard grid implementation
- [references/context-drift-patterns.md](references/context-drift-patterns.md) - Context drift detection strategies

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

### Step 8: Implement Context Drift Detection and Handling

One of the most critical challenges in multi-turn text-to-SQL conversations is context drift - when users switch topics or datasets mid-thread, potentially causing the AI to generate incorrect queries.

**Recommended Approach: Hybrid Guidance System**

Instead of forcing new threads or allowing unrestricted topic switching, implement an intelligent guidance system that:
- Detects potential context switches
- Guides users toward best practices
- Allows override for edge cases
- Makes thread scope transparent

#### Thread Context Tracking

Track the conversation context to detect topic switches:

```jsx
import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';

function ChatThread({ threadId }) {
  const [messages, setMessages] = useState([]);
  const [threadContext, setThreadContext] = useState({
    primaryTopic: null,
    relatedEntities: [],
    sqlTablesFocused: [],
    lastUpdated: null,
  });

  // Update context when new SQL is generated
  const updateThreadContext = (newResponse) => {
    const tables = extractTablesFromSQL(newResponse.sql);
    const entities = extractEntitiesFromQuestion(newResponse.question);

    setThreadContext(prev => ({
      primaryTopic: prev.primaryTopic || newResponse.question,
      relatedEntities: [...new Set([...prev.relatedEntities, ...entities])],
      sqlTablesFocused: [...new Set([...prev.sqlTablesFocused, ...tables])],
      lastUpdated: Date.now(),
    }));
  };

  return (
    <div className="chat-thread">
      <ThreadContextBadge context={threadContext} />
      <MessageList messages={messages} />
      <ChatInput
        onSubmit={(query) => handleSubmitQuery(query, threadContext)}
      />
    </div>
  );
}

ChatThread.propTypes = {
  threadId: PropTypes.string.isRequired,
};
```

#### Context Similarity Detection

Detect when a query is unrelated to the current thread:

```jsx
// Simple entity-based detection
function detectContextShift(newQuery, threadContext) {
  const newEntities = extractEntitiesFromQuestion(newQuery);
  const newTables = extractTableReferences(newQuery);

  // Calculate overlap with existing context
  const entityOverlap = newEntities.filter(e =>
    threadContext.relatedEntities.includes(e)
  ).length;

  const tableOverlap = newTables.filter(t =>
    threadContext.sqlTablesFocused.includes(t)
  ).length;

  const entitySimilarity = entityOverlap / Math.max(newEntities.length, 1);
  const tableSimilarity = tableOverlap / Math.max(newTables.length, 1);

  // Determine shift severity
  if (entitySimilarity < 0.2 && tableSimilarity === 0) {
    return { type: 'major', confidence: 'high' };
  } else if (entitySimilarity < 0.4 || tableSimilarity < 0.5) {
    return { type: 'minor', confidence: 'medium' };
  }

  return { type: 'continuation', confidence: 'high' };
}

// Helper functions
function extractEntitiesFromQuestion(question) {
  // Simple keyword extraction (can be enhanced with NLP)
  const keywords = question.toLowerCase()
    .split(/\s+/)
    .filter(word => word.length > 4);
  return keywords;
}

function extractTableReferences(query) {
  // Extract table names from query or use database schema matching
  const tablePattern = /\b(allocations|issues|users|projects|revenue|customers)\b/gi;
  return [...new Set((query.match(tablePattern) || []).map(t => t.toLowerCase()))];
}

function extractTablesFromSQL(sql) {
  // Extract FROM and JOIN table references
  const fromPattern = /FROM\s+(\w+)/gi;
  const joinPattern = /JOIN\s+(\w+)/gi;

  const tables = [
    ...(sql.match(fromPattern) || []).map(m => m.replace(/FROM\s+/i, '')),
    ...(sql.match(joinPattern) || []).map(m => m.replace(/JOIN\s+/i, '')),
  ];

  return [...new Set(tables.map(t => t.toLowerCase()))];
}
```

#### Context Switch Warning Dialog

Show a prompt when major context shift is detected:

```jsx
import { Dialog, Button } from '@salt-ds/core';
import PropTypes from 'prop-types';

function ContextSwitchDialog({
  isOpen,
  onClose,
  currentTopic,
  newQuery,
  onContinue,
  onNewThread
}) {
  return (
    <Dialog open={isOpen} onClose={onClose}>
      <Dialog.Header>
        <Dialog.Title>Starting a new topic?</Dialog.Title>
      </Dialog.Header>

      <Dialog.Content>
        <p>
          Your current thread is focused on: <strong>{currentTopic}</strong>
        </p>
        <p>
          Your new question appears to be about a different topic.
        </p>
        <div className="recommendation-box">
          <p>💡 <strong>Recommendation:</strong> Start a new thread to keep your analysis organized and ensure accurate query generation.</p>
        </div>
      </Dialog.Content>

      <Dialog.Actions>
        <Button onClick={onContinue} variant="secondary">
          Continue in this thread
        </Button>
        <Button onClick={onNewThread} variant="primary">
          Start new thread
        </Button>
      </Dialog.Actions>
    </Dialog>
  );
}

ContextSwitchDialog.propTypes = {
  isOpen: PropTypes.bool.isRequired,
  onClose: PropTypes.func.isRequired,
  currentTopic: PropTypes.string.isRequired,
  newQuery: PropTypes.string.isRequired,
  onContinue: PropTypes.func.isRequired,
  onNewThread: PropTypes.func.isRequired,
};
```

#### Query Submission with Context Detection

Integrate context detection into the query submission flow:

```jsx
async function handleSubmitQuery(query, threadContext) {
  // Skip detection for first message in thread
  if (messages.length === 0) {
    await submitQuery(query);
    return;
  }

  // Detect context shift
  const shift = detectContextShift(query, threadContext);

  if (shift.type === 'major' && shift.confidence === 'high') {
    // Show warning dialog
    const userChoice = await showContextSwitchDialog({
      currentTopic: threadContext.primaryTopic,
      newQuery: query,
    });

    if (userChoice === 'new_thread') {
      // Create new thread with this query
      const newThreadId = await createNewThread();
      navigateToThread(newThreadId, query);
      return;
    }
  }

  // Continue in current thread
  await submitQuery(query);
}

function showContextSwitchDialog({ currentTopic, newQuery }) {
  return new Promise((resolve) => {
    setDialogState({
      isOpen: true,
      currentTopic,
      newQuery,
      onContinue: () => {
        setDialogState({ isOpen: false });
        resolve('continue');
      },
      onNewThread: () => {
        setDialogState({ isOpen: false });
        resolve('new_thread');
      },
    });
  });
}
```

#### Thread Scope Indicator

Display the thread's current focus in the UI:

```jsx
import { Badge, Button } from '@salt-ds/core';
import PropTypes from 'prop-types';

function ThreadContextBadge({ context }) {
  if (!context.primaryTopic) return null;

  return (
    <div className="thread-context-badge">
      <Badge variant="info">
        🎯 Focused on: {context.primaryTopic}
      </Badge>
      {context.sqlTablesFocused.length > 0 && (
        <Badge variant="secondary">
          Tables: {context.sqlTablesFocused.join(', ')}
        </Badge>
      )}
      <Button
        variant="text"
        size="small"
        onClick={() => {/* Start new thread */}}
      >
        Change topic →
      </Button>
    </div>
  );
}

ThreadContextBadge.propTypes = {
  context: PropTypes.shape({
    primaryTopic: PropTypes.string,
    sqlTablesFocused: PropTypes.arrayOf(PropTypes.string),
  }).isRequired,
};
```

#### Follow-Up Action Buttons

After a response with SQL/chart, show scoped follow-up options:

```jsx
import { Button } from '@salt-ds/core';
import PropTypes from 'prop-types';

function FollowUpActions({ response, onQuickAction, onNewTopic }) {
  const quickActions = [
    { id: 'remove-columns', label: 'Remove columns', icon: '✂️' },
    { id: 'add-filter', label: 'Add filter', icon: '🔍' },
    { id: 'change-date-range', label: 'Change date range', icon: '📅' },
    { id: 'group-by', label: 'Group by different field', icon: '📊' },
    { id: 'sort', label: 'Change sorting', icon: '⬆️' },
  ];

  return (
    <div className="follow-up-actions">
      <div className="quick-actions">
        <p className="section-label">Refine this query:</p>
        <div className="action-buttons">
          {quickActions.map(action => (
            <Button
              key={action.id}
              variant="secondary"
              size="small"
              onClick={() => onQuickAction(action.id, response)}
            >
              {action.icon} {action.label}
            </Button>
          ))}
        </div>
      </div>

      <div className="divider" />

      <Button
        variant="text"
        onClick={onNewTopic}
        className="new-topic-button"
      >
        Ask about something else →
      </Button>
    </div>
  );
}

FollowUpActions.propTypes = {
  response: PropTypes.object.isRequired,
  onQuickAction: PropTypes.func.isRequired,
  onNewTopic: PropTypes.func.isRequired,
};
```

#### Best Practices for Context Drift Handling

1. **Allow free-form input** - Don't restrict what users can type
2. **Guide, don't force** - Suggest new threads but allow override
3. **Make scope visible** - Show thread context in the UI
4. **Provide quick actions** - Common refinements as buttons
5. **Educate users** - Explain why topic switching matters
6. **Track confidence** - Only warn on high-confidence context shifts
7. **Learn from overrides** - If users consistently override, reduce sensitivity

**Valid refinements within same context:**
- ✅ Adding/removing columns
- ✅ Changing filters (dates, categories)
- ✅ Changing grouping/aggregation
- ✅ Sorting differently
- ✅ Adding calculated fields
- ✅ Expanding/narrowing time ranges

**Likely context switches (should prompt):**
- ⚠️ Switching from allocations → issues
- ⚠️ Switching from revenue → customer churn
- ⚠️ Changing from project metrics → user metrics
- ⚠️ Moving between unrelated database tables

For comprehensive examples and advanced patterns, see [references/context-drift-patterns.md](references/context-drift-patterns.md).

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

## Implementation Checklist

### Performance
- [ ] Virtual scrolling implemented for threads
- [ ] Chart lazy loading on tab click
- [ ] Query result caching (15 min TTL)
- [ ] Skeleton UI during data fetch
- [ ] Debounce chart regeneration
- [ ] Limit table rows to 500
- [ ] Clean up old localStorage entries

### Context Drift Handling
- [ ] Thread context tracking (topic, tables, entities)
- [ ] Context similarity detection implemented
- [ ] Warning dialog for major context shifts
- [ ] Thread scope badge visible in UI
- [ ] Follow-up action buttons for query refinements
- [ ] Override tracking for adaptive sensitivity (optional)
- [ ] Test scenarios for context detection

## Resources

For comprehensive mockups and visual specifications:
- See [references/mockups.md](references/mockups.md) - All UI mockups and flows

For technical implementation details:
- See [references/tech-stack.md](references/tech-stack.md) - Technology choices and patterns
- See [references/dashboard-patterns.md](references/dashboard-patterns.md) - Dashboard grid implementation
