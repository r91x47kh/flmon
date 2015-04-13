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
		
	}
	
}

internal final class FakeClass { }
