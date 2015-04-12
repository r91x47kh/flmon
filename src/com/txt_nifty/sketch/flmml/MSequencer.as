package com.txt_nifty.sketch.flmml {
    import __AS3__.vec.Vector;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.SampleDataEvent;
    import flash.events.TimerEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.utils.*;

    public class MSequencer extends EventDispatcher {
        public var onSignal:Function = null;
		/** バッファ1ブロックのサイズ */
        public static const BUFFER_SIZE:int         = 8192;
        public static const RATE44100:int           = 44100;

        protected static const STATUS_STOP:int      = 0;
        protected static const STATUS_PAUSE:int     = 1;
        protected static const STATUS_BUFFERING:int = 2;
        protected static const STATUS_PLAY:int      = 3;
        protected static const STATUS_LAST:int      = 4;
		
        protected static const STEP_NONE:int     = 0;
        protected static const STEP_PRE:int      = 1;
        protected static const STEP_TRACK:int    = 2;
        protected static const STEP_POST:int     = 3;
        protected static const STEP_COMPLETE:int = 4;

        protected var m_sound:Sound;
        protected var m_soundChannel:SoundChannel;
        protected var m_soundTransform:SoundTransform;
		/** 波形生成用バッファ領域。m_buffer[0] と m_buffer[1] の2つがある。
		 * 片方が再生中（オーディオデバイスにデータ送信中）の時、もう片方は波形生成中となる。 */
        protected var m_buffer:Vector.<Vector.<Number>>;
		/** 現在 m_buffer[0] と m_buffer[1] のどちらが再生中（オーディオデバイスにデータ送信中）なのか */
        protected var m_playSide:int;
        protected var m_playSize:int;
        protected var m_step:int;
		
		/** 現在波形生成対象のトラック */
        protected var m_processTrack:int;
		/** 現在何サンプル目まで処理できているか */
        protected var m_processOffset:int;
		/** 現在オーディオデバイスのバッファへの波形コピーが実行中かどうか */
        protected var m_output:Boolean; //! 現在バッファ書き込み中かどうか
        protected var m_trackArr:Array;
        protected var m_signalArr:Array;
        protected var m_signalPtr:int;
        protected var m_globalTick:uint;
        protected var m_status:int;
        protected var m_signalInterval:int;
        protected var m_stopTimer:Timer; //! 停止処理キック用のタイマー
        protected var m_buffTimer:Timer; //! 一時停止＆バッファリング処理キック用のタイマー
        protected var m_procTimer:Timer; //! バッファ書き込み処理キック用のタイマー
		/** 一度に何ブロックのバッファ構築を行うか */
        protected var m_multiple:int;
        protected var m_startTime:uint;
		/** ポーズした時点での再生位置（再生位置の原点は getTimer() と同じくAVM2起動時刻）。単位は sample ではなく ms。 */
        protected var m_pausedPos:Number;
        protected var m_restTimer:Timer;
        protected var m_debugDate:Date;

		/**
		 * MSequencerインスタンスを作成する。
		 * 
		 * @param	multiple 一度に何ブロックのバッファ構築を行うかを指定する。デフォルトは32ブロック。
		 */
        public function MSequencer(multiple:int = 32) {
            m_multiple = multiple;
            m_output = false;
            MChannel.boot(MSequencer.BUFFER_SIZE * m_multiple);
            MOscillator.boot();
            MEnvelope.boot();
            m_trackArr = new Array();
            m_signalArr = new Array(3);
            for(var i:int = 0; i < m_signalArr.length; i++) {
                m_signalArr[i] = new MSignal(i);
                m_signalArr[i].setFunction(onSignalHandler);
            }
            m_signalPtr = 0;
            m_buffer = new Vector.<Vector.<Number>>(2);
            m_buffer.fixed = true;
            m_buffer[0] = new Vector.<Number>(MSequencer.BUFFER_SIZE * m_multiple * 2); // * 2 stereo
            m_buffer[0].fixed = true;
            m_buffer[1] = new Vector.<Number>(MSequencer.BUFFER_SIZE * m_multiple * 2); //
            m_buffer[1].fixed = true;
            m_playSide = 1;
            m_playSize = 0;
            m_step = STEP_NONE;
            m_sound = new Sound();
            m_soundChannel = new SoundChannel();
            m_soundTransform = new SoundTransform();
            m_pausedPos = 0;
            setMasterVolume(100);
            m_signalInterval = 96;
            stop();
            m_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
            m_restTimer = null;
        }

        public function play():void {
            if (m_status != STATUS_PAUSE) { // ポーズ中じゃなかったら新規に再生を開始
                stop(); // stop 内でタイマーを初期化しているので、stop は絶対に呼ばないとダメ
                m_globalTick = 0;
                for (var i:int = 0; i < m_trackArr.length; i++) {
                    m_trackArr[i].seekTop();
                }
                m_status = STATUS_BUFFERING;
                processStart();
            }
            else { // ポーズ中だったら再生をレジューム
                m_status = STATUS_PLAY;
                m_soundChannel = m_sound.play(m_pausedPos);
                m_startTime = getTimer(); // 再生開始時刻を記録
                var totl:uint = getTotalMSec();
                var rest:uint = (totl > m_pausedPos) ? (totl - m_pausedPos) : 0;
                m_restTimer = new Timer(rest, 1);
                m_restTimer.addEventListener(TimerEvent.TIMER, onStopReq);
                m_restTimer.start();
            }
            m_debugDate = new Date();
        }

		/**
		 * 再生を停止する。また、タイマーを初期化する。
		 */
        public function stop():void {
            m_stopTimer = new Timer(0, 1); // 0 ms 待ち、1回だけ実行
            m_stopTimer.addEventListener(TimerEvent.TIMER, onStopReq);
            m_buffTimer = new Timer(0, 1); // 0 ms 待ち、1回だけ実行
            m_buffTimer.addEventListener(TimerEvent.TIMER, onBufferingReq);
            m_procTimer = new Timer(2, 1); // 2 ms 待ち、1回だけ実行
            m_procTimer.addEventListener(TimerEvent.TIMER_COMPLETE, processAll);
            if (m_restTimer) m_restTimer.stop();
            if (m_soundChannel) m_soundChannel.stop();
            m_status = STATUS_STOP;
            m_pausedPos = 0;
        }

        public function pause():void {
            if (m_restTimer) m_restTimer.stop();
            if (m_soundChannel) m_soundChannel.stop();
            m_pausedPos = getNowMSec();
            m_status = STATUS_PAUSE;
        }

        public function setMasterVolume(vol:int):void {
            m_soundTransform.volume = vol * (1.0 / 127.0);
            SoundMixer.soundTransform = m_soundTransform;
        }

        public function isPlaying():Boolean {
            return (m_status > STATUS_PAUSE);
        }

        public function isPaused():Boolean {
            return (m_status == STATUS_PAUSE);
        }

        public function disconnectAll():void {
            while(m_trackArr.pop()) { }
            m_status = STATUS_STOP;
        }

		/** 渡された MTrack インスタンスのm_signalInterval をこのインスタンスの m_signalInterval で上書きした上で、
		 * このインスタンスに MTrack インスタンスへの参照を持たせる */
        public function connect(track:MTrack):void {
            track.m_signalInterval = m_signalInterval;
            m_trackArr.push(track);
        }

        public function getGlobalTick():uint {
            return m_globalTick;
        }

        public function setSignalInterval(interval:int):void {
            m_signalInterval = interval;
        }

        protected function onSignalHandler(globalTick:uint, event:int):void {
            m_globalTick = globalTick;
            if (onSignal != null) onSignal(globalTick, event);
        }

        private function reqStop():void {
            m_stopTimer.start();
        }
        private function onStopReq(e:Event):void {
            stop();
            dispatchEvent(new MMLEvent(MMLEvent.COMPLETE));
        }
		/**
		 * バッファが完成していないにもかかわらず SampleDataEvent.SAMPLE_DATA が発動してしまった時のためのメソッド
		 */
        private function reqBuffering():void {
            //trace("reqBf");
            m_buffTimer.start();
        }
		/**
		 * reqBuffering() によって start した m_buffTimer が呼ぶ、イベントハンドラ
		 * @param	e
		 */
        private function onBufferingReq(e:Event):void {
            pause();
            m_status = STATUS_BUFFERING;
        }

        //! バッファ書き込みリクエスト
		/** m_procTimer（時間を置いて processAll を呼び出すタイマー）を start して、かつ STEP_PRE に遷移させる。 */
        private function processStart():void {
            m_step = STEP_PRE;
            m_processOffset = 0; // processAll 内の case STEP_PRE: でどのみち m_processOffset = 0; されるので不要。なぜある？
            m_procTimer.start();
        }
        //! 実際のバッファ書き込み
        // UIのフリーズを避けるため、数ステップに分けて処理を行う
        private function processAll(e:Event):void {
            var entireLen:int = MSequencer.BUFFER_SIZE * m_multiple;
			
			/** 一度に何ブロック処理するか */
            var stepLen:int = MSequencer.BUFFER_SIZE * 4;
			
            if (stepLen > entireLen) stepLen = entireLen; // m_multiple が小さい場合への対処
			
            var m_trackArrLength:int = m_trackArr.length;
            var i:int;
            var buffer:Vector.<Number> = m_buffer[1 - m_playSide]; // 再生中じゃない方のバッファに書き込み
			
			/** 波形生成処理に要している時間を測るための変数 */
            var beginProcTime:Number = (new Date()).getTime();
			
            switch(m_step) {
            case STEP_PRE:
                if (m_output) { // 別コルーチンでバッファ書き込み処理（onSampleData）が走っている場合はしばらく待つ
                    //trace("pro1");
                    m_procTimer.start();
                    return;
                }
                for (i = entireLen * 2 - 1; i >= 0; i--) { // バッファを0埋め
                    buffer[i] = 0.0;
                }
                if (m_trackArrLength > 0) {
                    var track:MTrack = m_trackArr[MTrack.TEMPO_TRACK];
                    track.onSampleData(buffer, 0, entireLen, m_signalArr[m_signalPtr]); // まずテンポトラックに onSampleData
                }
                m_processTrack = MTrack.FIRST_TRACK; // 最初のトラックから波形生成を始める
                m_processOffset = 0;
                m_step = STEP_TRACK; // STEP_TRACK へ遷移
                m_procTimer.start(); // 少し待ってからまた processAll を実行（関数の先頭に戻る）
                break;
            case STEP_TRACK:
                if (m_output) { // 別コルーチンでバッファ書き込み処理（onSampleData）が走っている場合はしばらく待つ
                    //trace("pro2");
                    m_procTimer.start();
                    return;
                }
                do {
                    if (m_processTrack >= m_trackArrLength) { // 全てのトラックを処理し終えていたら STEP_POST へ遷移
                        m_step = STEP_POST; // STEP_POST へ遷移
                        break;
                    } else { // まだ処理していないトラックがあったらそのトラックを処理
						// stepLen サンプルずつ処理
                        m_trackArr[m_processTrack].onSampleData(buffer, m_processOffset, m_processOffset + stepLen);
                        m_processOffset += stepLen;
                        if (m_processOffset >= entireLen) { // バッファいっぱいまで波形生成処理が終わったら次のトラックへ
                            m_processTrack++;
                            m_processOffset = 0;
                            if (m_status == STATUS_BUFFERING) { // 1トラックの波形生成処理が終わるごとにバッファリング状況を dispatch
                                dispatchEvent(new MMLEvent(MMLEvent.BUFFERING, false, false, 0, 0, (m_processTrack+1) * 100 / (m_trackArrLength+1)));
                            }
                        }
                    }
                } while(beginProcTime + 5 >= (new Date()).getTime()); // 5msくらいはキックせず連続で処理をする
                m_procTimer.start(); // 少し待ってからまた processAll を実行（関数の先頭に戻る）
                break;
            case STEP_POST:
                m_step = STEP_COMPLETE; // STEP_COMPLETE へ遷移
                if (m_status == STATUS_BUFFERING) {
                    var date:Date = new Date();
                    //trace((date.getTime() - m_debugDate.getTime()) + "msec.");
                    m_status = STATUS_PLAY; // STATUS_BUFFERING から STATUS_PLAY に遷移
                    m_playSide = 1 - m_playSide;
                    m_playSize = 0;
                    processStart(); // STEP_PRE に遷移
                    m_soundChannel = m_sound.play(); // Sound インスタンスに SampleDataEvent.SAMPLE_DATA の dispatch を促す
                    //trace("play");
                    m_startTime = getTimer(); // 再生開始時刻を記録
					
                    var totl:uint = getTotalMSec();
                    var rest:uint = (totl > m_pausedPos) ? (totl - m_pausedPos) : 0;
					
                    m_restTimer = new Timer(rest, 1); // ここに到達するたびに停止用タイマーが new されるので、タイマーが増殖する可能性あり？
                    m_restTimer.addEventListener(TimerEvent.TIMER, onStopReq);
                    m_restTimer.start();
                }
                break;
            default:
                break;
            }
        }

        //!
        private function onSampleData(e:SampleDataEvent):void {
            var latency:Number = e.position / 44.1 - m_soundChannel.position;
            //trace((e.position / 44.1) + "-" + (m_soundChannel.position) + "="+latency);
            
            m_output = true;
            if (m_playSize >= m_multiple) {
                // バッファ完成済みの場合
                if (m_step == STEP_COMPLETE) {
                    m_playSide = 1 - m_playSide;
                    m_playSize = 0;
                    processStart();
                }
                // バッファが未完成の場合
                else {
                    m_output = false;
                    reqBuffering();
                    return;
                }
                if (m_status == STATUS_LAST) { // 再生がもう終わっている場合
                    m_output = false;
                    //reqStop(); stopはrestTimerに任せる
                    return;
                }
                else if (m_status == STATUS_PLAY) {
                    if (m_trackArr[MTrack.TEMPO_TRACK].isEnd()) {
                        m_status = STATUS_LAST;
                    }
                }
            }
			
            var buffer:Vector.<Number> = m_buffer[m_playSide];
			
			// ブロックオフセット
            var base:int = (BUFFER_SIZE * m_playSize) * 2;
			// 1ブロックずつオーディオデバイスに送信
            var i:int, len:int = BUFFER_SIZE << 1; // BUFFER_SIZE * 2 と等価
            for(i = 0; i < len; i++) {
                e.data.writeFloat(buffer[base + i]); // ここで初めてオーディオデバイス上のバッファへの書き込みが行われる
            }
            m_playSize++; // 次のブロックへ
			
            //m_signalArr[(m_signalPtr + m_signalArr.length-1) % m_signalArr.length].start();
            m_signalPtr = (++m_signalPtr) % m_signalArr.length;
            m_output = false;
        }
        public function createPipes(num:int):void {
            MChannel.createPipes(num);
        }
        public function createSyncSources(num:int):void {
        	MChannel.createSyncSources(num);
        }
		/** 総再生時間を取得する。単位は ms。 */
        public function getTotalMSec():uint {
            return m_trackArr[MTrack.TEMPO_TRACK].getTotalMSec();
        }
		/** 現在の再生位置を取得する。単位は ms。 */
        public function getNowMSec():uint {
            var now:uint = 0;
            var tot:uint = getTotalMSec();
            switch (m_status) {
                case STATUS_PLAY:
                case STATUS_LAST: // STATUS_PLAY の時もここの処理は行われるので注意（なぜなら、case STATUS_PLAY: の後に break; がないので）
					// 前回の（←ここ重要）ポーズ位置を元に現在の再生位置を計算する。
					// なぜこのような面倒なことをしているかというと、
					// m_startTime は名前に反してポーズ状態からレジュームされるごとに上書きされるから（つまり m_resumeTime 的な意味もある）。
					now = m_pausedPos + (getTimer() - m_startTime);
					return (now < tot) ? now : tot; // getTotalMSec() の値を超えないようクリッピング
                default:
					return m_pausedPos;
            }
            return 0;
        }
        public function getNowTimeStr():String {
            var sec:int = Math.ceil(Number(getNowMSec()) / 1000);
            var smin:String = "0" + int(sec / 60);
            var ssec:String = "0" + (sec % 60);
            return smin.substr(smin.length-2, 2) + ":" + ssec.substr(ssec.length-2, 2);
        }
    }
}
