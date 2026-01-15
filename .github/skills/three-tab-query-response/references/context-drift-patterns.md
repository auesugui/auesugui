# Context Drift Detection and Handling Patterns

This document provides comprehensive patterns for detecting and handling context drift in text-to-SQL conversation threads.

## Table of Contents
1. [Overview](#overview)
2. [Detection Strategies](#detection-strategies)
3. [UI Patterns](#ui-patterns)
4. [Advanced Implementations](#advanced-implementations)
5. [Real-World Examples](#real-world-examples)

## Overview

**Context drift** occurs when users switch topics or datasets within a conversation thread, potentially causing:
- Incorrect SQL generation (mixing unrelated contexts)
- Confusing conversation history
- Poor query performance (unnecessary JOINs)
- Difficulty in thread organization and retrieval

**Design Philosophy:**
- ✅ Allow free-form exploration
- ✅ Guide users toward best practices
- ✅ Make thread scope transparent
- ❌ Don't force rigid constraints
- ❌ Don't block legitimate pivots

## Detection Strategies

### Strategy 1: Entity-Based Detection (Simple)

Best for: Applications with known domain entities

```jsx
// Define your domain entities
const DOMAIN_ENTITIES = {
  allocations: ['allocation', 'assigned', 'resource', 'capacity'],
  issues: ['issue', 'ticket', 'bug', 'problem', 'defect'],
  revenue: ['revenue', 'sales', 'income', 'earnings'],
  customers: ['customer', 'client', 'account', 'buyer'],
  projects: ['project', 'initiative', 'program'],
  users: ['user', 'employee', 'person', 'staff'],
};

function detectTopicFromQuery(query) {
  const lowerQuery = query.toLowerCase();
  const scores = {};

  Object.entries(DOMAIN_ENTITIES).forEach(([topic, keywords]) => {
    scores[topic] = keywords.filter(kw =>
      lowerQuery.includes(kw)
    ).length;
  });

  const maxScore = Math.max(...Object.values(scores));
  if (maxScore === 0) return null;

  return Object.entries(scores)
    .find(([_, score]) => score === maxScore)[0];
}

function isContextShift(newQuery, threadHistory) {
  const newTopic = detectTopicFromQuery(newQuery);
  if (!newTopic) return { isShift: false };

  // Get topics from thread history
  const threadTopics = threadHistory
    .map(msg => detectTopicFromQuery(msg.content))
    .filter(Boolean);

  const hasNewTopic = !threadTopics.includes(newTopic);

  return {
    isShift: hasNewTopic,
    newTopic,
    previousTopics: [...new Set(threadTopics)],
    confidence: hasNewTopic ? 'high' : 'low',
  };
}
```

**Usage:**
```jsx
const result = isContextShift(
  "Show me all open issues",
  [
    { content: "What are the allocations for Q1?" },
    { content: "Can you break that down by team?" }
  ]
);

// Result: { isShift: true, newTopic: 'issues', previousTopics: ['allocations'], confidence: 'high' }
```

### Strategy 2: SQL Table-Based Detection (Recommended)

Best for: Applications with structured database schemas

```jsx
function extractTablesFromSQL(sql) {
  if (!sql) return [];

  // Match FROM clauses
  const fromPattern = /FROM\s+([`"]?\w+[`"]?)(?:\s+AS\s+\w+)?/gi;
  // Match JOIN clauses
  const joinPattern = /(?:INNER|LEFT|RIGHT|FULL|CROSS)?\s*JOIN\s+([`"]?\w+[`"]?)(?:\s+AS\s+\w+)?/gi;

  const tables = new Set();

  let match;
  while ((match = fromPattern.exec(sql)) !== null) {
    tables.add(match[1].replace(/[`"]/g, '').toLowerCase());
  }

  while ((match = joinPattern.exec(sql)) !== null) {
    tables.add(match[1].replace(/[`"]/g, '').toLowerCase());
  }

  return Array.from(tables);
}

function calculateTableOverlap(newTables, threadTables) {
  const overlap = newTables.filter(t => threadTables.includes(t));

  if (newTables.length === 0) return 1; // No tables to compare

  return overlap.length / newTables.length;
}

function detectContextShiftFromSQL(newSQL, threadContext) {
  const newTables = extractTablesFromSQL(newSQL);
  const threadTables = threadContext.sqlTablesFocused || [];

  if (threadTables.length === 0) {
    // First query in thread
    return { type: 'initialization', tables: newTables };
  }

  const overlapRatio = calculateTableOverlap(newTables, threadTables);

  if (overlapRatio === 0) {
    return {
      type: 'major',
      confidence: 'high',
      newTables,
      previousTables: threadTables,
      message: 'Completely different tables being queried',
    };
  } else if (overlapRatio < 0.5) {
    return {
      type: 'minor',
      confidence: 'medium',
      newTables,
      previousTables: threadTables,
      message: 'Some table overlap, but significant new tables introduced',
    };
  }

  return {
    type: 'continuation',
    confidence: 'high',
    newTables,
    previousTables: threadTables,
  };
}
```

**Example:**
```jsx
const threadContext = {
  sqlTablesFocused: ['allocations', 'users'],
};

const result = detectContextShiftFromSQL(
  'SELECT * FROM issues JOIN projects ON issues.project_id = projects.id',
  threadContext
);

// Result: { type: 'major', confidence: 'high', newTables: ['issues', 'projects'], ... }
```

### Strategy 3: LLM-Powered Detection (Advanced)

Best for: Complex applications where topic boundaries are fuzzy

```jsx
async function detectContextShiftWithLLM(newQuery, threadHistory) {
  const threadSummary = threadHistory
    .map(msg => msg.role === 'user' ? msg.content : '')
    .filter(Boolean)
    .join('; ');

  const prompt = `
Analyze if the new question is related to the previous conversation context.

Previous conversation topics: ${threadSummary}

New question: ${newQuery}

Classify this as:
A) CONTINUATION - Same topic, refinement, or closely related follow-up
B) MINOR_SHIFT - Somewhat related but different angle or dataset
C) MAJOR_SHIFT - Completely different topic or unrelated dataset

Return ONLY the letter (A, B, or C) and a brief 1-sentence explanation.
Format: "[LETTER]: [Explanation]"
`;

  const response = await callLLM(prompt);
  const [classification, explanation] = response.split(':');

  const typeMap = {
    'A': 'continuation',
    'B': 'minor',
    'C': 'major',
  };

  return {
    type: typeMap[classification.trim()],
    explanation: explanation.trim(),
    confidence: 'high',
    method: 'llm',
  };
}
```

### Strategy 4: Hybrid Approach (Production-Ready)

Combine multiple strategies for robust detection:

```jsx
async function detectContextShift(newQuery, newSQL, threadContext, threadHistory) {
  const strategies = [];

  // Strategy 1: Entity-based
  const entityResult = isContextShift(newQuery, threadHistory);
  strategies.push({ ...entityResult, weight: 0.3 });

  // Strategy 2: SQL table-based (if SQL available)
  if (newSQL && threadContext.sqlTablesFocused?.length > 0) {
    const sqlResult = detectContextShiftFromSQL(newSQL, threadContext);
    strategies.push({ ...sqlResult, weight: 0.5 });
  }

  // Strategy 3: LLM-based (fallback for ambiguous cases)
  if (threadHistory.length > 2) {
    const llmResult = await detectContextShiftWithLLM(newQuery, threadHistory);
    strategies.push({ ...llmResult, weight: 0.2 });
  }

  // Aggregate results
  const majorCount = strategies.filter(s => s.type === 'major').length;
  const totalWeight = strategies.reduce((sum, s) => sum + s.weight, 0);
  const majorWeight = strategies
    .filter(s => s.type === 'major')
    .reduce((sum, s) => sum + s.weight, 0);

  const majorRatio = majorWeight / totalWeight;

  if (majorRatio > 0.5) {
    return {
      type: 'major',
      confidence: majorRatio > 0.7 ? 'high' : 'medium',
      strategies,
    };
  } else if (majorRatio > 0.2) {
    return { type: 'minor', confidence: 'medium', strategies };
  }

  return { type: 'continuation', confidence: 'high', strategies };
}
```

## UI Patterns

### Pattern 1: Non-Intrusive Badge

Show thread focus without blocking user flow:

```jsx
import { Badge, Tooltip } from '@salt-ds/core';

function ThreadScopeBadge({ context, onChangeScope }) {
  if (!context.primaryTopic) return null;

  return (
    <div className="thread-scope-badge">
      <Tooltip content="This thread is focused on specific topics. Click to change.">
        <Badge
          variant="info"
          onClick={onChangeScope}
          className="clickable-badge"
        >
          🎯 {context.primaryTopic}
          {context.sqlTablesFocused?.length > 0 && (
            <span className="table-count">
              ({context.sqlTablesFocused.length} tables)
            </span>
          )}
        </Badge>
      </Tooltip>
    </div>
  );
}
```

### Pattern 2: Inline Warning with Actions

Show warning inline before query submission:

```jsx
import { Banner, Button } from '@salt-ds/core';

function ContextShiftWarning({ detection, onContinue, onNewThread, onDismiss }) {
  if (detection.type !== 'major') return null;

  return (
    <Banner variant="warning" className="context-warning">
      <Banner.Content>
        <p>
          <strong>Different topic detected</strong>
        </p>
        <p>
          This question appears to be about a different topic.
          Starting a new thread helps keep your analysis organized.
        </p>
      </Banner.Content>
      <Banner.Actions>
        <Button onClick={onNewThread} variant="primary" size="small">
          Start new thread
        </Button>
        <Button onClick={onContinue} variant="secondary" size="small">
          Continue here
        </Button>
        <Button onClick={onDismiss} variant="text" size="small">
          Dismiss
        </Button>
      </Banner.Actions>
    </Banner>
  );
}
```

### Pattern 3: Smart Follow-Up Suggestions

Show contextual quick actions based on previous response:

```jsx
function SmartFollowUpSuggestions({ response, threadContext }) {
  // Generate suggestions based on response type
  const suggestions = generateSuggestions(response, threadContext);

  return (
    <div className="follow-up-suggestions">
      <h5>Suggested follow-ups:</h5>
      <div className="suggestion-grid">
        {suggestions.refinements.map(sug => (
          <Button
            key={sug.id}
            variant="secondary"
            size="small"
            onClick={() => applySuggestion(sug)}
          >
            {sug.icon} {sug.label}
          </Button>
        ))}
      </div>

      <div className="divider-with-text">
        <span>or</span>
      </div>

      <Button
        variant="text"
        onClick={createNewThread}
        className="new-topic-btn"
      >
        Ask about something different →
      </Button>
    </div>
  );
}

function generateSuggestions(response, threadContext) {
  const suggestions = {
    refinements: [],
    pivots: [],
  };

  // Analyze response to generate relevant suggestions
  if (response.data?.length > 0) {
    const columns = Object.keys(response.data[0]);

    if (columns.length > 5) {
      suggestions.refinements.push({
        id: 'remove-columns',
        label: 'Show fewer columns',
        icon: '✂️',
        action: 'remove-columns',
      });
    }

    if (columns.some(c => c.includes('date') || c.includes('time'))) {
      suggestions.refinements.push({
        id: 'change-date-range',
        label: 'Change date range',
        icon: '📅',
        action: 'filter-dates',
      });
    }

    if (response.sql?.includes('GROUP BY')) {
      suggestions.refinements.push({
        id: 'change-grouping',
        label: 'Group by different field',
        icon: '📊',
        action: 'change-group-by',
      });
    }
  }

  return suggestions;
}
```

### Pattern 4: Progressive Disclosure

Start subtle, increase prominence with confidence:

```jsx
function ContextDriftIndicator({ detection, onAction }) {
  // Low confidence or continuation - no indicator
  if (detection.type === 'continuation' || detection.confidence === 'low') {
    return null;
  }

  // Medium confidence or minor shift - subtle badge
  if (detection.type === 'minor' || detection.confidence === 'medium') {
    return (
      <div className="context-hint">
        💡 <span className="hint-text">
          Consider starting a new thread for unrelated topics
        </span>
        <Button variant="text" size="small" onClick={() => onAction('new-thread')}>
          Start new thread
        </Button>
      </div>
    );
  }

  // High confidence major shift - prominent dialog
  return (
    <ContextSwitchDialog
      isOpen={true}
      detection={detection}
      onContinue={() => onAction('continue')}
      onNewThread={() => onAction('new-thread')}
    />
  );
}
```

## Advanced Implementations

### Multi-Tier Context Tracking

Track context at multiple levels:

```jsx
class ThreadContextManager {
  constructor() {
    this.context = {
      // Primary level: What is the main topic?
      primary: {
        topic: null,
        confidence: 0,
      },

      // Secondary level: What data sources are involved?
      dataSources: {
        tables: [],
        schemas: [],
        databases: [],
      },

      // Tertiary level: What are the analysis dimensions?
      dimensions: {
        timeRanges: [],
        aggregations: [],
        filters: [],
      },

      // Metadata
      metadata: {
        queryCount: 0,
        createdAt: null,
        lastUpdated: null,
      },
    };
  }

  updateContext(newResponse) {
    // Update primary topic (only if not set or low confidence)
    if (!this.context.primary.topic || this.context.primary.confidence < 0.7) {
      this.context.primary = {
        topic: extractPrimaryTopic(newResponse.question),
        confidence: 0.8,
      };
    }

    // Update data sources
    if (newResponse.sql) {
      const tables = extractTablesFromSQL(newResponse.sql);
      this.context.dataSources.tables = [
        ...new Set([...this.context.dataSources.tables, ...tables])
      ];
    }

    // Update dimensions
    this.context.dimensions = {
      timeRanges: extractTimeRanges(newResponse.sql),
      aggregations: extractAggregations(newResponse.sql),
      filters: extractFilters(newResponse.sql),
    };

    // Update metadata
    this.context.metadata.queryCount++;
    this.context.metadata.lastUpdated = Date.now();

    return this.context;
  }

  checkContextShift(newQuery, newSQL) {
    const newTables = extractTablesFromSQL(newSQL);
    const tableOverlap = calculateTableOverlap(
      newTables,
      this.context.dataSources.tables
    );

    const newTopic = extractPrimaryTopic(newQuery);
    const topicSimilarity = calculateSimilarity(
      newTopic,
      this.context.primary.topic
    );

    // Complex decision logic
    if (tableOverlap === 0 && topicSimilarity < 0.3) {
      return {
        type: 'major',
        reason: 'Both topic and data sources are completely different',
        recommendation: 'Create new thread',
      };
    } else if (tableOverlap < 0.5 || topicSimilarity < 0.5) {
      return {
        type: 'minor',
        reason: 'Partial overlap in context',
        recommendation: 'Consider new thread',
      };
    }

    return { type: 'continuation' };
  }
}
```

### Learning from User Behavior

Adapt sensitivity based on user overrides:

```jsx
class AdaptiveContextDetector {
  constructor() {
    this.userPreferences = {
      overrideCount: 0,
      totalWarnings: 0,
      topicSwitchPatterns: [],
    };

    this.sensitivityLevel = 0.5; // 0 = permissive, 1 = strict
  }

  recordUserAction(warning, userChoice) {
    this.userPreferences.totalWarnings++;

    if (userChoice === 'continue' && warning.type === 'major') {
      // User overrode a major warning
      this.userPreferences.overrideCount++;

      // Record the pattern they accepted
      this.userPreferences.topicSwitchPatterns.push({
        from: warning.previousTopics,
        to: warning.newTopic,
        acceptedAt: Date.now(),
      });
    }

    // Adjust sensitivity
    this.adjustSensitivity();
  }

  adjustSensitivity() {
    const overrideRate = this.userPreferences.overrideCount /
                        Math.max(this.userPreferences.totalWarnings, 1);

    if (overrideRate > 0.7) {
      // User frequently overrides - reduce sensitivity
      this.sensitivityLevel = Math.max(0.2, this.sensitivityLevel - 0.1);
    } else if (overrideRate < 0.2) {
      // User rarely overrides - increase sensitivity
      this.sensitivityLevel = Math.min(0.9, this.sensitivityLevel + 0.1);
    }
  }

  shouldWarn(detection) {
    // Check if this pattern was previously accepted
    const wasAcceptedBefore = this.userPreferences.topicSwitchPatterns.some(
      pattern =>
        pattern.from.includes(detection.previousTopics[0]) &&
        pattern.to === detection.newTopic
    );

    if (wasAcceptedBefore) {
      return false; // Don't warn for patterns user has accepted before
    }

    // Adjust threshold based on sensitivity
    const threshold = 0.5 + (this.sensitivityLevel * 0.3);

    return detection.confidence > threshold;
  }
}
```

## Real-World Examples

### Example 1: Allocations → Issues (Major Shift)

```jsx
// Thread history
const thread = [
  {
    role: 'user',
    content: 'Show me allocations for engineering team in Q1',
  },
  {
    role: 'assistant',
    sql: 'SELECT * FROM allocations WHERE team = "engineering" AND quarter = "Q1"',
  },
  {
    role: 'user',
    content: 'Break that down by project',
  },
  {
    role: 'assistant',
    sql: 'SELECT project, SUM(hours) FROM allocations WHERE team = "engineering" GROUP BY project',
  },
];

// New query
const newQuery = 'What are all the open issues assigned to Sarah?';

// Detection result
const result = detectContextShift(newQuery, thread);
/*
{
  type: 'major',
  confidence: 'high',
  previousTopics: ['allocations'],
  newTopic: 'issues',
  recommendation: 'Start new thread',
  reason: 'Switching from resource allocation analysis to issue tracking'
}
*/
```

**Recommended UI Response:**
- Show prominent dialog
- Suggest creating new thread
- Explain: "Your current thread is analyzing allocations. Issue tracking is a different topic."

### Example 2: Revenue → Customer Churn (Minor Shift)

```jsx
const thread = [
  {
    role: 'user',
    content: 'Show me total revenue by region for 2023',
  },
  {
    role: 'assistant',
    sql: 'SELECT region, SUM(revenue) FROM sales GROUP BY region',
  },
];

const newQuery = 'Which customers churned in Q4?';

// Detection result
/*
{
  type: 'minor',
  confidence: 'medium',
  previousTopics: ['revenue', 'sales'],
  newTopic: 'churn',
  recommendation: 'Consider new thread',
  reason: 'Related to customers but different analysis angle'
}
*/
```

**Recommended UI Response:**
- Show subtle banner
- Suggest new thread but don't block
- Allow continuation

### Example 3: Valid Refinement (Continuation)

```jsx
const thread = [
  {
    role: 'user',
    content: 'Show me all projects with budget over $100k',
  },
  {
    role: 'assistant',
    sql: 'SELECT * FROM projects WHERE budget > 100000',
  },
];

const newQuery = 'Sort those by start date and only show active ones';

// Detection result
/*
{
  type: 'continuation',
  confidence: 'high',
  reason: 'Refining previous query with sorting and filtering'
}
*/
```

**Recommended UI Response:**
- No warning
- Process normally

## Best Practices Summary

1. **Start Permissive**: Default to allowing continuation, warn only on high-confidence shifts
2. **Be Transparent**: Always explain why you're suggesting a new thread
3. **Provide Context**: Show users what the current thread is focused on
4. **Learn and Adapt**: Track user overrides and adjust sensitivity
5. **Offer Quick Actions**: Make valid refinements easy with buttons
6. **Never Block**: Always allow users to override recommendations
7. **Consider Domain**: Customize detection logic for your specific use case

## Testing Scenarios

Use these scenarios to validate your implementation:

```jsx
const testCases = [
  {
    name: 'Major shift - different tables',
    thread: ['SELECT * FROM allocations'],
    newQuery: 'Show me all issues',
    expectedType: 'major',
  },
  {
    name: 'Continuation - refinement',
    thread: ['SELECT * FROM users WHERE active = true'],
    newQuery: 'Sort those by signup date',
    expectedType: 'continuation',
  },
  {
    name: 'Minor shift - related topics',
    thread: ['SELECT revenue FROM sales'],
    newQuery: 'What about customer retention rates?',
    expectedType: 'minor',
  },
  {
    name: 'Continuation - expanded scope',
    thread: ['SELECT * FROM projects WHERE status = "active"'],
    newQuery: 'Include completed projects too',
    expectedType: 'continuation',
  },
];
```

## Integration Checklist

- [ ] Implement at least one detection strategy
- [ ] Add thread context tracking
- [ ] Create warning UI component
- [ ] Add thread scope badge/indicator
- [ ] Implement follow-up action buttons
- [ ] Add override tracking (optional)
- [ ] Write tests for detection logic
- [ ] Handle edge cases (empty threads, first query)
- [ ] Add analytics events for monitoring
- [ ] Document for your team
