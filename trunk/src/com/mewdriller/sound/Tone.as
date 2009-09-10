﻿package com.mewdriller.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class Tone extends EventDispatcher
	{
		public static const SAMPLING_RATE:Number = 44100;
		public static const BUFFER_SIZE:int = 8192;		
		public static const UNIT:int = 10;
		
		public static const ATTACK_PHASE:int = 1;
		public static const DECAY_PHASE:int = 2;
		public static const RELEASE_PHASE:int = 3;
		
		private var _toneMgr:ToneManager = ToneManager.getInstance();
		
		public function Tone(length:Number, volume:Number, attack:Number, decay:Number, sustain:Number, release:Number, isOn:Vector.<Boolean>)
		{	
			this.length = length;
			this.volume = volume;
			this.attack = attack;
			this.decay = decay;
			this.sustain = sustain;
			this.release = release;
			this.isOn = isOn; 
			
			check();
			initializeVelocity();
		}
		
		private var sound:Sound;
		private var channel:SoundChannel;
		
		private var phase:Number = 0;
		private var phase2:Number = 0;
		private var phase3:Number = 0;
		private var phase4:Number = 0;
		private var phase5:Number = 0;
		private var phase6:Number = 0;
		private var phase7:Number = 0;
		private var phase8:Number = 0;
		private var phase9:Number = 0;
		private var phase10:Number = 0;
		private var phase11:Number = 0;
		private var phase12:Number = 0;
		private var phase13:Number = 0;
		private var phase14:Number = 0;
		private var phase15:Number = 0;
		private var phase16:Number = 0;
		
		private var sample:Number = 0;
		private var sample2:Number = 0;
		private var sample3:Number = 0;
		private var sample4:Number = 0;
		private var sample5:Number = 0;
		private var sample6:Number = 0;
		private var sample7:Number = 0;
		private var sample8:Number = 0;
		private var sample9:Number = 0;
		private var sample10:Number = 0;
		private var sample11:Number = 0;
		private var sample12:Number = 0;
		private var sample13:Number = 0;
		private var sample14:Number = 0;
		private var sample15:Number = 0;
		private var sample16:Number = 0;
		
		private var amplify:Number = 0;
		
		private var tonePhase:int = 1; // 1: Attack, 2: Decay, 3: Release
		
		private var frequency:Number;
		private var length:Number;
		private var volume:Number;
		private var attack:Number;
		private var decay:Number;
		private var sustain:Number;
		private var release:Number;
		private var isOn:Vector.<Boolean>;
		private var step:Vector.<Number> = new Vector.<Number>();
		private var toner:Array = [220, 246.942, 293.665, 329.628, 369.994, 440, 493.883, 587.33, 659.255, 739.989, 880, 987.767, 1174.656, 1318.51, 1479.978, 1760];
		
		private var v1:Number;
		private var v2:Number;
		private var v3:Number;
		
		private function check():void
		{
			if (attack + decay + release != UNIT)
			{
				attack = 0;
				decay = 5;
				release = 5;
			}
				
			if (volume > UNIT)
				volume = UNIT;
			
			if (volume < 0)
				volume = 0;
				
			if (sustain > UNIT)
				sustain = UNIT;
				
			if (sustain < 0)
				sustain = 0;
		}
		
		private function initializeVelocity():void
		{			
			v1 = volume / (SAMPLING_RATE * length * attack / UNIT);
			v2 = (volume - sustain) / (SAMPLING_RATE * length * decay / UNIT);
			v3 = sustain / (SAMPLING_RATE * length * release / UNIT);
		}
		
		private function updateAmplify():void
		{
			switch (tonePhase) 
			{
				case ATTACK_PHASE:
					processAttackPhase();
				break;
				
				case DECAY_PHASE:
					processDecayPhase();
				break;
				
				case RELEASE_PHASE:
					processReleasePhase();
				break;
			}
		}
		
		private function processAttackPhase():void 
		{
			amplify += v1;
			
			if (amplify >= volume)
			{
				amplify = volume;
				tonePhase = DECAY_PHASE;
			}
		}
		
		private function processDecayPhase():void 
		{
			amplify -= v2;
			
			if (volume < sustain)
			{
				if (amplify >= sustain)
				{
					amplify = sustain;
					tonePhase = RELEASE_PHASE;
				}
			}
			else
			{
				if (amplify <= sustain)
				{
					amplify = sustain;
					tonePhase = RELEASE_PHASE;
				}
			}
		}
		
		private function processReleasePhase():void 
		{
			amplify -= v3;
			
			if (amplify <= 0)
			{
				amplify = 0;
				
				stop();
			}
		}
		
		private var _chord:Vector.<ByteArray> = new Vector.<ByteArray>();
		private var _index:int;
		
		
		public function start():void
		{
			buildChord();
			
			_index = 0;
			
			if (_toneMgr.hasChord(isOn)) _chord = _toneMgr.getChord(isOn);
			
			sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			channel = sound.play();
		}
		
		public function stop():void
		{
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (!_toneMgr.hasChord(isOn)) _toneMgr.storeChord(_chord, isOn);
		}
		
		private function buildChord():void
		{
			// TODO: Replace isOn with binary key to avoid conversion at each step.
			
			for (var i:Number = 0; i < 16; i++) step.push((isOn[i]) ? toner[i] : 0);
		}
		
		private function soundSampleDataHandler(event:SampleDataEvent):void
		{
			if (_chord.length <= _index)
			{
				_chord[_index] = computeByteArray();
			}
			
			event.data.writeBytes(_chord[_index]);
			
			_index++;
		}
		
		private function computeByteArray():ByteArray 
		{
			var bytes:ByteArray = new ByteArray();
			
			for (var i:int = 0; i < BUFFER_SIZE; ++i)
			{
				phase += step[0] / SAMPLING_RATE;
				phase2 += step[1] / SAMPLING_RATE;
				phase3 += step[2] / SAMPLING_RATE;
				phase4 += step[3] / SAMPLING_RATE;
				phase5 += step[4] / SAMPLING_RATE;
				phase6 += step[5] / SAMPLING_RATE;
				phase7 += step[6] / SAMPLING_RATE;
				phase8 += step[7] / SAMPLING_RATE;
				phase9 += step[8] / SAMPLING_RATE;
				phase10 += step[9] / SAMPLING_RATE;
				phase11 += step[10] / SAMPLING_RATE;
				phase12 += step[11] / SAMPLING_RATE;
				phase13 += step[12] / SAMPLING_RATE;
				phase14 += step[13] / SAMPLING_RATE;
				phase15 += step[14] / SAMPLING_RATE;
				phase16 += step[15] / SAMPLING_RATE;
					
				var phaseAngle:Number = phase * Math.PI * 2;
				var phaseAngle2:Number = phase2 * Math.PI * 2;
				var phaseAngle3:Number = phase3 * Math.PI * 2;
				var phaseAngle4:Number = phase4 * Math.PI * 2;
				var phaseAngle5:Number = phase5 * Math.PI * 2;
				var phaseAngle6:Number = phase6 * Math.PI * 2;
				var phaseAngle7:Number = phase7 * Math.PI * 2;
				var phaseAngle8:Number = phase8 * Math.PI * 2;
				var phaseAngle9:Number = phase9 * Math.PI * 2;
				var phaseAngle10:Number = phase10 * Math.PI * 2;
				var phaseAngle11:Number = phase11 * Math.PI * 2;
				var phaseAngle12:Number = phase12 * Math.PI * 2;
				var phaseAngle13:Number = phase13 * Math.PI * 2;
				var phaseAngle14:Number = phase14 * Math.PI * 2;
				var phaseAngle15:Number = phase15 * Math.PI * 2;
				var phaseAngle16:Number = phase16 * Math.PI * 2;
				
				sample = Math.sin(phaseAngle) * amplify / UNIT;
				sample2 = Math.sin(phaseAngle2) * amplify / UNIT;
				sample3 = Math.sin(phaseAngle3) * amplify / UNIT;
				sample4 = Math.sin(phaseAngle4) * amplify / UNIT;
				sample5 = Math.sin(phaseAngle5) * amplify / UNIT;
				sample6 = Math.sin(phaseAngle6) * amplify / UNIT;
				sample7 = Math.sin(phaseAngle7) * amplify / UNIT;
				sample8 = Math.sin(phaseAngle8) * amplify / UNIT;
				sample9 = Math.sin(phaseAngle9) * amplify / UNIT;
				sample10 = Math.sin(phaseAngle10) * amplify / UNIT;
				sample11 = Math.sin(phaseAngle11) * amplify / UNIT;
				sample12 = Math.sin(phaseAngle12) * amplify / UNIT;
				sample13 = Math.sin(phaseAngle13) * amplify / UNIT;
				sample14 = Math.sin(phaseAngle14) * amplify / UNIT;
				sample15 = Math.sin(phaseAngle15) * amplify / UNIT;
				sample16 = Math.sin(phaseAngle16) * amplify / UNIT;
				
				bytes.writeFloat(.2 * (sample + sample2 + sample3 + sample4 + sample5 + sample6 + sample7 + sample8 + sample9 + sample10 + sample11 + sample12 + sample13 + sample14 + sample15 + sample16) / 2);
				bytes.writeFloat(.2 * (sample + sample2 + sample3 + sample4 + sample5 + sample6 + sample7 + sample8 + sample9 + sample10 + sample11 + sample12 + sample13 + sample14 + sample15 + sample16) / 2);
				
				updateAmplify();
			}
			
			return bytes;
		}
	}
}