"""
Simple Calculator Implementation

User Story 1 (Priority: P1) - Basic Arithmetic Operations

Constitutional Authority: Article III (Test-First Imperative)
Implementation follows TDD: tests written FIRST, now implementing

Acceptance Criteria:
- AC1: Addition (spec.md:119)
- AC2: Subtraction (spec.md:120)
- AC3: Multiplication (spec.md:121)
- AC4: Division (spec.md:122)
- AC5: Divide by zero error (spec.md:123)
- AC6: Invalid input error (spec.md:124)
"""

from decimal import Decimal, InvalidOperation


class Calculator:
    """
    Basic calculator supporting arithmetic operations

    Following Article III: Implementation AFTER tests
    Uses Decimal for precise arithmetic (15-digit precision per spec.md:74)
    """

    def _validate_input(self, a, b):
        """
        Validate inputs are numbers (Decimal or convertible to Decimal)

        Raises:
            ValueError: If inputs cannot be converted to Decimal
        """
        try:
            # If already Decimal, return as-is
            if not isinstance(a, Decimal):
                a = Decimal(str(a))
            if not isinstance(b, Decimal):
                b = Decimal(str(b))
            return a, b
        except (InvalidOperation, ValueError, TypeError):
            raise ValueError("Invalid input: numbers required")

    def add(self, a, b):
        """
        Add two numbers

        Args:
            a: First number (Decimal or numeric)
            b: Second number (Decimal or numeric)

        Returns:
            Decimal: Sum of a and b

        Raises:
            ValueError: If inputs are invalid
        """
        a, b = self._validate_input(a, b)
        return a + b

    def subtract(self, a, b):
        """
        Subtract two numbers

        Args:
            a: First number (Decimal or numeric)
            b: Second number (Decimal or numeric)

        Returns:
            Decimal: Difference of a and b (a - b)

        Raises:
            ValueError: If inputs are invalid
        """
        a, b = self._validate_input(a, b)
        return a - b

    def multiply(self, a, b):
        """
        Multiply two numbers

        Args:
            a: First number (Decimal or numeric)
            b: Second number (Decimal or numeric)

        Returns:
            Decimal: Product of a and b

        Raises:
            ValueError: If inputs are invalid
        """
        a, b = self._validate_input(a, b)
        return a * b

    def divide(self, a, b):
        """
        Divide two numbers

        Args:
            a: Numerator (Decimal or numeric)
            b: Denominator (Decimal or numeric)

        Returns:
            Decimal: Quotient of a / b

        Raises:
            ValueError: If inputs are invalid or b is zero
        """
        a, b = self._validate_input(a, b)

        # Check for division by zero (AC5: spec.md:123)
        if b == Decimal('0'):
            raise ValueError("Cannot divide by zero")

        return a / b
