package com.mewdriller.view 
{
	import com.mewdriller.control.Controller;
	import com.mewdriller.control.event.DynamicEvent;
	import com.mewdriller.GameOfLivingSound;
	import com.mewdriller.sound.ToneManager;
	import com.noteflight.standingwave2.elements.AudioDescriptor;
	import com.noteflight.standingwave2.elements.IAudioSource;
	import com.noteflight.standingwave2.filters.EnvelopeFilter;
	import com.noteflight.standingwave2.output.AudioPlayer;
	import com.noteflight.standingwave2.sources.SineSource;
	import com.noteflight.standingwave2.utils.AudioUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * 
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public class SoundSquare extends Sprite
	{
		public static const SAMPLING_RATE:Number = 44100;
		public static const BUFFER_SIZE:int = 8192;
		public static const UNIT:int = 10;
		
		public static const SIZE:Number = 20;
		
		private var _controller:Controller = Controller.getInstance();
		private var _toneMgr:ToneManager = ToneManager.getInstance();
		
		private var _isOn:Boolean = false;
		private var _isInAddMode:Boolean = false;
		private var _activeTimeout:uint;
		
		public var row:int = 0;
		public var col:int = 0;
		
		public function get isOn():Boolean { return _isOn; }
		
		public function On():Boolean
		{
			if (_isOn) return true;
			else if (!_isOn) return false;
			
			return false;
		}
		
		public function set isOn(value:Boolean):void 
		{
			_isOn = value;
			
			if (_isOn) 
			{
				turnOn();
				_controller.addEventListener(Controller.PLAY_COLUMN, onPlayColumn, false, 0, true);
			}
			else 
			{
				turnOff();
				_controller.removeEventListener(Controller.PLAY_COLUMN, onPlayColumn);
			}
		}
		
		public function SoundSquare(row:int, col:int) 
		{
			this.row = row;
			this.col = col;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_controller.addEventListener(Controller.MODE_DRAG_ADD, onModeChange, false, 0, true);
			_controller.addEventListener(Controller.MODE_DRAG_CLEAR, onModeChange, false, 0, true);
			_controller.addEventListener(Controller.CLEAR_BOARD, onClearBoard, false, 0, true);
			
			turnOff();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			// Announce the drag-clear/add mode:
			
			isOn = !isOn;
			(isOn) ? _controller.startDragAddMode() : _controller.startDragClearMode();
		}
		
		private function onModeChange(e:Event):void 
		{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			
			_isInAddMode = e.type == Controller.MODE_DRAG_ADD;
		}
		
		private function onClearBoard(e:Event):void 
		{
			isOn = false;
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			if (_isInAddMode && !_isOn) isOn = true;
			else if (!_isInAddMode && _isOn) isOn = false;
		}
		
		private function onPlayColumn(e:DynamicEvent):void 
		{
			// Play sound tone according to row:
			
			if (e.col != null && e.col == col) 
			{
				turnActive();
				
				
				// TODO: Composite all the tones into one sound so that the frame plays through correctly.
				// Reference StandingWave's example to see if they're during this.
				
				//new AudioPlayer(8192).play(_toneMgr.getToneByRow(row));
			}
		}
		
		private function turnOn():void 
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(1, 1, SIZE - 2, SIZE - 2);
			graphics.endFill();
			
			clearTimeout(_activeTimeout);
		}
		
		private function turnActive():void 
		{
			// TODO: Redo active to have a glow that comes on/off during the notes playback.
			
			graphics.clear();
			graphics.beginFill(0x0000FF);
			graphics.drawRect(1, 1, SIZE - 2, SIZE - 2);
			graphics.endFill();
			
			_activeTimeout = setTimeout(turnOn, GameOfLivingSound.msPerSquare);
		}
		
		private function turnOff():void 
		{
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.drawRect(1, 1, SIZE - 2, SIZE - 2);
			graphics.endFill();
			
			clearTimeout(_activeTimeout);
		}
	}
}