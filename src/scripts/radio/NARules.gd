extends Node
## NATO radio phrasebook, callsigns, and grammar helpers.
##
## Provides tables and pattern helpers for validating and assisting the
## construction of voice commands.


## Build and return the parser table
func get_parser_tables() -> Dictionary:
	return {
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


## Build and return a vosk grammar list
func get_vosk_grammar_words() -> String:
	var words := []

	var tables := get_parser_tables()

	# Actions / prowords
	words.append_array(tables["action_synonyms"].keys())
	words.append_array(["now", "immediately"])

	# Callsigns / Directions
	words.append_array(tables["callsigns"].keys())
	words.append_array(tables["directions"].keys())

	# Prepositions (from tables)
	words.append_array(tables["prepositions"].keys())

	# Quantity labels (all variants + normalized units)
	var qlbl: Dictionary = tables["quantity_labels"]
	words.append_array(qlbl.keys())
	for v in qlbl.values():
		words.append(v)

	# Number words & digits
	words.append_array(tables["number_words"].keys())
	for d in 10:
		words.append(str(d))

	# Unknown token
	words.append("[unk]")

	return JSON.stringify(words)
