# OberheimMatrixGenie

Parameter Randomizer and SysEx utilities for the Oberheim Matrix synthesizer

Coded in SuperCollider.

SYSEX MESSAGE SPECIFICATION:

"https://www.cs.cmu.edu/~eli/music/m6-sysex.html"
"http://www.youngmonkey.ca/nose/audio_tech/synth/Oberheim-Matrix6R.html"

SYSEX FORMAT:

sysex start:
0xF0

Oberheim ID:
0x10

Device ID:
0x06 for M-6
0x02 for M-12 or Xpander

select quick patch edit:
0x05
...
