# Project Philosophy: ValidPy Library

> A Python library for runtime data validation with type safety and clear error messages

## Overview

This document defines the coding philosophy for ValidPy, a Python library that provides runtime validation for data structures with excellent developer experience, clear error messages, and zero runtime overhead when validation is disabled.

**Tech Stack**: Python 3.9+, type hints, dataclasses, pytest

**Team Size**: 3 maintainers, 50+ contributors

**Users**: 100k+ downloads/month, used in production by 500+ companies

**Use Cases**: API validation, configuration parsing, data pipeline verification

---

## Our Core Philosophy

Library code requires different thinking than application code - we serve thousands of developers, not users:

- **[Python's Zen](../../philosophies/languages/PYTHON.PHILOSOPHY.md)** - Beautiful is better than ugly, explicit is better than implicit
- **[Rich Hickey's Simplicity](../../philosophies/people/RICH_HICKEY.PHILOSOPHY.md)** - Make simple easy, make complex possible
- **[Clean Code](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)** - Clear API, readable code
- **[TDD](../../philosophies/methodologies/TDD.PHILOSOPHY.md)** - Libraries must be bulletproof
- **[Rust's Explicitness](../../philosophies/languages/RUST.PHILOSOPHY.md)** - No surprises, predictable behavior

**Our Philosophy Statement**: *"ValidPy makes validation delightful. Simple cases are trivial, complex cases are clear, and errors always tell you exactly what went wrong."*

---

## 1. API Design: Make Simple Things Simple

**Why**: Rich Hickey's philosophy - a library should make simple tasks trivial while keeping complex tasks possible.

### The API Hierarchy

```python
# ✅ Level 1: Dead simple (covers 80% of use cases)
from validpy import validate, String, Integer

user_data = {
    "name": "Alice",
    "age": 30
}

schema = {
    "name": String(min_length=1),
    "age": Integer(min=0, max=150)
}

result = validate(user_data, schema)
if result.is_valid:
    print("Valid!")
else:
    print(f"Errors: {result.errors}")

# ✅ Level 2: Moderate complexity (covers 15% of use cases)
from validpy import Validator, Email, Optional

class UserValidator(Validator):
    name: String(min_length=1, max_length=100)
    email: Email()
    age: Optional[Integer(min=0, max=150)]

    def validate_age(self, value):
        """Custom validation: adults only."""
        if value is not None and value < 18:
            raise ValidationError("Must be 18 or older")
        return value

validator = UserValidator()
result = validator.validate(user_data)

# ✅ Level 3: Advanced (covers 5% of use cases)
from validpy import Schema, Field, ValidationContext

class AdvancedUserSchema(Schema):
    name: Field(
        String(),
        transform=str.strip,
        validators=[
            lambda v: v.isalnum() or "Must be alphanumeric",
            lambda v: v[0].isupper() or "Must start with capital"
        ]
    )

    @validates("name")
    def check_name_not_admin(self, value, context: ValidationContext):
        """Context-aware validation."""
        if value.lower() == "admin" and not context.get("is_admin_user"):
            raise ValidationError("Reserved name")
        return value
```

**API Design Principle**: Each level builds on the previous. Users can graduate to complexity as needed, but simple cases never require understanding advanced features.

**Reference**: [Rich Hickey Philosophy](../../philosophies/people/RICH_HICKEY.PHILOSOPHY.md#1-simplicity-is-not-easy)

---

## 2. Error Messages: Clear and Actionable

**Why**: When validation fails, developers need to know exactly what's wrong and how to fix it.

### Error Message Quality

```python
# ❌ BAD: Vague errors
ValidationError: Invalid data
ValidationError: Field error at age

# ✅ GOOD: Specific, actionable errors
class ValidationResult:
    """Results from validation with detailed error context."""

    def __init__(self):
        self.errors: List[ValidationError] = []

    @property
    def is_valid(self) -> bool:
        return len(self.errors) == 0

    def add_error(
        self,
        field: str,
        message: str,
        value: Any = None,
        constraint: Any = None
    ):
        """Add error with full context."""
        self.errors.append(
            ValidationError(
                field=field,
                message=message,
                value=value,
                constraint=constraint,
                path=self._get_field_path(field)
            )
        )

# Example error output:
"""
ValidationError at user.profile.age:
  Value: -5
  Constraint: min=0, max=150
  Message: Age must be between 0 and 150, got -5

Did you mean to use an unsigned integer?
"""

# For nested structures, show the path:
"""
ValidationError at config.database.connections[0].port:
  Value: "3000"
  Expected: Integer between 1 and 65535
  Got: String

Hint: Convert to integer: port=int("3000")
"""
```

### Error Aggregation

```python
# Collect all errors, not just first one
def validate_dict(data: dict, schema: dict) -> ValidationResult:
    """Validate entire dict, collecting all errors."""
    result = ValidationResult()

    # Don't stop at first error - validate everything
    for field, validator in schema.items():
        if field not in data:
            result.add_error(
                field=field,
                message=f"Required field '{field}' is missing",
                constraint="required"
            )
            continue

        value = data[field]
        try:
            validator.validate(value)
        except ValidationError as e:
            result.add_error(
                field=field,
                message=str(e),
                value=value,
                constraint=validator.constraint
            )

    return result

# User sees ALL errors at once:
# - Missing field: email
# - Invalid value at age: must be >= 0
# - Invalid format at phone: must match pattern \d{3}-\d{3}-\d{4}
#
# They can fix everything in one go, not play whack-a-mole
```

**Reference**: [Clean Code Philosophy](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)

---

## 3. Type Safety: Leverage Python Type Hints

**Why**: Type hints provide IDE autocomplete, catch bugs early, and serve as documentation.

### Fully Typed Public API

```python
from typing import Any, Dict, List, Optional, Union, TypeVar, Generic
from typing_extensions import Protocol

T = TypeVar('T')

class Validator(Protocol[T]):
    """Protocol defining validator interface."""

    def validate(self, value: Any) -> T:
        """
        Validate and return typed value.

        Args:
            value: Raw input value

        Returns:
            Validated and possibly transformed value

        Raises:
            ValidationError: If validation fails
        """
        ...

    @property
    def constraint(self) -> Dict[str, Any]:
        """Return constraint description for error messages."""
        ...

# Concrete validators are fully typed
class String(Validator[str]):
    """String validator with type guarantee."""

    def __init__(
        self,
        *,
        min_length: Optional[int] = None,
        max_length: Optional[int] = None,
        pattern: Optional[str] = None
    ) -> None:
        self.min_length = min_length
        self.max_length = max_length
        self.pattern = pattern

    def validate(self, value: Any) -> str:
        """Validate and return string."""
        if not isinstance(value, str):
            raise ValidationError(
                f"Expected string, got {type(value).__name__}"
            )

        if self.min_length and len(value) < self.min_length:
            raise ValidationError(
                f"String must be at least {self.min_length} characters"
            )

        # ... more validation ...

        return value  # Type checker knows this is str

# Usage with full type inference
validator: Validator[str] = String(min_length=5)
result: str = validator.validate("hello")  # Type is known!
```

### Generic Validators

```python
class List_(Generic[T], Validator[List[T]]):
    """Generic list validator."""

    def __init__(
        self,
        item_validator: Validator[T],
        *,
        min_items: Optional[int] = None,
        max_items: Optional[int] = None
    ) -> None:
        self.item_validator = item_validator
        self.min_items = min_items
        self.max_items = max_items

    def validate(self, value: Any) -> List[T]:
        """Validate list and its items."""
        if not isinstance(value, list):
            raise ValidationError(f"Expected list, got {type(value).__name__}")

        if self.min_items and len(value) < self.min_items:
            raise ValidationError(f"List must have at least {self.min_items} items")

        # Validate each item
        validated_items: List[T] = []
        for i, item in enumerate(value):
            try:
                validated_item = self.item_validator.validate(item)
                validated_items.append(validated_item)
            except ValidationError as e:
                raise ValidationError(f"Invalid item at index {i}: {e}")

        return validated_items

# Type inference works perfectly:
int_list_validator: Validator[List[int]] = List_(Integer())
numbers: List[int] = int_list_validator.validate([1, 2, 3])  # Type is List[int]!
```

**Reference**: [Rust Language Philosophy](../../philosophies/languages/RUST.PHILOSOPHY.md#6-types-prevent-errors)

---

## 4. Testing: Comprehensive and Fast

**Why**: Libraries are used in countless ways we can't predict. Thorough testing is non-negotiable.

### Test Coverage Strategy

```python
# Aim for >95% coverage for public API
# 100% coverage for critical paths

import pytest
from validpy import String, Integer, ValidationError

class TestStringValidator:
    """Comprehensive tests for String validator."""

    def test_valid_string(self):
        """Basic happy path."""
        validator = String()
        assert validator.validate("hello") == "hello"

    def test_non_string_rejected(self):
        """Type checking."""
        validator = String()
        with pytest.raises(ValidationError, match="Expected string"):
            validator.validate(123)

    def test_min_length_enforced(self):
        """Min length constraint."""
        validator = String(min_length=5)
        assert validator.validate("hello") == "hello"

        with pytest.raises(ValidationError, match="at least 5 characters"):
            validator.validate("hi")

    def test_max_length_enforced(self):
        """Max length constraint."""
        validator = String(max_length=5)
        assert validator.validate("hello") == "hello"

        with pytest.raises(ValidationError, match="at most 5 characters"):
            validator.validate("hello world")

    @pytest.mark.parametrize("value,expected", [
        ("hello", True),
        ("", False),  # Too short
        ("a" * 1000, False),  # Too long
    ])
    def test_length_boundaries(self, value, expected):
        """Test boundary conditions."""
        validator = String(min_length=1, max_length=100)
        if expected:
            assert validator.validate(value) == value
        else:
            with pytest.raises(ValidationError):
                validator.validate(value)

    def test_pattern_matching(self):
        """Regex pattern validation."""
        email = String(pattern=r"^[\w\.-]+@[\w\.-]+\.\w+$")

        assert email.validate("user@example.com") == "user@example.com"

        with pytest.raises(ValidationError, match="pattern"):
            email.validate("not-an-email")

# Property-based testing for edge cases
from hypothesis import given, strategies as st

class TestStringProperties:
    """Property-based tests using Hypothesis."""

    @given(st.text())
    def test_validate_never_crashes(self, text):
        """String validator should never crash on any string."""
        validator = String()
        try:
            validator.validate(text)
        except ValidationError:
            pass  # ValidationError is expected, crashes are not

    @given(st.text(min_size=10, max_size=20))
    def test_length_constraints_always_work(self, text):
        """Length validation should work for any valid string."""
        validator = String(min_length=5, max_length=50)
        result = validator.validate(text)
        assert isinstance(result, str)
        assert 5 <= len(result) <= 50
```

### Integration Tests

```python
class TestRealWorldUseCases:
    """Test realistic usage patterns."""

    def test_api_request_validation(self):
        """Validate API request body."""
        schema = {
            "username": String(min_length=3, max_length=20),
            "email": Email(),
            "age": Integer(min=18),
            "tags": List_(String(), max_items=5)
        }

        # Valid data
        valid_data = {
            "username": "alice",
            "email": "alice@example.com",
            "age": 25,
            "tags": ["python", "rust"]
        }
        result = validate(valid_data, schema)
        assert result.is_valid

        # Invalid data - collect all errors
        invalid_data = {
            "username": "ab",  # Too short
            "email": "not-an-email",
            "age": 15,  # Too young
            "tags": ["a", "b", "c", "d", "e", "f"]  # Too many
        }
        result = validate(invalid_data, schema)
        assert not result.is_valid
        assert len(result.errors) == 4  # All errors collected

    def test_config_file_parsing(self):
        """Validate configuration from YAML/JSON."""
        config_schema = {
            "database": {
                "host": String(),
                "port": Integer(min=1, max=65535),
                "name": String()
            },
            "cache": {
                "enabled": Boolean(),
                "ttl": Integer(min=0)
            }
        }

        config_data = load_config("config.yml")
        result = validate(config_data, config_schema)

        if not result.is_valid:
            # Generate helpful error message
            raise ConfigError(
                f"Invalid configuration:\n{format_errors(result.errors)}"
            )
```

**Test Performance**:
```
Collected 847 tests
test_validators.py .................. [  12%]
test_schemas.py ..................... [  35%]
test_integration.py ................. [  58%]
test_edge_cases.py .................. [  81%]
test_performance.py ................. [ 100%]

847 passed in 3.24s
```

**Reference**: [TDD Philosophy](../../philosophies/methodologies/TDD.PHILOSOPHY.md)

---

## 5. Performance: Fast by Default

**Why**: Libraries are often in hot paths. Slow libraries get replaced.

### Performance Targets

```python
# TARGETS:
# - Simple validation: < 1µs
# - Complex validation: < 10µs
# - Nested structures: O(n) where n = number of fields
# - Zero overhead when validation disabled (production mode)

# ❌ SLOW: Create objects on every validation
class SlowValidator:
    def validate(self, value):
        errors = []  # Allocation!
        result = ValidationResult()  # Allocation!
        # ...

# ✅ FAST: Reuse objects, minimize allocations
class FastValidator:
    def __init__(self):
        self._result = ValidationResult()  # Reused
        self._errors = []  # Reused

    def validate(self, value):
        self._result.clear()
        self._errors.clear()
        # ... validation logic ...
        return self._result

# ✅ FAST: Avoid regex compilation on every call
class EmailValidator:
    # Compile pattern once at class level
    EMAIL_PATTERN = re.compile(r"^[\w\.-]+@[\w\.-]+\.\w+$")

    def validate(self, value: str) -> str:
        if not self.EMAIL_PATTERN.match(value):
            raise ValidationError("Invalid email format")
        return value
```

### Lazy Compilation

```python
class Schema:
    """Schema that compiles validators lazily."""

    def __init__(self, schema_dict: Dict[str, Validator]):
        self._schema = schema_dict
        self._compiled: Optional[CompiledSchema] = None

    def validate(self, data: Dict[str, Any]) -> ValidationResult:
        # Compile schema once on first use
        if self._compiled is None:
            self._compiled = self._compile_schema()

        return self._compiled.validate(data)

    def _compile_schema(self) -> 'CompiledSchema':
        """
        Pre-compute validation plan.

        For schema like:
        {
            "name": String(min_length=1),
            "age": Integer(min=0)
        }

        Generate optimized validation bytecode:
        1. Check key "name" exists
        2. Check value is str
        3. Check len >= 1
        4. Check key "age" exists
        5. Check value is int
        6. Check value >= 0
        """
        return CompiledSchema(self._schema)
```

### Optional JIT Compilation

```python
# Advanced: Compile validators to native code for hot paths
try:
    from validpy.jit import compile_schema

    # For production: compile to native code
    validator = compile_schema(schema, optimize=True)
    # 10x faster for large schemas
except ImportError:
    # Fallback to pure Python
    validator = Schema(schema)
```

**Benchmark Results**:
```python
import pytest

def benchmark_simple_validation(benchmark):
    validator = String(min_length=1, max_length=100)

    benchmark(validator.validate, "hello")
    # Result: 587 ns/op (< 1µs) ✓

def benchmark_complex_schema(benchmark):
    schema = {
        "user": {
            "name": String(min_length=1),
            "email": Email(),
            "age": Integer(min=0, max=150),
            "tags": List_(String(), max_items=10)
        }
    }

    data = {
        "user": {
            "name": "Alice",
            "email": "alice@example.com",
            "age": 30,
            "tags": ["python", "rust"]
        }
    }

    benchmark(validate, data, schema)
    # Result: 8.3 µs/op (< 10µs) ✓
```

**Reference**: [John Carmack Philosophy](../../philosophies/people/JOHN_CARMACK.PHILOSOPHY.md#1-performance-enables-experiences)

---

## 6. Backward Compatibility: Semver Strictly

**Why**: Breaking users' code destroys trust. Semantic versioning is a contract.

### Versioning Policy

```python
# v1.0.0 → v1.0.1: Patch (bug fixes only)
# - Fix: Email validator now correctly handles +addresses
# - Fix: Error messages show correct field path for nested objects
# GUARANTEE: No API changes, drop-in replacement

# v1.0.0 → v1.1.0: Minor (new features, backward compatible)
# - Add: IPv4Address validator
# - Add: Optional transform parameter to all validators
# - Deprecate: validate_dict() in favor of validate()
# GUARANTEE: Old code still works

# v1.0.0 → v2.0.0: Major (breaking changes)
# - BREAKING: Remove deprecated validate_dict()
# - BREAKING: ValidationResult.errors is now a list, not dict
# - BREAKING: Minimum Python version is now 3.9
# GUARANTEE: Clear migration guide provided
```

### Deprecation Process

```python
import warnings
from typing import Optional

def validate_dict(
    data: dict,
    schema: dict
) -> ValidationResult:
    """
    Validate dictionary against schema.

    .. deprecated:: 1.1.0
        Use :func:`validate` instead. This function will be
        removed in version 2.0.0.

    Example migration:

        # Old (deprecated):
        result = validate_dict(data, schema)

        # New (recommended):
        result = validate(data, schema)
    """
    warnings.warn(
        "validate_dict() is deprecated, use validate() instead",
        DeprecationWarning,
        stacklevel=2
    )
    return validate(data, schema)

# Users get warning with clear upgrade path:
# DeprecationWarning: validate_dict() is deprecated, use validate() instead
#   See: https://docs.validpy.org/en/latest/migration-guide.html#v1-1-0
```

### Feature Flags for Breaking Changes

```python
# Allow users to opt into new behavior before v2.0
class Config:
    """Global configuration."""

    # v1.x default: errors is dict
    # v2.x default: errors is list
    errors_as_list: bool = False

# v1.5.0: Introduce opt-in flag
Config.errors_as_list = True  # Opt into v2.0 behavior early

# v2.0.0: Make it default
# Users who opted in early have smooth upgrade
```

**Reference**: [Rich Hickey Philosophy](../../philosophies/people/RICH_HICKEY.PHILOSOPHY.md) - Spec-ulation Keynote on change

---

## 7. Documentation: Excellent Docs = More Users

**Why**: Library success depends on documentation quality. Great code with poor docs won't get adopted.

### Documentation Layers

```python
# Layer 1: Docstrings (for IDE autocomplete)
class String(Validator[str]):
    """
    Validate string values with optional constraints.

    Args:
        min_length: Minimum string length (inclusive)
        max_length: Maximum string length (inclusive)
        pattern: Regular expression pattern to match

    Example:
        >>> validator = String(min_length=5, max_length=10)
        >>> validator.validate("hello")
        'hello'
        >>> validator.validate("hi")
        ValidationError: String must be at least 5 characters

    See Also:
        - :class:`Email` for email validation
        - :class:`URL` for URL validation
    """

    def __init__(
        self,
        *,
        min_length: Optional[int] = None,
        max_length: Optional[int] = None,
        pattern: Optional[str] = None
    ) -> None:
        ...

# Layer 2: Tutorial (for getting started)
# docs/tutorial.md

# Layer 3: How-to guides (for common tasks)
# docs/how-to/validate-api-requests.md
# docs/how-to/custom-validators.md

# Layer 4: Reference (for complete API)
# Auto-generated from docstrings using Sphinx

# Layer 5: Theory (for understanding concepts)
# docs/concepts/validation-vs-parsing.md
```

### Runnable Examples

```python
# Every code example in docs must be runnable and tested

# docs/examples/basic_validation.py
"""
Basic Validation Example
========================

This example shows how to validate a simple dictionary.
"""

from validpy import validate, String, Integer

# Define schema
schema = {
    "name": String(min_length=1),
    "age": Integer(min=0, max=150)
}

# Valid data
data = {"name": "Alice", "age": 30}
result = validate(data, schema)
print(f"Valid: {result.is_valid}")  # Output: Valid: True

# Invalid data
data = {"name": "", "age": -5}
result = validate(data, schema)
print(f"Valid: {result.is_valid}")  # Output: Valid: False
print(f"Errors: {result.errors}")
# Output: Errors: [
#   ValidationError(field='name', message='String must be at least 1 characters'),
#   ValidationError(field='age', message='Integer must be >= 0')
# ]

# Test that this example actually works:
if __name__ == "__main__":
    import doctest
    doctest.testmod()

# CI runs: python docs/examples/basic_validation.py
# If it fails, docs are broken!
```

### Interactive Documentation

```python
# Use Jupyter notebooks for tutorials
# docs/tutorials/getting-started.ipynb

# Cells are:
# 1. Text explanation
# 2. Code example
# 3. Output shown inline
# 4. User can experiment interactively

# Published to: https://docs.validpy.org/tutorials/
```

**Reference**: [Clean Code Philosophy](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)

---

## 8. Dependencies: Minimize and Justify

**Why**: Every dependency is a liability - security, compatibility, bloat.

### Dependency Policy

```python
# CORE (zero dependencies):
# - validpy/validators.py
# - validpy/schema.py
# - validpy/errors.py
# - validpy/result.py
# Uses only Python stdlib

# OPTIONAL (extras):
# pip install validpy[email]   → adds email-validator
# pip install validpy[phone]   → adds phonenumbers
# pip install validpy[jit]     → adds numba for compilation

# pyproject.toml
[project]
name = "validpy"
dependencies = []  # Zero required dependencies!

[project.optional-dependencies]
email = ["email-validator>=2.0"]
phone = ["phonenumbers>=8.13"]
jit = ["numba>=0.56"]
dev = ["pytest>=7.0", "hypothesis>=6.0", "mypy>=1.0"]
```

### Conditional Imports

```python
# Graceful degradation for optional dependencies

try:
    from email_validator import validate_email as _validate_email
    HAS_EMAIL_VALIDATOR = True
except ImportError:
    HAS_EMAIL_VALIDATOR = False

class Email(Validator[str]):
    """Email validator."""

    def validate(self, value: str) -> str:
        if HAS_EMAIL_VALIDATOR:
            # Use external library if available (more robust)
            try:
                validated = _validate_email(value)
                return validated.email
            except EmailNotValidError as e:
                raise ValidationError(f"Invalid email: {e}")
        else:
            # Fallback to simple regex (good enough for most cases)
            if not re.match(r"^[\w\.-]+@[\w\.-]+\.\w+$", value):
                raise ValidationError(
                    "Invalid email format. "
                    "Install validpy[email] for better validation."
                )
            return value
```

**Why Zero Dependencies?**:
1. Faster installation
2. Fewer security vulnerabilities
3. No version conflicts
4. Smaller package size
5. Works everywhere Python works

**Reference**: [Unix Philosophy](../../philosophies/methodologies/UNIX.PHILOSOPHY.md) - Minimalism

---

## 9. Extensibility: Make Customization Easy

**Why**: Libraries can't predict all use cases. Users need to extend functionality.

### Custom Validators

```python
# Make it trivial to create custom validators

from validpy import Validator, ValidationError

class CreditCard(Validator[str]):
    """Custom validator for credit card numbers."""

    def validate(self, value: str) -> str:
        # Remove spaces and dashes
        cleaned = value.replace(" ", "").replace("-", "")

        # Check length
        if not (13 <= len(cleaned) <= 19):
            raise ValidationError("Credit card must be 13-19 digits")

        # Check all digits
        if not cleaned.isdigit():
            raise ValidationError("Credit card must contain only digits")

        # Luhn algorithm
        if not self._luhn_check(cleaned):
            raise ValidationError("Invalid credit card number (failed Luhn check)")

        return cleaned

    def _luhn_check(self, number: str) -> bool:
        """Validate using Luhn algorithm."""
        digits = [int(d) for d in number]
        checksum = 0

        for i, digit in enumerate(reversed(digits)):
            if i % 2 == 1:
                digit *= 2
                if digit > 9:
                    digit -= 9
            checksum += digit

        return checksum % 10 == 0

# Usage - works like built-in validators
card_validator = CreditCard()
card_validator.validate("4532-1488-0343-6467")  # Visa card
```

### Validator Composition

```python
# Combine validators easily

class OneOf(Validator[T]):
    """Value must pass at least one validator."""

    def __init__(self, *validators: Validator[T]):
        self.validators = validators

    def validate(self, value: Any) -> T:
        errors = []

        for validator in self.validators:
            try:
                return validator.validate(value)
            except ValidationError as e:
                errors.append(str(e))

        # None passed
        raise ValidationError(
            f"Value did not pass any validator. Errors: {'; '.join(errors)}"
        )

# Usage: Accept string or integer
validator = OneOf(String(), Integer())
validator.validate("hello")  # ✓ Valid
validator.validate(42)       # ✓ Valid
validator.validate([])       # ✗ Invalid

# Allow phone as string or structured object
phone = OneOf(
    String(pattern=r"\d{3}-\d{3}-\d{4}"),
    Dict({
        "country_code": String(),
        "area_code": String(),
        "number": String()
    })
)
```

### Hooks and Middleware

```python
# Allow users to hook into validation process

class ValidatorMiddleware:
    """Middleware that wraps validation."""

    def before_validate(self, validator: Validator, value: Any):
        """Called before validation."""
        pass

    def after_validate(self, validator: Validator, value: Any, result: Any):
        """Called after successful validation."""
        pass

    def on_error(self, validator: Validator, value: Any, error: ValidationError):
        """Called when validation fails."""
        pass

# Example: Logging middleware
class LoggingMiddleware(ValidatorMiddleware):
    def before_validate(self, validator, value):
        logger.debug(f"Validating {type(value).__name__} with {validator}")

    def on_error(self, validator, value, error):
        logger.warning(f"Validation failed: {error}")

# Apply middleware
schema = Schema({
    "name": String(),
    "age": Integer()
}, middleware=[LoggingMiddleware()])
```

**Reference**: [Clean Code Philosophy](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)

---

## 10. Release Process: Stable and Predictable

**Why**: Users depend on libraries. Unstable releases break trust.

### Release Checklist

```markdown
# Release Checklist for v1.5.0

## Pre-release (1 week before)
- [ ] All tests passing on all Python versions (3.9, 3.10, 3.11, 3.12)
- [ ] Code coverage ≥ 95%
- [ ] Type checking passes (mypy --strict)
- [ ] Performance benchmarks within targets
- [ ] Changelog updated
- [ ] Migration guide written (if needed)
- [ ] Documentation updated
- [ ] All examples tested and working

## Release Day
- [ ] Version bumped in pyproject.toml
- [ ] Git tag created: v1.5.0
- [ ] Build: python -m build
- [ ] Test package: pip install dist/validpy-1.5.0-py3-none-any.whl
- [ ] Upload to Test PyPI: twine upload --repository testpypi dist/*
- [ ] Test install from Test PyPI
- [ ] Upload to PyPI: twine upload dist/*
- [ ] GitHub release created with changelog
- [ ] Documentation deployed
- [ ] Announcement on Twitter/Reddit/HN

## Post-release (1 week after)
- [ ] Monitor GitHub issues for bug reports
- [ ] Monitor PyPI download stats
- [ ] Respond to user feedback
- [ ] Plan next release
```

### Automated Release Pipeline

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.9', '3.10', '3.11', '3.12']

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}

      - name: Install dependencies
        run: |
          pip install -e ".[dev]"

      - name: Run tests
        run: pytest --cov=validpy --cov-report=xml

      - name: Type check
        run: mypy validpy

  build:
    needs: test
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4

      - name: Build package
        run: |
          pip install build
          python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
        with:
          password: ${{ secrets.PYPI_API_TOKEN }}

  docs:
    needs: build
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Build docs
        run: |
          cd docs
          pip install -r requirements.txt
          make html

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs/_build/html
```

**Reference**: [Martin Fowler Philosophy](../../philosophies/people/MARTIN_FOWLER.PHILOSOPHY.md#6-continuous-integration)

---

## Anti-Patterns

### ❌ Don't Add Features Without Use Cases

```python
# Bad: Adding features "just in case"
class String(Validator):
    def __init__(
        self,
        min_length=None,
        max_length=None,
        pattern=None,
        contains=None,
        starts_with=None,
        ends_with=None,
        case_sensitive=True,
        trim=False,
        normalize=False,
        transliterate=False,  # Nobody asked for this!
        soundex=False,         # Or this!
        metaphone=False        # Or this!
    ):
        # 90% of these won't be used
        # But we pay the complexity cost forever
        ...

# Good: Start simple, add based on demand
class String(Validator):
    def __init__(
        self,
        min_length=None,
        max_length=None,
        pattern=None
    ):
        # Simple, focused API
        # Add features when users actually need them
        ...
```

### ❌ Don't Break Backward Compatibility Lightly

```python
# Bad: Breaking change in minor version
# v1.4.0 → v1.5.0
class ValidationResult:
    errors: list  # Was dict, now list ❌ BREAKS USERS

# Good: Deprecate in minor, remove in major
# v1.5.0: Add deprecation warning
@property
def errors(self):
    warnings.warn(...)
    return self._errors_as_dict()  # Still works

# v2.0.0: Remove deprecated API
errors: list  # Now it's a list
```

### ❌ Don't Swallow Errors

```python
# Bad: Silent failures
def validate(value):
    try:
        return validator.validate(value)
    except Exception:
        return None  # ❌ What happened?!

# Good: Explicit error handling
def validate(value):
    try:
        return validator.validate(value)
    except ValidationError:
        raise  # Let user handle validation errors
    except Exception as e:
        # Only catch unexpected errors
        raise RuntimeError(f"Unexpected error during validation: {e}") from e
```

---

## Summary Checklist

Before releasing any version:

- [ ] API is simple for simple cases
- [ ] Error messages are clear and actionable
- [ ] Full type hints on public API
- [ ] Test coverage ≥ 95%
- [ ] Performance benchmarks pass
- [ ] Semantic versioning followed strictly
- [ ] Documentation complete and tested
- [ ] Zero required dependencies (or justified)
- [ ] Extension points provided
- [ ] Release process followed

---

## Further Reading

### Internal References
- [Python Language Philosophy](../../philosophies/languages/PYTHON.PHILOSOPHY.md)
- [Rich Hickey's Simplicity](../../philosophies/people/RICH_HICKEY.PHILOSOPHY.md)
- [Clean Code Methodology](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)
- [Test-Driven Development](../../philosophies/methodologies/TDD.PHILOSOPHY.md)
- [Rust Language Philosophy](../../philosophies/languages/RUST.PHILOSOPHY.md)

### External Resources
- [Semantic Versioning](https://semver.org/)
- [Python Packaging Guide](https://packaging.python.org/)
- [Write the Docs](https://www.writethedocs.org/)
- [Crafting Interpreters - Library Design](https://craftinginterpreters.com/)
- [Rich Hickey - Spec-ulation](https://www.youtube.com/watch?v=oyLBGkS5ICk)

---

**Last Updated**: 2025-11-15
**Next Review**: 2025-12-15
**Maintainers**: ValidPy Core Team
**Feedback**: GitHub Issues / Discussions
