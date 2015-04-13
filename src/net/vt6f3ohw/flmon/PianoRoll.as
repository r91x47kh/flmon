package net.vt6f3ohw.flmon {
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class PianoRoll extends Sprite {
		
		// 定数たち
		/** 1拍あたりの幅 */
		public static var BEAT_WIDTH:uint = 48;
		/** 1半音あたりの高さ */
		public static var SEMITONE_HEIGHT:uint = 12;
		/** ピアノロールの高さ */
		public static var PIANOROLL_HEIGHT:uint = SEMITONE_HEIGHT*128; // TODO: MChannel@FlMMLエンジン の frequencyMap の要素数に応じてこの値が動的に変わるようにする
		
		// 参照のプールたち
		private var _shape2_ref:Shape;
		public function get shape2_ref():Shape {
			return _shape2_ref;
		}
		/** ノート(= PianoRollItem)レイヤ */
		private var _itemLayer_ref:Shape;
		public function get itemLayer_ref():Shape {
			return _itemLayer_ref;
		}
		
		public function PianoRoll() {
			super();
			
			var i:uint; // for用

			this.opaqueBackground = true; // 背景を不透明に設定
			this.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
			{ // 背景矩形を描画
				this.graphics.beginFill(0xffffff);
				this.graphics.drawRect(0, 0, (PianoRoll.BEAT_WIDTH*4)*100, PianoRoll.SEMITONE_HEIGHT*128);
				this.graphics.endFill();
			}
			{ // 子Shape （線レイヤ）を追加
				var shape2:Shape;
				{
					shape2 = new Shape();
					shape2.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
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
			{ // 子Shape （ノート(= PianoRollItem)レイヤ）を追加
				var itemLayer:Shape;
				{
					itemLayer = new Shape();
					itemLayer.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
				}
				_itemLayer_ref = itemLayer; // 参照のプール
				
				this.addChild(itemLayer);
			}
			
		}
		
	}

}