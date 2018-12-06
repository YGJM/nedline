import unicode, sequtils
import terminal, utf8utils as utf8
import log

when not defined(noskk):
  import skk

when defined(testing):
  const DEBUG = true
else:
  const DEBUG = false

const Module = "term"

const
  MaxHistory = 20

var ihistory : array[MaxHistory, seq[Rune]]
var ihistoryp = 0
 
proc redraw(prompt: string, input: seq[Rune], curp: int, skkon: bool) =
  var cp = curp
  eraseLine()
  when not defined(noskk):
    if skkon: cp += displayMode()
  #setCursorXPos(cp + 1)
  if prompt != "": stdout.write(prompt)
  for r in items(input):
    stdout.write(toUTF8(r))
  cp += prompt.len
  setCursorXPos(cp)

proc cursorPosAtEnd(input: seq[Rune]): int =
  var ep = 0
  for r in items(input):
    ep += utf8.unicodeCharWidth(r)
  return ep

proc left(idx, cp: var int, line: seq[Rune]) =
  #when DEBUG: echo "index => ", idx, " curp => ", cp
  if line.len > 0:
    idx = max(0, idx - 1)
    cp = max(0, cp - utf8.unicodeCharWidth(line[idx]))

proc right(idx, cp: var int, line: seq[Rune]) =
  if line.len > 0:
    idx = min(line.len, idx + 1)
    let lastp = cursorPosAtEnd(line)
    cp = min(lastp, cp + utf8.unicodeCharWidth(line[idx - 1]))
    #when DEBUG: echo "index => ", idx, " curp => ", cp, " lastp => ", lastp
    
proc addIHistory*(data: seq[Rune]) =
  if ihistoryp < MaxHistory:
    ihistory[ihistoryp] = data
    inc(ihistoryp)
  else:
    for i in 0 .. int(MaxHistory / 2) - 1:
      ihistory[i] = ihistory[i + int(MaxHistory / 2)]
    ihistoryp = int(MaxHistory / 2)
    ihistory[ihistoryp] = data
    inc(ihistoryp)

proc prevIHistory(line: var seq[Rune]): bool =
  result = false
  if ihistoryp > 0:
    dec(ihistoryp)
    line = ihistory[ihistoryp]
    result = true

proc nextIHistory(line: var seq[Rune]): bool =
  result = false
  if ihistoryp < MaxHistory - 1:
    inc(ihistoryp)
    line = ihistory[ihistoryp]
    result = true
    
## command line edit
##
## key bindings SKK off
## 
## enter       : finish to edit line
## BS, ^h      : delete char before cursor
## left, right : cursor move
## up, down    : history up, down
##
## ^X^J        : SKK Kana mode on/off
##
proc lineEdit*(prompt = "", skk: bool = false): seq[Rune] =
  var c: char
  var r: seq[Rune]
  var input = newSeq[Rune](0)
  var index = 0
  var curp = 0
  var tmp = newString(MaxRune)
  var cflag = false
  var dflag = false
  var skkon = skk
  #var skkbuf = ""

  if prompt != "": stdout.write(prompt)

  while true:
    c = getch()
    case ord(c)
    of 13:           # '\r'
      when DEBUG: debugLog(Module, "press return key")
      #if not skkon: break     # return
      break
    of 24:           # ^X  skkmode
      when not defined(noskk):
        if getch() == '\n':      # ^J
          if skkon: skkon = false
          else: skkon = true
          when DEBUG: debugLog(Module, "skkon => " & $skkon)
    of 10, 32..126:            # '\n' and ascii
      when not defined(noskk):
        if skkon:
          when DEBUG: debugLog(Module, "skkinput c: " & $ord(c))
          r = skkInput(c, curp)
          redraw(prompt, input, curp, skkon)
        else:
          r = toRunes($c)
      else:
        r = toRunes($c)
      #if cflag:
      #  input.delete(index)
      #  input.insert(r[0], index)
      #else:
      if index == 0 and input.len == 0: input.add(r)
      elif index == input.len: input.add(r)
      else: input.insert(r[0], index)
      inc(index, r.len)
      for i in 0 .. r.len - 1:
        curp += utf8.unicodeCharWidth(r[i])
    of 128..255:                   # utf8 not through skk
      let fill = utf8.runeByteLen(c)
      when DEBUG: debugLog(Module, "c => " & $ord(c) & " byte len => " & $fill)
      tmp[0] = c
      var i = 1
      while i < fill:
        tmp[i] = getch()
        inc(i)
      let r = toRunes(tmp[0 .. fill - 1])
      when DEBUG: debugLog(Module, "tmp => " & repr(tmp) & " rune => " & repr(r))
      if input.len > 0:
        if index == input.len: input.add(r)
        elif cflag:
          input.delete(index)
          input.insert(r[0], index)
        else: input.insert(r[0], index)
      else:
        input.add(r)
      when DEBUG: debugLog(Module, "input => " & repr(input))
      inc(index)
      curp += utf8.unicodeCharWidth(r[0])
      when DEBUG: debugLog(Module, "index => " & $index & " curp => " & $curp)
    of 8, 127:        # Backspace
      if input.len > 0 and index > 0:
        when DEBUG: debugLog(Module, "BS key index => " & $index & " input len => " & $len(input) & " curp => " & $curp)
        curp = max(0, curp - utf8.unicodeCharWidth(input[index - 1]))
        index = max(0, index - 1)
        input.delete(index)
    of 27:         # esc. arrow key
      let c1 = getch()
      let c2 = getch()
      if ord(c1) == 91:
        if ord(c2) == 68:       # left
          left(index, curp, input)
        elif ord(c2) == 67:     # right
          right(index, curp, input)
        elif ord(c2) == 65:     # up
          if prevIHistory(input): curp = 0
        elif ord(c2) == 66:     # down
          if nextIHistory(input): curp = 0
    else: discard
    result = input
    redraw(prompt, input, curp, skkon)

# test code
when isMainModule:

  block lineEditTest:
    echo "=== lineEditTest ==="
    #if skk.initSkkJisyo():
    while true:
      #let input = lineEdit()
      let input = lineEdit(prompt = "zf> ")
      if len(input) == 1 and toUTF8(input[0]) == ".": break
      addIHistory(input)
      stdout.write('\n')
      echo "input => ", repr(input)

