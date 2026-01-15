# Elasticsearch Integration for Text-to-SQL Applications

This document covers leveraging Elasticsearch for powerful search, discovery, and analytics capabilities in your text-to-SQL application.

## Table of Contents
1. [Overview](#overview)
2. [Index Design](#index-design)
3. [Core Features](#core-features)
4. [Implementation Patterns](#implementation-patterns)
5. [UI Components](#ui-components)
6. [Advanced Use Cases](#advanced-use-cases)

## Overview

Elasticsearch enables several high-value features for text-to-SQL applications:

**Search Capabilities:**
- 🔍 Full-text search across query history
- 🎯 Semantic search for similar queries
- 📊 Find charts and visualizations by description
- 🧵 Search within conversation threads
- ⚡ Real-time autocomplete suggestions

**Analytics Capabilities:**
- 📈 Query pattern analysis
- 👥 Most popular queries
- 🏷️ Automatic query categorization
- 📊 Usage analytics and insights

**Discovery Features:**
- 🔄 "Similar to this query" recommendations
- 💡 Suggested follow-up queries
- 📚 Browse historical queries by topic
- 🎨 Chart gallery with search

## Index Design

### Index 1: Query History

Store all user queries with metadata for comprehensive search:

```json
{
  "index": "query-history",
  "mappings": {
    "properties": {
      "query_id": { "type": "keyword" },
      "thread_id": { "type": "keyword" },
      "user_id": { "type": "keyword" },
      "question": {
        "type": "text",
        "fields": {
          "keyword": { "type": "keyword" }
        },
        "analyzer": "standard"
      },
      "sql": {
        "type": "text",
        "analyzer": "sql_analyzer"
      },
      "tables_used": { "type": "keyword" },
      "columns_selected": { "type": "keyword" },
      "filters_applied": { "type": "keyword" },
      "aggregations": { "type": "keyword" },
      "result_count": { "type": "integer" },
      "execution_time_ms": { "type": "integer" },
      "chart_type": { "type": "keyword" },
      "was_pinned": { "type": "boolean" },
      "was_successful": { "type": "boolean" },
      "error_message": { "type": "text" },
      "timestamp": { "type": "date" },
      "topic_category": { "type": "keyword" },
      "entities_mentioned": { "type": "keyword" },
      "question_embedding": {
        "type": "dense_vector",
        "dims": 384
      }
    }
  },
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1,
    "analysis": {
      "analyzer": {
        "sql_analyzer": {
          "type": "custom",
          "tokenizer": "standard",
          "filter": ["lowercase", "sql_synonym"]
        }
      },
      "filter": {
        "sql_synonym": {
          "type": "synonym",
          "synonyms": [
            "SELECT, select",
            "WHERE, where",
            "GROUP BY, group by"
          ]
        }
      }
    }
  }
}
```

### Index 2: Thread Conversations

Store entire conversation threads for contextual search:

```json
{
  "index": "threads",
  "mappings": {
    "properties": {
      "thread_id": { "type": "keyword" },
      "user_id": { "type": "keyword" },
      "title": {
        "type": "text",
        "fields": {
          "keyword": { "type": "keyword" }
        }
      },
      "summary": { "type": "text" },
      "messages": {
        "type": "nested",
        "properties": {
          "role": { "type": "keyword" },
          "content": { "type": "text" },
          "timestamp": { "type": "date" }
        }
      },
      "primary_topic": { "type": "keyword" },
      "tables_accessed": { "type": "keyword" },
      "query_count": { "type": "integer" },
      "created_at": { "type": "date" },
      "updated_at": { "type": "date" },
      "last_accessed": { "type": "date" },
      "is_archived": { "type": "boolean" }
    }
  }
}
```

### Index 3: Pinned Charts (Dashboard)

Searchable dashboard charts:

```json
{
  "index": "pinned-charts",
  "mappings": {
    "properties": {
      "chart_id": { "type": "keyword" },
      "user_id": { "type": "keyword" },
      "title": {
        "type": "text",
        "fields": {
          "keyword": { "type": "keyword" }
        }
      },
      "description": { "type": "text" },
      "chart_type": { "type": "keyword" },
      "sql": { "type": "text" },
      "tables_used": { "type": "keyword" },
      "metrics": { "type": "keyword" },
      "dimensions": { "type": "keyword" },
      "tags": { "type": "keyword" },
      "created_at": { "type": "date" },
      "last_refreshed": { "type": "date" },
      "view_count": { "type": "integer" },
      "is_shared": { "type": "boolean" }
    }
  }
}
```

## Core Features

### Feature 1: Query History Search

**Backend Implementation:**

```javascript
import { Client } from '@elastic/elasticsearch';

const esClient = new Client({
  node: process.env.ELASTICSEARCH_URL,
  auth: {
    apiKey: process.env.ELASTICSEARCH_API_KEY
  }
});

async function searchQueryHistory(searchText, filters = {}) {
  const must = [
    {
      multi_match: {
        query: searchText,
        fields: ['question^3', 'sql^2', 'topic_category'],
        type: 'best_fields',
        fuzziness: 'AUTO'
      }
    }
  ];

  // Apply filters
  const filter = [];
  if (filters.tables) {
    filter.push({ terms: { tables_used: filters.tables } });
  }
  if (filters.dateRange) {
    filter.push({
      range: {
        timestamp: {
          gte: filters.dateRange.from,
          lte: filters.dateRange.to
        }
      }
    });
  }
  if (filters.wasSuccessful !== undefined) {
    filter.push({ term: { was_successful: filters.wasSuccessful } });
  }

  const response = await esClient.search({
    index: 'query-history',
    body: {
      query: {
        bool: { must, filter }
      },
      sort: [
        { _score: 'desc' },
        { timestamp: 'desc' }
      ],
      size: 20,
      highlight: {
        fields: {
          question: {},
          sql: {}
        }
      },
      aggs: {
        by_table: {
          terms: { field: 'tables_used', size: 10 }
        },
        by_topic: {
          terms: { field: 'topic_category', size: 10 }
        },
        by_chart_type: {
          terms: { field: 'chart_type', size: 10 }
        }
      }
    }
  });

  return {
    results: response.hits.hits.map(hit => ({
      ...hit._source,
      highlights: hit.highlight,
      score: hit._score
    })),
    aggregations: response.aggregations,
    total: response.hits.total.value
  };
}
```

**Frontend Component:**

```jsx
import { useState, useCallback } from 'react';
import { Input, Button, Badge } from '@salt-ds/core';
import debounce from 'lodash/debounce';

function QueryHistorySearch({ onSelectQuery }) {
  const [searchText, setSearchText] = useState('');
  const [results, setResults] = useState([]);
  const [filters, setFilters] = useState({});
  const [loading, setLoading] = useState(false);

  const performSearch = useCallback(
    debounce(async (text, currentFilters) => {
      if (!text || text.length < 2) {
        setResults([]);
        return;
      }

      setLoading(true);
      try {
        const data = await fetch('/api/search/queries', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ query: text, filters: currentFilters })
        }).then(res => res.json());

        setResults(data.results);
      } catch (error) {
        console.error('Search failed:', error);
      } finally {
        setLoading(false);
      }
    }, 300),
    []
  );

  const handleSearchChange = (e) => {
    const text = e.target.value;
    setSearchText(text);
    performSearch(text, filters);
  };

  return (
    <div className="query-history-search">
      <Input
        value={searchText}
        onChange={handleSearchChange}
        placeholder="Search your query history..."
        startAdornment={<SearchIcon />}
      />

      {loading && <Spinner />}

      <div className="search-results">
        {results.map(result => (
          <QueryResultCard
            key={result.query_id}
            result={result}
            onSelect={() => onSelectQuery(result)}
          />
        ))}
      </div>
    </div>
  );
}

function QueryResultCard({ result, onSelect }) {
  return (
    <div className="query-result-card" onClick={onSelect}>
      <div className="question">
        {result.highlights?.question?.[0] ? (
          <span dangerouslySetInnerHTML={{ __html: result.highlights.question[0] }} />
        ) : (
          result.question
        )}
      </div>
      <div className="metadata">
        <Badge>{result.topic_category}</Badge>
        {result.tables_used.map(table => (
          <Badge key={table} variant="secondary">{table}</Badge>
        ))}
        <span className="timestamp">
          {new Date(result.timestamp).toLocaleDateString()}
        </span>
      </div>
      {result.chart_type && (
        <div className="chart-info">
          📊 {result.chart_type} chart
        </div>
      )}
    </div>
  );
}
```

### Feature 2: Semantic Search (Similar Queries)

Find queries similar to the current one using vector embeddings:

```javascript
async function findSimilarQueries(queryId, limit = 5) {
  // First, get the current query's embedding
  const currentQuery = await esClient.get({
    index: 'query-history',
    id: queryId
  });

  const embedding = currentQuery._source.question_embedding;

  // Search for similar queries using cosine similarity
  const response = await esClient.search({
    index: 'query-history',
    body: {
      query: {
        script_score: {
          query: {
            bool: {
              must_not: [
                { term: { query_id: queryId } } // Exclude current query
              ]
            }
          },
          script: {
            source: "cosineSimilarity(params.query_vector, 'question_embedding') + 1.0",
            params: {
              query_vector: embedding
            }
          }
        }
      },
      size: limit
    }
  });

  return response.hits.hits.map(hit => ({
    ...hit._source,
    similarity_score: hit._score
  }));
}
```

**UI Component:**

```jsx
function SimilarQueriesPanel({ currentQueryId }) {
  const [similarQueries, setSimilarQueries] = useState([]);

  useEffect(() => {
    fetch(`/api/queries/${currentQueryId}/similar`)
      .then(res => res.json())
      .then(data => setSimilarQueries(data));
  }, [currentQueryId]);

  if (similarQueries.length === 0) return null;

  return (
    <div className="similar-queries-panel">
      <h4>💡 Similar queries you've asked:</h4>
      <div className="similar-queries-list">
        {similarQueries.map(query => (
          <div key={query.query_id} className="similar-query-item">
            <div className="question">{query.question}</div>
            <div className="metadata">
              <Badge>
                {Math.round(query.similarity_score * 100)}% similar
              </Badge>
              <span>{new Date(query.timestamp).toLocaleDateString()}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
```

### Feature 3: Autocomplete Suggestions

Real-time query suggestions as users type:

```javascript
async function getAutocompleteSuggestions(partialQuery, limit = 5) {
  const response = await esClient.search({
    index: 'query-history',
    body: {
      suggest: {
        question_suggest: {
          prefix: partialQuery,
          completion: {
            field: 'question.completion',
            size: limit,
            skip_duplicates: true,
            fuzzy: {
              fuzziness: 'AUTO'
            }
          }
        }
      },
      // Also get popular queries matching the prefix
      query: {
        bool: {
          must: [
            {
              match_phrase_prefix: {
                question: partialQuery
              }
            }
          ],
          filter: [
            { term: { was_successful: true } }
          ]
        }
      },
      size: limit,
      sort: [
        { timestamp: 'desc' }
      ]
    }
  });

  return {
    suggestions: response.suggest.question_suggest[0].options,
    recentMatches: response.hits.hits.map(hit => hit._source)
  };
}
```

**Autocomplete Component:**

```jsx
import { useState, useCallback } from 'react';
import { Combobox } from '@salt-ds/core';
import debounce from 'lodash/debounce';

function QueryInputWithAutocomplete({ onSubmit }) {
  const [query, setQuery] = useState('');
  const [suggestions, setSuggestions] = useState([]);

  const fetchSuggestions = useCallback(
    debounce(async (text) => {
      if (text.length < 3) {
        setSuggestions([]);
        return;
      }

      const data = await fetch(`/api/autocomplete?q=${encodeURIComponent(text)}`)
        .then(res => res.json());

      setSuggestions(data.suggestions.map(s => ({
        value: s.text,
        label: s.text,
        count: s._source?.result_count
      })));
    }, 200),
    []
  );

  const handleInputChange = (e) => {
    const text = e.target.value;
    setQuery(text);
    fetchSuggestions(text);
  };

  return (
    <Combobox
      value={query}
      onChange={handleInputChange}
      onSelect={(selected) => {
        setQuery(selected.value);
        onSubmit(selected.value);
      }}
      options={suggestions}
      placeholder="Ask a question about your data..."
    />
  );
}
```

### Feature 4: Thread Search

Search within conversation threads:

```javascript
async function searchThreads(searchText, options = {}) {
  const response = await esClient.search({
    index: 'threads',
    body: {
      query: {
        bool: {
          should: [
            {
              multi_match: {
                query: searchText,
                fields: ['title^3', 'summary^2'],
                type: 'best_fields'
              }
            },
            {
              nested: {
                path: 'messages',
                query: {
                  match: {
                    'messages.content': searchText
                  }
                },
                inner_hits: {
                  size: 3,
                  highlight: {
                    fields: {
                      'messages.content': {}
                    }
                  }
                }
              }
            }
          ]
        }
      },
      size: options.limit || 10,
      sort: options.sortBy === 'relevance'
        ? [{ _score: 'desc' }]
        : [{ last_accessed: 'desc' }]
    }
  });

  return response.hits.hits.map(hit => ({
    ...hit._source,
    matchedMessages: hit.inner_hits?.messages?.hits?.hits || [],
    score: hit._score
  }));
}
```

### Feature 5: Query Analytics Dashboard

Aggregate insights about query patterns:

```javascript
async function getQueryAnalytics(dateRange) {
  const response = await esClient.search({
    index: 'query-history',
    body: {
      query: {
        range: {
          timestamp: {
            gte: dateRange.from,
            lte: dateRange.to
          }
        }
      },
      size: 0, // We only want aggregations
      aggs: {
        // Most queried tables
        top_tables: {
          terms: {
            field: 'tables_used',
            size: 10
          }
        },

        // Most popular query patterns
        top_topics: {
          terms: {
            field: 'topic_category',
            size: 10
          }
        },

        // Query success rate
        success_rate: {
          filters: {
            filters: {
              successful: { term: { was_successful: true } },
              failed: { term: { was_successful: false } }
            }
          }
        },

        // Average execution time
        avg_execution_time: {
          avg: {
            field: 'execution_time_ms'
          }
        },

        // Queries over time
        queries_over_time: {
          date_histogram: {
            field: 'timestamp',
            calendar_interval: 'day'
          }
        },

        // Most pinned chart types
        pinned_chart_types: {
          filter: { term: { was_pinned: true } },
          aggs: {
            by_type: {
              terms: {
                field: 'chart_type',
                size: 10
              }
            }
          }
        }
      }
    }
  });

  return response.aggregations;
}
```

**Analytics Dashboard Component:**

```jsx
import ReactECharts from 'echarts-for-react';
import { Card } from '@salt-ds/core';

function QueryAnalyticsDashboard() {
  const [analytics, setAnalytics] = useState(null);

  useEffect(() => {
    fetch('/api/analytics/queries')
      .then(res => res.json())
      .then(data => setAnalytics(data));
  }, []);

  if (!analytics) return <Spinner />;

  const topTablesOption = {
    title: { text: 'Most Queried Tables' },
    xAxis: {
      type: 'category',
      data: analytics.top_tables.buckets.map(b => b.key)
    },
    yAxis: { type: 'value' },
    series: [{
      data: analytics.top_tables.buckets.map(b => b.doc_count),
      type: 'bar'
    }]
  };

  return (
    <div className="analytics-dashboard">
      <Card>
        <h3>Query Analytics</h3>
        <div className="metrics-grid">
          <div className="metric">
            <div className="value">{analytics.total_queries}</div>
            <div className="label">Total Queries</div>
          </div>
          <div className="metric">
            <div className="value">
              {Math.round(
                (analytics.success_rate.buckets.successful.doc_count /
                 analytics.total_queries) * 100
              )}%
            </div>
            <div className="label">Success Rate</div>
          </div>
          <div className="metric">
            <div className="value">
              {Math.round(analytics.avg_execution_time.value)}ms
            </div>
            <div className="label">Avg Execution Time</div>
          </div>
        </div>

        <ReactECharts option={topTablesOption} style={{ height: '300px' }} />
      </Card>
    </div>
  );
}
```

## UI Components

### Global Search Bar

Add a global search bar to the nav drawer:

```jsx
function NavDrawer() {
  const [searchOpen, setSearchOpen] = useState(false);

  return (
    <div className="nav-drawer">
      <div className="search-section">
        <Button
          variant="text"
          onClick={() => setSearchOpen(true)}
          startIcon={<SearchIcon />}
        >
          Search queries...
        </Button>
      </div>

      {searchOpen && (
        <GlobalSearchModal
          isOpen={searchOpen}
          onClose={() => setSearchOpen(false)}
        />
      )}

      {/* Rest of nav drawer */}
    </div>
  );
}

function GlobalSearchModal({ isOpen, onClose }) {
  const [searchText, setSearchText] = useState('');
  const [results, setResults] = useState({ queries: [], threads: [], charts: [] });

  const handleSearch = async (text) => {
    const data = await fetch(`/api/search/all?q=${encodeURIComponent(text)}`)
      .then(res => res.json());
    setResults(data);
  };

  return (
    <Dialog open={isOpen} onClose={onClose} size="large">
      <Dialog.Header>
        <Input
          autoFocus
          value={searchText}
          onChange={(e) => {
            setSearchText(e.target.value);
            handleSearch(e.target.value);
          }}
          placeholder="Search queries, threads, charts..."
          startAdornment={<SearchIcon />}
        />
      </Dialog.Header>

      <Dialog.Content>
        <Tabs>
          <Tab label={`Queries (${results.queries.length})`}>
            <QueryResultsList results={results.queries} />
          </Tab>
          <Tab label={`Threads (${results.threads.length})`}>
            <ThreadResultsList results={results.threads} />
          </Tab>
          <Tab label={`Charts (${results.charts.length})`}>
            <ChartResultsList results={results.charts} />
          </Tab>
        </Tabs>
      </Dialog.Content>
    </Dialog>
  );
}
```

## Advanced Use Cases

### Use Case 1: Query Recommendation Engine

Suggest queries based on user behavior and popular patterns:

```javascript
async function getRecommendedQueries(userId, context = {}) {
  // Get user's query history
  const userHistory = await esClient.search({
    index: 'query-history',
    body: {
      query: { term: { user_id: userId } },
      size: 50,
      sort: [{ timestamp: 'desc' }]
    }
  });

  // Extract user's frequent tables and topics
  const userTables = [...new Set(
    userHistory.hits.hits.flatMap(h => h._source.tables_used)
  )];
  const userTopics = [...new Set(
    userHistory.hits.hits.map(h => h._source.topic_category)
  )];

  // Find popular queries in similar context
  const recommendations = await esClient.search({
    index: 'query-history',
    body: {
      query: {
        bool: {
          should: [
            { terms: { tables_used: userTables, boost: 2.0 } },
            { terms: { topic_category: userTopics, boost: 1.5 } }
          ],
          must_not: [
            { term: { user_id: userId } } // Exclude user's own queries
          ],
          filter: [
            { term: { was_successful: true } },
            { term: { was_pinned: true } } // Prioritize pinned queries
          ]
        }
      },
      collapse: {
        field: 'question.keyword' // Deduplicate similar questions
      },
      size: 10
    }
  });

  return recommendations.hits.hits.map(hit => hit._source);
}
```

### Use Case 2: Automatic Query Categorization

Use ML to automatically categorize queries:

```javascript
async function categorizeQuery(question, sql, tables) {
  // Index with ingest pipeline that uses ML model
  await esClient.index({
    index: 'query-history',
    pipeline: 'query-categorization-pipeline',
    body: {
      question,
      sql,
      tables_used: tables,
      // ... other fields
    }
  });
}

// Define the ingest pipeline (run once during setup)
async function setupCategorizationPipeline() {
  await esClient.ingest.putPipeline({
    id: 'query-categorization-pipeline',
    body: {
      processors: [
        {
          inference: {
            model_id: 'query-classification-model',
            field_map: {
              question: 'text_field'
            },
            target_field: 'topic_category'
          }
        },
        {
          script: {
            source: `
              // Extract entities from question
              ctx.entities_mentioned = /\\b[A-Z][a-z]+\\b/.findAll(ctx.question);
            `
          }
        }
      ]
    }
  });
}
```

### Use Case 3: Chart Gallery with Faceted Search

Searchable chart gallery with filters:

```jsx
function ChartGallery() {
  const [charts, setCharts] = useState([]);
  const [filters, setFilters] = useState({});
  const [facets, setFacets] = useState({});

  const searchCharts = async (query, currentFilters) => {
    const response = await fetch('/api/charts/search', {
      method: 'POST',
      body: JSON.stringify({ query, filters: currentFilters })
    }).then(res => res.json());

    setCharts(response.results);
    setFacets(response.facets);
  };

  return (
    <div className="chart-gallery">
      <div className="filters-sidebar">
        <h4>Filters</h4>

        <div className="filter-group">
          <h5>Chart Type</h5>
          {facets.chart_types?.map(type => (
            <Checkbox
              key={type.key}
              label={`${type.key} (${type.count})`}
              onChange={(checked) => {
                setFilters({
                  ...filters,
                  chartType: checked ? type.key : null
                });
              }}
            />
          ))}
        </div>

        <div className="filter-group">
          <h5>Data Source</h5>
          {facets.tables?.map(table => (
            <Checkbox
              key={table.key}
              label={`${table.key} (${table.count})`}
            />
          ))}
        </div>
      </div>

      <div className="charts-grid">
        {charts.map(chart => (
          <ChartCard key={chart.chart_id} chart={chart} />
        ))}
      </div>
    </div>
  );
}
```

## Implementation Checklist

- [ ] Set up Elasticsearch indices with proper mappings
- [ ] Implement query indexing on every SQL execution
- [ ] Add global search bar to navigation
- [ ] Implement autocomplete for query input
- [ ] Add "Similar queries" panel to response view
- [ ] Create query analytics dashboard
- [ ] Build chart gallery with faceted search
- [ ] Implement thread search functionality
- [ ] Add query recommendations
- [ ] Set up ML pipeline for automatic categorization (optional)
- [ ] Create scheduled jobs to clean up old indices
- [ ] Add monitoring and alerting for Elasticsearch health

## Performance Considerations

1. **Index Size Management**: Implement index lifecycle policies to archive old queries
2. **Search Performance**: Use index aliases for zero-downtime reindexing
3. **Caching**: Cache frequent search results in Redis (if available)
4. **Bulk Indexing**: Batch index operations for better performance
5. **Query Optimization**: Use filters instead of queries where possible

## Security and Privacy

1. **User Isolation**: Always filter by user_id in queries
2. **Sensitive Data**: Don't index PII in query results
3. **Access Control**: Implement field-level security for multi-tenant setups
4. **Audit Logging**: Log all search operations for compliance

## Example Backend Setup

```javascript
// elasticsearch.js - Service initialization
import { Client } from '@elastic/elasticsearch';

class ElasticsearchService {
  constructor() {
    this.client = new Client({
      node: process.env.ELASTICSEARCH_URL,
      auth: {
        apiKey: process.env.ELASTICSEARCH_API_KEY
      }
    });
  }

  async indexQuery(query) {
    await this.client.index({
      index: 'query-history',
      body: {
        query_id: query.id,
        thread_id: query.threadId,
        user_id: query.userId,
        question: query.question,
        sql: query.sql,
        tables_used: this.extractTables(query.sql),
        result_count: query.resultCount,
        execution_time_ms: query.executionTime,
        chart_type: query.chartType,
        was_pinned: false,
        was_successful: query.success,
        timestamp: new Date(),
        topic_category: await this.categorizeQuery(query.question)
      },
      refresh: 'wait_for' // Make immediately searchable
    });
  }

  extractTables(sql) {
    const fromPattern = /FROM\s+(\w+)/gi;
    const joinPattern = /JOIN\s+(\w+)/gi;

    const tables = new Set();
    let match;

    while ((match = fromPattern.exec(sql)) !== null) {
      tables.add(match[1].toLowerCase());
    }
    while ((match = joinPattern.exec(sql)) !== null) {
      tables.add(match[1].toLowerCase());
    }

    return Array.from(tables);
  }

  async categorizeQuery(question) {
    // Simple keyword-based categorization
    // Replace with ML model for better accuracy
    const categories = {
      revenue: /revenue|sales|income|earnings/i,
      users: /user|customer|client|account/i,
      projects: /project|initiative|program/i,
      issues: /issue|ticket|bug|problem/i,
      allocations: /allocation|resource|capacity/i
    };

    for (const [category, pattern] of Object.entries(categories)) {
      if (pattern.test(question)) {
        return category;
      }
    }

    return 'general';
  }
}

export default new ElasticsearchService();
```

## Conclusion

Elasticsearch adds powerful search and discovery capabilities to your text-to-SQL application. The key is to index queries as they're executed, maintaining rich metadata that enables intelligent search, recommendations, and analytics. Start with basic full-text search and gradually add more advanced features like semantic search and ML-powered categorization.
