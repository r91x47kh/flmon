package net.vt6f3ohw.flmon {
	
	// Flashで色のRGBやHSV（HSB）変換と管理をする。:しっぽのブログ http://tail.s68.xrea.com/blog/2006/09/flashrgbhsvhsb.html
	// より拝借。
	// （AS2 のコードだったので、一部 AS3 化した）
	
	/*
	 * ColorSet
	 * 
	 * 色の管理と、カラーコード⇔RGB分解⇔HSV分解を自動で行います。
	 * 
	 * HSVは本来はHSB(Brightness)とすべきですが、bがBlueと被るためv(Value)としてあります。
	 * この表記はわりと一部で使用されているもので、WikiPedia等はHSVと表記しています。
	 * HSBとHSVはまったく同じ意味です。
	 * 
	 * HSVの最大値はPhotoShopにあわせて、360、100、100となっています。
	 * RGBはFlashの標準で255、255、255です。
	 * cはRGBを統合したカラーコードですが、整数のみ返す仕様なので、
	 * HSV、RGBに対して小数点以下で誤差が発生することがあります。
	 * 
	 * RGBが入力された時は直ちにHSVを計算せず、HSVが呼び出されるまでズレた状態になります。
	 * これはHSVを使用しない場合に、計算量を抑えるためです。
	 * 
	 * @version	0.9
	 * @author 	しっぽ
	 * 
	 */
	public class ColorSet
	{
		static private var _RGB_MAX:Number = 255;
		static private var _H_MAX:Number = 360;
		static private var _SV_MAX:Number = 100;
		
		private var _r:Number = 255; // 赤色　0～255
		private var _g:Number = 255; // 緑色　0～255
		private var _b:Number = 255; // 青色　0～255
		
		private var _h:Number = 0; // 色相　0～360
		private var _s:Number = 0; // 再度　0～100
		private var _v:Number = 100; // 明度　0～100
		private var _rightnessHSV:Boolean = true; // RGBとHSVが同じ値をとっているかのフラグ。違う場合RGB優先。
		
		public function ColorSet(arg_1:Object = 255, arg_g:Number = 255, arg_b:Number = 255){
			if (arguments.length == 1){ // 値が１つの場合はカラーコードと考える。
				c = arguments[0];
			}else if (arguments.length == 3){ // 3つの値ならRGB
				_r = Number(arguments[0]);
				_g = arguments[1];
				_b = arguments[2];
			}else{ c = 0xffffff;} // 値が無い場合とかは白
			_rightnessHSV = false;
		}
		
		// RGB　普通の変数として使える。
		public function get r():Number{	return _r;}
		public function set r(arg:Number):void{
			_r = Math.min(Math.max(0, arg), _RGB_MAX);
			_rightnessHSV = false;
		}
		public function get g():Number{	return _g;}
		public function set g(arg:Number):void{
			_g = Math.min(Math.max(0, arg), _RGB_MAX);
			_rightnessHSV = false;
		}
		public function get b():Number{	return _b;}
		public function set b(arg:Number):void{
			_b = Math.min(Math.max(0, arg), _RGB_MAX);
			_rightnessHSV = false;
		}
		
		// カラー。　RGBの変動で自動的に変わる。
		public function get c():Number{
			// RGBから統合。四捨五入をするので誤差あり。
			return Math.round(_r)*0x10000 + Math.round(_g)*0x100 + Math.round(_b);
		}
		public function set c(arg_c:Number):void{
			arg_c = Math.min(Math.max(0, arg_c), 0xffffff);
			// RGBに分割。
			_r = Math.floor(arg_c / 0x10000);
			_g = Math.floor(arg_c / 0x100) % 0x100;
			_b = arg_c % 0x100;
			_rightnessHSV = false;
		}
		
		// HSV　呼び出された時にRGBとズレていれば計算し、そうでない場合は保存してある値を返す。
		public function get h():Number{
			if (!_rightnessHSV) calcHSV();
			return _h;
		}
		public function set h(arg:Number):void{
			if (!_rightnessHSV) calcHSV();
			_h = (arg % _H_MAX + _H_MAX) % _H_MAX;
			calcRGB();
		}
		public function get s():Number{
			if (!_rightnessHSV) calcHSV();
			return _s;
		}
		public function set s(arg:Number):void{
			if (!_rightnessHSV) calcHSV();
			_s = Math.min(Math.max(0, arg), _SV_MAX);
			calcRGB();
		}
		public function get v():Number{
			if (!_rightnessHSV) calcHSV();
			return _v;
		}
		public function set v(arg:Number):void{
			if (!_rightnessHSV) calcHSV();
			_v = Math.min(Math.max(0, arg), _SV_MAX);
			calcRGB();
		}
		
		// HSVから入力された時にRGBを計算する。
		private function calcRGB():void{
			if (_s == 0){ // 無彩色
				_r = _g = _b = _v*_RGB_MAX/_SV_MAX;
			}else{
				var hi:Number = Math.floor(_h / (_H_MAX / 6)) % 6;
				var f:Number = _h / (_H_MAX / 6) - hi;
				var p:Number = _v / _SV_MAX * ( 1 - _s / _SV_MAX );
				var q:Number = _v / _SV_MAX * ( 1 - _s / _SV_MAX  * f);
				var t:Number = _v / _SV_MAX * ( 1 - _s / _SV_MAX  * ( 1 - f));
				
				switch (hi) { 
				case 0 : 
					_r = _v/_SV_MAX; _g = t; _b = p;
					break; 
				case 1 : 
					_r = q; _g = _v/_SV_MAX; _b = p;
					break; ;
				case 2 : 
					_r = p; _g = _v/_SV_MAX; _b = t;
					break; 
				case 3 : 
					_r = p; _g = q; _b = _v/_SV_MAX;
					break; 
				case 4 : 
					_r = t; _g = p; _b = _v/_SV_MAX;
					break; 
				case 5 : 
					_r = _v/_SV_MAX; _g = p; _b = q;
					break; 
				}
				_r *= _RGB_MAX;
				_g *= _RGB_MAX;
				_b *= _RGB_MAX;
			}
			_rightnessHSV = true;
		}
		// RGBから入力された時にHSVを計算する。
		private function calcHSV():void{
			var maxRGB:Number = Math.max(_r, Math.max(_g, _b));
			var difference:Number = maxRGB - Math.min(_r, Math.min(_g, _b));
			if (maxRGB == 0){ // 最大値が0。つまり黒。
				_v = 0; // V以外の値は元の値を維持する。
			}else if (difference == 0){ // 全ての色が均一。つまり無彩色
				_v = maxRGB * _SV_MAX / _RGB_MAX;
				_s = 0; // Hは未定義になるため元の値を維持する。
			}else{ // 普通の色。
				_v = maxRGB * _SV_MAX / _RGB_MAX;
				_s = (difference / maxRGB)*_SV_MAX; 
				if (maxRGB == _r) _h = ((_g - _b)/difference + 0)*_H_MAX/6;
				else if (maxRGB == _g) _h = ((_b - _r)/difference + 2)*_H_MAX/6;
				else _h = ((_r - _g)/difference + 4)*_H_MAX/6;
				_h = (_h % _H_MAX + _H_MAX)%_H_MAX;
			}
			_rightnessHSV = true;
		}
		
		// 文字列変換
		public function toString():String{
			if (!_rightnessHSV) calcHSV();
			return "color:" + colorCode + "(" + _r + ", " + _g + "," + _b +")(" + _h + ", " + _s + "," + _v + ")";
		}
		
		// カラーコードを文字列で返す
		public function get colorCode():String{
			var ans:String = c.toString(16);
			var zero:String = "";
			for (var i:int = 0; i < 6 - ans.length; i++) zero += "0";
			return zero + ans;
		}
		
		/*
		 * カラーコードを文字列で入力する。#とか0xとかいうのも消してくれる。
		 * あと、f0aみたいな3文字を、ff00aaと解釈。
		 * fa03のような場合は00fa03と解釈。
		 */
		public function set colorCode(arg:String):void{
			arg = arg.split("#").join("");
			arg = arg.split("0x").join("");
			if (arg.length == 3){
				arg = arg.substr(0, 1) + arg.substr(0, 1)
					+ arg.substr(1, 1) + arg.substr(1, 1)
					+ arg.substr(2, 1) + arg.substr(2, 1);
			}
			c = parseInt(arg, 16);
		}
		
		public static function get RGB_MAX():Number{	return _RGB_MAX;}
		public static function get H_MAX():Number{	return _H_MAX;}
		public static function get SV_MAX():Number{	return _SV_MAX;}

	}
}
