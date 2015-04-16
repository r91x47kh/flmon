package net.vt6f3ohw.flmon {
	/**
	 * ...
	 * @author john
	 */
	public class Util {
		
		public function Util() {
		}
		
		/**
		 * インスタンスIDを強引な方法で取得する。
		 * 具体的には、型変換失敗エラーを起こして、エラーメッセージからインスタンスIDを取得する。
		 *
		 * @param	obj
		 * @return インスタンスID
		 * 
		 * @see http://stackoverflow.com/questions/1343282/how-can-i-get-an-instances-memory-location-in-actionscript
		 */
		public static function getInstanceID(obj:Object):String {
			try{
				FakeClass(obj);
			}catch(e:Error){
				return String(e).replace(/.*([@|\$].*?) を .*$/gi, '$1'); // ロケールごとにエラーメッセージのフォーマットが違うので注意
			}
			
			return null;
		}
		
		
		/**
		 * 2次式による out easing。
		 * 
		 * 実引数例:
		 *	time : 1～100
		 *	beginValue : 0
		 *	totalValue : 100
		 *	totalTime : 1
		 * 
		 * @param	time 時間(進行度)
		 * @param	beginValue 開始の値(開始時の座標やスケールなど)
		 * @param	totalValue  開始と終了の値の差分
		 * @param	totalTime Tween(トゥイーン)の合計時間
		 * @return
		 * 
		 * @see イージング処理の計算式 - 強火で進め http://d.hatena.ne.jp/nakamura001/20111117/1321539246
		 */
		public static function easeOut_Quadratic(time:Number, beginValue:Number, totalValue:Number, totalTime:Number):Number {
			time /= totalTime;
			
			return -totalValue * time * (time - 2.0) + beginValue;
		}
		
		/**
		 * 2次式による in-out easing。
		 * 
		 * 実引数例:
		 *	time : 1～100
		 *	beginValue : 0
		 *	totalValue : 100
		 *	totalTime : 1
		 * 
		 * @param	time 時間(進行度)
		 * @param	beginValue 開始の値(開始時の座標やスケールなど)
		 * @param	totalValue  開始と終了の値の差分
		 * @param	totalTime Tween(トゥイーン)の合計時間
		 * @return
		 * 
		 * @see イージング処理の計算式 - 強火で進め http://d.hatena.ne.jp/nakamura001/20111117/1321539246
		 */
		public static function easeInOut_Quadratic(time:Number, beginValue:Number, totalValue:Number, totalTime:Number):Number {
			time /= totalTime / 2.0;
			if (time < 1.0) {
				return totalValue / 2.0 * time * time + beginValue;
			}
			time = time - 1.0;
			
			return -totalValue / 2.0 * (time * (time - 2.0) - 1.0) + beginValue;
		}
		
		/**
		 * 3次式による in-out easing。
		 * 
		 * 実引数例:
		 *	time : 1～100
		 *	beginValue : 0
		 *	totalValue : 100
		 *	totalTime : 1
		 * 
		 * @param	time 時間(進行度)
		 * @param	beginValue 開始の値(開始時の座標やスケールなど)
		 * @param	totalValue  開始と終了の値の差分
		 * @param	totalTime Tween(トゥイーン)の合計時間
		 * @return
		 * 
		 * @see イージング処理の計算式 - 強火で進め http://d.hatena.ne.jp/nakamura001/20111117/1321539246
		 */
		public static function easeInOut_Cubic(time:Number, beginValue:Number, totalValue:Number, totalTime:Number):Number {
			time /= totalTime / 2.0;
			if (time < 1.0) {
				return totalValue / 2.0 * time * time * time + beginValue;
			}
			time = time - 2.0;
			
			return totalValue / 2.0 * (time * time * time + 2.0) + beginValue;
		}
		
		/**
		 * 正弦関数による in-out easing。
		 * 
		 * 実引数例:
		 *	time : 1～100
		 *	beginValue : 0
		 *	totalValue : 100
		 *	totalTime : 1
		 * 
		 * @param	time 時間(進行度)
		 * @param	beginValue 開始の値(開始時の座標やスケールなど)
		 * @param	totalValue  開始と終了の値の差分
		 * @param	totalTime Tween(トゥイーン)の合計時間
		 * @return
		 * 
		 * @see イージング処理の計算式 - 強火で進め http://d.hatena.ne.jp/nakamura001/20111117/1321539246
		 */
		public static function easeInOut_Sinusoidal(time:Number, beginValue:Number, totalValue:Number, totalTime:Number):Number {
			return -totalValue/2.0 * (Math.cos(Math.PI*time/totalTime) - 1.0) + beginValue;
		}
	}
	
}

internal final class FakeClass { }
