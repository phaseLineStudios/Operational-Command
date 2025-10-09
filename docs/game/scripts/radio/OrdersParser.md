# OrdersParser Class Reference

*File:* `scripts/radio/OrdersParser.gd`
*Class name:* `OrdersParser`
*Inherits:* `Node`
> **Experimental**

## Synopsis

```gdscript
class_name OrdersParser
extends Node
```

## Brief

Converts radio transcripts into structured orders.

## Detailed Description

Consumes the full `result` string from STTService and extracts one or more
machine-readable orders for AI units using tables from `NaRules`.

Minimal schema returned per order.

## Public Member Functions

- [`func _ready() -> void`](OrdersParser/functions/_ready.md)
- [`func parse(text: String) -> Array`](OrdersParser/functions/parse.md) — Parse a full STT sentence into one or more structured orders.
- [`func _extract_orders(tokens: PackedStringArray) -> Array`](OrdersParser/functions/_extract_orders.md) — Scan tokens left→right and extract orders.
- [`func _new_order_builder() -> Dictionary`](OrdersParser/functions/_new_order_builder.md) — Builder for a fresh order dictionary.
- [`func _finalize(cur: Dictionary) -> Dictionary`](OrdersParser/functions/_finalize.md) — Finalize a builder into an immutable order dictionary.
- [`func _normalize_and_tokenize(text: String) -> PackedStringArray`](OrdersParser/functions/_normalize_and_tokenize.md) — Lowercase, strip, keep letters/digits/space/hyphen/brackets, and split.
- [`func _read_number(tokens: PackedStringArray, idx: int, number_words: Dictionary) -> Dictionary`](OrdersParser/functions/_read_number.md) — Read a verbal or digit number from tokens[idx..]; sets 'consumed'.
- [`func _is_int_literal(s: String) -> bool`](OrdersParser/functions/_is_int_literal.md) — True if s consists only of ASCII digits (uses unicode_at()).
- [`func _all_under_ten(vals: Array) -> bool`](OrdersParser/functions/_all_under_ten.md) — True if all numbers in array are 0..9.
- [`func _is_ascii_alpha_cp(cp: int) -> bool`](OrdersParser/functions/_is_ascii_alpha_cp.md) — ASCII alpha test for a code point.
- [`func _is_ascii_digit_cp(cp: int) -> bool`](OrdersParser/functions/_is_ascii_digit_cp.md) — ASCII digit test for a code point.
- [`func order_to_string(o: Dictionary) -> String`](OrdersParser/functions/order_to_string.md) — Human-friendly summary for a single order.
- [`func _order_type_to_string(t: int) -> String`](OrdersParser/functions/_order_type_to_string.md) — String name for OrderType.

## Public Attributes

- `Dictionary _tables`

## Signals

- `signal parsed(orders: Array)` — Emitted when parsing succeeds.
- `signal parse_error(msg: String)` — Emitted if parsing fails (no orders, or malformed input).

## Enumerations

- `enum OrderType` — High-level order categories.

## Member Function Documentation

### _ready

```gdscript
func _ready() -> void
```

### parse

```gdscript
func parse(text: String) -> Array
```

Parse a full STT sentence into one or more structured orders.

### _extract_orders

```gdscript
func _extract_orders(tokens: PackedStringArray) -> Array
```

Scan tokens left→right and extract orders.

### _new_order_builder

```gdscript
func _new_order_builder() -> Dictionary
```

Builder for a fresh order dictionary.

### _finalize

```gdscript
func _finalize(cur: Dictionary) -> Dictionary
```

Finalize a builder into an immutable order dictionary.

### _normalize_and_tokenize

```gdscript
func _normalize_and_tokenize(text: String) -> PackedStringArray
```

Lowercase, strip, keep letters/digits/space/hyphen/brackets, and split.

### _read_number

```gdscript
func _read_number(tokens: PackedStringArray, idx: int, number_words: Dictionary) -> Dictionary
```

Read a verbal or digit number from tokens[idx..]; sets 'consumed'.

### _is_int_literal

```gdscript
func _is_int_literal(s: String) -> bool
```

True if s consists only of ASCII digits (uses unicode_at()).

### _all_under_ten

```gdscript
func _all_under_ten(vals: Array) -> bool
```

True if all numbers in array are 0..9.

### _is_ascii_alpha_cp

```gdscript
func _is_ascii_alpha_cp(cp: int) -> bool
```

ASCII alpha test for a code point.

### _is_ascii_digit_cp

```gdscript
func _is_ascii_digit_cp(cp: int) -> bool
```

ASCII digit test for a code point.

### order_to_string

```gdscript
func order_to_string(o: Dictionary) -> String
```

Human-friendly summary for a single order.

### _order_type_to_string

```gdscript
func _order_type_to_string(t: int) -> String
```

String name for OrderType.

## Member Data Documentation

### _tables

```gdscript
var _tables: Dictionary
```

## Signal Documentation

### parsed

```gdscript
signal parsed(orders: Array)
```

Emitted when parsing succeeds.

### parse_error

```gdscript
signal parse_error(msg: String)
```

Emitted if parsing fails (no orders, or malformed input).

## Enumeration Type Documentation

### OrderType

```gdscript
enum OrderType
```

High-level order categories.
