import unicode

#[  from chibi-scheme lib/chibi/term.scm
(define low-non-spacing-chars '#u8(
#xff #xff #xff #xff #xff #xff #xff #xff #xff #xff #xff #xff #xff #xff    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
#x78    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0 #xfe #xff #xff #xff #xff #xff #x1f    0    0    0    0    0    0    0
   0    0 #x3f    0    0    0    0    0    0 #xf8 #xff #x01    0    0 #x01    0
   0    0    0    0    0    0    0    0    0    0 #xc0 #xff #xff #x3f    0    0
   0    0 #x02    0    0    0 #xff #xff #xff #x07    0    0    0    0    0    0
   0    0    0    0 #xc0 #xff #x01    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
#x06    0    0    0    0    0    0 #x10 #xfe #x21 #x1e    0 #x0c    0    0    0
#x02    0    0    0    0    0    0 #x10 #x1e #x20    0    0 #x0c    0    0    0
#x06    0    0    0    0    0    0 #x10 #xfe #x3f    0    0    0    0 #x03    0
#x06    0    0    0    0    0    0 #x30 #xfe #x21    0    0 #x0c    0    0    0
#x02    0    0    0    0    0    0 #x90 #x0e #x20 #x40    0    0    0    0    0
#x04    0    0    0    0    0    0    0    0 #x20    0    0    0    0    0    0
   0    0    0    0    0    0    0 #xc0 #xc1 #xff #x7f    0    0    0    0    0
   0    0    0    0    0    0    0 #x10 #x40 #x30    0    0    0    0    0    0
   0    0    0    0    0    0    0    0 #x0e #x20    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0 #x04 #x7c    0    0    0    0    0
   0    0    0    0    0    0 #xf2 #x07 #x80 #x7f    0    0    0    0    0    0
   0    0    0    0    0    0 #xf2 #x1f    0 #x3f    0    0    0    0    0    0
   0    0    0 #x03    0    0 #xa0 #x02    0    0    0    0    0    0 #xfe #x7f
#xdf    0 #xff #xff #xff #xff #xff #x1f #x40    0    0    0    0    0    0    0
   0    0    0    0    0 #xe0 #xfd #x02    0    0    0 #x03    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0 #x1c    0    0    0 #x1c    0    0    0 #x0c    0    0    0 #x0c    0
   0    0    0    0    0    0 #x80 #x3f #x40 #xfe #x0f #x20    0    0    0    0
   0 #x38    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0 #x02    0    0    0    0    0    0    0    0    0    0
   0    0    0    0 #x87 #x01 #x04 #x0e    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
   0    0    0    0    0    0    0    0    0    0 #xff #x1f #xe2 #x07))

(define (unicode-char-width c)
  (let ((ci (char->integer c)))
    (cond
      ;; hand-checked ranges from EastAsianWidth.txt
      ((<= #x1100 ci #x115F) 2) ; Hangul
      ((<= #x2E80 ci #x4DB5) 2) ; CJK
      ((<= #x4E00 ci #xA4C6) 2)
      ((<= #xAC00 ci #xD7A3) 2) ; Hangul
      ((<= #xF900 ci #xFAD9) 2) ; CJK compat
      ((<= #xFE10 ci #xFE6B) 2)
      ((<= #xFF01 ci #xFF60) 2)
      ((<= #xFFE0 ci #xFFE6) 2)
      ((<= #x20000 ci #x30000) 2)
      ;; non-spacing mark (Mn) ranges from UnicodeData.txt
      ((<= #x0300 ci #x3029)
       ;; inlined bit-vector-ref for portability
       (let* ((i (- ci #x0300))
              (byte (quotient i 8))
              (off (remainder i 8)))
         (if (zero? (bitwise-and (bytevector-u8-ref low-non-spacing-chars byte)
                                 (arithmetic-shift 1 off)))
             1
             0)))
      ((<= #x302A ci #x302F) 0)
      ((<= #x3099 ci #x309A) 0)
      ((= #xFB1E ci) 0)
      ((<= #xFE00 ci #xFE23) 0)
      ((<= #x1D167 ci #x1D169) 0)
      ((<= #x1D17B ci #x1D182) 0)
      ((<= #x1D185 ci #x1D18B) 0)
      ((<= #x1D1AA ci #x1D1AD) 0)
      ((<= #xE0100 ci #xE01EF) 0)
      (else 1))))
]#

const
  MaxRune* = 6
  lowNonSpacingChars = [0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   0x78,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0x1f,    0,    0,    0,    0,    0,    0,    0,
      0,    0, 0x3f,    0,    0,    0,    0,    0,    0, 0xf8, 0xff, 0x01,    0,    0, 0x01,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 0xc0, 0xff, 0xff, 0x3f,    0,    0,
      0,    0, 0x02,    0,    0,    0, 0xff, 0xff, 0xff, 0x07,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0, 0xc0, 0xff, 0x01,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   0x06,    0,    0,    0,    0,    0,    0, 0x10, 0xfe, 0x21, 0x1e,    0, 0x0c,    0,    0,    0,
   0x02,    0,    0,    0,    0,    0,    0, 0x10, 0x1e, 0x20,    0,    0, 0x0c,    0,    0,    0,
   0x06,    0,    0,    0,    0,    0,    0, 0x10, 0xfe, 0x3f,    0,    0,    0,    0, 0x03,    0,
   0x06,    0,    0,    0,    0,    0,    0, 0x30, 0xfe, 0x21,    0,    0, 0x0c,    0,    0,    0,
   0x02,    0,    0,    0,    0,    0,    0, 0x90, 0x0e, 0x20, 0x40,    0,    0,    0,    0,    0,
   0x04,    0,    0,    0,    0,    0,    0,    0,    0, 0x20,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0, 0xc0, 0xc1, 0xff, 0x7f,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0, 0x10, 0x40, 0x30,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0, 0x0e, 0x20,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0, 0x04, 0x7c,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0, 0xf2, 0x07, 0x80, 0x7f,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0, 0xf2, 0x1f,    0, 0x3f,    0,    0,    0,    0,    0,    0,
      0,    0,    0, 0x03,    0,    0, 0xa0, 0x02,    0,    0,    0,    0,    0,    0, 0xfe, 0x7f,
   0xdf,    0, 0xff, 0xff, 0xff, 0xff, 0xff, 0x1f, 0x40,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0, 0xe0, 0xfd, 0x02,    0,    0,    0, 0x03,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0, 0x1c,    0,    0,    0, 0x1c,    0,    0,    0, 0x0c,    0,    0,    0, 0x0c,    0,
      0,    0,    0,    0,    0,    0, 0x80, 0x3f, 0x40, 0xfe, 0x0f, 0x20,    0,    0,    0,    0,
      0, 0x38,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0, 0x02,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0, 0x87, 0x01, 0x04, 0x0e,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
      0,    0,    0,    0,    0,    0,    0,    0,    0,    0, 0xff, 0x1f, 0xe2, 0x07]

proc unicodeCharWidth*(r: Rune): int {.inline.} =
  let ci = ord(r)
  if ci >= 0x1100 and ci <= 0x115F: return 2     # Hangul
  elif ci >= 0x2E80 and ci <= 0x4D85: return 2     # CJK
  elif ci >= 0x4E00 and ci <= 0xA4C6: return 2
  elif ci >= 0xAC00 and ci <= 0xD7A3: return 2     # Hangul
  elif ci >= 0xF900 and ci <= 0xFAD9: return 2     # CJK compat
  elif ci >= 0xFE10 and ci <= 0xFE6B: return 2
  elif ci >= 0xFF01 and ci <= 0xFF60: return 2
  elif ci >= 0xFFE0 and ci <= 0xFFE6: return 2
  elif ci >= 0x20000 and ci <= 0x30000: return 2
  elif ci >= 0x0300 and ci <= 0x3029:
    let i = ci - 0x0300
    let byte = i div 8
    let off = i mod 8
    if (lowNonSpacingChars[byte] and 1 shr off) == 0:
      return 1
  elif ci >= 0x302A and ci <= 0x302F: return 0
  elif ci >= 0x3099 and ci <= 0x309A: return 0
  elif ci == 0xFB1E: return 0
  elif ci >= 0xFE00 and ci <= 0xFE23: return 0
  elif ci >= 0x1D167 and ci <= 0x1D169: return 0
  elif ci >= 0x1D178 and ci <= 0x1D182: return 0
  elif ci >= 0x1D185 and ci <= 0x1D188: return 0
  elif ci >= 0x1D1AA and ci <= 0x1D1AD: return 0
  elif ci >= 0xE0100 and ci <= 0xE01EF: return 0
  else: return 1

proc runeByteLen*(c: char): int {.inline.} =
  if ord(c) <= 127: return 1
  elif ord(c) shr 5 == 0b110: return 2
  elif ord(c) shr 4 == 0b1110: return 3
  elif ord(c) shr 3 == 0b11110: return 4
  elif ord(c) shr 2 == 0b111110: return 5
  elif ord(c) shr 1 == 0b1111110: return 6
