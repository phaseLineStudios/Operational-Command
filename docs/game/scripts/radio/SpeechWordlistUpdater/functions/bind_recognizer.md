# SpeechWordlistUpdater::bind_recognizer Function Reference

*Defined at:* `scripts/radio/WordListUpdater.gd` (lines 33–36)</br>
*Belongs to:* [SpeechWordlistUpdater](../../SpeechWordlistUpdater.md)

**Signature**

```gdscript
func bind_recognizer(r: Vosk) -> void
```

- **r**: Recognizer instance exposing `set_wordlist(String)`.

## Description

Bind or replace the active recognizer.
Use when the recognizer is created after this node is ready.

## Source

```gdscript
func bind_recognizer(r: Vosk) -> void:
	recognizer = r
```
