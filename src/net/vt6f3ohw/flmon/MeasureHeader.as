package net.vt6f3ohw.flmon {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class MeasureHeader extends Sprite {
		
		/** 小節番号表示ヘッダの縦幅 */
		private static var HEADER_HEIGHT:Number = 48.0;
		
		public function MeasureHeader() {
			super();
			
			var i:int; // for用
			
			this.opaqueBackground = true; // 背景を不透明に設定
			this.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
			{ // 前景レイヤを追加
				var shape:Shape;
				{
					shape = new Shape();
					shape.opaqueBackground = true;
					shape.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
					{ // 矩形を描画
						shape.graphics.beginFill(0xbdd7ee);
						shape.graphics.lineStyle(0);
						for (i = 0 ; i < 100 ; i++) {
							shape.graphics.drawRect((PianoRoll.BEAT_WIDTH*4)*i, 0, PianoRoll.BEAT_WIDTH*4, HEADER_HEIGHT);
						}
						shape.graphics.endFill();
					}
					{ // 1小節ごとに線を引く
						shape.graphics.lineStyle(3, 0x999999);
						for (i = 0 ; i < 100 ; i++) {
							shape.graphics.moveTo((PianoRoll.BEAT_WIDTH*4)*i, 0);
							shape.graphics.lineTo((PianoRoll.BEAT_WIDTH*4)*i, HEADER_HEIGHT);
						}
					}
				}
				
				this.addChild(shape);
			}
			{ // 文字列（小節番号）を配置
				var format:TextFormat;
				{
					format = new TextFormat();
					format.size = 18;
					format.align = TextFormatAlign.LEFT;
					format.font = "Arial";
					format.color = 0x333333;
				}
				
				var textField:TextField;
				for (i = 0 ; i < 100 ; i++) {
					{ // TextFieldインスタンスを生成してadd
						{
							textField = new TextField();
							textField.x = (PianoRoll.BEAT_WIDTH*4)*i + /*微調整*/8;
							textField.y = 12;
							textField.width = (PianoRoll.BEAT_WIDTH*4);
							textField.height = HEADER_HEIGHT;
							textField.selectable = false;
							textField.defaultTextFormat = format;
							textField.text = (i+1).toString();
						}
						
						this.addChild(textField);
					}
				}
			}
			{ // 左端と右端に線を配置
				var shape2:Shape;
				{
					shape2 = new Shape();
					shape2.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
					{
						shape2.graphics.lineStyle(1, 0x7f7f7f);
						shape2.graphics.moveTo(0, 0);
						shape2.graphics.lineTo((PianoRoll.BEAT_WIDTH*4)*100, 0);
						shape2.graphics.moveTo(0, HEADER_HEIGHT-1);
						shape2.graphics.lineTo((PianoRoll.BEAT_WIDTH*4)*100, HEADER_HEIGHT-1);
					}
				}
				
				this.addChild(shape2);
			}
		}
		
	}

}