# CustomCommand Class Reference

*File:* `scripts/data/CustomCommand.gd`
*Class name:* `CustomCommand`
*Inherits:* `Resource`

## Synopsis

```gdscript
class_name CustomCommand
extends Resource
```

## Brief

Custom voice command definition for per-mission special commands.

## Detailed Description

Allows scenarios to define mission-specific voice commands that can:
  
1. Trigger a specific ScenarioTrigger when heard via `member trigger_id`
  
2. Generate a CUSTOM order type that OrdersRouter handles via `member route_as_order`
  
3. Both (trigger fires AND order routes)
  

**Usage:** Add to `member ScenarioData.custom_commands` array in scenario JSON.
The system automatically registers keywords with OrdersParser and adds grammar to STT.
  

**Example JSON:**

```
{
"keyword": "fire mission",
"additional_grammar": ["danger", "close", "grid"],
"trigger_id": "fire_mission_trigger",
"route_as_order": true
}
```

## Public Member Functions

- [`func serialize() -> Dictionary`](CustomCommand/functions/serialize.md) — Serialize to dictionary for JSON persistence.
- [`func deserialize(d: Variant) -> CustomCommand`](CustomCommand/functions/deserialize.md) — Deserialize from dictionary.

## Public Attributes

- `String keyword` — Primary keyword or phrase that activates this command (e.g., "fire mission").
- `Array[String] additional_grammar` — Additional grammar words to add to STT recognition for better accuracy.
- `String trigger_id` — Optional trigger ID to auto-activate when this command is heard.
- `bool route_as_order` — If true, generates a CUSTOM order type that routes through OrdersRouter.

## Member Function Documentation

### serialize

```gdscript
func serialize() -> Dictionary
```

Serialize to dictionary for JSON persistence.

### deserialize

```gdscript
func deserialize(d: Variant) -> CustomCommand
```

Deserialize from dictionary.

## Member Data Documentation

### keyword

```gdscript
var keyword: String
```

Decorators: `@export`

Primary keyword or phrase that activates this command (e.g., "fire mission").
Matching is case-insensitive and uses substring matching in OrdersParser.

### additional_grammar

```gdscript
var additional_grammar: Array[String]
```

Decorators: `@export`

Additional grammar words to add to STT recognition for better accuracy.
Include related terms that might be said with this command.

### trigger_id

```gdscript
var trigger_id: String
```

Decorators: `@export`

Optional trigger ID to auto-activate when this command is heard.
If set, the trigger with this ID will have its condition forced true.

### route_as_order

```gdscript
var route_as_order: bool
```

Decorators: `@export`

If true, generates a CUSTOM order type that routes through OrdersRouter.
Listen to `signal OrdersRouter.custom_order_received` to handle the order.
