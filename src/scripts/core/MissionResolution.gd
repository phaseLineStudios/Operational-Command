extends Node
class_name MissionResolution

## Tracks mission progress and computes a placeholder outcome + score.
## Use as a helper owned by your Game singleton / mission scene.
## @experimental

signal objective_updated(objective_id: StringName, state: ObjectiveState)
signal score_changed(total: int)
signal mission_finalized(outcome: MissionOutcome, summary: Dictionary)

## Logical Objective states
enum ObjectiveState { PENDING, SUCCESS, FAILED }
## Logical Mission Outcome states
enum MissionOutcome { UNDECIDED, SUCCESS, PARTIAL, FAILED, ABORTED }

## Scoring weights
@export var score_primary_success := 100
@export var score_friendly_casualty := -1
@export var score_enemy_casualty := 0
@export var score_unit_lost := -10
@export var score_time_penalty_per_min := -1

@export var scenario_id: StringName
@export var primary_objectives: Array[StringName] = []

var _objective_states: Dictionary = {}
var _casualties := {
	"friendly": 0,
	"enemy": 0,
}
var _units_lost: int = 0
var _elapsed_s: float = 0.0
var _total_score: int = 0
var _outcome: MissionOutcome = MissionOutcome.UNDECIDED
var _is_final: bool = false


## Initialize for a mission.
func start(prim: Array[StringName], scenario: StringName = &"") -> void:
	_reset()
	scenario_id = scenario if scenario != &"" else scenario_id
	primary_objectives = prim
	for id in prim:
		_objective_states[id] = ObjectiveState.PENDING
	_recompute_score()


## Advance internal timer. Call from mission loop.
func tick(dt: float) -> void:
	if _is_final:
		return
	_elapsed_s += dt

## Update an objective state.
func set_objective_state(id: StringName, state: ObjectiveState) -> void:
	if _is_final:
		return
	if not _objective_states.has(id):
		_objective_states[id] = ObjectiveState.PENDING
	var prev: int = _objective_states[id]
	if prev == state:
		return
	_objective_states[id] = state
	emit_signal("objective_updated", id, state)
	_recompute_score()

## Record casualties (aggregated).
func add_casualties(friendly: int = 0, enemy: int = 0) -> void:
	if _is_final:
		return
	_casualties.friendly += max(0, friendly)
	_casualties.enemy += max(0, enemy)
	_recompute_score()

## Record fully destroyed friendly unit(s) (e.g., wiped marker).
func add_units_lost(count: int = 1) -> void:
	if _is_final:
		return
	_units_lost += max(count, 0)
	_recompute_score()

## Compute current best-guess outcome (not final).
func evaluate_outcome() -> MissionOutcome:
	if _is_final:
		return _outcome
	var prim_total := primary_objectives.size()
	var prim_success := 0
	var prim_failed := 0
	for id in primary_objectives:
		match _objective_states.get(id, ObjectiveState.PENDING):
			ObjectiveState.SUCCESS: prim_success += 1
			ObjectiveState.FAILED: prim_failed += 1
	if prim_failed > 0:
		return MissionOutcome.FAILED
	if prim_success == prim_total and prim_total > 0:
		return MissionOutcome.SUCCESS
	if _total_score >= prim_total * (score_primary_success * 0.6):
		return MissionOutcome.PARTIAL
	return MissionOutcome.UNDECIDED


## Finalize the mission (moves to immutable state).
func finalize(abort: bool = false) -> Dictionary:
	if _is_final:
		return to_summary_payload()
	_is_final = true
	var time_penalty := int(floor((_elapsed_s / 60.0) * score_time_penalty_per_min))
	_total_score += time_penalty

	_outcome = MissionOutcome.ABORTED if abort else evaluate_outcome()
	var summary := to_summary_payload()
	emit_signal("mission_finalized", _outcome, summary)
	return summary

## Debrief/persistence payload; stable contract for other screens.
func to_summary_payload() -> Dictionary:
	return {
		"scenario_id": scenario_id,
		"elapsed_s": int(round(_elapsed_s)),
		"objectives": _objective_states.duplicate(true),
		"primary_objectives": primary_objectives.duplicate(),
		"casualties": _casualties.duplicate(true),
		"units_lost": _units_lost,
		"score_total": _total_score,
		"score_breakdown": _score_breakdown(),
		"outcome": _outcome,
	}

## Clear all state.
func _reset() -> void:
	_objective_states.clear()
	_casualties = {"friendly": 0, "enemy": 0}
	_units_lost = 0
	_elapsed_s = 0.0
	_total_score = 0
	_outcome = MissionOutcome.UNDECIDED
	_is_final = false

func _recompute_score() -> void:
	var score := 0
	for id in primary_objectives:
		if _objective_states.get(id, ObjectiveState.PENDING) == ObjectiveState.SUCCESS:
			score += score_primary_success
	score += _casualties.enemy * score_enemy_casualty
	score += _casualties.friendly * score_friendly_casualty
	score += _units_lost * score_unit_lost

	if score != _total_score:
		_total_score = score
		emit_signal("score_changed", _total_score)

func _score_breakdown() -> Dictionary:
	return {
		"primary_success": primary_objectives.filter(
			func(id): return _objective_states.get(id, ObjectiveState.PENDING) == ObjectiveState.SUCCESS
		).size() * score_primary_success,
		"friendly_casualties": _casualties.friendly * score_friendly_casualty,
		"enemy_casualties": _casualties.enemy * score_enemy_casualty,
		"units_lost": _units_lost * score_unit_lost,
		"time_penalty_applied_on_finalize": int(floor((_elapsed_s / 60.0) * score_time_penalty_per_min)),
	}
