# DebugMenu::_get_property_doc_comment Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 332–388)</br>
*Belongs to:* [DebugMenu](../../DebugMenu.md)

**Signature**

```gdscript
func _get_property_doc_comment(node: Node, prop_name: String) -> String
```

## Description

Extract doc comment for a property from the script source

## Source

```gdscript
func _get_property_doc_comment(node: Node, prop_name: String) -> String:
	var script = node.get_script()
	if script == null:
		return ""

	var source_code: String = script.source_code
	if source_code == "":
		return ""

	var lines := source_code.split("\n")
	var doc_lines: Array[String] = []

	for i in range(lines.size()):
		var line := lines[i].strip_edges()

		var var_pattern := "var " + prop_name
		if line.contains(var_pattern):
			var pos := line.find(var_pattern)
			if pos >= 0:
				var after_var := pos + var_pattern.length()
				if after_var >= line.length() or line[after_var] in [":", "=", " ", "\t"]:
					var j := i - 1
					var found_any_comment := false
					var skip_empty_before_comment := true

					while j >= 0:
						var prev_line := lines[j].strip_edges()

						if prev_line.begins_with("##"):
							doc_lines.push_front(prev_line.substr(2).strip_edges())
							found_any_comment = true
							skip_empty_before_comment = false
							j -= 1

						elif prev_line.begins_with("@export"):
							if not found_any_comment:
								j -= 1
							else:
								break

						elif prev_line == "":
							if found_any_comment:
								break
							elif skip_empty_before_comment:
								skip_empty_before_comment = false
								j -= 1
							else:
								break

						else:
							break

					break

	return " ".join(doc_lines)
```
