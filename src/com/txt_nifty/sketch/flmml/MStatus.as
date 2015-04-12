package com.txt_nifty.sketch.flmml {
	/** MEvent の種類を定義したクラス */
    public final class MStatus {
        public static const EOT:int           = 0;
        public static const NOP:int           = 1;
        public static const NOTE_ON:int       = 2;
        public static const NOTE_OFF:int      = 3;
        public static const TEMPO:int         = 4;
        public static const VOLUME:int        = 5;
        public static const NOTE:int          = 6;
        public static const FORM:int          = 7;
        public static const ENVELOPE1_ATK:int = 8;
        public static const ENVELOPE1_ADD:int = 9;
        public static const ENVELOPE1_REL:int = 10;
        public static const NOISE_FREQ:int    = 11;
        public static const PWM:int           = 12;
        public static const PAN:int           = 13;
        public static const FORMANT:int       = 14;
        public static const DETUNE:int        = 15;
        public static const LFO_FMSF:int      = 16;
        public static const LFO_DPWD:int      = 17;
        public static const LFO_DLTM:int      = 18;
        public static const LFO_TARGET:int    = 19;
        public static const LPF_SWTAMT:int    = 20;
        public static const LPF_FRQRES:int    = 21;
        public static const CLOSE:int         = 22;
        public static const VOL_MODE:int      = 23;
        public static const ENVELOPE2_ATK:int = 24;
        public static const ENVELOPE2_ADD:int = 25;
        public static const ENVELOPE2_REL:int = 26;
        public static const INPUT:int         = 27;
        public static const OUTPUT:int        = 28;
        public static const EXPRESSION:int    = 29;
        public static const RINGMODULATE:int  = 30;
        public static const SYNC:int          = 31;
		public static const PORTAMENTO:int    = 32;
		public static const MIDIPORT:int      = 33;
		public static const MIDIPORTRATE:int  = 34;
		public static const BASENOTE:int      = 35;
		public static const POLY:int		  = 36;
		public static const SOUND_OFF:int	  = 37;
		public static const RESET_ALL:int	  = 38;
		public static const HW_LFO:int        = 39;
		
		/**
		 * status ID を文字列「status 名(status ID)」に変換する。
		 * 
		 * @param	statusId status ID
		 * @return status 名
		 */
		public static function getStatusName(statusId:int):String {
			switch(statusId) {
				case EOT: return "EOT(0)";
				case NOP: return "NOP(1)";
				case NOTE_ON: return "NOTE_ON(2)";
				case NOTE_OFF: return "NOTE_OFF(3)";
				case TEMPO: return "TEMPO(4)";
				case VOLUME: return "VOLUME(5)";
				case NOTE: return "NOTE(6)";
				case FORM: return "FORM(7)";
				case ENVELOPE1_ATK: return "ENVELOPE1_ATK(8)";
				case ENVELOPE1_ADD: return "ENVELOPE1_ADD(9)";
				case ENVELOPE1_REL: return "ENVELOPE1_REL(10)";
				case NOISE_FREQ: return "NOISE_FREQ(11)";
				case PWM: return "PWM(12)";
				case PAN: return "PAN(13)";
				case FORMANT: return "FORMANT(14)";
				case DETUNE: return "DETUNE(15)";
				case LFO_FMSF: return "LFO_FMSF(16)";
				case LFO_DPWD: return "LFO_DPWD(17)";
				case LFO_DLTM: return "LFO_DLTM(18)";
				case LFO_TARGET: return "LFO_TARGET(19)";
				case LPF_SWTAMT: return "LPF_SWTAMT(20)";
				case LPF_FRQRES: return "LPF_FRQRES(21)";
				case CLOSE: return "CLOSE(22)";
				case VOL_MODE: return "VOL_MODE(23)";
				case ENVELOPE2_ATK: return "ENVELOPE2_ATK(24)";
				case ENVELOPE2_ADD: return "ENVELOPE2_ADD(25)";
				case ENVELOPE2_REL: return "ENVELOPE2_REL(26)";
				case INPUT: return "INPUT(27)";
				case OUTPUT: return "OUTPUT(28)";
				case EXPRESSION: return "EXPRESSION(29)";
				case RINGMODULATE: return "RINGMODULATE(30)";
				case SYNC: return "SYNC(31)";
				case PORTAMENTO: return "PORTAMENTO(32)";
				case MIDIPORT: return "MIDIPORT(33)";
				case MIDIPORTRATE: return "MIDIPORTRATE(34)";
				case BASENOTE: return "BASENOTE(35)";
				case POLY: return "POLY(36)";
				case SOUND_OFF: return "SOUND_OFF(37)";
				case RESET_ALL: return "RESET_ALL(38)";
				case HW_LFO: return "HW_LFO(39)";
				default: return "unknown status";
			}
		}
    }
}
