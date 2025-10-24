# Implementation Tasks: Simple Calculator

**Feature**: simple-calculator
**Created**: 2025-10-19
**Plan**: specs/test-simple-calculator/plan.md
**Status**: Ready to Execute

---

## Task Organization

**Constitutional Requirement**: Article VII (User-Story-Centric Organization)

Tasks are organized by user story priority, not by technical layer.

**Execution Order**: P1 (MVP) → P2 (Enhancement) → P3 (Nice-to-Have)

---

## Phase 1: User Story P1 - Basic Arithmetic Operations (MVP)

**Priority**: Must-Have
**Goal**: Implement core calculator functionality
**Independent Test**: Can perform calculations without history/memory features

### Task P1.1: Set Up Project Structure

**Description**: Create project directory structure and configuration files

**Steps**:
1. Create directory structure:
   ```
   calculator/
   ├── calculator.py
   ├── cli.py
   ├── tests/
   │   └── test_calculator.py
   └── requirements.txt
   ```
2. Create requirements.txt with pytest
3. Initialize git repository (optional)

**Acceptance**: Directory structure exists, pytest can be installed

**Estimated**: 15 minutes

**Dependencies**: None

**Parallelizable**: No (foundation for other tasks)

---

### Task P1.2: Write Tests for P1 Acceptance Criteria

**Description**: Create 6 tests from P1 acceptance criteria (TDD: write tests FIRST)

**Test File**: `tests/test_calculator.py`

**Tests to Write**:
1. `test_add_two_numbers()` - AC1: 5 + 3 = 8
2. `test_subtract_two_numbers()` - AC2: 10 - 2 = 8
3. `test_multiply_two_numbers()` - AC3: 4 * 5 = 20
4. `test_divide_two_numbers()` - AC4: 15 / 3 = 5
5. `test_divide_by_zero_error()` - AC5: 10 / 0 → error "Cannot divide by zero"
6. `test_invalid_input_error()` - AC6: "abc" → error "Invalid input: numbers required"

**Expected**: All tests FAIL (no implementation yet - this is TDD)

**Acceptance**: 6 tests written, all fail with expected errors

**Estimated**: 30 minutes

**Dependencies**: Task P1.1 complete

**Parallelizable**: No (must run after setup)

---

### Task P1.3: Implement Calculator Class

**Description**: Create Calculator class with arithmetic operations

**File**: `calculator.py`

**Implementation**:
```python
from decimal import Decimal, InvalidOperation

class Calculator:
    def add(self, a: Decimal, b: Decimal) -> Decimal:
        return a + b

    def subtract(self, a: Decimal, b: Decimal) -> Decimal:
        return a - b

    def multiply(self, a: Decimal, b: Decimal) -> Decimal:
        return a * b

    def divide(self, a: Decimal, b: Decimal) -> tuple[Decimal | None, str | None]:
        if b == 0:
            return None, "Cannot divide by zero"
        return a / b, None
```

**Acceptance**: Tests 1-5 pass (divide by zero handling works)

**Estimated**: 30 minutes

**Dependencies**: Task P1.2 complete

**Parallelizable**: No (must run after tests written)

---

### Task P1.4: Implement CLI Interface

**Description**: Create command-line interface for calculator operations

**File**: `cli.py`

**Implementation**:
- Use argparse for command parsing
- Commands: `calc add <a> <b>`, `calc subtract <a> <b>`, etc.
- Input validation (ensure arguments are numeric)
- Error handling (display clear messages)

**Acceptance**: Test 6 passes (invalid input handled), can run from command line

**Estimated**: 45 minutes

**Dependencies**: Task P1.3 complete

**Parallelizable**: No (depends on Calculator class)

---

### Task P1.5: Verify P1 Independent Test

**Description**: Verify P1 story works standalone without P2/P3 features

**Validation**:
1. Run all 6 P1 tests → all pass
2. Manual test: `python cli.py add 5 3` → outputs 8
3. Manual test: `python cli.py divide 10 0` → error message
4. Confirm: No history/memory features required

**Acceptance**: P1 independently testable and working

**Estimated**: 15 minutes

**Dependencies**: Tasks P1.1-P1.4 complete

**Parallelizable**: No (final validation step)

---

**Phase 1 Total**: 2 hours 15 minutes
**Phase 1 Deliverable**: ✓ MVP shippable (basic calculator working)

---

## Phase 2: User Story P2 - Calculation History

**Priority**: Important (enhances P1)
**Goal**: Add history viewing and management
**Independent Test**: Can view/clear history without memory functions

### Task P2.1: Write Tests for P2 Acceptance Criteria

**Description**: Create 3 tests from P2 acceptance criteria

**Test File**: `tests/test_history.py`

**Tests to Write**:
1. `test_view_history_shows_all_operations()` - AC1: Perform 5+3, 10-2, view history → see both
2. `test_clear_history_empties_list()` - AC2: Perform operations, clear → history empty
3. `test_history_handles_1000_entries()` - AC3: Add 1,000 calculations → all stored

**Expected**: All tests FAIL (no History class yet)

**Acceptance**: 3 tests written, all fail with expected errors

**Estimated**: 20 minutes

**Dependencies**: Phase 1 complete (P1 must be working)

**Parallelizable**: No (depends on P1)

---

### Task P2.2: Implement History Class

**Description**: Create History class for storing calculations

**File**: `history.py`

**Implementation**:
```python
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from collections import deque

@dataclass
class HistoryEntry:
    operation: str
    result: Decimal
    timestamp: datetime

class History:
    def __init__(self, max_size=1000):
        self._entries = deque(maxlen=max_size)  # FIFO eviction

    def add(self, operation: str, result: Decimal):
        entry = HistoryEntry(operation, result, datetime.now())
        self._entries.append(entry)

    def get_all(self) -> list[HistoryEntry]:
        return list(self._entries)

    def clear(self):
        self._entries.clear()

    def __len__(self):
        return len(self._entries)
```

**Acceptance**: Tests 1-3 pass

**Estimated**: 25 minutes

**Dependencies**: Task P2.1 complete

**Parallelizable**: No (must run after tests)

---

### Task P2.3: Integrate History with Calculator

**Description**: Update Calculator and CLI to use History

**Changes**:
1. Calculator stores History instance
2. After each operation, add to history
3. CLI adds commands: `calc history`, `calc history clear`

**Acceptance**: History automatically populated after calculations

**Estimated**: 20 minutes

**Dependencies**: Task P2.2 complete

**Parallelizable**: No (integration task)

---

### Task P2.4: Verify P2 Independent Test

**Description**: Verify P2 story works standalone

**Validation**:
1. Run all 3 P2 tests → all pass
2. Manual test: Perform calculations, run `calc history` → see all operations
3. Manual test: Run `calc history clear` → history empty
4. Confirm: Works without memory functions

**Acceptance**: P2 independently testable and working

**Estimated**: 10 minutes

**Dependencies**: Tasks P2.1-P2.3 complete

**Parallelizable**: No (final validation)

---

**Phase 2 Total**: 1 hour 15 minutes
**Phase 2 Deliverable**: ✓ Calculator with history feature

---

## Phase 3: User Story P3 - Memory Functions

**Priority**: Nice-to-Have (future iteration)
**Goal**: Add memory storage and manipulation
**Independent Test**: Can use memory functions standalone

### Task P3.1: Write Tests for P3 Acceptance Criteria

**Description**: Create 5 tests from P3 acceptance criteria

**Test File**: `tests/test_memory.py`

**Tests to Write**:
1. `test_store_value_in_memory()` - AC1: M+ 8, MR → 8
2. `test_recall_memory_shows_value()` - AC2: M+ 8, MR → 8
3. `test_add_to_memory()` - AC3: M+ 8, M+ 5, MR → 13
4. `test_subtract_from_memory()` - AC4: M+ 13, M- 3, MR → 10
5. `test_clear_memory()` - AC5: M+ 10, MC, MR → 0

**Expected**: All tests FAIL (no Memory class yet)

**Acceptance**: 5 tests written, all fail with expected errors

**Estimated**: 25 minutes

**Dependencies**: Phase 2 complete (P2 must be working)

**Parallelizable**: No (depends on P2)

---

### Task P3.2: Implement Memory Class

**Description**: Create Memory class for value storage

**File**: `memory.py`

**Implementation**:
```python
from decimal import Decimal

class Memory:
    def __init__(self):
        self._value = Decimal(0)

    def add(self, value: Decimal):
        self._value += value

    def subtract(self, value: Decimal):
        self._value -= value

    def recall(self) -> Decimal:
        return self._value

    def clear(self):
        self._value = Decimal(0)
```

**Acceptance**: Tests 1-5 pass

**Estimated**: 20 minutes

**Dependencies**: Task P3.1 complete

**Parallelizable**: No (must run after tests)

---

### Task P3.3: Add Memory Commands to CLI

**Description**: Update CLI with memory commands

**Changes**:
1. CLI stores Memory instance
2. Add commands: `calc memory add <value>`, `calc memory recall`, `calc memory clear`
3. Update help text

**Acceptance**: Memory commands work from CLI

**Estimated**: 20 minutes

**Dependencies**: Task P3.2 complete

**Parallelizable**: No (integration task)

---

### Task P3.4: Verify P3 Independent Test

**Description**: Verify P3 story works standalone

**Validation**:
1. Run all 5 P3 tests → all pass
2. Manual test: `calc memory add 5` → stored
3. Manual test: `calc memory recall` → shows 5
4. Manual test: `calc memory clear` → recall shows 0
5. Confirm: Works independently

**Acceptance**: P3 independently testable and working

**Estimated**: 10 minutes

**Dependencies**: Tasks P3.1-P3.3 complete

**Parallelizable**: No (final validation)

---

**Phase 3 Total**: 1 hour 15 minutes
**Phase 3 Deliverable**: ✓ Full-featured calculator with memory

---

## Final Verification

### Task V.1: Run Full Test Suite

**Description**: Execute all 14 tests (P1: 6, P2: 3, P3: 5)

**Command**: `pytest tests/ -v --cov`

**Acceptance**: 14/14 tests passing, 100% AC coverage

**Estimated**: 5 minutes

**Dependencies**: All phases complete

**Parallelizable**: No (final step)

---

### Task V.2: Performance Validation

**Description**: Verify all operations < 100ms

**Method**:
1. Time each arithmetic operation
2. Time history operations (view, clear)
3. Time memory operations

**Acceptance**: All operations < 100ms (requirement met)

**Estimated**: 10 minutes

**Dependencies**: Task V.1 complete

**Parallelizable**: Yes (can run in parallel with V.3)

---

### Task V.3: Create Verification Report

**Description**: Generate verification-report.md documenting AC verification

**Content**:
- All 14 ACs listed
- Test results for each AC
- Performance metrics
- Independent test validations

**File**: `specs/test-simple-calculator/verification.md`

**Acceptance**: Verification report complete

**Estimated**: 15 minutes

**Dependencies**: Tasks V.1, V.2 complete

**Parallelizable**: No (needs results from V.1, V.2)

---

**Final Verification Total**: 30 minutes

---

## Summary

**Total Tasks**: 16 (P1: 5, P2: 4, P3: 4, Verification: 3)
**Total Time**: ~4 hours 45 minutes

**Parallelization Opportunities**: Limited (sequential by design - test-first approach)

**Critical Path**: P1 → P2 → P3 → Verification

**Story-Centric Organization**: ✓ Tasks grouped by user story per Article VII

**Test-First**: ✓ All test tasks before implementation tasks

**Independent Tests**: ✓ Each story has independent validation

---

**Version**: 1.0
**Last Updated**: 2025-10-19
**Status**: Ready for implement-and-verify skill execution

**Next Step**: Execute tasks using implement-and-verify skill with story-by-story workflow
