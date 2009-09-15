package com.mewdriller.sound
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
		
		private var phase:Array = new Array();
		
		private var sample:Number = 0;
	
		
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
		private var _key:String;
		
		public function start():void
		{
			buildChord();
			
			_index = 0;
			
			_key = _toneMgr.makeKey(isOn);
			
			if (_toneMgr.hasChord(_key)) _chord = _toneMgr.getChord(_key);
			
			sound = new Sound();
			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			channel = sound.play();
		}
		
		private var _shouldBePlaying:Boolean = true;
		
		public function stop():void
		{
			_shouldBePlaying = false;
			
			//channel.stop();
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, soundSampleDataHandler);
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (!_toneMgr.hasChord(_key)) 
			{
				_toneMgr.storeChord(_chord, _key);
			}
		}
		
		private function buildChord():void
		{
			for (var i:Number = 0; i < 16; i++) step.push((isOn[i]) ? toner[i] : 0);
			for (var a:int = 0; a < 16; a++) if (step[a] != 0) phase.push(step[a] / SAMPLING_RATE);
		}
		
		private function soundSampleDataHandler(event:SampleDataEvent):void
		{
			if (!_toneMgr.hasChord(_key)) _chord[_index] = computeByteArray();
			
			if (_index < _chord.length) event.data.writeBytes(_chord[_index++]);
		}
		
		private function computeByteArray():ByteArray 
		{
			var bytes:ByteArray = new ByteArray();
			
						
			
			for (var i:int = 0; i < BUFFER_SIZE && _shouldBePlaying; ++i)
			{
				var count:int = i++;
				
				
				for (var ii:int = 0; ii < phase.length; ii++) sample += ((Math.sin(phase[ii] * count * 2 * Math.PI)) * amplify / UNIT); 
				bytes.writeFloat(sample / 10);
				bytes.writeFloat(sample / 10);
				sample = 0;
				updateAmplify();	
				
				
					
			
				
			}
			
			return bytes;
		}
	}
}