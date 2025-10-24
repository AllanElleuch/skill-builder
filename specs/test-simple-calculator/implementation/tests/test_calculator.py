"""
Test Suite for Simple Calculator - P1: Basic Arithmetic Operations

User Story 1 (Priority: P1)
Tests written BEFORE implementation per Article III (Test-First Imperative)

Constitutional Authority: Article III, Article VII
"""

import pytest
from decimal import Decimal
from calculator.calculator import Calculator


class TestP1BasicArithmetic:
    """User Story 1 - Basic Arithmetic Operations (P1)"""

    def setup_method(self):
        """Create fresh calculator instance for each test"""
        self.calc = Calculator()

    # AC1: Addition Test
    def test_add_two_numbers(self):
        """
        Given: Two numbers (5 and 3)
        When: I add them
        Then: I receive result 8

        Acceptance Criterion 1 from spec.md:119
        """
        result = self.calc.add(Decimal('5'), Decimal('3'))
        assert result == Decimal('8'), f"Expected 8, got {result}"

    # AC2: Subtraction Test
    def test_subtract_two_numbers(self):
        """
        Given: Two numbers (10 and 2)
        When: I subtract them
        Then: I receive result 8

        Acceptance Criterion 2 from spec.md:120
        """
        result = self.calc.subtract(Decimal('10'), Decimal('2'))
        assert result == Decimal('8'), f"Expected 8, got {result}"

    # AC3: Multiplication Test
    def test_multiply_two_numbers(self):
        """
        Given: Two numbers (4 and 5)
        When: I multiply them
        Then: I receive result 20

        Acceptance Criterion 3 from spec.md:121
        """
        result = self.calc.multiply(Decimal('4'), Decimal('5'))
        assert result == Decimal('20'), f"Expected 20, got {result}"

    # AC4: Division Test
    def test_divide_two_numbers(self):
        """
        Given: Two numbers (15 and 3)
        When: I divide them
        Then: I receive result 5

        Acceptance Criterion 4 from spec.md:122
        """
        result = self.calc.divide(Decimal('15'), Decimal('3'))
        assert result == Decimal('5'), f"Expected 5, got {result}"

    # AC5: Divide by Zero Error
    def test_divide_by_zero_error(self):
        """
        Given: Two numbers (10 and 0)
        When: I attempt to divide
        Then: I receive error "Cannot divide by zero"

        Acceptance Criterion 5 from spec.md:123
        """
        with pytest.raises(ValueError, match="Cannot divide by zero"):
            self.calc.divide(Decimal('10'), Decimal('0'))

    # AC6: Invalid Input Error
    def test_invalid_input_error(self):
        """
        Given: I enter invalid input (letters instead of numbers)
        When: I attempt calculation
        Then: I receive error "Invalid input: numbers required"

        Acceptance Criterion 6 from spec.md:124
        """
        with pytest.raises(ValueError, match="Invalid input: numbers required"):
            self.calc.add("abc", "def")


# Independent Test Verification (Article VII requirement)
class TestP1Independence:
    """Verify P1 works standalone without P2 (history) or P3 (memory)"""

    def test_calculator_works_without_history(self):
        """
        Verify calculator can perform basic arithmetic
        without requiring history or memory features

        Article VII: MVP = P1 complete
        """
        calc = Calculator()

        # Perform multiple calculations
        assert calc.add(Decimal('1'), Decimal('1')) == Decimal('2')
        assert calc.subtract(Decimal('5'), Decimal('3')) == Decimal('2')
        assert calc.multiply(Decimal('2'), Decimal('3')) == Decimal('6')
        assert calc.divide(Decimal('10'), Decimal('2')) == Decimal('5')

        # No dependency on history or memory features
        # Calculator should work in isolation
