package net.vt6f3ohw.flmon {
	import mx.utils.StringUtil;
	
	public class PianoRollItem {
		
		/** note on 時点での再生位置 */
		private var _startPosInTick:uint;
		public function get startPosInTick():uint { return _startPosInTick; }
		public function set startPosInTick(startPosInTick:uint):void { this._startPosInTick = startPosInTick; }
		
		/** note off 時点での再生位置 */
		private var _endPosInTick:uint;
		public function get endPosInTick():uint { return _endPosInTick; }
		public function set endPosInTick(endPosInTick:uint):void { this._endPosInTick = endPosInTick; }
		
		/** note の velocity */
		private var _velocity:uint;
		public function get velocity():uint { return _velocity; }
		public function set velocity(velocity:uint):void { this._velocity = velocity; }
		
		/** note on 時点での pitch */
		private var _startPitch:int;
		public function get startPitch():int { return _startPitch; }
		public function set startPitch(startPitch:int):void { this._startPitch = startPitch; }
		
		public function PianoRollItem() {
		}
		
		/**
		 * このメソッドの文字列表現を返す。
		 */
		public function toString():String {
			return StringUtil.substitute("[_startPosInTick={0},\t_endPosInTick={1},\t_velocity={2},\t_startPitch={3}]", _startPosInTick, _endPosInTick, _velocity, _startPitch);
		}
	}

}