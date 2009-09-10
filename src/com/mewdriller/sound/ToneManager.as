package com.mewdriller.sound 
{
	import com.noteflight.standingwave2.elements.AudioDescriptor;
	import com.noteflight.standingwave2.elements.IAudioSource;
	import com.noteflight.standingwave2.filters.EchoFilter;
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
		
		public function hasChord(key:String):Boolean 
		{
			var hit:Boolean = chords[key] != null;
			
			return hit;
		}
		
		public function storeChord(chord:Vector.<ByteArray>, key:String):void 
		{
			trace("storing @ " + key);
			
			chords[key] = chord;
		}
		
		public function getChord(key:String):Vector.<ByteArray> 
		{
			var chord:Vector.<ByteArray> = chords[key];
			
			return chords[key];
		}
		
		public function makeKey(column:Vector.<Boolean>):String 
		{
			var key:String = "";
			
			for (var i:int = 0; i < column.length; i++) 
			{
				key = ((column[i]) ? "1" : "0") + key;
			}
			
			return key;
		}
		
	}	
}