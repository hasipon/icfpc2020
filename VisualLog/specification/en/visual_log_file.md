# Visual log format

# Extension
`vilog`

# Endian
Little-endian

# Header

## identifier 4byte
'vilo'

## version 2byte
1

## header size 4byte
29

## width: 4byte
`<uint32>`

## height: 4byte
`<uint32>`

## FPS 4byte
`<float32>`

## background color: 4byte
`<argb:uint32>`

## texture required: 1byte
```
0: Not required
1: Required
2: Unknown
```

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
```
0: None
1: Clear layer
```

## Commands byte size: 4byte
`<uint32>`

# Commands

### LINE TO: 9byte
`0 <toX:float32> <toY:float32>`

### MOVE TO: 9byte
`1 <toX> <toY>`

### QUADRATIC CURVE TO: 17byte
`2 <ctrlX:float32> <ctrlY:float32> <toX> <toY>`

### BEZIER CURVE TO: 25byte
`3 <ctrlX> <ctrlY> <ctrl2X:float32> <ctrl2Y:float32> <toX> <toY>`

### ARC: 22byte
`4 <ctrlX> <ctrlY> <radius:float32> <startAngle:float32> <endAngle:float32> <anticlockwise:boolean>`

### ARC TO: 21byte
`5 <fromX:float32> <fromY:float32> <toX> <toY> <radius:float32>`

### FILL: 1byte
`6`

### CLOSE PATH: 1byte
`7`

### DRAW CIRCLE: 13byte
`8 <x:float32> <y:float32> <radius>`

### DRAW ELLIPSE: 17byte
`9 <x> <y> <width:float32> <height:float32>`

### DRAW RECTANGLE: 17byte
`10 <x> <y> <width> <height>`

### DRAW ROUND RECTANGLE: 21byte
`11 <x> <y> <width> <height> <radius>`

### DRAW REGULAR POLYGON: 19byte
`12 <x> <y> <points:uint16> <radius> <rotation:uint16>`

### DRAW STAR: 23byte
`13 <x> <y> <points:uint16> <radius> <innerRadius:float32> <rotation:uint16>`

#### rotation
```
no rotation    : 0
1 / points lap : 65535
```

### DRAW GRID: 21byte
`14 <x> <y> <gridWidth:uint16> <gridHeight:uint16> <cellWidth:float32> <cellHeight:float32>`

### DRAW COLUMNS
`15 <x> <y> <columnWidth:float32> <margin:float32> <length:uint16> <heights:float32[]>`

### MULTPLY TRANSFORM: 25byte
`16 <matrix:<float32> <float32> <float32> <float32> <float32> <float32>>`

### RESET TRANSFORM: 25byte
`17 <matrix>`

### MULTPLY ALPHA: 3byte
`18 <alpha:uint16>`

#### alpha
```
hidden: 0
opaque: 65535
```

### RESET ALPHA: 3byte
`19 <alpha>`

### SET LINE ALPHA: 3byte
`20 <alpha>`

### SET FILL ALPHA 3byte
`21 <alpha>`

### SET LINE COLOR 4byte
`22 <rgb:uint24>`

### SET FILL COLOR 4byte
`23 <rgb>`

### SET LINE THICKNESS 5byte
`24 <float32>`

### SET BLENDMODE 2byte
`25 <blendMode:BlendMode>`

#### BlendMode:uint8
```
0 : None
1 : Add
2 : Multiply
3 : Screen
4 : Overlay
5 : Darken
6 : Lighten
7 : ColorDodge
8 : ColorBurn
9 : HardLight
10: SoftLight
11: Difference
12: Exclusion
13: Hue
14: Saturate
15: Color
16: Luminosity
```

### SET LINE ALIGNMENT: 5byte
`26 <alignment:float32>`

### SET FONT LIST
`27 <length:uint16> <name:String16[]>`

#### String
encodeing should be utf-8
String16 : `<byteSize:uint16> <data>`
String24 : `<byteSize:uint24> <data>`

### SET FONT SIZE: 5byte
`28 <pixel:float32>`

### SET FONT STYLE: 2byte
`29 <fontStyle:FontStyle>`

#### FontStyle:uint8
```
0: Normal
1: Bold
2: Italic
3: Italic Bold
```

### SET TEXT HOLIZONTAL ALIGN: 5byte
`30 <align:float32>`

### SET TEXT VERTICAL ALIGN: 5byte
`31 <align:float32>`

### DRAW TEXT: 12byte + length
`32 <x> <y> <data:String24>`

### SET IMAGE HOLIZONTAL ALIGN: 5byte
`33 <align:float32>`

### SET IMAGE VERTICAL ALIGN: 5byte
`34 <align:float32>`

### DRAW IMAGE
`35 <x> <y> <path:String16>`

### Start masking region: 1byte
`36`

### Start masked region: 3byte
`37 <maskIndexFromLast:uint16>`

### End masking/masked region: 1byte
`38`

### Reference commands 16_8: 4byte
`39 <startPosition:uint16> <length:uint8>`

### Reference commands 24_16: 6byte
`40 <startPosition:uint24> <length:uint16>`

### Reference commands 32_24: 8byte
`41 <startPosition:uint32> <length:uint24>`

### ARROW TO: 11byte
`42 <toX:float32> <toY:float32> <arrowVisiblities:uint8> <arrowWidth:float32> <arrowLength:float32>`
