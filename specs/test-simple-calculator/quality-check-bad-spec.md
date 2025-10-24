# Quality Checklist

**Feature**: simple-calculator-bad
**Created**: 2025-10-19
**Specification**: specs/test-simple-calculator/spec-with-tech-details.md
**Purpose**: TEST - Validate quality checklist catches technology details

---

## Purpose

Pre-planning validation to ensure specification quality before technical design.

**Constitutional Authority**: Article V (Template-Driven Quality)

---

## Content Quality

**Check**: Specification is technology-agnostic (no implementation details)

- [ ] No tech stack mentioned (React, Python, etc.)
- [ ] No architecture details (REST API, microservices, etc.)
- [ ] No implementation specifics ("create database table", "use OAuth")
- [ ] Focus is on WHAT and WHY, not HOW

**Status**: ✗ FAIL

**Violations** (if any):

**CRITICAL VIOLATIONS - Technology Details in Specification**:

1. **Line 8 (Summary)**: "A React-based calculator application that uses a REST API backend built with Node.js and Express"
   - Violation: Mentions React, REST API, Node.js, Express
   - Should be: Technology-agnostic description of calculator functionality

2. **Line 8 (Summary)**: "storing calculation history in a PostgreSQL database"
   - Violation: Specifies database technology (PostgreSQL)
   - Should be: "stores calculation history" (no tech mentioned)

3. **FR-001 (Line 18)**: "System MUST use React with TypeScript for the user interface"
   - Violation: Mandates specific framework (React) and language (TypeScript)
   - Should be: "System MUST display user interface for calculations"

4. **FR-001 (Line 18)**: "implementing a component-based architecture with Redux for state management"
   - Violation: Specifies architecture pattern and state library
   - Should be: Describe WHAT state needs to be managed, not HOW

5. **FR-002 (Line 23)**: "System MUST implement REST API endpoints using Express.js framework"
   - Violation: Mandates REST architecture and Express framework
   - Should be: "System MUST provide interface for arithmetic operations"

6. **FR-002 (Lines 24-26)**: Specific API endpoints (POST /api/calculate, GET /api/history)
   - Violation: Implementation details (HTTP methods, URL patterns)
   - Should be: Describe operations needed, not API design

7. **FR-003 (Line 31)**: "System MUST create a PostgreSQL database table `calculations`"
   - Violation: Mandates database technology and schema
   - Should be: "System MUST store calculation history persistently"

8. **FR-003 (Lines 33-39)**: SQL CREATE TABLE statement
   - Violation: Actual implementation code in specification
   - Should be: Data model description (what needs to be stored)

9. **FR-004 (Line 46)**: "System MUST use OAuth 2.0 with JWT tokens for user authentication"
   - Violation: Specifies authentication protocol and token format
   - Should be: "System MUST authenticate users securely"

10. **Architecture Section (Lines 52-56)**: Entire section is implementation details
    - Violations: Docker, AWS Lambda, Netlify, Redis, microservices
    - Should be: Non-functional requirements (scale, availability) not tech choices

11. **Technology Stack Section (Lines 58-63)**: Entire section violates technology-agnostic rule
    - Violations: React 18, Node.js 20, PostgreSQL 15, Redis 7, GitHub Actions
    - Should be: This section should NOT exist in specification

12. **User Story 1 AC1 (Line 75)**: "When React loads"
    - Violation: References specific technology in acceptance criteria
    - Should be: "When application loads"

13. **User Story 1 AC2 (Line 76)**: "When Redux state updates"
    - Violation: References specific state library
    - Should be: "When user performs operation"

**TOTAL VIOLATIONS**: 13 technology references found

**Category Breakdown**:
- Frontend tech (React, TypeScript, Redux, Tailwind): 5 violations
- Backend tech (Node.js, Express, REST API): 4 violations
- Database tech (PostgreSQL, Redis, SQL): 3 violations
- Infrastructure (Docker, AWS, microservices): 3 violations
- Security tech (OAuth 2.0, JWT): 1 violation

---

## Requirement Completeness

**Check**: All requirements are testable, measurable, and bounded

**Status**: ✗ FAIL (due to Content Quality failure - cannot proceed to planning)

**Note**: Even if requirements were otherwise complete, the specification MUST be technology-agnostic before proceeding to planning per Article IV.

---

## Feature Readiness

**Check**: Feature has all artifacts needed for planning

**Status**: ✗ FAIL (blocked by Content Quality failure)

**Note**: Cannot assess readiness when fundamental constraint (technology-agnostic) is violated.

---

## Overall Assessment

**Content Quality**: ✗ FAIL (13 violations)
**Requirement Completeness**: ✗ FAIL (blocked)
**Feature Readiness**: ✗ FAIL (blocked)

**Summary**:
This specification violates the fundamental SDD principle of technology-agnostic specifications. The specification contains 13 distinct references to specific technologies, frameworks, and implementation details.

**Article IV Violation**: This specification mandates implementation choices (React, Node.js, PostgreSQL, OAuth 2.0, etc.) that should be deferred to the implementation plan phase.

**Impact**:
- Implementation team has no flexibility to choose appropriate technologies
- Specification becomes outdated when technology choices change
- Cannot reuse specification for different tech stacks
- Violates separation of concerns (WHAT vs HOW)

---

## Decision

**Ready for Planning**: ✗ NO - BLOCKED

**Required Actions**:
1. **Remove all technology references** - Rewrite specification to describe WHAT and WHY, not HOW
2. **Eliminate Architecture section** - Move to implementation plan
3. **Eliminate Technology Stack section** - Move to implementation plan
4. **Rewrite functional requirements** - Focus on capabilities, not implementation
5. **Fix acceptance criteria** - Remove React/Redux references, use generic "application" language
6. **Review against feature-spec.md template** - Ensure compliance with technology-agnostic constraint

**Example Fix**:
- ✗ BAD: "System MUST use React with TypeScript for the user interface"
- ✓ GOOD: "System MUST display user interface showing number input and operation selection"

- ✗ BAD: "System MUST implement REST API endpoints using Express.js"
- ✓ GOOD: "System MUST provide interface for performing arithmetic operations"

- ✗ BAD: "System MUST create PostgreSQL database table `calculations`"
- ✓ GOOD: "System MUST store calculation history persistently across sessions"

**If Yes, Next Step**: N/A - specification must be fixed first

---

**Validation Date**: 2025-10-19
**Validated By**: Claude Code (SDD Testing - Scenario 4)
**Status**: ✗ BLOCKED - Fix violations before proceeding to planning

**Test Outcome**: ✓ SUCCESS - Quality checklist correctly identified all technology violations
