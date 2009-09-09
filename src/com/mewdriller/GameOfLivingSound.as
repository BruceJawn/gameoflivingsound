package com.mewdriller
{
	import com.bit101.components.PushButton;
	import com.mewdriller.control.Controller;
	import com.mewdriller.view.SoundSquare;
	import com.mewdriller.sound.Tone;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 
	 * 
	 * @author amiller
	 * @version 1.0
	 */
	public final class GameOfLivingSound extends Sprite 
	{
		public static const BOARD_SIZE:int = 16;
		
		private var _controller:Controller = Controller.getInstance();
		private var _beat:Timer = new Timer(msPerSquare);
		private var isOn:Vector.<Boolean> = new Vector.<Boolean>();
		private var soundBoard:Vector.<Vector.<SoundSquare>>;
		
		/**
		 * Number of ms between beats.
		 */
		public static function get msPerSquare():Number { return 2000 / BOARD_SIZE; }
		
		public var clearButton:PushButton;
		public var playButton:PushButton;
		public var stopButton:PushButton;
		
		public function GameOfLivingSound():void 
		{
			if (stage) onAddedToStage();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			drawSquares();
			addButtons();
			
			_beat.addEventListener(TimerEvent.TIMER, onBeatTick, false, 0, true);
		}
		
		private function onBeatTick(e:TimerEvent):void 
		{
			// Play the appropriate column of tones.
			var col:Number = ((_beat.currentCount - 1) % 16);
		
			
			
			
				
				isOn.unshift(soundBoard[0][col].isOn);
				isOn.unshift(soundBoard[1][col].isOn);
				isOn.unshift(soundBoard[2][col].isOn);
				isOn.unshift(soundBoard[3][col].isOn);
				isOn.unshift(soundBoard[4][col].isOn);
				isOn.unshift(soundBoard[5][col].isOn);
				isOn.unshift(soundBoard[6][col].isOn);
				isOn.unshift(soundBoard[7][col].isOn);
				isOn.unshift(soundBoard[8][col].isOn);
				isOn.unshift(soundBoard[9][col].isOn);
				isOn.unshift(soundBoard[10][col].isOn);
				isOn.unshift(soundBoard[11][col].isOn);
				isOn.unshift(soundBoard[12][col].isOn);
				isOn.unshift(soundBoard[13][col].isOn);
				isOn.unshift(soundBoard[14][col].isOn);
				isOn.unshift(soundBoard[15][col].isOn);
				
				
			//trace(isOn[0], isOn[1], isOn[2], isOn[3]);
			new Tone(2, 8, 3, 5, 2, 5, isOn).start();
			_controller.playColumn(col);
		}
		
		private function addButtons():void 
		{
			// Add the clear, play, and stop buttons:
			
			playButton = new PushButton(this, 0, 0, "Play", onPlayClick);
			stopButton = new PushButton(this, playButton.getBounds(this).right + 10, 0, "Stop", onStopClick);
			clearButton = new PushButton(this, stopButton.getBounds(this).right + 10, 0, "Clear", onClearClick);
		}
		
		private function onPlayClick(e:MouseEvent):void 
		{
			_beat.start();
		}
		
		private function onStopClick(e:MouseEvent):void 
		{
			_beat.reset();
		}
		
		private function onClearClick(e:MouseEvent):void 
		{
			_controller.clearBoard();
		}
		
		private function drawSquares():void 
		{
			var square:SoundSquare, row:int, col:int;
			soundBoard = new Vector.<Vector.<SoundSquare>>( 16, true );
			
			for (row = 0; row < BOARD_SIZE; row++) 
			{
				soundBoard[row] = new Vector.<SoundSquare>(16, true);
				for (col = 0; col < BOARD_SIZE; col++) 
				{
					square = new SoundSquare(row, col);					
					square.x = SoundSquare.SIZE * col;
					square.y = SoundSquare.SIZE * row + SoundSquare.SIZE + 10;
					soundBoard[row][col] = square;
					addChild(square);
				}
			}
		}
	}
}