package com.mewdriller.sound 
{
	import com.noteflight.standingwave2.elements.AudioDescriptor;
	import com.noteflight.standingwave2.elements.IAudioSource;
	import com.noteflight.standingwave2.filters.EnvelopeFilter;
	import com.noteflight.standingwave2.sources.SineSource;
	import com.noteflight.standingwave2.utils.AudioUtils;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * Singleton manager for the tones used within the Game of Living Sound.
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public class ToneManager 
	{
		private static var _instance:ToneManager;
		
		/**
		 * Gets a reference to the singleton ToneManager.
		 * @return	The singleton reference to the ToneManager.
		 */
		public static function getInstance():ToneManager 
		{
			if (_instance == null) _instance = new ToneManager();
			return _instance;
		}
		
		public var chords:Dictionary = new Dictionary();
		
		/**
		 * Constructs a ToneManager.
		 * @private
		 */
		public function ToneManager() 
		{
			if (_instance != null) 
				throw new IllegalOperationError("Use ToneManager.getInstance() instead.");
			else
				initialize();
		}
		
		/**
		 * Initializes the ToneManager, caches the tones used in the app.
		 * @private
		 */
		private function initialize():void 
		{
			// TODO: Generate all chords.
		}
		
		public function hasChord(column:Vector.<Boolean>):Boolean 
		{
			return chords[makeKey(column)] != null;
		}
		
		public function storeChord(chord:Vector.<ByteArray>, column:Vector.<Boolean>):void 
		{
			chords[makeKey(column)] = chord;
		}
		
		public function getChord(column:Vector.<Boolean>):Vector.<ByteArray> 
		{
			var key:Number = makeKey(column);
			
			if (key != 0) trace("key: " + key);
			
			return chords[key];
		}
		
		private function makeKey(column:Vector.<Boolean>):Number 
		{
			var key:Number = 0;
			
			for (var i:int = 0; i < column.length; i++) 
			{
				if (column[i]) key += Math.pow(2, i);
			}
			
			return key;
		}
		
	}	
}