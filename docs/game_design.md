# ORBAT Game Design Document
*ORBAT stands for Order Of Battle and is a common military term*

## Overview
**Title:** ORBAT

### Game Concept
ORBAT is a Real-Time Strategy (RTS) game set during an alternate history where the Cold War escalates 
into full-scale conflict in the 1980s. Players act as a NATO field officer, commanding units at the 
platoon or battalion level via a tactical map and radio communication system. The entire interface 
simulates a command post, with players analyzing intelligence, planning maneuvers, and issuing voice-based 
commands to coordinate military operations.

### Genre
Real-Time Strategy (RTS)

### Target Audience
- Players interested in military history and Cold War scenarios
- Fans of deep, strategic gameplay
- Players who enjoy alternate history fiction
- Players who prefer deep, tactical planning over fast-paced unit micromanagement.

### Game Flow Summary
Players progress through a connected series of military missions that form part of a larger campaign. 
Mission performance influences future missions, with unit preservation and promotion carrying over between 
scenarios.

### Look and Feel
The visual style combines 2D map interfaces with potential 3D elements representing a command center. 
Players interact with map tools, documents, and radios as if situated in a field HQ. The design emphasizes 
realism, minimalism, and Cold War aesthetics.

## Gameplay and Mechanics
Players command military units using voice commands through a simulated radio system. 
The game involves planning movements, reacting to battlefield developments, and managing resources 
such as manpower and equipment. There is no direct control of units; players issue orders and monitor outcomes.

### Gameplay
The core interaction is voice command using a speech-to-text system, based on NATO radio protocols. 
Players view a topographic map to place unit markers, draw plans, and measure distances. Unit markers 
must be manually placed by the player. Position and status updates are obtained through voice queries 
to units. Supporting documents like mission briefings, force compositions (ToE), and intel reports are 
available for strategic reference.

A map editor is also available, allowing users to create and share custom scenarios.

#### Game progression
- Missions award points for completed objectives
- A minimum score is required to succeed in a mission, with various levels of succession
- Campaign continues with persistent unit experience, losses, and logistics
- Units gain veterancy or can be disbanded/combined if understrength
- Equipment and manpower are awarded between missions, but are limited

#### Mission/challenge Structure
- Hierarchical: Early missions introduce core mechanics
- Later missions are larger and more complex, with higher stakes
- Player-selected deployment options add replayability

#### Objectives
- Fulfill mission-specific tasks (e.g., defend, delay, attack, recon)
- Maintain unit cohesion and manage logistics
- Preserve experienced units for long-term campaign success

### Mechanics
#### Physics
The game simulates combat and movement based on unit stats and terrain conditions. No traditional 
physics system is used; instead, outcomes rely on data-driven simulations influenced by elevation, 
visibility, and obstacles.

#### Movement
Movement is executed via issued commands. Players instruct units to move, hold, or retreat based on 
map coordinates. Units follow realistic speed and pathfinding constraints.

#### Objects
Game objects include unit markers, map tools (ruler, compass, drawing instruments), radio, clock to 
control game speed, and interactive mission documents. These tools support planning and command execution.

Players use a first-person perspective to diegetically interact with objects on a command table.

#### Actions
Besides issuing commands, players analyze reports, mark positions, review mission progress, 
and adjust plans based on updates from the field.

#### Combat
- Combat resolution is handled by simulation using unit stats and terrain effects
- Factors include: 
	- Unit strength
	- Unit morale
	- Unit Spotting Distance
	- Unit Attack Distance
	- Unit Attack Power
	- Unit Defence
	- terrain
	- enemy disposition
- Outcomes: units may retreat, surrender, or be destroyed

#### Economy
- Manpower and Equipment based
- Units require personnel and appropriate gear to function
- Post-mission, player receives limited reinforcements
- Encourages careful planning and low-casualty strategies
- Each unit has ammunition that runs out during combat and would require logistical supply
- Vehicle units have fuel that runs out from movement and would require logistical supply

#### Screne Flow
The player moves between screens in the following order:
- Main Menu
- Campaign Selection
- Mission Selection
- Mission Briefing
- Unit Selection
- Tactical Map (Mission Execution)
- Mission Debrief
- Unit Management and Reinforcement

### Game Options
Options include difficulty levels affecting AI behavior and unit stats. Accessibility settings 
include subtitles and speech-to-text configuration. Graphics and audio settings are also adjustable.

### Replay and Saving
Campaign progress is saved between missions. Individual missions cannot be saved mid-play to encourage 
planning and accountability. Unit composition, strength, and resources are stored for continuity.

### Cheats and Easter Eggs
There may be references to historical events in documents, or maybe obscure commands that trigger 
humorous or alternate history content.

## The Story, Setting, and Character
### Story and Narrative
In this alternate 1980s timeline, East Germany (DDR) initiates a surprise invasion of West Germany, 
including a coup in West Berlin. NATO responds with a defensive operation that evolves into a 
full counteroffensive. The player represents a NATO officer directing ground forces across Germany.
If given the time an alternate campaign for the East German / Soviet side should be considered.

### Game World
#### General look and feel of the World
The world is grounded in realistic, Cold War-era military presentation. Maps are designed to 
resemble tactical field maps. The HQ scene uses muted, functional design typical of military 
installations.

#### Areas
Missions take place in various West German locations including rural regions, urban centers, 
forests, and river crossings. Each area presents tactical challenges shaped by terrain and 
enemy placement.

### Characters
The main character is the player—a NATO field commander. Supporting characters include voice actors 
for command staff and unit leaders. Units are persistent entities with their own history, which can 
be influenced by player decisions.

## Levels
### Playing Levels
Each level includes a mission briefing, deployment planning, execution phase, and debrief. Maps are 
unique and based on realistic or semi-fictional Cold War battlefields. Key encounters are based on 
the player's plan and ability to adapt.

### Training level
The training mission introduces players to the radio command system, map interaction tools, and 
basic unit deployment. It is designed to onboard players in a controlled environment with scripted 
scenarios designed to play like a military exercise in west germany.

## Interface
### Visual System
The HUD includes a top-down tactical map, command indicators, and tool access. If a 3D HQ is used, 
players interact with models of radios, documents, and maps. The interface emphasizes clarity and 
realism.

### Control System
Controls include voice commands via microphone, mouse input for map tools, and optional keyboard 
shortcuts.

### Audio, Music, Sound Effects
Audio includes ambient HQ sounds, radio chatter, and battlefield reports. Music is sparse and 
atmospheric, reflecting the tension of Cold War operations. Sound effects reinforce realism without 
overwhelming the player.

### Help System
The help system includes a tutorial mission, visual hints, a command reference guide, and tooltips 
for all interactive elements. Voice command construction suggestions assist new players during 
missions.

## Artificial Intelligence
### Opponent and Enemy AI
Enemy forces follow Cold War military doctrine and react dynamically to player orders. AI can 
attempt flanking, delaying, or ambushing strategies based on battlefield conditions. Like the player 
the AI maintains a list of tasks of which they must complete. 

### Non-combat and Friendly Characters
Friendly units interpret and follow orders independently. Voice responses indicate status and 
success. Some scripted characters (e.g., mission briefers) provide narrative structure.

### Support AI
The speech-to-text system supports command recognition, offering predictive suggestions for valid 
command continuations. Additional AI governs pathfinding, reaction timing, and visibility for all 
units.

### Player and Collision Detection, Path-finding.
Units use terrain-aware pathfinding. No traditional player collision is necessary unless in a 3D HQ 
setting, in which case basic object interaction is modeled. Unit paths avoid impassable terrain and 
react to enemy contact.

## Technical
### Target Hardware
PC (Windows, Linux, macOS)

### Development Hardware and Software (including game engine)
- Engine: Godot
- Code: GDScript
- Tools: Speech-to-text (Vosk), asset editors, version control

### Network requirements
- Primarily offline single-player, but optionally Cooperative or adversial play. 
- Optional features could include cloud saves.

## Game Art
### Key assets 
- 2D tactical maps and NATO symbols
- 3D assets for command tools (radios, documents)
- HQ environment (if 3D)
- Minimalist, functional UI matching Cold War military style

This is an extension of parts of [cs.unc.edu](http://wwwx.cs.unc.edu/Courses/comp585-s11/585GameDesignDocumentTemplate.docx)
