# Trace log format

# Extension
`trlog`

# Endian
Little-endian

# Header

## Identifier 4byte
'trlo'

## Version 2byte
1

## Header rest byte size 4byte
16

## FPS 4byte
`<float32>`

## Frame number: 4byte
`<uint32>`
0xFFFFFFFF means unknown size.

## Entry number: 4byte
`<uint32>`
0xFFFFFFFF means unknown size.

## Entries byte size: 4byte
`<uint32>`
0xFFFFFFFF means unknown size.

# Entries

## skip frame size: 4byte
`<uint32>`

## layer index: 4byte
`<int32>`

## flags: 1byte
0: None
1: Clear layer

## Commands byte size: 4byte
`<uint32>`

## Commands

### ADD TEXT: 2byte + length
`0 <data:String24>`

#### String
encodeing should be utf-8
String24 : `<byteSize:uint24> <data>`