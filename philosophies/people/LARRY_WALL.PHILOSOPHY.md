---
layout: default
title: Larry Wall
parent: People
grand_parent: Philosophies
nav_order: 13
---

# Larry Wall's Programming Philosophy

> "There's more than one way to do it." (TMTOWTDI)

## Overview

Larry Wall is the creator of Perl and a linguist by training. His philosophy embraces the messiness of natural language, believing programming languages should be expressive, flexible, and tolerant of different approaches. Perl is designed to make easy things easy and hard things possible.

**Key Contributions**:
- Perl programming language
- Raku (Perl 6)
- patch utility
- rn newsreader
- Three Virtues of Programming

**Core Philosophy**: Programming languages should be expressive like natural languages. There should be more than one way to do things. Make easy things easy and hard things possible.

---

## Core Principles

### 1. TMTOWTDI (There's More Than One Way To Do It)

**Philosophy**: Let programmers express ideas in ways that feel natural to them.

```perl
# Multiple valid ways to do the same thing

# Print array elements
print "$_\n" for @array;
print "$_\n" foreach @array;
foreach my $item (@array) { print "$item\n"; }
map { print "$_\n" } @array;
print join("\n", @array), "\n";

# Conditional execution
print "yes" if $condition;
if ($condition) { print "yes"; }
$condition && print "yes";
$condition and print "yes";

# Choose what's clearest for your context
```

---

### 2. The Three Virtues

**Philosophy**: Great programmers are lazy, impatient, and proud (in the right way).

**Laziness**: Write code that reduces total work
```perl
# Automate repetitive tasks
# Generate code instead of typing it
# Build reusable modules
```

**Impatience**: Write code that anticipates needs
```perl
# Handle edge cases before users hit them
# Make programs responsive
# Cache expensive operations
```

**Hubris**: Write code you're proud of
```perl
# Document well so others can use it
# Maintain high quality standards
# Build things others want to use
```

---

### 3. Natural Language Principles

**Philosophy**: Programming languages should borrow ideas from natural languages.

```perl
# Context sensitivity (like natural language)
@array = (1, 2, 3);
$count = @array;      # Scalar context: 3
@copy = @array;       # List context: (1, 2, 3)

# Pronouns: $_ is "it"
for (@array) {
    print;            # Prints $_
    chomp;            # Chomps $_
    s/foo/bar/;       # Substitutes in $_
}

# Multiple valid orderings
print "found" if $found;     # Statement modifier
if ($found) { print "found"; }  # Traditional
```

---

### 4. Easy Things Easy, Hard Things Possible

**Philosophy**: Common tasks should require minimal code. Complex tasks should be achievable.

```perl
# Easy things are easy
print "Hello, World!\n";

# One-liner text processing
perl -pe 's/old/new/g' file.txt

# Complex things are possible
# - Full regex engine
# - Database access
# - Network programming
# - System administration
```

---

### 5. Do What I Mean (DWIM)

**Philosophy**: The language should try to understand programmer intent.

```perl
# Perl tries to do what you mean
$x = "5";
$y = $x + 3;    # String "5" becomes number 5: $y = 8

# Automatic dereferencing
my @array = @{$arrayref};
my @array = $arrayref->@*;  # Modern syntax

# Context-sensitive behavior
if (@array) {   # True if array has elements
    # ...
}
```

---

### 6. Regular Expressions as First-Class

**Philosophy**: Pattern matching is fundamental and deserves language support.

```perl
# Regex built into the language
if ($string =~ /pattern/) {
    print "Matched!\n";
}

# Substitution
$string =~ s/old/new/g;

# Extended patterns
$string =~ /
    ^           # Start
    (\d{3})     # Area code
    -
    (\d{4})     # Number
    $           # End
/x;

# Named captures
if ($string =~ /(?<name>\w+)/) {
    print $+{name};
}
```

---

### 7. Practical Extraction and Reporting

**Philosophy**: Perl excels at text processing—its original purpose.

```perl
# Process files line by line
while (<>) {
    chomp;
    my @fields = split /,/;
    print "$fields[0]\n";
}

# One-liners for quick tasks
perl -ne 'print if /error/i' log.txt
perl -pe 's/\t/,/g' data.txt
perl -ane 'print $F[2]' file.txt
```

---

### 8. Everything is Context-Dependent

**Philosophy**: Like natural language, meaning depends on context.

```perl
# Scalar vs list context
my @array = (1, 2, 3);
my $count = @array;      # 3 (scalar context)
my @copy = @array;       # (1, 2, 3) (list context)

# Functions behave differently based on context
my @lines = <FILE>;      # List: all lines
my $line = <FILE>;       # Scalar: one line

# Void context
wantarray;  # Check calling context
```

---

### 9. Huffman Coding for Syntax

**Philosophy**: Common operations should have short syntax.

```perl
# Frequent operations are terse
$_      # Default variable
@_      # Subroutine arguments
$!      # Error message
$/      # Input record separator
$.      # Line number

# Common modifiers are concise
if ($cond) { }
unless ($cond) { }
while ($cond) { }
until ($cond) { }
```

---

### 10. Swiss Army Chainsaw

**Philosophy**: Perl is powerful and potentially dangerous. Use wisely.

```perl
# Perl can do almost anything
# - System administration
# - Web development
# - Network programming
# - Bioinformatics
# - Text processing
# - Rapid prototyping

# But with great power...
# Write-only code is possible
# Discipline is important
```

---

## Anti-Patterns to Avoid

### ❌ Write-Only Code

```perl
# Bad: Unreadable
$_=q;2-ede
sede
ie!1="
;s;\s;;g;s;s(.)s;"s"x
length$1;ge;
y;edis";0-9;;td;print

# Good: Readable Perl
my $input = get_input();
my $processed = process($input);
print format_output($processed);
```

### ❌ Golf When Clarity Matters

```perl
# Bad for production: Perl golf
print+(map{chr}map{$_+32}48,79,82,69,76,32)[-1..5]

# Good for production: Clear code
my @chars = map { chr($_ + 32) } (48, 79, 82, 69, 76, 32);
my $word = join '', @chars;
print $word;
```

---

## Quotes

> "There's more than one way to do it."

> "A language that doesn't have everything is actually easier to program in than some that do."

> "Perl is designed to give you several ways to do anything, so consider picking the most readable one."

> "The three chief virtues of a programmer are: Laziness, Impatience and Hubris."

---

## Summary

Larry Wall's philosophy embraces **linguistic expressiveness** and **programmer freedom**:

1. **TMTOWTDI** - Multiple ways to do things
2. **Three virtues** - Laziness, impatience, hubris
3. **Natural language** - Context and flexibility
4. **Easy and possible** - Simple things simple, hard things doable
5. **DWIM** - Do what I mean
6. **First-class regex** - Pattern matching built in
7. **Text processing** - Core strength
8. **Context-sensitive** - Meaning from context
9. **Huffman coding** - Short syntax for common tasks
10. **Swiss Army Chainsaw** - Powerful, be careful

Perl proves that a language can be both powerful and flexible, letting programmers express ideas in whatever way feels most natural.

---

## Further Reading

- "Programming Perl" (The Camel Book)
- "Learning Perl" (The Llama Book)
- Larry Wall's "Perl, the first postmodern computer language" talk
- Perl documentation (perldoc)
