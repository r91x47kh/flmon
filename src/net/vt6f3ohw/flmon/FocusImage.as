package net.vt6f3ohw.flmon
{
	import flash.events.FocusEvent;
	
	import mx.controls.Image;
	import mx.managers.IFocusManagerComponent;
	
	
	// [注]
	// このソースコードファイルの内容は
	// http://www.fxug.net/modules/xhnewbb/viewtopic.php?topic_id=1985
	// の内容を元にしている。
	
	
	/**
	 * フォーカスを受け取るようにしたImageクラス。
	 * (IFocusManagerComponentインターフェースを実装しているのがポイント。)
	 */
	public class FocusImage extends Image implements IFocusManagerComponent
	{
		//==========================================================
		//メソッド
		
		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		//コンストラクタ
		
		/**
		 * コンストラクタです。
		 */
		public function FocusImage()
		{
			//親クラスのコンストラクタを先に呼び出す
			super();
			
			//==========================================================
			//デフォルトプロパティの設定
			
			//基本的にはフォーカスを取得できるようにする
			super.focusEnabled = true;

			//Tabキーによるフォーカス取得を有効にする
			//(TODO: Tabキーによるフォーカス取得が不要な場合はfalseを指定して下さい)
			super.tabEnabled = true
			
			//マウス選択によるフォーカスの取得を有効にする
			//(TODO: マウス選択によるフォーカスの取得が不要な場合はfalseを指定して下さい)
			super.mouseFocusEnabled = true;
			
			
			//==========================================================
			//デフォルトスタイルの設定
			
			//フォーカス枠の太さを変更
			//(TODO: このスタイル設定はあくまでもフォーカスを取得したことをわかりやすくするためなので、不要ならばコメントアウトして下さい)
			//super.setStyle("focusThickness", 5);
			super.setStyle("focusThickness", 0);
		}


		//_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
		//オーバーライトするメソッド

		/**
		 * フォーカスを取得した場合のイベントハンドラ関数です。
		 * 
		 * @param event フォーカスイベントオブジェクト
		 */
		override protected function focusInHandler(event :FocusEvent) :void
		{
			//親クラスの処理を先に呼び出す
			super.focusInHandler(event);
			
			//フォーカスマネージャーが存在する場合
			if(super.focusManager != null)
			{
				//フォーカスインジケータ(フォーカス枠)を描画する
				//(この処理を行わないと、Tabキーによるフォーカス取得以外の場合にフォーカス枠が表示されない)
				super.focusManager.showFocus();
			}
		}
		
	}
}