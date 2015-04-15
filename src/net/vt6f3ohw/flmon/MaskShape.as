package net.vt6f3ohw.flmon {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	
	/**
	 * mx:Image から描画がはみ出すのを防止するための Shape。
	 */
	public class MaskShape extends Shape {
		
		private var self:MaskShape;
		
		/**
		 * @param	parent サイズいっぱいにマスクを設定したい親DisplayObject
		 */
		public function MaskShape(parent:DisplayObject) {
			self = this;
			
			this.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, parent.width, parent.height);
			this.graphics.endFill();
			parent.addEventListener(Event.RESIZE, function(e:Event):void {
				{ // 親DisplayObjectのサイズ変化に応じてマスク矩形のサイズを更新
					self.graphics.clear();
					self.graphics.beginFill(0x000000);
					self.graphics.drawRect(0, 0, parent.width, parent.height);
					self.graphics.endFill();
				}
			});
		}
		
	}

}