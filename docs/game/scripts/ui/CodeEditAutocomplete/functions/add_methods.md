# CodeEditAutocomplete::add_methods Function Reference

*Defined at:* `scripts/ui/CodeEditAutocomplete.gd` (lines 133–147)</br>
*Belongs to:* [CodeEditAutocomplete](../../CodeEditAutocomplete.md)

**Signature**

```gdscript
func add_methods(methods: Dictionary) -> void
```

- **methods**: Dictionary of method definitions.

## Description

Add multiple custom methods at once.

## Source

```gdscript
func add_methods(methods: Dictionary) -> void:
	for method_name in methods:
		var method_data: Dictionary = methods[method_name]
		var params_array: Array[String] = []
		var raw_params: Array = method_data.get("params", [])
		for param in raw_params:
			params_array.append(str(param))
		add_method(
			method_name,
			method_data.get("return_type", "void"),
			method_data.get("description", ""),
			params_array
		)
```
