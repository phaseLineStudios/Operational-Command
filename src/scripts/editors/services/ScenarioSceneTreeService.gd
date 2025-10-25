class_name ScenarioSceneTreeService
extends RefCounted

var tasks: ScenarioTasksService


func setup(tasks_service: ScenarioTasksService) -> void:
	tasks = tasks_service


func rebuild(ctx: ScenarioEditorContext) -> void:
	var tree := ctx.scene_tree
	tree.clear()
	var root := tree.create_item()

	var slots := tree.create_item(root)
	slots.set_text(0, "Slots")
	if ctx.data.unit_slots:
		for i in ctx.data.unit_slots.size():
			var slot: UnitSlotData = ctx.data.unit_slots[i]
			if slot == null:
				continue
			var s_item := tree.create_item(slots)
			s_item.set_text(0, slot.title)
			s_item.set_metadata(0, {"type": &"slot", "index": i})
			var icon := load("res://assets/textures/units/slot_icon.png") as Texture2D
			var img := icon.get_image()
			img.resize(24, 24, Image.INTERPOLATE_LANCZOS)
			s_item.set_icon(0, ImageTexture.create_from_image(img))
			

	var units := tree.create_item(root)
	units.set_text(0, "Units")
	if ctx.data.units:
		for ui in ctx.data.units.size():
			var su: ScenarioUnit = ctx.data.units[ui]
			if su == null:
				continue
			var u_item := tree.create_item(units)
			u_item.set_text(0, su.callsign)
			u_item.set_metadata(0, {"type": &"unit", "index": ui})
			var icon := (
				su.unit.icon
				if su.affiliation == ScenarioUnit.Affiliation.FRIEND
				else su.unit.enemy_icon
			)
			if icon:
				var img := icon.get_image()
				if not img.is_empty():
					img.resize(16, 16, Image.INTERPOLATE_LANCZOS)
					u_item.set_icon(0, ImageTexture.create_from_image(img))

			var ordered := tasks.collect_unit_chain(ctx.data, ui)
			for idx in ordered.size():
				var ti := ordered[idx]
				var inst: ScenarioTask = ctx.data.tasks[ti]
				if inst == null:
					continue
				var t_item := tree.create_item(u_item)
				t_item.set_text(0, tasks.make_task_title(inst, idx))
				t_item.set_metadata(0, {"type": &"task", "index": ti})
				if inst.task and inst.task.icon:
					var img := inst.task.icon.get_image()
					if not img.is_empty():
						img.resize(16, 16, Image.INTERPOLATE_LANCZOS)
						t_item.set_icon(0, ImageTexture.create_from_image(img))

	var triggers := tree.create_item(root)
	triggers.set_text(0, "Triggers")
	if ctx.data.triggers:
		for i in ctx.data.triggers.size():
			var trig: ScenarioTrigger = ctx.data.triggers[i]
			if trig == null:
				continue
			var t_item := tree.create_item(triggers)
			t_item.set_text(0, trig.title)
			t_item.set_metadata(0, {"type": &"trigger", "index": i})
			if trig.icon:
				var img := trig.icon.get_image()
				if not img.is_empty():
					img.resize(16, 16, Image.INTERPOLATE_LANCZOS)
					t_item.set_icon(0, ImageTexture.create_from_image(img))
