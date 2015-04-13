package net.vt6f3ohw.flmon {
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class PianoRoll extends Sprite {
		
		// 定数たち
		/** 1拍あたりの幅 */
		public static var BEAT_WIDTH:uint = 48;
		/** 1半音あたりの高さ */
		public static var SEMITONE_HEIGHT:uint = 12;
		
		// 参照のプールたち
		private var _shape2_ref:Shape;
		public function get shape2_ref():Shape {
			return _shape2_ref;
		}
		
		public function PianoRoll() {
			super();
			
			var i:uint; // for用

			{ // rootSp_PRoll に子Sprite （線）を追加
				var shape2:Shape;
				{
					shape2 = new Shape();
					shape2.cacheAsBitmap = true;
					{ // 1拍ごとに線を引く
						shape2.graphics.lineStyle(0.4, 0xeeeeee);
						for (i = 0 ; i < 400 ; i++ ) {
							shape2.graphics.moveTo(BEAT_WIDTH*i, 0);
							shape2.graphics.lineTo(BEAT_WIDTH*i, SEMITONE_HEIGHT*128);
						}
					}
					{ // 半音ごとに線を引く
						shape2.graphics.lineStyle(0.4, 0xeeeeee);
						for (i = 0 ; i <= 128 ; i++ ) {
							shape2.graphics.moveTo(0, SEMITONE_HEIGHT*i);
							shape2.graphics.lineTo(10000, SEMITONE_HEIGHT*i);
						}
					}
					{ // 1小節ごとに線を引く
						shape2.graphics.lineStyle(3, 0xcccccc);
						for (i = 0 ; i < 100 ; i++ ) {
							shape2.graphics.moveTo((BEAT_WIDTH*4)*i, 0);
							shape2.graphics.lineTo((BEAT_WIDTH*4)*i, SEMITONE_HEIGHT*128);
						}
					}
					{ // C に線を引く
						shape2.graphics.lineStyle(1, 91*0x10000 + 155*0x100 + 213);
						for (i = 0 ; i < 10 ; i++ ) {
							shape2.graphics.moveTo(0, SEMITONE_HEIGHT*(8 + 12*i));
							shape2.graphics.lineTo(10000, SEMITONE_HEIGHT*(8 + 12*i));
						}
					}
				}
				_shape2_ref = shape2; // 参照のプール
				
				this.addChild(shape2);
			}
			
		}
		
	}

}