# DebugMenu::_get_property_doc_comment Function Reference

*Defined at:* `scripts/ui/DebugMenu.gd` (lines 352–421)</br>
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

	# Look for the property declaration
	var lines := source_code.split("\n")
	var doc_lines: Array[String] = []

	for i in range(lines.size()):
		var line := lines[i].strip_edges()

		# Check if this line contains our exact property (not a substring)
		# Match "var prop_name:" or "var prop_name =" or "var prop_name<space>"
		var var_pattern := "var " + prop_name
		if line.contains(var_pattern):
			# Verify it's an exact match by checking what comes after the property name
			var pos := line.find(var_pattern)
			if pos >= 0:
				var after_var := pos + var_pattern.length()
				# Check if what follows is a valid separator (not part of another identifier)
				if after_var >= line.length() or line[after_var] in [":", "=", " ", "\t"]:
					# Look backward for doc comments (##)
					var j := i - 1
					var found_any_comment := false
					var skip_empty_before_comment := true

					while j >= 0:
						var prev_line := lines[j].strip_edges()

						if prev_line.begins_with("##"):
							# Collect comment line
							doc_lines.push_front(prev_line.substr(2).strip_edges())
							found_any_comment = true
							skip_empty_before_comment = false
							j -= 1

						elif prev_line.begins_with("@export"):
							# Skip over export annotations (only before finding comments)
							if not found_any_comment:
								j -= 1
							else:
								# Stop - we've gone past the comment block
								break

						elif prev_line == "":
							# Empty line handling:
							# - Before finding comments: skip one empty line (between @export and ##)
							# - After finding comments: stop (end of comment block)
							if found_any_comment:
								break
							elif skip_empty_before_comment:
								skip_empty_before_comment = false
								j -= 1
							else:
								break

						else:
							# Hit other code, stop
							break

					break

	return " ".join(doc_lines)
```
