# MCP Tools Reference

**Purpose**: External intelligence sources via Model Context Protocol (MCP)
**Configuration**: .mcp.json in project root (if present)

---

## Overview

MCP (Model Context Protocol) servers provide Claude Code with access to external tools and data sources. These tools extend Claude's capabilities beyond the local filesystem.

**Available in this project**:
- Ref - Library documentation
- Supabase - Database schema and operations
- Shadcn - Component registry
- Chrome - Browser automation
- Brave - Web search
- 21st-dev - Design ideation

---

## Ref MCP

### Purpose
Query authoritative library documentation from official sources.

### When to Use
- Need latest React, Next.js, TypeScript documentation
- Researching library APIs and best practices
- Verifying correct usage patterns
- Finding examples from official docs

### Available Functions

#### `ref_search_documentation`
Search for documentation across public and private sources.

```typescript
mcp__Ref__ref_search_documentation({
  query: "React useEffect hook cleanup"
})
```

**Parameters**:
- `query` (string): Search query including programming language, framework, library names

**Tips**:
- Include language/framework name: "React useState" not just "useState"
- Use `ref_src=private` to search private docs
- Be specific: "Next.js App Router navigation" vs "navigation"

---

#### `ref_read_url`
Read content from documentation URL as markdown.

```typescript
mcp__Ref__ref_read_url({
  url: "https://react.dev/reference/react/useEffect"
})
```

**Parameters**:
- `url` (string): EXACT URL from `ref_search_documentation` result

**Important**: Only use URLs returned by `ref_search_documentation`. Don't construct URLs manually.

---

### Example Workflow

```typescript
// 1. Search for relevant docs
const searchResults = await mcp__Ref__ref_search_documentation({
  query: "Next.js 14 server components data fetching"
});

// 2. Read specific documentation page
const docContent = await mcp__Ref__ref_read_url({
  url: searchResults[0].url  // Use exact URL from search results
});
```

---

## Supabase MCP

### Purpose
Access database schema, RLS policies, and execute database operations.

### When to Use
- Need database table schema
- Checking RLS (Row Level Security) policies
- Verifying database structure
- Understanding data relationships

### Common Operations
- Get table schemas
- List RLS policies
- View edge functions
- Check database structure

**Note**: Requires Supabase project configuration in .mcp.json

---

## Shadcn MCP

### Purpose
Search and integrate shadcn/ui components.

### When to Use
- Adding UI components from shadcn registry
- Finding component examples
- Getting component code
- Checking component dependencies

### Available Functions

#### `get_project_registries`
Get configured registry names from components.json.

```typescript
mcp__shadcn__get_project_registries()
```

**Returns**: Error if no components.json exists (use init_project to create one)

---

#### `search_items_in_registries`
Search for components using fuzzy matching.

```typescript
mcp__shadcn__search_items_in_registries({
  registries: ["@shadcn"],
  query: "button",
  limit: 10
})
```

**Parameters**:
- `registries` (array): Registry names (e.g., `["@shadcn", "@acme"]`)
- `query` (string): Search term
- `limit` (number): Max results (optional)
- `offset` (number): Pagination offset (optional)

**Note**: After finding an item, use `get_item_examples_from_registries` to see usage examples.

---

#### `view_items_in_registries`
View detailed information about specific registry items.

```typescript
mcp__shadcn__view_items_in_registries({
  items: ["@shadcn/button", "@shadcn/card"]
})
```

**Parameters**:
- `items` (array): Item names with registry prefix

**Returns**: Name, description, type, and file contents (not usage examples)

---

#### `get_item_examples_from_registries`
Find usage examples and demos with complete code.

```typescript
mcp__shadcn__get_item_examples_from_registries({
  registries: ["@shadcn"],
  query: "button-demo"
})
```

**Parameters**:
- `registries` (array): Registry names
- `query` (string): Example search (e.g., "accordion-demo", "button example")

**Common patterns**:
- `{item-name}-demo`
- `{item-name} example`
- `example-{item-name}`
- `example-booking-form`, `example-hero`

---

#### `get_add_command_for_items`
Get the shadcn CLI add command for specific items.

```typescript
mcp__shadcn__get_add_command_for_items({
  items: ["@shadcn/button", "@shadcn/card"]
})
```

**Returns**: CLI command to add components to project

---

#### `get_audit_checklist`
Get verification checklist after creating components.

```typescript
mcp__shadcn__get_audit_checklist()
```

**When to use**: After generating new components or code files

---

### Example Workflow

```typescript
// 1. Search for component
const results = await mcp__shadcn__search_items_in_registries({
  registries: ["@shadcn"],
  query: "button"
});

// 2. View component details
const details = await mcp__shadcn__view_items_in_registries({
  items: ["@shadcn/button"]
});

// 3. Get usage examples
const examples = await mcp__shadcn__get_item_examples_from_registries({
  registries: ["@shadcn"],
  query: "button-demo"
});

// 4. Get add command
const command = await mcp__shadcn__get_add_command_for_items({
  items: ["@shadcn/button"]
});
```

---

## Brave Search MCP

### Purpose
Web search for general information, news, articles, and online content.

### When to Use
- Broad information gathering
- Recent events or news
- Finding diverse web sources
- General research

### Available Functions

#### `brave_web_search`
Perform web search using Brave Search API.

```typescript
mcp__brave-search__brave_web_search({
  query: "Next.js 15 new features",
  count: 10,
  offset: 0
})
```

**Parameters**:
- `query` (string): Search query (max 400 chars, 50 words)
- `count` (number): Results to return (1-20, default 10)
- `offset` (number): Pagination offset (max 9, default 0)

**Returns**: Search results with titles, URLs, snippets

**Best for**: General queries, documentation, articles

---

#### `brave_local_search`
Search for local businesses and places.

```typescript
mcp__brave-search__brave_local_search({
  query: "pizza near Central Park",
  count: 5
})
```

**Parameters**:
- `query` (string): Local search query
- `count` (number): Results to return (1-20, default 5)

**Returns**:
- Business names and addresses
- Ratings and review counts
- Phone numbers and opening hours

**Best for**: "near me" queries, physical locations, businesses

**Note**: Automatically falls back to web search if no local results

---

### Brave vs Ref

| Use Brave When | Use Ref When |
|----------------|--------------|
| Recent news/articles | Official documentation |
| General information | Library API reference |
| Multiple sources | Authoritative single source |
| Blog posts/tutorials | Canonical examples |

---

## Chrome MCP

### Purpose
Browser automation and E2E testing.

### When to Use
- Testing web applications
- Automating browser interactions
- Capturing screenshots
- Running E2E tests

**Note**: Requires Chrome/Chromium installed and configured

---

## 21st-dev MCP

### Purpose
Design ideation and inspiration.

### When to Use
- Generating design ideas
- Finding UI/UX inspiration
- Component design brainstorming
- Visual design exploration

---

## Context7 MCP

### Purpose
Library documentation resolution and retrieval.

### When to Use
- Need specific library versions
- Resolving package names to documentation
- Getting comprehensive library docs

### Available Functions

#### `resolve-library-id`
Resolve package name to Context7-compatible library ID.

```typescript
mcp__context7__resolve-library-id({
  libraryName: "mongodb"
})
```

**Must call this BEFORE `get-library-docs`** unless user provides library ID in format `/org/project` or `/org/project/version`.

**Returns**: List of matching libraries with IDs, descriptions, trust scores

---

#### `get-library-docs`
Fetch up-to-date documentation for a library.

```typescript
mcp__context7__get-library-docs({
  context7CompatibleLibraryID: "/mongodb/docs",
  topic: "aggregation",
  tokens: 5000
})
```

**Parameters**:
- `context7CompatibleLibraryID` (string): Exact ID from `resolve-library-id` or user-provided
- `topic` (string): Focus topic (optional)
- `tokens` (number): Max tokens to retrieve (default 5000)

**Example IDs**:
- `/mongodb/docs`
- `/vercel/next.js`
- `/vercel/next.js/v14.3.0-canary.87`
- `/supabase/supabase`

---

## MCP Best Practices

### 1. Query External Intelligence Before Reading Files

```markdown
# ✅ Good
1. Query Ref MCP for React docs
2. Query project-intel.mjs for local code
3. Read targeted files with context

# ❌ Bad
1. Read all React-related files
2. Guess at correct usage
```

---

### 2. Use Appropriate Tool for Task

| Task | Tool |
|------|------|
| Library documentation | Ref or Context7 |
| Database schema | Supabase |
| Component code | Shadcn |
| Recent news | Brave (web) |
| Local business | Brave (local) |
| Browser testing | Chrome |
| Design ideas | 21st-dev |

---

### 3. Save Retrieved Data to Files

Don't dump large MCP outputs directly in chat. Save to files for parsing.

```typescript
// ✅ Good
const docs = await mcp__Ref__ref_read_url({ url: "..." });
await Write("temp-docs.md", docs);
// Parse temp-docs.md as needed

// ❌ Bad
const docs = await mcp__Ref__ref_read_url({ url: "..." });
// Print entire docs to chat (context pollution)
```

---

### 4. Log MCP Queries in Event Stream

```markdown
[2025-10-19 10:16:10] [session-id] research-external - mcp__Ref__ref_search_documentation("React hooks")
[2025-10-19 10:16:13] [session-id] research-external - Retrieved 5 doc sources, saved to research-docs.md
```

---

### 5. Verify MCP Results

MCP tools can return outdated or incorrect information. Always:
- Cross-reference with official sources
- Check documentation dates
- Verify examples actually work

---

## Integration with Intelligence Workflow

### Standard Pattern

```markdown
## Step 1: Local Intelligence (ALWAYS FIRST)
project-intel.mjs --search "component" --json

## Step 2: External Intelligence (IF NEEDED)
- Ref MCP for library docs
- Supabase MCP for database schema
- Brave MCP for recent articles

## Step 3: Read Files (WITH CONTEXT)
Read specific files identified by intel queries

## Step 4: Analysis with Evidence
CoD^Σ_Trace: "Per Ref MCP React docs, useEffect cleanup..."
```

---

## Troubleshooting

### MCP Server Not Available

**Cause**: Server not configured in .mcp.json or not approved

**Solution**:
1. Check .mcp.json exists
2. Verify server is listed
3. Approve server when prompted
4. Check Claude Code settings for MCP approval

---

### MCP Tool Returns No Results

**Possible causes**:
- Query too specific
- Service temporarily unavailable
- Authentication issues

**Solutions**:
- Broaden search terms
- Retry after brief delay
- Check MCP server logs
- Verify API keys (if required)

---

### MCP Response Too Large

**Solution**:
- Save to file instead of printing
- Use more specific queries
- Limit tokens parameter (Context7)
- Limit count parameter (Brave)

---

## Related Documentation

- **System Overview**: @docs/architecture/system-overview.md (Intelligence Sources section)
- **Project Intel CLI**: @docs/reference/project-intel-cli.md (local intelligence)
- **Claude Code MCP Guide**: @docs/reference/claude-code-docs/claude-code_configuration.md

---

**Key Takeaway**: MCP tools extend Claude's intelligence beyond local files. Use them for authoritative external information, but always query local intelligence (project-intel.mjs) first.
