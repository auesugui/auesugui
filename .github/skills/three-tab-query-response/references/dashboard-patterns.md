# Dashboard Implementation Patterns

This document covers implementing the pinned charts dashboard with drag-and-drop grid layout.

## Overview

The dashboard displays pinned charts in a draggable, resizable grid. Users can:
- View all pinned charts in a grid layout
- Drag charts to rearrange them
- Resize charts
- Refresh individual charts or all at once
- Edit chart properties
- Unpin charts

## Grid Layout with react-grid-layout

### Installation
```bash
npm install react-grid-layout
npm install @types/react-grid-layout  # Optional: for better IDE support
```

### Basic Dashboard Component

```jsx
import { useState } from 'react';
import GridLayout from 'react-grid-layout';
import { Button, Card } from '@salt-ds/core';
import useLocalStorage from '@/hooks/useLocalStorage';
import 'react-grid-layout/css/styles.css';
import 'react-grid-layout/css/resizable.css';

function Dashboard() {
  const [pinnedCharts, setPinnedCharts] = useLocalStorage('pinned-charts', []);
  const [layout, setLayout] = useLocalStorage('dashboard-layout', []);

  // Generate layout from pinned charts if not exists
  const gridLayout = layout.length > 0
    ? layout
    : pinnedCharts.map((chart, index) => ({
        i: chart.id,
        x: (index % 2) * 6,  // 2 columns
        y: Math.floor(index / 2) * 4,
        w: 6,  // Half width
        h: 4,  // 4 rows tall
      }));

  const handleLayoutChange = (newLayout) => {
    setLayout(newLayout);
  };

  const handleRefreshAll = async () => {
    const refreshed = await Promise.all(
      pinnedCharts.map(async (chart) => {
        const freshData = await executeSQL(chart.sql);
        return {
          ...chart,
          data: freshData,
          lastRefreshed: new Date().toISOString(),
        };
      })
    );

    setPinnedCharts(refreshed);
  };

  return (
    <div className="dashboard">
      <DashboardHeader
        chartCount={pinnedCharts.length}
        onRefreshAll={handleRefreshAll}
      />

      {pinnedCharts.length === 0 ? (
        <EmptyDashboard />
      ) : (
        <GridLayout
          className="dashboard-grid"
          layout={gridLayout}
          cols={12}
          rowHeight={100}
          width={1200}
          onLayoutChange={handleLayoutChange}
          draggableHandle=".drag-handle"
          compactType="vertical"
        >
          {pinnedCharts.map((chart) => (
            <div key={chart.id}>
              <ChartCard
                chart={chart}
                onRefresh={() => handleRefreshChart(chart.id)}
                onUnpin={() => handleUnpinChart(chart.id)}
                onDelete={() => handleDeleteChart(chart.id)}
              />
            </div>
          ))}
        </GridLayout>
      )}
    </div>
  );
}

Dashboard.propTypes = {};

export default Dashboard;
```

### Dashboard Header

```jsx
import { Button } from '@salt-ds/core';
import PropTypes from 'prop-types';

function DashboardHeader({ chartCount, onRefreshAll }) {
  return (
    <div className="dashboard-header">
      <h1>Dashboard</h1>

      <div className="header-stats">
        <span>{chartCount} pinned chart{chartCount !== 1 ? 's' : ''}</span>
      </div>

      <div className="header-actions">
        <Button onClick={() => {/* Open settings */}}>
          ⚙️ Settings
        </Button>
        <Button onClick={onRefreshAll}>
          🔄 Refresh All
        </Button>
      </div>
    </div>
  );
}

DashboardHeader.propTypes = {
  chartCount: PropTypes.number.isRequired,
  onRefreshAll: PropTypes.func.isRequired,
};
```

### Chart Card Component

```jsx
import { useState } from 'react';
import { Card, Dropdown, Button } from '@salt-ds/core';
import ReactECharts from 'echarts-for-react';
import PropTypes from 'prop-types';

function ChartCard({ chart, onRefresh, onUnpin, onDelete }) {
  const [showLegend, setShowLegend] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [isEditingTitle, setIsEditingTitle] = useState(false);
  const [title, setTitle] = useState(chart.title);

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await onRefresh();
    setIsRefreshing(false);
  };

  const formatLastRefreshed = () => {
    if (!chart.lastRefreshed) return 'Never';

    const date = new Date(chart.lastRefreshed);
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);

    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins} min${diffMins > 1 ? 's' : ''} ago`;

    const diffHours = Math.floor(diffMins / 60);
    if (diffHours < 24) return `${diffHours} hour${diffHours > 1 ? 's' : ''} ago`;

    const diffDays = Math.floor(diffHours / 24);
    return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`;
  };

  const menuItems = [
    {
      label: 'Edit Chart Properties',
      onClick: () => {/* Open edit modal */},
    },
    {
      label: 'Refresh Data',
      onClick: handleRefresh,
    },
    {
      label: showLegend ? 'Hide Legend' : 'Show Legend',
      onClick: () => setShowLegend(!showLegend),
    },
    {
      label: 'Unpin from Dashboard',
      onClick: onUnpin,
    },
    {
      label: 'Delete',
      onClick: onDelete,
      danger: true,
    },
  ];

  // Transform chart spec to ECharts option
  const chartOption = {
    ...chart.chartSpec,
    legend: { show: showLegend },
  };

  return (
    <Card className="chart-card">
      {/* Drag Handle */}
      <div className="chart-card-header drag-handle">
        {isEditingTitle ? (
          <input
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            onBlur={() => {
              setIsEditingTitle(false);
              onUpdateTitle(chart.id, title);
            }}
            onKeyPress={(e) => {
              if (e.key === 'Enter') {
                setIsEditingTitle(false);
                onUpdateTitle(chart.id, title);
              }
            }}
            autoFocus
          />
        ) : (
          <h3 onClick={() => setIsEditingTitle(true)}>
            {title}
          </h3>
        )}

        <Dropdown
          items={menuItems}
          trigger={<Button variant="icon">⋮</Button>}
        />
      </div>

      {/* Chart Visualization */}
      <div className="chart-card-body">
        {isRefreshing ? (
          <div className="chart-loading">
            <Spinner />
            <p>Refreshing data...</p>
          </div>
        ) : (
          <ReactECharts
            option={chartOption}
            style={{ height: '100%', width: '100%' }}
            notMerge={true}
          />
        )}
      </div>

      {/* Footer with Metadata */}
      <div className="chart-card-footer">
        <span className="last-updated">
          Last updated: {formatLastRefreshed()}
        </span>
      </div>
    </Card>
  );
}

ChartCard.propTypes = {
  chart: PropTypes.shape({
    id: PropTypes.string.isRequired,
    title: PropTypes.string.isRequired,
    chartSpec: PropTypes.object.isRequired,
    data: PropTypes.array.isRequired,
    sql: PropTypes.string,
    lastRefreshed: PropTypes.string,
  }).isRequired,
  onRefresh: PropTypes.func.isRequired,
  onUnpin: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
};
```

### Empty Dashboard State

```jsx
import { Button } from '@salt-ds/core';

function EmptyDashboard() {
  return (
    <div className="empty-dashboard">
      <div className="empty-state-icon">📊</div>
      <h2>No Pinned Charts</h2>
      <p>
        Pin charts from your query threads to create a personalized dashboard.
      </p>
      <Button onClick={() => navigateTo('/chat')}>
        Start New Query
      </Button>
    </div>
  );
}
```

## Pinning Charts from Thread

### Pin Button in ChartTab

```jsx
function ChartTab({ response, onPin }) {
  const [isPinned, setIsPinned] = useLocalStorage(
    `response-${response.id}-pinned`,
    false
  );

  const handlePin = () => {
    onPin(response);
    setIsPinned(true);
    showToast('Chart pinned to dashboard!');
  };

  return (
    <div className="chart-tab">
      <div className="chart-controls">
        <Button
          onClick={handlePin}
          disabled={isPinned}
          variant="primary"
        >
          {isPinned ? '✓ Pinned' : '📌 Pin to Dashboard'}
        </Button>
      </div>

      <ReactECharts option={chartOption} />
    </div>
  );
}
```

### Pin Handler in Parent Component

```jsx
function handlePinChart(response) {
  const [pinnedCharts, setPinnedCharts] = useLocalStorage('pinned-charts', []);

  // Check if already pinned
  if (pinnedCharts.some(c => c.responseId === response.id)) {
    showToast('Chart already pinned!', 'warning');
    return;
  }

  const newChart = {
    id: `chart-${Date.now()}`,
    responseId: response.id,
    title: response.question || 'Query Result',
    chartSpec: response.chartSpec,
    data: response.data,
    sql: response.sql,
    createdAt: new Date().toISOString(),
    lastRefreshed: new Date().toISOString(),
  };

  setPinnedCharts([...pinnedCharts, newChart]);
}
```

## Advanced Features

### Chart Refresh with Cache Invalidation

```jsx
async function handleRefreshChart(chartId) {
  const chart = pinnedCharts.find(c => c.id === chartId);

  if (!chart) return;

  try {
    // Execute query again
    const freshData = await executeSQL(chart.sql);

    // Update chart data
    setPinnedCharts(
      pinnedCharts.map(c =>
        c.id === chartId
          ? {
              ...c,
              data: freshData,
              lastRefreshed: new Date().toISOString(),
            }
          : c
      )
    );

    // Clear localStorage cache for this query
    localStorage.removeItem(`query-cache-${chart.responseId}`);

    showToast('Chart refreshed successfully!');
  } catch (error) {
    showToast(`Failed to refresh: ${error.message}`, 'error');
  }
}
```

### Scheduled Auto-Refresh

```jsx
function Dashboard() {
  const [pinnedCharts, setPinnedCharts] = useLocalStorage('pinned-charts', []);
  const [autoRefresh, setAutoRefresh] = useLocalStorage('dashboard-auto-refresh', false);
  const [refreshInterval, setRefreshInterval] = useLocalStorage('refresh-interval', 5); // minutes

  useEffect(() => {
    if (!autoRefresh) return;

    const intervalId = setInterval(() => {
      handleRefreshAll();
    }, refreshInterval * 60 * 1000);

    return () => clearInterval(intervalId);
  }, [autoRefresh, refreshInterval]);

  return (
    <div className="dashboard">
      <DashboardHeader
        autoRefresh={autoRefresh}
        onToggleAutoRefresh={() => setAutoRefresh(!autoRefresh)}
        refreshInterval={refreshInterval}
        onChangeInterval={setRefreshInterval}
      />
      {/* ... */}
    </div>
  );
}
```

### Export Dashboard Configuration

```jsx
function exportDashboard() {
  const [pinnedCharts] = useLocalStorage('pinned-charts', []);
  const [layout] = useLocalStorage('dashboard-layout', []);

  const config = {
    version: '1.0',
    exportedAt: new Date().toISOString(),
    charts: pinnedCharts,
    layout: layout,
  };

  const blob = new Blob([JSON.stringify(config, null, 2)], {
    type: 'application/json',
  });

  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.href = url;
  link.download = `dashboard-${Date.now()}.json`;
  link.click();

  URL.revokeObjectURL(url);
}

function importDashboard(file) {
  const reader = new FileReader();

  reader.onload = (e) => {
    try {
      const config = JSON.parse(e.target.result);

      if (config.version !== '1.0') {
        throw new Error('Incompatible dashboard version');
      }

      setPinnedCharts(config.charts);
      setLayout(config.layout);

      showToast('Dashboard imported successfully!');
    } catch (error) {
      showToast(`Failed to import: ${error.message}`, 'error');
    }
  };

  reader.readAsText(file);
}
```

## Responsive Grid

```jsx
import { useMediaQuery } from '@salt-ds/core';

function ResponsiveDashboard() {
  const isMobile = useMediaQuery('(max-width: 768px)');
  const isTablet = useMediaQuery('(max-width: 1024px)');

  const cols = isMobile ? 1 : isTablet ? 2 : 12;
  const rowHeight = isMobile ? 200 : 100;

  return (
    <GridLayout
      cols={cols}
      rowHeight={rowHeight}
      width={isMobile ? window.innerWidth - 32 : 1200}
      // ...
    />
  );
}
```

## Styling Patterns

### Dashboard Grid CSS

```css
.dashboard {
  padding: 24px;
  background: var(--salt-background-primary);
}

.dashboard-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--salt-border-primary);
}

.dashboard-grid {
  position: relative;
}

.chart-card {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: var(--salt-surface-primary);
  border: 1px solid var(--salt-border-primary);
  border-radius: 4px;
  transition: box-shadow 0.2s;
}

.chart-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.chart-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid var(--salt-border-primary);
  cursor: move;
}

.chart-card-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  cursor: text;
}

.chart-card-body {
  flex: 1;
  padding: 16px;
  min-height: 300px;
}

.chart-card-footer {
  padding: 12px 16px;
  border-top: 1px solid var(--salt-border-primary);
  font-size: 12px;
  color: var(--salt-text-secondary);
}

.empty-dashboard {
  text-align: center;
  padding: 80px 24px;
}

.empty-state-icon {
  font-size: 64px;
  margin-bottom: 16px;
}
```

## Testing Dashboard

```jsx
import { render, screen, fireEvent } from '@testing-library/react';
import Dashboard from './Dashboard';

test('displays pinned charts', () => {
  const mockCharts = [
    { id: '1', title: 'Revenue by Region', /* ... */ },
    { id: '2', title: 'Top Customers', /* ... */ },
  ];

  render(<Dashboard initialCharts={mockCharts} />);

  expect(screen.getByText('Revenue by Region')).toBeInTheDocument();
  expect(screen.getByText('Top Customers')).toBeInTheDocument();
});

test('refreshes all charts', async () => {
  const mockRefresh = jest.fn();
  render(<Dashboard onRefreshAll={mockRefresh} />);

  fireEvent.click(screen.getByText('🔄 Refresh All'));

  expect(mockRefresh).toHaveBeenCalled();
});

test('unpins chart', async () => {
  const mockUnpin = jest.fn();
  render(<Dashboard onUnpin={mockUnpin} />);

  // Open chart menu
  fireEvent.click(screen.getByText('⋮'));

  // Click unpin
  fireEvent.click(screen.getByText('Unpin from Dashboard'));

  expect(mockUnpin).toHaveBeenCalled();
});
```
