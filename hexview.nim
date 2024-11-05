## A simple utility to view contents of something in hexadecimal form.

type uint4 = 0'u8 .. 15'u8

template writeDigit(target: var string, a: uint4) =
  if a >= 10:
    target.add(char(ord('a') + a - 10))
  else:
    target.add(char(ord('0') + a))

func hexView*(
    where: pointer, length: Natural, limit: Natural = 16, appendNewLine: bool = false
): string =
  for i in 0 ..< length:
    let item = cast[ptr byte](cast[uint](where) + uint(i))[]

    # new line every `limit` bytes
    if (i mod limit) == 0 and (i != 0):
      result.add('\n')

    # show byte
    writeDigit(result, item shr 4 and 0b1111)
    writeDigit(result, item and 0b1111)

    # write space between bytes
    if not (((i mod limit) == (limit - 1)) or (i == (length - 1))):
      result.add(' ')
  # newline afterwards
  if appendNewLine:
    result.add('\n')

func hexView*[T](
    which: openArray[T], limit: Natural = 16, appendNewLine: bool = false
): string =
  hexView(which.unsafeAddr, len(which) * sizeof(which[0]), limit, appendNewLine)

when isMainModule:
  import std/unittest

  test "simple":
    check hexView("112314") == "31 31 32 33 31 34"

  test "simple with newline":
    check hexView("9587", appendNewLine = true) == "39 35 38 37\n"

  test "wrapped bytes":
    check hexView("1123", 2) == "31 31\n32 33"

  test "wrapped bytes with newline":
    check hexView("1145", 2, true) == "31 31\n34 35\n"
