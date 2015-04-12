package com.txt_nifty.sketch.flmml {
    import flash.events.Event;

	/** 
	 * MML インスタンスや MSequencer インスタンスが dispatch するイベント。
	 * 「実は Event クラスのサブクラスではない MEvent」と異なり、
	 * このクラスは Event クラスのサブクラス。 */
    public class MMLEvent extends Event {
        //public static const SIGNAL:String = 'signal';
		
		/** 再生完了時に MSequencer インスタンスが dispatch するイベント */
        public static const COMPLETE:String = "complete"; 
		
		/** コンパイル完了時に MML インスタンスが dispatch するイベント */
        public static const COMPILE_COMPLETE:String  = 'compileComplete';
		
		/** 波形生成処理が1トラック分終了するごとに MSequencer インスタンスが dispatch するイベント */
        public static const BUFFERING:String = 'buffering';
		
        public var globalTick:uint;
        public var id:int;
        public var progress:int;

        public function MMLEvent(aType:String, aBubbles:Boolean = false, aCancelable:Boolean = false, aGlobalTick:int = 0, aId:int = 0, aProgress:int = 0) {
            super(aType, aBubbles, aCancelable);
            globalTick = aGlobalTick;
            id = aId;
            progress = aProgress;
        }
        public override function clone():Event {
            return new MMLEvent(type, bubbles, cancelable, globalTick, id);
        }
    }
}
