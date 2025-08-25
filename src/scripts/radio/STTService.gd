extends Node
class_name STTService
## Offline speech-to-text capture using Vosk via GDExtension.
##
## Captures microphone audio, applies optional VAD, and submits chunks to
## vosk_gd. Emits transcription results for parsing into orders.
