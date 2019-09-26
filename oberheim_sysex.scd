
/* Parameter Randomizer for the Oberheim Matrix-6(r) and Preset Saving to a text File.

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

opcode to change and correspinding value between 0-99 as opposed to the hardware menu

sysex end (EOX):
0xF7

The high bit of each byte is zero, reserved as the MIDI status bit.
Wait at least 20 ms between sysex operations on the old firmware, faster for the update.

The M-6 must be in Patch Edit mode in order to act upon parameter change commands.

'Incorrect' messages will be ignored by the M-6.

On The To-Do List: Patch Dumps from synth, Sweet Spot randomizer that constrains the parameter ranges for more likely musical patches

*/

//instantiate midi hardware interface used to communicate with the M-6

MIDIClient.init;
MIDIIn.connect;

//set midi port - make sure you are sending to the correct channel.

m = MIDIOut(1);

//check that devices are connected by sending out a note - reset the port if necessary

m.noteOn(0,  60, 60);
m.noteOff(0,  60, 60);

//send a message to the matrix-6 and set it to patch-edit mode - your synth menu LEDs should reflect the change.

m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);


/*

Basic SysEx Message Tests

*/

/*
patch dump message --- M-6 currently sends data but it isn't yet accessible to SuperCollider will be testing if possible with the new firmware
*/

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, //Device ID: 0x06 for M-6
	0x04, //patch dump request
	0x0, //Transmit all Single Patches, Splits, and Master parameters
	0xf7]);  //sysex end (EOX)

//send a message to the matrix-6 and set it to patch-edit mode and change a parameter

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	00x05, //parameter id DCO Shape
	0x3F.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0, //parameter id DCO Shape
	99.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x2, //parameter id DCO Shape
	0x3.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x1, //parameter id DCO Shape
	99.rand, //parameter value to send // can't get negative values yet
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x4, //parameter id DCO Shape
	99.rand, //parameter value to send // can't get negative values yet
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x3, //parameter id DCO Shape
	99.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x6, //parameter id DCO Shape
	3.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x7, //parameter id DCO Shape
	99.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x8, //parameter id DCO Shape
	99.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0x9, //parameter id DCO Shape
	[0x0,0x1].choose, //parameter value to send
	0xf7]);  //sysex end (EOX)

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0xA, //parameter id DCO Shape
	99.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)


//change multiple params in one message:

m.sysex(Int8Array[
	0xF0,  //sysex start
	0x10,  //Oberheim ID
	0x06, 0x06, //Device ID: 0x06 for M-6
	0, //parameter id DCO Shape
	99.rand, //parameter value to send
	0xf7]);  //sysex end (EOX)

/*

Store each parameter name to hex value.
Associate parameter hex value to lower and upper bounds for

*/
(

//Associate names to parameter indexes - NOTE THE MISSING INDEXES

~parameter_index_dictionary = Dictionary.new;

//DCO1

~parameter_index_dictionary.add("DCO1_FREQ" -> 0);
~parameter_index_dictionary.add("DCO1_FREQ_MOD_BY_LFO1" -> 1);
~parameter_index_dictionary.add("DCO1_SYNC" -> 2);
~parameter_index_dictionary.add("DCO1_PULSE_WIDTH" -> 3);
~parameter_index_dictionary.add("DCO1_PULSE_WIDTH_MOD_BY_LF02" -> 4);
~parameter_index_dictionary.add("DCO1_WAVE_SHAPE" -> 5);
~parameter_index_dictionary.add("DCO1_WAVE_SELECT" -> 6);
~parameter_index_dictionary.add("DCO1_LEVELS" -> 7);
~parameter_index_dictionary.add("DCO1_KEYBOARD/PORTAMENTO" -> 8);
~parameter_index_dictionary.add("DCO1_KEY_CLICK" -> 9);

//DCO2

~parameter_index_dictionary.add("DCO2_FREQ" -> 10);
~parameter_index_dictionary.add("DCO2_FREQ_MOD_BY_LFO1" -> 11);
~parameter_index_dictionary.add("DCO2_DETUNE" -> 12);
~parameter_index_dictionary.add("DCO2_PULSE_WIDTH" -> 13);
~parameter_index_dictionary.add("DCO2_PULSE_WIDTH_MOD_BY_LF02" -> 14);
~parameter_index_dictionary.add("DCO2_WAVE_SHAPE" -> 15);
~parameter_index_dictionary.add("DCO2_WAVE_SELECT" -> 16);
~parameter_index_dictionary.add("DCO2_LEVELS" -> 17);
~parameter_index_dictionary.add("DCO2_KEYBOARD/PORTAMENTO" -> 18);
~parameter_index_dictionary.add("DCO2_KEY_CLICK" -> 19);

//VCF - VCA

~parameter_index_dictionary.add("BALANCE" -> 20);
~parameter_index_dictionary.add("FREQUENCY" -> 21);
~parameter_index_dictionary.add("FREQ_MOD_BY_ENV_1" -> 22);
~parameter_index_dictionary.add("FREQ_MOD_BY_PRESSURE" -> 23);
~parameter_index_dictionary.add("RESONANCE" -> 24);
~parameter_index_dictionary.add("LEVERS" -> 25);
~parameter_index_dictionary.add("KEYBOARD/PORTAMENTO" -> 26);
~parameter_index_dictionary.add("VCA_1_VOLUME" -> 27);
~parameter_index_dictionary.add("VCA1_MOD_BY_VELOCITY" -> 28);
~parameter_index_dictionary.add("VCA2_MOD_BY_ENV2" -> 29);

//FM - TRACK

~parameter_index_dictionary.add("VCF_FM_AMOUNT" -> 30);
~parameter_index_dictionary.add("FM_MOD_BY_ENV_3" -> 31);
~parameter_index_dictionary.add("FM_MOD_BY_PRESSURE" -> 32);
~parameter_index_dictionary.add("TRACK_INPUT" -> 33);
~parameter_index_dictionary.add("TRACK_INPUT_POINT_1" -> 34);
~parameter_index_dictionary.add("TRACK_INPUT_POINT_2" -> 35);
~parameter_index_dictionary.add("TRACK_INPUT_POINT_3" -> 36);
~parameter_index_dictionary.add("TRACK_INPUT_POINT_4" -> 37);
~parameter_index_dictionary.add("TRACK_INPUT_POINT_5" -> 38);

//RAMP - PORTAMENTO

~parameter_index_dictionary.add("RAMP_1_RATE" -> 40);
~parameter_index_dictionary.add("RAMP_1_TRIGGER" -> 41);
~parameter_index_dictionary.add("RAMP_2_RATE" -> 42);
~parameter_index_dictionary.add("RAMP_2_TRIGGER" -> 43);
~parameter_index_dictionary.add("PORTMENTO_RATE" -> 44);
~parameter_index_dictionary.add("PORT_MOD_BY_VELOCITY" -> 45);
~parameter_index_dictionary.add("PORTAMENTO_MODE" -> 46);
~parameter_index_dictionary.add("LEGATO_PORTAMENTO" -> 47);
~parameter_index_dictionary.add("KEYBOARD_MODE" -> 48);

//ENV 1

~parameter_index_dictionary.add("ENV_1_DELAY" -> 50);
~parameter_index_dictionary.add("ENV_1_ATTACK" -> 51);
~parameter_index_dictionary.add("ENV_1_DECAY" -> 52);
~parameter_index_dictionary.add("ENV_1_SUSTAIN" -> 53);
~parameter_index_dictionary.add("ENV_1_RELEASE" -> 54);
~parameter_index_dictionary.add("ENV_1_AMPLITUDE" -> 55);
~parameter_index_dictionary.add("ENV_1_AMP_MOD_BY_VELOCITY" -> 56);
~parameter_index_dictionary.add("ENV_1_TRIGGER_MODE" -> 57);
~parameter_index_dictionary.add("ENV_1_ENVELOPE_MODE" -> 58);
~parameter_index_dictionary.add("ENV_1_LFO_1_TRIGGER" -> 59);

//ENV 2

~parameter_index_dictionary.add("ENV_2_DELAY" -> 60);
~parameter_index_dictionary.add("ENV_2_ATTACK" -> 61);
~parameter_index_dictionary.add("ENV_2_DECAY" -> 62);
~parameter_index_dictionary.add("ENV_2_SUSTAIN" -> 63);
~parameter_index_dictionary.add("ENV_2_RELEASE" -> 64);
~parameter_index_dictionary.add("ENV_2_AMPLITUDE" -> 65);
~parameter_index_dictionary.add("ENV_2_AMP_MOD_BY_VELOCITY" -> 66);
~parameter_index_dictionary.add("ENV_2_TRIGGER_MODE" -> 67);
~parameter_index_dictionary.add("ENV_2_ENVELOPE_MODE" -> 68);
~parameter_index_dictionary.add("ENV_2_LFO_1_TRIGGER" -> 69);

//ENV 3

~parameter_index_dictionary.add("ENV_3_DELAY" -> 70);
~parameter_index_dictionary.add("ENV_3_ATTACK" -> 71);
~parameter_index_dictionary.add("ENV_3_DECAY" -> 72);
~parameter_index_dictionary.add("ENV_3_SUSTAIN" -> 73);
~parameter_index_dictionary.add("ENV_3_RELEASE" -> 74);
~parameter_index_dictionary.add("ENV_3_AMPLITUDE" -> 75);
~parameter_index_dictionary.add("ENV_3_AMP_MOD_BY_VELOCITY" -> 76);
~parameter_index_dictionary.add("ENV_3_TRIGGER_MODE" -> 77);
~parameter_index_dictionary.add("ENV_3_ENVELOPE_MODE" -> 78);
~parameter_index_dictionary.add("ENV_3_LFO_1_TRIGGER" -> 79);

//LFO 1

~parameter_index_dictionary.add("LFO_1_SPEED" -> 80);
~parameter_index_dictionary.add("LFO_1_SPEED_MOD_BY_PRESSURE" -> 81);
~parameter_index_dictionary.add("LFO_1_WAVEFORM" -> 82);
~parameter_index_dictionary.add("LFO_1_RETRIGGER_POINT" -> 83);
~parameter_index_dictionary.add("LFO_1_AMPLITUDE" -> 84);
~parameter_index_dictionary.add("LFO_1_AMP_MOD_BY_RAMP_1" -> 85);
~parameter_index_dictionary.add("LFO_1_TRIGGER_MODE" -> 86);
~parameter_index_dictionary.add("LFO_1_LAG" -> 87);
~parameter_index_dictionary.add("LFO_1_SAMPLE_INPUT" -> 88);

//LFO 2

~parameter_index_dictionary.add("LFO_2_SPEED" -> 90);
~parameter_index_dictionary.add("LFO_2_SPEED_MOD_BY_PRESSURE" -> 91);
~parameter_index_dictionary.add("LFO_2_WAVEFORM" -> 92);
~parameter_index_dictionary.add("LFO_2_RETRIGGER_POINT" -> 93);
~parameter_index_dictionary.add("LFO_2_AMPLITUDE" -> 94);
~parameter_index_dictionary.add("LFO_2_AMP_MOD_BY_RAMP_1" -> 95);
~parameter_index_dictionary.add("LFO_2_TRIGGER_MODE" -> 96);
~parameter_index_dictionary.add("LFO_2_LAG" -> 97);
~parameter_index_dictionary.add("LFO_2_SAMPLE_INPUT" -> 98);

~parameter_index_dictionary.postcs;
)


/*

IDENTIFY APPROPRIATE RANGE VALUES FOR PARAMETERS

For instance, Wave Select should take ranges from 0-4.

After testing, some out-of-range values will not be ignored and will affect the parameter/sound.

*/


(
e = Array.fill(99, [0,60]);
~e_new_patch = Array.fill(99, 0);

~indexes_with_nonstandard_range = [
	[2, [0,3]],
	[6, [0,3]],
	[7, [0,3]],
	[8, [0,1]],
	[9, [0,1]],
	[16, [0,4]],
	[17, [0,3]],
	[18, [0,2]],
	[19, [0,1]],
	[21, [30,91]],
	[25, [0,3]],
	[26, [0,2]],
	[27, [40,92]],
	[28, [60, 63]],
	[29, [60, 63]],

	[33, [0,19]],
	[41, [0,3]],
	[43, [0,3]],
	[47, [0,1]],
	[48, [0,3]],
	[55, [40,99]],

	[57, [0,7]],
	[58, [0,0]],
	[59, [0,2]],
	[65, [40,99]],
	[66, [40,99]],
	[67, [0,3]],
	[68, [0,0]],
	[69, [0,0]],
	[74, [40,99]],
	[77, [0,7]],
	[78, [0,0]],
	[79, [0,2]],
	[82, [0,6]],
	[86, [0,3]],
	[87, [0,1]],
	[88, [0,18]],
	[92, [0,6]],
	[96, [0,3]],
	[98, [0,18]]
];

~indexes_with_nonstandard_range.do({ arg item, i;
	e[item[0]] = item[1];
});

//create a Routine to batch edit

//send patch edit message

//m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

//create routine to cycle through parameters and pass a random value within the specified ranges

/*
r = Routine {
var temp_v;
m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

e.do({ arg item, i;
item.postcs;
temp_v = (item[0]..item[1]).choose.postcs;
~e_new_patch[i] = temp_v;

if((i != 89) ||(i != 49) || (i != 39)){
m.sysex(Int8Array[
0xF0,  //sysex start
0x10,  //Oberheim ID
0x06, 0x06, //Device ID: 0x06 for M-6
i, //parameter id DCO Shape
temp_v, //parameter value to send
0xf7]);  //sysex end (EOX)
};


0.24.wait;
});
}
*/

/*
Define the Parameter Randomizer Routine that sends the sequence of SysEx messages
*/

~parameter_randomizer = {

	Routine {
		var temp_v;
		m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

		e.do({ arg item, i;
			//item.postcs;
			temp_v = (item[0]..item[1]).choose;
			~e_new_patch[i] = temp_v;
			// ||(i != 49) || (i != 39))
			if(i != 89)
			{
				if(i != 49){
					if(i != 48){
						if(i != 39){
							m.sysex(Int8Array[
								0xF0,  //sysex start
								0x10,  //Oberheim ID
								0x06,0x06,  //Device ID: 0x06 for M-6
								i, //parameter id DCO Shape
								temp_v, //parameter value to send
								0xf7]);  //sysex end (EOX)

							i.post;
							" ".postcs;
							~parameter_index_dictionary.findKeyForValue(i).post;
							": ".post;
							temp_v.postcs;
						};
					};
				};
			};
			0.25.wait;
		});
		"PATCH PARAMETER VALUES".postcs;
		~e_new_patch.postcs;
	}

}
)

//Run the Randomizer

~parameter_randomizer.value.play

//Test the new patch by playing a note

m.noteOn(0,  1, 126);

m.noteOn(0,  60, 126);
m.noteOn(0,  60+4, 126);
m.noteOn(0,  20, 126);

m.noteOn(0,  1, 126);

m.noteOff(0,  1, 126);
m.noteOff(0,  60, 126);
m.noteOff(0,  40, 126);
m.noteOff(0,  64, 126);
m.noteOff(0,  20, 126);
m.noteOff(0,  10, 126);
m.noteOff(0,  67, 126);
m.noteOff(0,  60+17, 126);

//collect some cool parameter lists

~new_patch = [ 1, 46, 0, 31, 18, 44, 1, 2, 0, 1, 37, 39, 27, 32, 13, 31, 0, 1, 1, 0, 5, 23, 15, 53, 22, 1, 1, 47, 25, 24, 44, 44, 43, 3, 37, 43, 23, 56, 32, 48, 3, 1, 7, 1, 13, 41, 6, 0, 0, 50, 22, 22, 21, 12, 13, 52, 34, 5, 3, 0, 26, 34, 58, 40, 46, 28, 29, 0, 0, 2, 14, 37, 18, 41, 5, 28, 46, 7, 1, 1, 12, 9, 4, 59, 28, 35, 3, 1, 7, 59, 10, 16, 1, 15, 23, 50, 3, 21, 15 ];

~cool_low = [ 24, 49, 2, 43, 38, 36, 1, 2, 1, 0, 36, 10, 15, 37, 30, 11, 1, 1, 0, 0, 29, 47, 13, 56, 43, 2, 2, 18, 31, 51, 44, 58, 33, 0, 42, 57, 48, 51, 15, 7, 53, 3, 49, 1, 49, 35, 11, 1, 1, 4, 9, 30, 42, 40, 33, 59, 23, 5, 1, 2, 37, 25, 10, 57, 59, 54, 27, 0, 2, 0, 45, 6, 40, 24, 12, 6, 44, 0, 3, 2, 56, 16, 2, 54, 23, 50, 3, 0, 2, 46, 5, 23, 1, 35, 14, 39, 2, 33, 7 ];

~new_patch2 = [ 17, 47, 1, 51, 50, 10, 3, 1, 1, 0, 42, 25, 47, 7, 32, 41, 1, 1, 0, 0, 32, 38, 46, 4, 44, 2, 0, 27, 10, 34, 33, 13, 35, 4, 20, 53, 56, 2, 8, 2, 3, 1, 10, 2, 35, 41, 55, 0, 1, 60, 12, 10, 24, 59, 52, 22, 56, 6, 3, 0, 7, 40, 11, 42, 32, 10, 34, 6, 2, 1, 18, 20, 11, 31, 1, 18, 36, 0, 0, 1, 4, 12, 2, 5, 44, 30, 2, 0, 2, 33, 54, 1, 5, 9, 58, 31, 1, 55, 17 ];

~new_patch3 = [ 7, 34, 0, 3, 60, 60, 3, 0, 0, 0, 42, 29, 10, 57, 16, 14, 4, 3, 2, 0, 39, 41, 57, 51, 7, 3, 2, 56, 43, 30, 39, 11, 4, 9, 9, 57, 21, 8, 34, 22, 26, 2, 11, 3, 33, 3, 56, 1, 3, 25, 55, 40, 31, 30, 58, 19, 5, 7, 2, 1, 30, 22, 17, 58, 26, 18, 29, 3, 3, 0, 48, 33, 10, 56, 28, 53, 48, 6, 1, 1, 7, 52, 2, 44, 7, 41, 2, 0, 13, 37, 30, 7, 1, 48, 48, 7, 1, 39, 2 ];

~new_patch4 = [ 22, 9, 2, 29, 27, 58, 2, 2, 1, 0, 16, 47, 22, 51, 13, 42, 0, 0, 0, 1, 15, 44, 49, 11, 41, 1, 0, 13, 40, 58, 26, 52, 59, 0, 18, 18, 48, 8, 2, 22, 51, 1, 2, 2, 41, 15, 38, 1, 0, 6, 40, 58, 54, 28, 59, 13, 44, 6, 1, 2, 43, 29, 17, 45, 4, 19, 30, 6, 3, 1, 34, 59, 6, 28, 60, 15, 21, 4, 0, 1, 42, 50, 2, 47, 28, 25, 1, 1, 4, 32, 5, 6, 2, 45, 7, 30, 1, 15, 4 ];

~bass1 = [ 12, 45, 2, 48, 42, 59, 3, 2, 1, 1, 27, 45, 16, 45, 37, 26, 1, 1, 0, 0, 24, 32, 37, 36, 37, 1, 2, 50, 7, 43, 42, 52, 36, 10, 1, 4, 27, 13, 58, 47, 41, 3, 10, 0, 0, 9, 8, 0, 1, 25, 59, 21, 3, 5, 9, 50, 28, 6, 1, 0, 0, 22, 13, 30, 59, 44, 18, 1, 2, 1, 22, 24, 30, 54, 21, 15, 9, 0, 3, 2, 13, 27, 0, 20, 47, 4, 3, 1, 13, 47, 11, 51, 1, 4, 6, 40, 0, 5, 18 ];

~bass2 = [ 9, 55, 0, 38, 27, 28, 2, 0, 0, 1, 29, 13, 23, 39, 58, 52, 1, 2, 0, 0, 39, 22, 18, 48, 45, 0, 2, 55, 36, 57, 1, 13, 38, 0, 27, 32, 37, 55, 51, 16, 53, 3, 42, 0, 2, 37, 42, 1, 2, 3, 14, 48, 6, 16, 52, 36, 12, 0, 3, 1, 15, 56, 21, 18, 8, 5, 29, 7, 2, 0, 57, 56, 23, 32, 58, 7, 32, 1, 0, 0, 25, 42, 1, 47, 42, 39, 2, 0, 2, 49, 25, 31, 0, 21, 57, 27, 0, 56, 18 ];

//~new_patch.size

j = Routine {
	var temp_v;
	m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

	e.do({ arg item, i;
		item.postcs;
		//temp_v = (item[0]..item[1]).choose.postcs;

		if((i != 89) ||(i != 49) || (i != 39)){
			m.sysex(Int8Array[
				0xF0,  //sysex start
				0x10,  //Oberheim ID
				0x06, 0x06, //Device ID: 0x06 for M-6
				i, //parameter id DCO Shape
				~new_patch4[i], //parameter value to send
				0xf7]);  //sysex end (EOX)
		};
		0.022.wait;
	});
}

/*
Load a patch from an Array in SC.
*/

~load_parameters_from_list = {arg parameter_list;

	Routine {
		var temp_v;
		m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

		e.do({ arg item, i;
			//item.postcs;
			//temp_v = (item[0]..item[1]).choose.postcs;

			/*

			(((i != 89) ||(i != 48))
			||((i != 49) ||(i != 50))) || (i != 39))
			*/

			if(i!=39){
				if(i!=48){
					if(i!=89){
						m.sysex(Int8Array[
							0xF0,  //sysex start
							0x10,  //Oberheim ID
							0x06, 0x06, //Device ID: 0x06 for M-6
							i, //parameter id DCO Shape
							parameter_list[i], //parameter value to send
							0xf7]);  //sysex end (EOX)

						i.post;
						" ".post;
						~parameter_index_dictionary.findKeyForValue(i).post;
						": ".post;
						parameter_list[i].postcs;
					};
				};
			};
			0.39.wait;
		});
	}

};

~load_parameters_from_list.value(~cool_low).play;

m.noteOn(0,  59-24, 122);
m.noteOff(0,  59-24, 126);

(var param_size = 50;
e = Array.fill(param_size, [0,60]);
~e_new_patch = Array.fill(param_size, 0);

~indexes_with_nonstandard_range = [
	[2, [0,3]],
	[6, [0,3]],
	[7, [0,3]],
	[8, [0,1]],
	[9, [0,1]],
	[16, [0,4]],
	[17, [0,3]],
	[18, [0,2]],
	[19, [0,1]],
	[19, [0,1]],
	[25, [0,3]],
	[26, [0,2]],
	[33, [0,19]],
	[41, [0,3]],
	[43, [0,3]],
	[47, [0,1]],
	[48, [0,3]],
	[57, [0,7]],
	[58, [0,3]],
	[59, [0,2]],
	[67, [0,7]],
	[68, [0,3]],
	[69, [0,2]],
	[77, [0,7]],
	[78, [0,3]],
	[79, [0,2]],
	[82, [0,6]],
	[86, [0,3]],
	[87, [0,1]],
	[88, [0,18]],
	[92, [0,6]],
	[96, [0,3]],
	[98, [0,18]]
];

~indexes_with_nonstandard_range.do({ arg item, i;
	if(item[0] < param_size){
		e[item[0]] = item[1];
	};
});

//create a Routine to batch edit

//send patch edit message
m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

//create routine to cycle through parameters and pass a random value within the specified ranges

r = Routine {
	var temp_v;
	m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

	e.do({ arg item, i;
		item.postcs;
		temp_v = (item[0]..item[1]).choose.postcs;
		~e_new_patch[i] = temp_v;

		if((i != 89) ||(i != 49) || (i != 39)){
			m.sysex(Int8Array[
				0xF0,  //sysex start
				0x10,  //Oberheim ID
				0x06, 0x06, //Device ID: 0x06 for M-6
				i, //parameter id DCO Shape
				temp_v, //parameter value to send
				0xf7]);  //sysex end (EOX)
		};

		0.42.wait;
	});
}
)

m.noteOn(0,  60, 60);

m.noteOff(0,  60, 60);

r.play
~e_new_patch







(~make_patch = {
	e = Array.fill(99, [0,60]);
	~e_new_patch = Array.fill(99, 0);

	~indexes_with_nonstandard_range = [
		[2, [0,3]],
		[6, [0,3]],
		[7, [0,3]],
		[8, [0,1]],
		[9, [0,1]],
		[16, [0,4]],
		[17, [0,3]],
		[18, [0,2]],
		[19, [0,1]],
		[19, [0,1]],
		[25, [0,3]],
		[26, [0,2]],
		[33, [0,19]],
		[41, [0,3]],
		[43, [0,3]],
		[47, [0,1]],
		[48, [0,3]],
		[57, [0,7]],
		[58, [0,3]],
		[59, [0,2]],
		[67, [0,7]],
		[68, [0,3]],
		[69, [0,2]],
		[77, [0,7]],
		[78, [0,3]],
		[79, [0,2]],
		[82, [0,6]],
		[86, [0,3]],
		[87, [0,1]],
		[88, [0,18]],
		[92, [0,6]],
		[96, [0,3]],
		[98, [0,18]]
	];

	~indexes_with_nonstandard_range.do({ arg item, i;
		e[item[0]] = item[1];
	});

	//create a Routine to batch edit

	//send patch edit message
	m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

	//create routine to cycle through parameters and pass a random value within the specified ranges

	r = Routine {
		var temp_v;
		m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

		e.do({ arg item, i;
			item.postcs;
			temp_v = (item[0]..item[1]).choose.postcs;
			~e_new_patch[i] = temp_v;

			if((i != 89) ||(i != 49) || (i != 39)){
				m.sysex(Int8Array[
					0xF0,  //sysex start
					0x10,  //Oberheim ID
					0x06, 0x06, //Device ID: 0x06 for M-6
					i, //parameter id DCO Shape
					temp_v, //parameter value to send
					0xf7]);  //sysex end (EOX)
			};

			0.022.wait;
		});
	};
}
)
~make_patch.value.play


m.noteOn(0,  60, 60);

m.noteOff(0,  60, 60);


~e_new_patch





(
MIDIClient.init;
m = MIDIOut(1, MIDIClient.destinations.at(1).uid);
m.noteOn(0, 60, 60);
)



//this attempts to just keep changing parameters


(var param_size = 50;
e = Array.fill(param_size, [0,60]);
~e_new_patch = Array.fill(param_size, 0);

~indexes_with_nonstandard_range = [
	[2, [0,3]],
	[6, [0,3]],
	[7, [0,3]],
	[8, [0,1]],
	[9, [0,1]],
	[16, [0,4]],
	[17, [0,3]],
	[18, [0,2]],
	[19, [0,1]],
	[19, [0,1]],
	[25, [0,3]],
	[26, [1,2]],
	[27, [60,99]],
	[33, [0,19]],
	[41, [0,3]],
	[43, [0,3]],
	[47, [0,1]],
	[48, [0,3]],
	[57, [0,7]],
	[58, [0,3]],
	[59, [0,2]],
	[67, [0,7]],
	[68, [0,3]],
	[69, [0,2]],
	[77, [0,7]],
	[78, [0,3]],
	[79, [0,2]],
	[82, [0,6]],
	[86, [0,3]],
	[87, [0,1]],
	[88, [0,18]],
	[92, [0,6]],
	[96, [0,3]],
	[98, [0,18]]
];

~indexes_with_nonstandard_range.do({ arg item, i;
	if(item[0] < param_size){
		e[item[0]] = item[1];
	};
});

//create a Routine to batch edit

//send patch edit message
m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

//create routine to cycle through parameters and pass a random value within the specified ranges

r = Routine {
	var temp_v;
	m.sysex(Int8Array[0xF0, 0x10, 0x06, 0x05, 0xf7]);

	//40.do({ arg item2, i2;
	e.do({ arg item, i;
		item.postcs;
		temp_v = (item[0]..item[1]).choose.postcs;
		~e_new_patch[i] = temp_v;

		if((i != 89) ||(i != 49) || (i != 39)){
			m.sysex(Int8Array[
				0xF0,  //sysex start
				0x10,  //Oberheim ID
				0x06, 0x06, //Device ID: 0x06 for M-6
				i, //parameter id DCO Shape
				temp_v, //parameter value to send
				0xf7]);  //sysex end (EOX)
		};

		0.25.wait;
	});

	//});

}
)

m.noteOn(0,  67, 80);
m.noteOn(0,  60, 80);
m.noteOn(0,  72, 80);

m.noteOn(0,  67-12, 80);

m.noteOn(0,  60-12, 80);
m.noteOn(0,  71-12, 80);

r.play

