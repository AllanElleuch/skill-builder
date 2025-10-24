---
feature: simple-calculator-bad
created: 2025-10-19
status: Draft
priority: P1
technology_agnostic: true  # This is a LIE - spec contains tech details
---

# Feature Specification: Simple Calculator (WITH TECH DETAILS - TEST)

**NOTE**: This is a TEST specification with intentional violations to validate quality gates.

---

## Summary

A React-based calculator application that uses a REST API backend built with Node.js and Express, storing calculation history in a PostgreSQL database.

**Problem Statement**: Users need calculations
**Value Proposition**: Provides calculator functionality

---

## Functional Requirements

### FR-001: Frontend Implementation
System MUST use React with TypeScript for the user interface, implementing a component-based architecture with Redux for state management.

**Rationale**: Modern tech stack
**Priority**: Must Have

### FR-002: Backend API
System MUST implement REST API endpoints using Express.js framework:
- POST /api/calculate - for arithmetic operations
- GET /api/history - to retrieve calculation history
- DELETE /api/history - to clear history

**Rationale**: Standard API design
**Priority**: Must Have

### FR-003: Database Schema
System MUST create a PostgreSQL database table `calculations` with schema:
```sql
CREATE TABLE calculations (
  id SERIAL PRIMARY KEY,
  operation VARCHAR(50),
  result DECIMAL(15,2),
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Rationale**: Data persistence
**Priority**: Should Have

### FR-004: Authentication
System MUST use OAuth 2.0 with JWT tokens for user authentication.

**Rationale**: Security
**Priority**: Should Have

---

## Non-Functional Requirements

### Architecture
- Use microservices architecture with Docker containers
- Deploy backend on AWS Lambda
- Host frontend on Netlify
- Use Redis for caching

### Technology Stack
- Frontend: React 18, TypeScript, Tailwind CSS
- Backend: Node.js 20, Express.js 4.x
- Database: PostgreSQL 15
- Cache: Redis 7
- CI/CD: GitHub Actions

---

## User Stories

### User Story 1 - Calculator UI (Priority: P1)

**As a** user
**I want to** see a React-based calculator interface
**So that** I can perform calculations

**Acceptance Criteria**:
1. **Given** I open the app, **When** React loads, **Then** I see the calculator UI
2. **Given** I click buttons, **When** Redux state updates, **Then** display shows result

---

**Version**: 1.0 (BAD - for testing only)
