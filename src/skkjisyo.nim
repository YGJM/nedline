import strutils, sequtils, strtabs, os

const
  skkServerJisyo = "SKK-JISYO.L"
  BackupExt = ".BAK"
  Vowel* = {'a', 'i', 'u', 'e', 'o'}
  Consonant = {'a'..'z'} - Vowel

when defined(openbsd):
  const skkJisyoPath = "/usr/local/share/skk"
else:
  const skkJisyoPath = "/usr/share/skk"

const DEBUG = true

when isMainModule:
  const skkUserJisyo = ".skk-jisyo.utf8"
else:
  const skkUserJisyo = ".skk-jisyo"

var
  skkjisyoari* = newStringTable(modeStyleInsensitive)
  skkjisyonasi* = newStringTable(modeStyleInsensitive)
  skkuserjisyoari* = newStringTable(modeStyleInsensitive)
  skkuserjisyonasi* = newStringTable(modeStyleInsensitive)
  jisyook* = false

# load/init skk jisyo
proc loadSkkJisyo(path: string, jisyoari, jisyonasi: var StringTableRef): bool =
  var file: system.File
  var jisyo: StringTableRef
  var line: TaintedString

  result = true
  if open(file, path, fmRead):
    try:
      while true:
        line = readLine(file)
        #when DEBUG: echo "line: ", line
        if line[0..1] == ";;":
          if line == ";; okuri-ari entries.": jisyo = jisyoari
          elif line == ";; okuri-nasi entries.": jisyo = jisyonasi
        else:
          let se = splitWhitespace(line, maxsplit = 1)
          #when DEBUG: echo "key => ", se[0], " val => ", se[1]
          jisyo[se[0]] = se[1]
    except IOError: discard
    finally: close(file)
  else:
    echo "can't open ", path
    result = false

proc initSkkJisyo*(): bool =
  let main = skkJisyoPath & '/' & skkServerJisyo
  let user = getHomeDir() & '/' & skkUserJisyo

  #stdout.write("loading skk jisyo ... ")
  result = loadSkkJisyo(user, skkuserjisyoari, skkuserjisyonasi)
  result = loadSkkJisyo(main, skkjisyoari, skkjisyonasi)
  if result:
    jisyook = true
 #  stdout.write("ok\n")
 #else: stdout.write("error\n")
 
proc registerToUserJisyo*(yomi, kakutei: string): bool =
  var cands: string

  if yomi[^1] in {'a'..'z'}:
    if haskey(skkuserjisyoari, yomi):
      cands = skkuserjisyoari[yomi]
      let idx = find(cands, kakutei)
      if idx == -1: cands = '/' & kakutei & cands
      elif idx > 1:
        let endp = find(cands, '/', idx)
        cands = '/' & kakutei & cands[0 .. idx - 1] & cands[endp + 1 .. ^1] 
      skkuserjisyoari[yomi] = cands
    else:
      skkuserjisyoari[yomi] = '/' & kakutei & '/'
  else:
    if haskey(skkuserjisyonasi, yomi):
      cands = skkuserjisyonasi[yomi]
      let idx = find(cands, kakutei)
      if idx == -1: cands = '/' & kakutei & cands
      elif idx > 1:
        let endp = find(cands, '/', idx)
        cands = '/' & kakutei & cands[0 .. idx - 1] & cands[endp + 1 .. ^1] 
      skkuserjisyonasi[yomi] = cands
    else:
      skkuserjisyonasi[yomi] = '/' & kakutei & '/'     
  return true
      
proc saveUserJisyo() =
  var sf: system.File
  let path = getHomeDir() & '/' & skkUserJisyo
  let backup = path & BackupExt
  copyFile(path, backup)

  if open(sf, path, fmWrite):
    try:
      write(sf, ";; okuri-ari entries.\n")
      for k, v in pairs(skkuserjisyoari):
        let line = k & ' ' & v & '\n'
        write(sf, line)
      write(sf, ";; okuri-nasi entries.\n")
      for k, v in pairs(skkuserjisyonasi):
        let line = k & ' ' & v & '\n'
        write(sf, line)
    except IOError:
      echo "IO error!"
    except:
      echo "Unknown exception!"
      raise
    finally:
      close(sf)

proc splitCands*(koho: string): seq[string] =
  var kstr = koho[1..^2]     # trim first and last '/'
  let pos = find(kstr, '[')  # ignore [...] in user jisyo
  if pos != -1: kstr = kstr[0..pos - 2]
  #echo "splitCands kstr => ", kstr
  split(kstr, '/')

proc getCandsFromUserJisyo*(yomi: string, cands: var seq[string]): bool =
  result = false
  
  if yomi[^1] in {'a'..'z'}:
    if haskey(skkuserjisyoari, yomi):
      cands.add(splitCands(skkuserjisyoari[yomi]))
      result = true
  else:
    if haskey(skkuserjisyonasi, yomi):
      cands.add(splitCands(skkuserjisyonasi[yomi]))
      result = true

proc getCandsFromMainJisyo*(yomi: string, cands: var seq[string]): bool =
  result = false
  
  if yomi[^1] in {'a'..'z'}:
    if haskey(skkjisyoari, yomi):
      cands.add(splitCands(skkjisyoari[yomi]))
      result = true
  else:
    if haskey(skkjisyonasi, yomi):
      cands.add(splitCands(skkjisyonasi[yomi]))
      result = true

when isMainModule:
  proc writeJisyo(jisyo: StringTableRef) =
    for k, v in pairs(jisyo):
      echo "key: ", k, " value: ", v
      
  let user = getHomeDir() & '/' & skkUserJisyo
  var cands = newSeq[string]()
  if loadSkkJisyo(user, skkuserjisyoari, skkuserjisyonasi):
    #discard registerToUserJisyo("はかr", "図")
    #discard registerToUserJisyo("はかr", "測")
    #discard registerToUserJisyo("まき", "真希")
    #discard registerToUserJisyo("まき", "薪")
    #echo "** skk user jisyo-ari **"
    #writeJisyo(skkuserjisyoari)
    #echo "** skk user jisyo-nasi **"
    #writeJisyo(skkuserjisyonasi)
    #saveUserJisyo()
    if getCandsFromUserJisyo("はかr", cands):
      for k in items(cands): echo "cands => ", k
      cands.delete(0, high(cands))
    else: echo "no cands!"
  else: echo "error loading user jisyo!"
