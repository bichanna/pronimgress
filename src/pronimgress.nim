#[
  pronimgress.nim
  @author: Nobuharu Shimazu
]#

import strformat, strutils, system

type
  # {prefix} {leftSurroundChar}{backgroundChar}{progressChar}{progressHeadChar}{rightSurroundChar} <percentage> {suffix}
  # e.g., Progress: [=================>          ] 62.30% Complete
  # prefix            = "Progress:"
  # leftSurroundChar  = '['
  # backgroundChar    = ' '
  # progressChar      = '='
  # progressHeadChar  = '>'
  # rightSurroundChar = ']'
  # suffix            = "Complete"
  PronimgressBar* = object
    prefix: string
    suffix: string
    leftSurroundChar: char
    rightSurroundChar: char
    backgroundChar: char
    progressChar: char
    progressHeadChar: char
    size: float
    count: int


proc newPronimgressBar*(
  prefix:             string   = "Progress",
  suffix:             string   = "Complete",
  leftSurroundChar:   char     = '[',
  rightSurroundChar:  char     = ']',
  backgroundChar:     char     = ' ',
  progressChar:       char     = '#',
  progressHeadChar:   char     = '\0',
  size:               float    = 100.0
  ): PronimgressBar = 
  ## Creates a new PronimgressBar and returns it
  return PronimgressBar(
    prefix: prefix,
    suffix: suffix,
    leftSurroundChar: leftSurroundChar,
    rightSurroundChar: rightSurroundChar,
    backgroundChar: backgroundChar,
    progressChar: progressChar,
    progressHeadChar: progressHeadChar,
    size: size,
    count: 0
  )


proc charXint(c: char, num: int): string =
  ## "h" * 3 = "hhh"
  
  for i in 0 ..< num:
    result &= $c
  return result


proc update*(self: var PronimgressBar, addCount: int, newSuffix: string = "") = 
  ## Updates the pronimgress bar
  
  const lenBar = 60
  let
    filledLen: int = ((lenBar * self.count).float / self.size).int
    percents: string = formatFloat(100.0 * self.count.float32 / float32(self.size), ffDecimal, 2)
  var
    bar: string = ""
    printV: string = ""
  self.count += addCount

  # Adding progress chars
  if self.progressHeadChar == '\0':
    bar = charXint(self.progressChar, filledLen)
    discard
  else:
    bar = charXint(self.progressChar, filledLen - 1) & $self.progressHeadChar
  
  # Adding background chars
  bar &= charXint(self.backgroundChar, lenBar - filledLen)

  # Assembling this:
  # {prefix} {leftSurroundChar}{backgroundChar}{progressChar}{progressHeadChar}{rightSurroundChar} <percentage> {suffix}
  stdout.flushFile()
  if newSuffix.isEmptyOrWhitespace:
    printV = fmt"{self.prefix} {self.leftSurroundChar}{bar}{self.rightSurroundChar} {percents}% {self.suffix}" & "\r"
  else:
    printV = fmt"{self.prefix} {self.leftSurroundChar}{bar}{self.rightSurroundChar} {percents}% {newSuffix}" & "\r"
  stdout.write(charXint(' ', len(printV)) & "\r")
  stdout.write(printV)
  stdout.flushFile()