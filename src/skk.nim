import tables, terminal, unicode, encodings, strutils, strtabs, sequtils, os
import skkazik, skkjisyo
import utf8utils as utf8
import log
export jisyook

when defined(openbsd):
  {.passL:"-liconv".}

when defined(testing):
  const DEBUG = true
else:
  const DEBUG = false
  
const Module = "skk"

const
  Kutouten = {',', '.'}     # {',', '。'} or {'、', '。'}
  ZeneiTbl = {' ': "　",
              '!': "！",
              '"': "”",
              '#': "＃",
              '$': "＄",
              '%': "％",
              '&': "＆",
              '\'': "’",
              '(': "（",
              ')': "）",
              '*': "＊",
              '+': "＋",
              ',': "、",
              '-': "ー",
              '.': "。",
              '/': "／",
              '0': "０",
              '1': "１",
              '2': "２",
              '3': "３",
              '4': "４",
              '5': "５",
              '6': "６",
              '7': "７",
              '8': "８",
              '9': "９",
              ':': "：",
              ';': "；",
              '<': "＜",
              '=': "＝",
              '>': "＞",
              '?': "？",
              '@': "＠",
              'A': "Ａ",
              'B': "Ｂ",
              'C': "Ｃ",
              'D': "Ｄ",
              'E': "Ｅ",
              'F': "Ｆ",
              'G': "Ｇ",
              'H': "Ｈ",
              'I': "Ｉ",
              'J': "Ｊ",
              'K': "Ｋ",
              'L': "Ｌ",
              'M': "Ｍ",
              'N': "Ｎ",
              'O': "Ｏ",
              'P': "Ｐ",
              'Q': "Ｑ",
              'R': "Ｒ",
              'S': "Ｓ",
              'T': "Ｔ",
              'U': "Ｕ",
              'V': "Ｖ",
              'W': "Ｗ",
              'X': "Ｘ",
              'Y': "Ｙ",
              'Z': "Ｚ",
              '[': "［",
              '\\': "＼",
              ']': "］",
              '^': "＾",
              '_': "＿",
              '`': "‘",
              'a': "ａ",
              'b': "ｂ",
              'c': "ｃ",
              'd': "ｄ",
              'e': "ｅ",
              'f': "ｆ",
              'g': "ｇ",
              'h': "ｈ",
              'i': "ｉ",
              'j': "ｊ",
              'k': "ｋ",
              'l': "ｌ",
              'm': "ｍ",
              'n': "ｎ",
              'o': "ｏ",
              'p': "ｐ",
              'q': "ｑ",
              'r': "ｒ",
              's': "ｓ",
              't': "ｔ",
              'u': "ｕ",
              'v': "ｖ",
              'w': "ｗ",
              'x': "ｘ",
              'y': "ｙ",
              'z': "ｚ",
              '{': "｛",
              '|': "｜",
              '}': "｝",
              '~': "〜"}.totable
  SkkJisyoEncoding = "EUC-JP"
  OutputEncoding = "UTF-8"
  MaxShowKohoEach = 5
  #SelectStr = "ASDFJKL"
  AsciiMode = "[a]"
  HiraMode = "[あ]"
  KataMode = "[ア]"
  ZeneiMode = "[Ａ]"
  HenkanMode = "[変]"
  KohoMode = "[候]"
  #JisyoMode = "[辞]"

type
  SkkMode = enum Ascii, Hira, Kata, Zenei, Henkan, Koho      #, Jisyo

var skkbuf = newSeq[Rune]()   # yomi for Henkan
var henkanp = 0               # cursor position of henkan start
var skkmode* = Hira     # Ascii
var prevmode: SkkMode

var eucToUtf: EncodingConverter
var utfToEuc: EncodingConverter
#var jisyook = false

proc displayMode*(redraw = -1): int =
  result = 4
  if redraw != -1:
    stdout.setCursorXPos(redraw)
  case skkmode
  of Ascii:
    result = 3
    stdout.write(AsciiMode)
  of Hira:
    if jisyook: writeStyled(HiraMode, {styleBright})
    else:stdout.write(HiraMode)
  of Kata:
    if jisyook: writeStyled(KataMode, {styleBright})
    else: stdout.write(KataMode)
  of Zenei: stdout.write(ZeneiMode)
  of Henkan: stdout.write(HenkanMode)
  of Koho: stdout.write(KohoMode)
  #of Jisyo: stdout.write(JisyoMode)
  else: discard
  
proc setSkkMode*(c: char) =
  case c
  of '\n':
    if skkmode == Ascii or skkmode == Zenei: skkmode = Hira
  of '@':
    if skkmode == Hira: skkmode = Kata
    elif skkmode == Kata: skkmode = Hira
  of '*':
    if skkmode == Hira or skkmode == Kata: skkmode = Ascii
  of 'L':
    if skkmode == Hira or skkmode == Kata: skkmode = Zenei
  else: discard
  #when DEBUG: echo "setSkkMode: skkmode => ", skkmode

proc getKana(s: string, kana: var seq[Rune]): bool =
  result = true
  case skkmode:
  of Ascii:
    kana.add(toRunes(s))
  of Hira, Kata:
    if haskey(skkazik.AzikTbl, s):
      let (h, k) = skkazik.AzikTbl[s]
      #when DEBUG: echo "getkana: enter haskey skkmode => ", skkmode
      if skkmode == Hira: kana.add(toRunes(h))
      elif skkmode == Kata: kana.add(toRunes(k))
    else: result = false
  of Zenei:
    kana.add(toRunes(ZeneiTbl[s[0]]))
  else: result = false
  
proc showKoho(c: char): tuple[kanji: seq[Rune], okuri: string]

## skk main rutine: call from term.lineEdit
## key binding SKK on
##
## @  : Hiragana(ひらがな)/Katakana(カタカナ) toggle
## *  : Ascii
## L  : Zenei(ａｉｕｅｏ１２３４５＠：；！”＃＄％＆)
## ^j : ascii, Zenei => Hiragana mode
##
## Kana Kanji translation key
##
## A-Z   : start translation region when not start translation
## Space : start translation and show candidates, select candidate
## a-z or enter  : finish translation
## A-Z   : okuri-ari translation Ex. KaKu => [変]かu => [変]書 => 書く
## 
proc skkInput*(c: char, curp: int): seq[Rune] =
  var ch = c
  var s = ""
  henkanp = curp

  proc redraw(r: seq[Rune], start: int): int =
    var bs = 0
    for c in r: bs += utf8.unicodeCharWidth(c)
    result = bs
    setCursorXPos(start)
    while bs > 0:
      stdout.write(' ')
      dec(bs)
    setCursorXPos(start)
    for c in r: stdout.write(toUTF8(c))
          
  result = newSeq[Rune]()
  while true:
    if ch in {'\n', '@', '*', 'L'}:
      setSkkMode(ch)
      break

    case skkmode
    of Hira, Kata:
      #echo "skkInput enter Hira Kata mode"
      case ch
      #of '\n', '@', '*', 'L': setSkkMode(ch)
      of 'A'..'K', 'M'..'Z':      # henkan mode
        prevmode = skkmode
        skkmode = Henkan
        #stdout.setCursorXPos(0)     # redraw skk mode
        henkanp += displayMode(henkanp + 4)
        let (kanji, okuri) = showKoho(toLowerAscii(ch))
        when DEBUG: debugLog(Module, "skkInput kanji => " & repr(kanji) & " okuri => " & okuri)
        skkmode = prevmode
        result.add(kanji)
        if okuri != "":
          if okuri == "tt":   # 'tt' => 'たち' in azik but 'tt' => 'っt' in skk
            result.add(toRunes("っ"))
            s = "t"
          elif okuri.len == 2 and okuri[0] in Vowel:
            discard getKana($okuri[0], result)
            if isUpperAscii(okuri[1]):    # next kanji henkan
              ch = okuri[1]
              henkanp -= redraw(result, henkanp - 4)
              continue
            else:
              if ord(okuri[1]) > 32: s = $okuri[1]      # TODO: reject control code
          elif okuri.len == 1 and isUpperAscii(okuri[0]):   # next kanji henkan
            #when DEBUG: echo "skkInput okuri upperascii"
            ch = okuri[0]
            henkanp -= redraw(result, henkanp - 4)
            continue
          else:
            s = s & okuri
          stdout.write(okuri)
      of 'a'..'z', ';', '-':
        s = s & ch
        stdout.write(ch)
        #when DEBUG: echo "skkinput s => ", s
      else:
        if not (ord(ch) >= 0 and ord(ch) < 32) or ord(ch) != 127:
          result.add(toRunes($ch))
        break
    of Ascii, Zenei:
      s = s & ch
      stdout.write(ch)
    else: discard
    if s.len > 0:
      if s.len > 3:
        result.add(toRunes(s))
        break
      #when DEBUG: echo "skkInput s => ", s
      if getKana(s, result): break
    ch = getch()

when DEBUG:
  proc showBuf(): string =
    var s = "skkbuf => "
    for r in items(skkbuf):
      s.add(toUTF8(r))
    return s
    
proc getYomi(c: char): char =
  # henkan mode  
  var ch = c
  var s = ""
  var skkbufp = 0
  var cp = henkanp + 4   # cursor position

  result = '\0'
  while true:
    case ch
    of '\a':        # ^G
      while skkbufp > 0:
        let bs = utf8.unicodeCharWidth(skkbuf[skkbufp - 1])
        cp = max(henkanp + 1, cp - bs)
        setCursorXPos(cp)
        for i in 0 .. bs - 1: stdout.write(' ')
        setCursorXPos(cp)
        skkbuf.delete(skkbufp - 1)
        dec(skkbufp)       
      return '\a'
    of 'A'..'K', 'M'..'Z', '+':     # '+' => shift semicolon
      if ch == '+': result = 't'    # Ex '走っ*t'
      else: result = toLowerAscii(ch)
      break
    of ' ': break     # show candsidates
    of '\b', chr(127):          # back space ^H(8) and DEL(127)
      if skkbufp > 0:
        when DEBUG: debugLog(Module, showBuf())
        let bs = utf8.unicodeCharWidth(skkbuf[skkbufp - 1])
        cp = max(henkanp + 1, cp - bs)
        setCursorXPos(cp)
        for i in 0 .. bs - 1: stdout.write(' ')
        setCursorXPos(cp)
        skkbuf.delete(skkbufp - 1)
        dec(skkbufp)
    of 'a'..'z', ';':
      s = s & ch
      #if ch notin Vowel: stdout.write(ch)
    else: discard
    if s.len > 0:
      if haskey(skkazik.AzikTbl, s):
        #when DEBUG: echo "enter haskey s => ", s
        let (h, k) = skkazik.AzikTbl[s]
        let r = toRunes(h)
        var i = s.len - 1
        while i > 0:
          skkbuf.delete(skkbufp - 1)
          dec(skkbufp)
          dec(i)
        skkbuf.add(r)
        inc(skkbufp, r.len)
        cp -= s.len - 1
        setCursorXPos(cp)
        if prevmode == Hira:
          writeStyled(h, {styleUnderscore})
        if prevmode == Kata:
          writeStyled(k, {styleUnderscore})
        s = ""
        for u in items(r): cp += utf8.unicodeCharWidth(u)
        setCursorXPos(cp)
      else:
        if s.len > 3 or s[high(s)] in Vowel:
          s = ""
          #break
        let r = toRunes(s)
        skkbuf.add(r)
        inc(skkbufp, r.len)
        setCursorXPos(cp)
        writeStyled(s, {styleUnderscore})
        #s = ""
        for u in items(r): cp += utf8.unicodeCharWidth(u)
        #stdout.write(s)
    ch = getch()
    # call initSkkJisyo
  if not jisyook: discard initSkkJisyo()
        
proc displaySingleKoho(koho: string, kohozan: int) =
  #if kohozan > 3: setBackgroundColor(stdout, bgBlue)
  #else: setBackgroundColor(stdout, bgYellow)
  let l = displayMode(henkanp)
  #resetAttributes(stdout)
  stdout.setCursorXPos(henkanp + l)
  stdout.write(koho)
  #system.addQuitProc(resetAttributes)

proc afterKakutei(kakutei, okuri: string): tuple[kanji: seq[Rune], okuri: string] =
  skkbuf.delete(0, high(skkbuf))
  skkmode = prevmode   # finish henkan mode
  let res = toRunes(kakutei)
  result = (kanji: res, okuri: okuri)
  for r in items(res): henkanp += utf8.unicodeCharWidth(r)   # ready for next henkan
  setCursorXPos(henkanp + 1)

proc showKoho(c: char): tuple[kanji: seq[Rune], okuri: string] =
  let okuri = getYomi(c)
  when DEBUG: debugLog(Module, showBuf() & "okuri => " & okuri)
  if okuri == '\a':      # ^G
    var tmp = newSeq[Rune]()
    for r in items(skkbuf): tmp.add(r)
    if len(skkbuf) != 0:
      skkbuf.delete(0, high(skkbuf))
    skkmode = prevmode
    discard displayMode(henkanp)
    return (kanji: tmp, okuri: "")   # ^G
  var c: char
  var koho, s, gana, kakutei: string
  var num, cnt: int
  var cands = newSeq[string]()
  gana = if okuri == '\0': "" else: $okuri
  result = (kanji: skkbuf, okuri: gana)

  eucToUtf = open(OutputEncoding, SkkJisyoEncoding)
  utfToEuc = open(SkkJisyoEncoding, OutputEncoding)
  
  s = ""
  for r in items(skkbuf): s = s & toUTF8(r)
  when DEBUG: debugLog(Module, "showKoho skkbuf => " & s)
  let yomi = convert(utfToEuc, s) & gana
  #let yomi = if gana notin "aiueo": convert(utfToEuc, s) & gana
  #           else: convert(utfToEuc, s)
  #when DEBUG: echo "showKoho yomi => ", convert(eucToUtf, yomi), " gana => ", gana
  try:
    if getCandsFromUserJisyo(yomi, cands):
      num = len(cands)
    if getCandsFromMainJisyo(yomi, cands):
      num = len(cands)
  except IndexError:
    return (kanji: skkbuf, okuri: gana)
  when DEBUG: debugLog(Module, "showKoho cands => " & repr(cands) & "showKoho num => " & $num)
  if num > 0:
    var converted = newSeq[string]()
    for k in items(cands): converted.add(convert(eucToUtf, k))
    cnt = 0
    kakutei = ""
    skkMode = Koho
    while cnt < num:     # cnt < MaxShowKohoEach and cnt < num:
      koho = converted[cnt]
      let pos = find(koho, ';')    # ignore annotation
      if pos != -1: koho = koho[0 .. pos - 1]
      displaySingleKoho(koho, num - cnt)
      c = getch()
      case c
      of '\a':       # ^G
        var tmp = newSeq[Rune]()
        for r in items(skkbuf): tmp.add(r)
        if len(skkbuf) != 0:
          skkbuf.delete(0, high(skkbuf))
        skkmode = prevmode
        discard displayMode(henkanp)
        return (kanji: tmp, okuri: gana)
      of 'a'..'z', 'A'..'K', 'M'..'Z', ';', '-':
        gana = gana & c
        when DEBUG: debugLog(Module, "okuri-gana => " & gana)
        kakutei = koho
        break
      of '\r':
        kakutei = koho
        break
      of ' ':
        inc(cnt)
        continue
      else: discard
    if kakutei == "":
      var tmp = newSeq[Rune]()
      for r in items(skkbuf): tmp.add(r)
      skkmode = prevmode
      discard displayMode(henkanp)
      result = (kanji: tmp, okuri: gana)
    else:
      result = afterKakutei(kakutei, gana)
  if len(skkbuf) != 0: skkbuf.delete(0, high(skkbuf))

# getKoho for gui part
proc getKoho*(yomi: string): seq[string] =
  # iconv converter
  eucToUtf = open(OutputEncoding, SkkJisyoEncoding)
  utfToEuc = open(SkkJisyoEncoding, OutputEncoding)

  # call initSkkJisyo
  echo "initialzing skk jisyo ..."
  if not jisyook: discard initSkkJisyo()

  let gana = convert(utfToEuc, yomi)
  echo "gane => ", gana
  var cands = newSeq[string]()
  var num: int
  try:
    if getCandsFromUserJisyo(gana, cands):
      num = len(cands)
    if getCandsFromMainJisyo(gana, cands):
      num = len(cands)
  except IndexError:
    return @[]
  
  if num > 0:
    var converted = newSeq[string]()
    for k in items(cands): converted.add(convert(eucToUtf, k))
    return converted

when isMainModule:
#[
  block skkTest:
    skkmode = Hira
    let (o, l) = skk()
    echo "str => ", o, " len => ", l

  block initJisyoTest:
    eucToUtf = open("UTF-8", "EUC-JP")
    utfToEuc = open("EUC-JP", "UTF-8")
    let user = getHomeDir() & '/' & skkUserJisyo
    #let main = skkJisyoPath & '/' & skkServerJisyo
    if loadSkkJisyo(user, skkuserjisyoari, skkuserjisyonasi):
      #echo "あい => ", convert(eucToUtf, skkjisyonasi[convert(utfToEuc, "あい")])
      #echo "あいs => ", convert(eucToUtf, skkjisyoari[convert(utfToEuc, "あいs")])
      echo "はじm => "
      for k in splitCands(convert(eucToUtf, skkuserjisyoari[convert(utfToEuc, "はじm")])):
        echo k
]#
  block getKohoTest:
    #if initSkkJisyo():
    let koho = getKoho("あい")
    echo "あい => "     #, repr(koho)
    for k in items(koho):
      echo k
#[
  block getYomiTest:
    prevmode = Hira
    echo "okuri => ", getYomi()
    echo "skkbuf => "
    for r in items(skkbuf): stdout.write(toUTF8(r))
    stdout.write('\n')

  block showKohoTest:
    prevmode = Hira
    #if initSkkJisyo():
    echo "Enter YOMI and space to show KOHO"
    let (kanji, okuri) = showKoho(getch())
    #if okuri != "": echo "okuri => ", okuri
    for r in items(kanji):
      stdout.write(toUTF8(r))
    stdout.write('\n')
]#
