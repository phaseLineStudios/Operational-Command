extends Node
## NATO radio phrasebook, callsigns, and grammar helpers.
##
## Provides tables and pattern helpers for validating and assisting the
## construction of voice commands.

var _mission_overrides: Dictionary = {}


## Set mission-specific overrides for custom actions and extra words.
## Merges custom action keywords into [code]action_synonyms[/code] table and adds
## extra words to Vosk grammar for better STT recognition.
## [br][br]
## [b]Called automatically by SimWorld._init_custom_commands() during mission init.[/b]
## [param custom_actions] Dictionary mapping keyword -> OrderType (or any int).
## Added to action_synonyms. [param extra_words] Array of additional words to recognize in STT
## (keywords + additional_grammar).
func set_mission_overrides(
	custom_actions: Dictionary = {}, extra_words: Array[String] = []
) -> void:
	_mission_overrides = {"custom_actions": custom_actions, "extra_words": extra_words}
	LogService.info(
		"Mission overrides set: %d actions, %d words" % [custom_actions.size(), extra_words.size()],
		"NARules.gd"
	)


## Clear mission overrides (call when leaving a mission).
## Should be called on mission end to reset grammar to defaults.
func clear_mission_overrides() -> void:
	_mission_overrides.clear()


## Build and return the parser table
func get_parser_tables() -> Dictionary:
	var base_tables := {
		"callsigns":
		{
			"alpha": "ALPHA",
			"bravo": "BRAVO",
			"charlie": "CHARLIE",
			"delta": "DELTA",
			"echo": "ECHO",
			"foxtrot": "FOXTROT",
			"golf": "GOLF",
			"hotel": "HOTEL",
			"india": "INDIA",
			"juliett": "JULIETT",
			"kilo": "KILO",
			"lima": "LIMA",
			"mike": "MIKE",
			"november": "NOVEMBER",
			"oscar": "OSCAR",
			"papa": "PAPA",
			"quebec": "QUEBEC",
			"romeo": "ROMEO",
			"sierra": "SIERRA",
			"tango": "TANGO",
			"uniform": "UNIFORM",
			"victor": "VICTOR",
			"whiskey": "WHISKEY",
			"xray": "XRAY",
			"yankee": "YANKEE",
			"zulu": "ZULU"
		},
		"action_synonyms":
		{
			"move": OrdersParser.OrderType.MOVE,
			"advance": OrdersParser.OrderType.MOVE,
			"proceed": OrdersParser.OrderType.MOVE,
			"shift": OrdersParser.OrderType.MOVE,
			"head": OrdersParser.OrderType.MOVE,
			"relocate": OrdersParser.OrderType.MOVE,
			"fall": OrdersParser.OrderType.MOVE,
			"hold": OrdersParser.OrderType.HOLD,
			"defend": OrdersParser.OrderType.DEFEND,
			"block": OrdersParser.OrderType.DEFEND,
			"attack": OrdersParser.OrderType.ATTACK,
			"engage": OrdersParser.OrderType.ATTACK,
			"assault": OrdersParser.OrderType.ATTACK,
			"recon": OrdersParser.OrderType.RECON,
			"recce": OrdersParser.OrderType.RECON,
			"scout": OrdersParser.OrderType.RECON,
			"fire": OrdersParser.OrderType.FIRE,
			"suppress": OrdersParser.OrderType.FIRE,
			"shell": OrdersParser.OrderType.FIRE,
			"report": OrdersParser.OrderType.REPORT,
			"status": OrdersParser.OrderType.REPORT,
			"cancel": OrdersParser.OrderType.CANCEL,
			"abort": OrdersParser.OrderType.CANCEL
		},
		"directions":
		{
			"north": "N",
			"south": "S",
			"east": "E",
			"west": "W",
			"northeast": "NE",
			"north-east": "NE",
			"northwest": "NW",
			"north-west": "NW",
			"southeast": "SE",
			"south-east": "SE",
			"southwest": "SW",
			"south-west": "SW"
		},
		"stopwords":
		{
			"over": true,
			"out": true,
			"roger": true,
			"wilco": true,
			"how": true,
			"copy": true,
			"i": true,
			"we": true,
			"be": true,
			"to": true,
			"the": true,
			"a": true,
			"an": true
		},
		"number_words":
		{
			"zero": 0,
			"oh": 0,
			"one": 1,
			"two": 2,
			"three": 3,
			"four": 4,
			"five": 5,
			"six": 6,
			"seven": 7,
			"eight": 8,
			"nine": 9,
			"niner": 9,
			"ten": 10,
			"eleven": 11,
			"twelve": 12,
			"thirteen": 13,
			"fourteen": 14,
			"fifteen": 15,
			"sixteen": 16,
			"seventeen": 17,
			"eighteen": 18,
			"nineteen": 19,
			"twenty": 20,
			"thirty": 30,
			"forty": 40,
			"fifty": 50,
			"sixty": 60,
			"seventy": 70,
			"eighty": 80,
			"ninety": 90,
			"hundred": 100,
			"thousand": 1000
		},
		"prepositions":
		{
			"to": true,
			"toward": true,
			"towards": true,
			"into": true,
			"onto": true,
			"at": true,
			"on": true,
			"for": true,
			"from": true,
			"of": true,
			"in": true,
			"by": true
		},
		"quantity_labels":
		{
			"block": "block",
			"blocks": "block",
			"grid": "grid",
			"grids": "grid",
			"meter": "m",
			"meters": "m",
			"metre": "m",
			"metres": "m",
			"m": "m",
			"kilometer": "km",
			"kilometers": "km",
			"kilometre": "km",
			"kilometres": "km",
			"km": "km",
			"click": "km",
			"clicks": "km",
			"round": "rounds",
			"rounds": "rounds"
		}
	}

	# Merge mission overrides if present
	if _mission_overrides.has("custom_actions"):
		var custom_actions: Dictionary = _mission_overrides["custom_actions"]
		for key in custom_actions.keys():
			base_tables["action_synonyms"][key] = custom_actions[key]

	return base_tables


## Build a deduped list of grammar words (and phrases) with mission overrides.
func build_vosk_word_array(
	callsigns_override: Array[String] = [], label_texts: Array[String] = []
) -> PackedStringArray:
	var words: Array[String] = []
	var tables := get_parser_tables()

	words.append_array(tables["action_synonyms"].keys())
	words.append_array(["now", "immediately"])

	var calls: Array = (
		callsigns_override if callsigns_override.size() > 0 else tables["callsigns"].keys()
	)
	for c in calls:
		var s := str(c).strip_edges().to_lower()
		if s != "":
			words.append(s)

	words.append_array(tables["directions"].keys())
	words.append_array(tables["prepositions"].keys())

	var qlbl: Dictionary = tables["quantity_labels"]
	words.append_array(qlbl.keys())
	for v in qlbl.values():
		words.append(str(v))

	words.append_array(tables["number_words"].keys())
	for d in 10:
		words.append(str(d))

	for label in label_texts:
		var phrase := str(label).strip_edges().to_lower()
		if phrase == "":
			continue
		words.append(phrase)
		for tok in phrase.split(" ", false):
			if tok != "":
				words.append(tok)

	# Add mission-specific extra words
	if _mission_overrides.has("extra_words"):
		var extra: Array = _mission_overrides["extra_words"]
		for w in extra:
			var word := str(w).strip_edges().to_lower()
			if word != "":
				words.append(word)
				# Also add individual tokens if it's a phrase
				for tok in word.split(" ", false):
					if tok != "":
						words.append(tok)

	words.append("[unk]")

	var seen := {}
	var out: Array[String] = []
	for w in words:
		if not seen.has(w):
			seen[w] = true
			out.append(w)

	return PackedStringArray(out)


## Build and return Vosk grammar JSON with mission overrides.
func get_vosk_grammar_words(
	callsigns_override: Array[String] = [], label_texts: Array[String] = []
) -> String:
	var arr := build_vosk_word_array(callsigns_override, label_texts)
	return JSON.stringify(arr)
