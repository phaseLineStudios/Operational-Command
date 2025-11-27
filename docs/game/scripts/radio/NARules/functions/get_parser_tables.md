# NARules::get_parser_tables Function Reference

*Defined at:* `scripts/radio/NARules.gd` (lines 35–209)</br>
*Belongs to:* [NARules](../../NARules.md)

**Signature**

```gdscript
func get_parser_tables() -> Dictionary
```

## Description

Build and return the parser table

## Source

```gdscript
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
			"sitrep": OrdersParser.OrderType.REPORT,
			"cancel": OrdersParser.OrderType.CANCEL,
			"abort": OrdersParser.OrderType.CANCEL,
			"lay": OrdersParser.OrderType.ENGINEER,
			"place": OrdersParser.OrderType.ENGINEER,
			"build": OrdersParser.OrderType.ENGINEER,
			"construct": OrdersParser.OrderType.ENGINEER,
			"engineer": OrdersParser.OrderType.ENGINEER
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
```
