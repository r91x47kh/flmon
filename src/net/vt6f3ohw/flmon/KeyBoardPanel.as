package net.vt6f3ohw.flmon {
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class KeyBoardPanel extends Sprite {
		
		/** 鍵盤表示部の幅 */
		private static var PANEL_WIDTH:Number = 120.0;
		
		public function KeyBoardPanel() {
			super();
			
			var i:int; // for用
			
			this.opaqueBackground = true; // 背景を不透明に設定
			this.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
			{ // 鍵盤レイヤを追加
				var shape:Shape;
				{
					shape = new Shape();
					shape.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
					{ // 鍵盤を配置
						for (i = 128 ; i >= 0 ; i--) { // i が int ではなく uint だと無限ループするので注意
							switch(i % 12){
								case 0: // c
									shape.graphics.beginFill(0xbdd7ee);
									break;
								case 2: // 白鍵
								case 4:
								case 5:
								case 7:
								case 9:
								case 11:
									shape.graphics.beginFill(0xffffff);
									break;
								case 1: // 黒鍵
								case 3:
								case 6:
								case 8:
								case 10:
									shape.graphics.beginFill(0xd8d8d8);
									break;
							}
							shape.graphics.lineStyle(1, 0x7f7f7f);
							shape.graphics.drawRect(0, -(PianoRoll.SEMITONE_HEIGHT / 2.0) + PianoRoll.SEMITONE_HEIGHT * (128 - i), PANEL_WIDTH, PianoRoll.SEMITONE_HEIGHT);
							shape.graphics.endFill();
						}
					}
				}
				
				this.addChild(shape);
			}
			{ // 左端と右端に線を配置
				var shape2:Shape;
				{
					shape2 = new Shape();
					shape2.cacheAsBitmap = true; // 描画結果（＝ビットマップ）をキャッシュして高速化
					{
						shape2.graphics.lineStyle(1, 0x7f7f7f);
						shape2.graphics.moveTo(1, 0);
						shape2.graphics.lineTo(1, PianoRoll.PIANOROLL_HEIGHT);
						shape2.graphics.moveTo(PANEL_WIDTH-1, 0);
						shape2.graphics.lineTo(PANEL_WIDTH-1, PianoRoll.PIANOROLL_HEIGHT);
					}
				}
				
				this.addChild(shape2);
			}
			{ // 文字列を配置
				var format:TextFormat;
				{
					format = new TextFormat();
					format.size = 12;
					format.align = TextFormatAlign.RIGHT;
					format.font = "Arial";
				}
				
				var textField:TextField;
				for (i = 128 ; i >= 0 ; i--) { // i が int ではなく uint だと無限ループするので注意
					if (i == 69) { // o5a は特別
						{ // TextFieldインスタンスを生成してadd
							{
								textField = new TextField();
								textField.x = 0;
								textField.y = -(PianoRoll.SEMITONE_HEIGHT / 2.0) + PianoRoll.SEMITONE_HEIGHT * (128 - i)
								- 3; // 微調整
								textField.width = PANEL_WIDTH;
								textField.height = PianoRoll.SEMITONE_HEIGHT * 2.0;
								textField.selectable = false;
								textField.defaultTextFormat = format;
								textField.text = "440 Hz = o5a";
							}
							
							this.addChild(textField);
						}
						continue;
					}
					
					switch(i % 12){
						case 0: // c
							{ // TextFieldインスタンスを生成してadd
								{
									textField = new TextField();
									textField.x = 0;
									textField.y = -(PianoRoll.SEMITONE_HEIGHT / 2.0) + PianoRoll.SEMITONE_HEIGHT * (128 - i)
									- 3; // 微調整
									textField.width = PANEL_WIDTH;
									textField.height = PianoRoll.SEMITONE_HEIGHT * 2.0;
									textField.selectable = false;
									textField.defaultTextFormat = format;
									textField.text = "o" + (i/12) + "c";
								}
								
								this.addChild(textField);
							}
							break;
						case 2: // 白鍵
						case 4:
						case 5:
						case 7:
						case 9:
						case 11:
							break;
						case 1: // 黒鍵
						case 3:
						case 6:
						case 8:
						case 10:
							break;
					}
				}
			}
		}
		
	}

}