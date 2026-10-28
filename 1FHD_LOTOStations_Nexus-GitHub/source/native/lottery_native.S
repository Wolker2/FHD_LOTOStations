/* Recovered x86 source: complete original executable instructions.
 * No original DLL or opaque executable payload is needed to build.
 * Labels and fixed .org offsets preserve the supplied PE layout.
 * Encoded branch widths and NOP padding are explicit for byte identity. */
.intel_syntax noprefix
.section .text,"ax",@progbits
.org 0x0
L_10001000:
.global LotteryNumber
LotteryNumber:
    push   ebx
.org 0x1
L_10001001:
    push   edi
.org 0x2
L_10001002:
    push   esi
.org 0x3
L_10001003:
    mov    edi,DWORD PTR [entropy_counter]
.org 0x9
L_10001009:
    inc    edi
.org 0xa
L_1000100a:
    mov    DWORD PTR [entropy_counter],edi
.org 0x10
L_10001010:
    call   DWORD PTR [IAT_GetTickCount]
.org 0x16
L_10001016:
    mov    esi,eax
.org 0x18
L_10001018:
    call   DWORD PTR [IAT_GetCurrentProcessId]
.org 0x1e
L_1000101e:
    imul   ebx,eax,0x9e3779b9
.org 0x24
L_10001024:
    call   DWORD PTR [IAT_GetCurrentThreadId]
.org 0x2a
L_1000102a:
    imul   eax,eax,0x85ebca6b
.org 0x30
L_10001030:
    imul   ecx,edi,0xc2b2ae35
.org 0x36
L_10001036:
    xor    ebx,esi
.org 0x38
L_10001038:
    xor    ebx,ecx
.org 0x3a
L_1000103a:
    xor    ebx,eax
.org 0x3c
L_1000103c:
    mov    eax,ebx
.org 0x3e
L_1000103e:
    shr    eax,0x10
.org 0x41
L_10001041:
    xor    eax,ebx
.org 0x43
L_10001043:
    imul   eax,eax,0x7feb352d
.org 0x49
L_10001049:
    mov    ecx,eax
.org 0x4b
L_1000104b:
    shr    ecx,0xf
.org 0x4e
L_1000104e:
    xor    ecx,eax
.org 0x50
L_10001050:
    imul   eax,ecx,0x846ca68b
.org 0x56
L_10001056:
    mov    esi,eax
.org 0x58
L_10001058:
    shr    esi,0x10
.org 0x5b
L_1000105b:
    xor    esi,eax
.org 0x5d
L_1000105d:
    mov    edi,0x86186187
.org 0x62
L_10001062:
    mov    eax,esi
.org 0x64
L_10001064:
    mul    edi
.org 0x66
L_10001066:
    mov    eax,esi
.org 0x68
L_10001068:
    sub    eax,edx
.org 0x6a
L_1000106a:
    shr    eax,1
.org 0x6c
L_1000106c:
    add    eax,edx
.org 0x6e
L_1000106e:
    shr    eax,0x4
.org 0x71
L_10001071:
    lea    ecx,[eax+eax*4]
.org 0x74
L_10001074:
    lea    eax,[eax+ecx*4]
.org 0x77
L_10001077:
    mov    ecx,esi
.org 0x79
L_10001079:
    sub    ecx,eax
.org 0x7b
L_1000107b:
    cmp    ecx,DWORD PTR [last_number]
.org 0x81
L_10001081:
    # jne    L_100010c2
    .byte 0x75
    .byte L_100010c2 - . - 1
.org 0x83
L_10001083:
    shr    esi,0x8
.org 0x86
L_10001086:
    mov    edx,0xccccccd
.org 0x8b
L_1000108b:
    mov    eax,esi
.org 0x8d
L_1000108d:
    mul    edx
.org 0x8f
L_1000108f:
    shl    edx,0x2
.org 0x92
L_10001092:
    lea    eax,[edx+edx*4]
.org 0x95
L_10001095:
    sub    esi,eax
.org 0x97
L_10001097:
    add    ecx,esi
.org 0x99
L_10001099:
    inc    ecx
.org 0x9a
L_1000109a:
    mov    eax,ecx
.org 0x9c
L_1000109c:
    mul    edi
.org 0x9e
L_1000109e:
    mov    eax,ecx
.org 0xa0
L_100010a0:
    sub    eax,edx
.org 0xa2
L_100010a2:
    shr    eax,1
.org 0xa4
L_100010a4:
    add    eax,edx
.org 0xa6
L_100010a6:
    shr    eax,0x4
.org 0xa9
L_100010a9:
    lea    edx,[eax+eax*4]
.org 0xac
L_100010ac:
    lea    eax,[eax+edx*4]
.org 0xaf
L_100010af:
    sub    ecx,eax
.org 0xb1
L_100010b1:
    cmp    ecx,DWORD PTR [last_number]
.org 0xb7
L_100010b7:
    # jne    L_100010c2
    .byte 0x75
    .byte L_100010c2 - . - 1
.org 0xb9
L_100010b9:
    inc    ecx
.org 0xba
L_100010ba:
    xor    eax,eax
.org 0xbc
L_100010bc:
    cmp    ecx,0x15
.org 0xbf
L_100010bf:
    cmove  ecx,eax
.org 0xc2
L_100010c2:
    mov    DWORD PTR [last_number],ecx
.org 0xc8
L_100010c8:
    mov    eax,ecx
.org 0xca
L_100010ca:
    pop    esi
.org 0xcb
L_100010cb:
    pop    edi
.org 0xcc
L_100010cc:
    pop    ebx
.org 0xcd
L_100010cd:
    ret
.org 0xce
L_100010ce:
    # Alignment padding: xchg   ax,ax
    .byte 0x66,0x90
.org 0xd0
L_100010d0:
.global LotteryHasRecord
LotteryHasRecord:
    mov    ecx,DWORD PTR [esp+0x4]
.org 0xd4
L_100010d4:
    mov    edx,DWORD PTR [esp+0x8]
.org 0xd8
L_100010d8:
    push   0x0
.org 0xda
L_100010da:
    push   DWORD PTR [esp+0x10]
.org 0xde
L_100010de:
    # call   L_100010f0
    .byte 0xe8
    .long L_100010f0 - . - 4
.org 0xe3
L_100010e3:
    add    esp,0x8
.org 0xe6
L_100010e6:
    ret
.org 0xe7
L_100010e7:
    # Alignment padding: nop    WORD PTR [eax+eax*1+0x0]
    .byte 0x66,0xf,0x1f,0x84,0x0,0x0,0x0,0x0,0x0
.org 0xf0
L_100010f0:
.global FindJournalRecord
FindJournalRecord:
    push   ebp
.org 0xf1
L_100010f1:
    push   ebx
.org 0xf2
L_100010f2:
    push   edi
.org 0xf3
L_100010f3:
    push   esi
.org 0xf4
L_100010f4:
    sub    esp,0x350
.org 0xfa
L_100010fa:
    mov    DWORD PTR [esp+0xc],edx
.org 0xfe
L_100010fe:
    mov    DWORD PTR [esp+0x8],ecx
.org 0x102
L_10001102:
    lea    edi,[esp+0x50]
.org 0x106
L_10001106:
    mov    ecx,edi
.org 0x108
L_10001108:
    # call   L_100015b0
    .byte 0xe8
    .long L_100015b0 - . - 4
.org 0x10d
L_1000110d:
    xor    ecx,ecx
.org 0x10f
L_1000110f:
    test   eax,eax
.org 0x111
L_10001111:
    # je     L_1000132a
    .byte 0xf,0x84
    .long L_1000132a - . - 4
.org 0x117
L_10001117:
    sub    esp,0x1c
.org 0x11a
L_1000111a:
    movaps xmm0,XMMWORD PTR [read_open_arguments]
.org 0x121
L_10001121:
    movups XMMWORD PTR [esp+0x4],xmm0
.org 0x126
L_10001126:
    mov    DWORD PTR [esp],edi
.org 0x129
L_10001129:
    mov    DWORD PTR [esp+0x18],0x0
.org 0x131
L_10001131:
    mov    DWORD PTR [esp+0x14],0x80
.org 0x139
L_10001139:
    call   DWORD PTR [IAT_CreateFileA]
.org 0x13f
L_1000113f:
    xor    ecx,ecx
.org 0x141
L_10001141:
    cmp    eax,0xffffffff
.org 0x144
L_10001144:
    # je     L_1000132a
    .byte 0xf,0x84
    .long L_1000132a - . - 4
.org 0x14a
L_1000114a:
    mov    esi,eax
.org 0x14c
L_1000114c:
    mov    DWORD PTR [esp],0x0
.org 0x153
L_10001153:
    mov    edi,esp
.org 0x155
L_10001155:
    lea    ebx,[esp+0x1c]
.org 0x159
L_10001159:
    push   0x0
.org 0x15b
L_1000115b:
    push   edi
.org 0x15c
L_1000115c:
    push   0x34
.org 0x15e
L_1000115e:
    push   ebx
.org 0x15f
L_1000115f:
    push   eax
.org 0x160
L_10001160:
    call   DWORD PTR [IAT_ReadFile]
.org 0x166
L_10001166:
    test   eax,eax
.org 0x168
L_10001168:
    # je     L_100012e1
    .byte 0xf,0x84
    .long L_100012e1 - . - 4
.org 0x16e
L_1000116e:
    mov    DWORD PTR [esp+0x4],0x0
.org 0x176
L_10001176:
    cmp    DWORD PTR [esp],0x34
.org 0x17a
L_1000117a:
    # jne    L_1000131f
    .byte 0xf,0x85
    .long L_1000131f - . - 4
.org 0x180
L_10001180:
    mov    ebp,DWORD PTR [IAT_ReadFile]
.org 0x186
L_10001186:
    mov    DWORD PTR [esp+0x10],esi
.org 0x18a
L_1000118a:
    # Alignment padding: nop    WORD PTR [eax+eax*1+0x0]
    .byte 0x66,0xf,0x1f,0x44,0x0,0x0
.org 0x190
L_10001190:
    cmp    DWORD PTR [esp+0x1c],0x4c444846
.org 0x198
L_10001198:
    # jne    L_100012c1
    .byte 0xf,0x85
    .long L_100012c1 - . - 4
.org 0x19e
L_1000119e:
    cmp    DWORD PTR [esp+0x20],0x10001
.org 0x1a6
L_100011a6:
    # jne    L_100012c1
    .byte 0xf,0x85
    .long L_100012c1 - . - 4
.org 0x1ac
L_100011ac:
    mov    edx,DWORD PTR [esp+0x24]
.org 0x1b0
L_100011b0:
    mov    eax,DWORD PTR [esp+0x28]
.org 0x1b4
L_100011b4:
    mov    DWORD PTR [esp+0x18],edx
.org 0x1b8
L_100011b8:
    xor    edx,0x345a6785
.org 0x1be
L_100011be:
    imul   edx,edx,0x1000193
.org 0x1c4
L_100011c4:
    mov    esi,eax
.org 0x1c6
L_100011c6:
    xor    esi,edx
.org 0x1c8
L_100011c8:
    shr    edx,0xd
.org 0x1cb
L_100011cb:
    xor    edx,esi
.org 0x1cd
L_100011cd:
    imul   esi,edx,0x1000193
.org 0x1d3
L_100011d3:
    mov    ebx,DWORD PTR [esp+0x2c]
.org 0x1d7
L_100011d7:
    mov    DWORD PTR [esp+0x14],ebx
.org 0x1db
L_100011db:
    xor    ebx,esi
.org 0x1dd
L_100011dd:
    shr    esi,0xd
.org 0x1e0
L_100011e0:
    xor    esi,ebx
.org 0x1e2
L_100011e2:
    imul   esi,esi,0x1000193
.org 0x1e8
L_100011e8:
    mov    ebx,DWORD PTR [esp+0x30]
.org 0x1ec
L_100011ec:
    mov    edx,ebp
.org 0x1ee
L_100011ee:
    mov    ebp,ebx
.org 0x1f0
L_100011f0:
    xor    ebp,esi
.org 0x1f2
L_100011f2:
    shr    esi,0xd
.org 0x1f5
L_100011f5:
    xor    esi,ebp
.org 0x1f7
L_100011f7:
    imul   esi,esi,0x1000193
.org 0x1fd
L_100011fd:
    mov    edi,DWORD PTR [esp+0x34]
.org 0x201
L_10001201:
    mov    ebp,edi
.org 0x203
L_10001203:
    xor    ebp,esi
.org 0x205
L_10001205:
    shr    esi,0xd
.org 0x208
L_10001208:
    xor    esi,ebp
.org 0x20a
L_1000120a:
    imul   ebp,esi,0x1000193
.org 0x210
L_10001210:
    mov    ecx,DWORD PTR [esp+0x38]
.org 0x214
L_10001214:
    mov    esi,ecx
.org 0x216
L_10001216:
    xor    esi,ebp
.org 0x218
L_10001218:
    shr    ebp,0xd
.org 0x21b
L_1000121b:
    xor    ebp,esi
.org 0x21d
L_1000121d:
    imul   esi,ebp,0x1000193
.org 0x223
L_10001223:
    mov    ebp,esi
.org 0x225
L_10001225:
    shr    ebp,0xd
.org 0x228
L_10001228:
    xor    ebp,DWORD PTR [esp+0x3c]
.org 0x22c
L_1000122c:
    xor    ebp,esi
.org 0x22e
L_1000122e:
    imul   esi,ebp,0x1000193
.org 0x234
L_10001234:
    mov    ebp,esi
.org 0x236
L_10001236:
    shr    ebp,0xd
.org 0x239
L_10001239:
    xor    ebp,DWORD PTR [esp+0x40]
.org 0x23d
L_1000123d:
    xor    ebp,esi
.org 0x23f
L_1000123f:
    imul   esi,ebp,0x1000193
.org 0x245
L_10001245:
    mov    ebp,esi
.org 0x247
L_10001247:
    shr    ebp,0xd
.org 0x24a
L_1000124a:
    xor    ebp,DWORD PTR [esp+0x44]
.org 0x24e
L_1000124e:
    xor    ebp,esi
.org 0x250
L_10001250:
    imul   esi,ebp,0x1000193
.org 0x256
L_10001256:
    mov    ebp,esi
.org 0x258
L_10001258:
    shr    ebp,0xd
.org 0x25b
L_1000125b:
    xor    ebp,DWORD PTR [esp+0x48]
.org 0x25f
L_1000125f:
    xor    ebp,esi
.org 0x261
L_10001261:
    imul   esi,ebp,0x1000193
.org 0x267
L_10001267:
    mov    ebp,esi
.org 0x269
L_10001269:
    shr    ebp,0xd
.org 0x26c
L_1000126c:
    xor    ebp,DWORD PTR [esp+0x4c]
.org 0x270
L_10001270:
    xor    ebp,esi
.org 0x272
L_10001272:
    mov    esi,DWORD PTR [esp+0x10]
.org 0x276
L_10001276:
    cmp    ebp,0xf4d5c39b
.org 0x27c
L_1000127c:
    mov    ebp,edx
.org 0x27e
L_1000127e:
    setne  dl
.org 0x281
L_10001281:
    cmp    ebx,0x15
.org 0x284
L_10001284:
    setae  dh
.org 0x287
L_10001287:
    cmp    edi,0x15
.org 0x28a
L_1000128a:
    mov    edi,esp
.org 0x28c
L_1000128c:
    setae  bl
.org 0x28f
L_1000128f:
    or     bl,dh
.org 0x291
L_10001291:
    cmp    ecx,0x4
.org 0x294
L_10001294:
    setae  cl
.org 0x297
L_10001297:
    or     cl,bl
.org 0x299
L_10001299:
    lea    ebx,[esp+0x1c]
.org 0x29d
L_1000129d:
    or     cl,dl
.org 0x29f
L_1000129f:
    cmp    cl,0x1
.org 0x2a2
L_100012a2:
    # je     L_100012c1
    .byte 0x74
    .byte L_100012c1 - . - 1
.org 0x2a4
L_100012a4:
    mov    ecx,DWORD PTR [esp+0x18]
.org 0x2a8
L_100012a8:
    xor    ecx,DWORD PTR [esp+0x8]
.org 0x2ac
L_100012ac:
    xor    eax,DWORD PTR [esp+0xc]
.org 0x2b0
L_100012b0:
    or     eax,ecx
.org 0x2b2
L_100012b2:
    mov    ecx,DWORD PTR [esp+0x14]
.org 0x2b6
L_100012b6:
    xor    ecx,DWORD PTR [esp+0x364]
.org 0x2bd
L_100012bd:
    or     ecx,eax
.org 0x2bf
L_100012bf:
    # je     L_100012eb
    .byte 0x74
    .byte L_100012eb - . - 1
.org 0x2c1
L_100012c1:
    mov    DWORD PTR [esp],0x0
.org 0x2c8
L_100012c8:
    push   0x0
.org 0x2ca
L_100012ca:
    push   edi
.org 0x2cb
L_100012cb:
    push   0x34
.org 0x2cd
L_100012cd:
    push   ebx
.org 0x2ce
L_100012ce:
    push   esi
.org 0x2cf
L_100012cf:
    call   ebp
.org 0x2d1
L_100012d1:
    test   eax,eax
.org 0x2d3
L_100012d3:
    # je     L_1000131f
    .byte 0x74
    .byte L_1000131f - . - 1
.org 0x2d5
L_100012d5:
    cmp    DWORD PTR [esp],0x34
.org 0x2d9
L_100012d9:
    # je     L_10001190
    .byte 0xf,0x84
    .long L_10001190 - . - 4
.org 0x2df
L_100012df:
    # jmp    L_1000131f
    .byte 0xeb
    .byte L_1000131f - . - 1
.org 0x2e1
L_100012e1:
    mov    DWORD PTR [esp+0x4],0x0
.org 0x2e9
L_100012e9:
    # jmp    L_1000131f
    .byte 0xeb
    .byte L_1000131f - . - 1
.org 0x2eb
L_100012eb:
    mov    DWORD PTR [esp+0x4],0x1
.org 0x2f3
L_100012f3:
    mov    ecx,DWORD PTR [esp+0x368]
.org 0x2fa
L_100012fa:
    test   ecx,ecx
.org 0x2fc
L_100012fc:
    # je     L_1000131f
    .byte 0x74
    .byte L_1000131f - . - 1
.org 0x2fe
L_100012fe:
    mov    eax,DWORD PTR [esp+0x4c]
.org 0x302
L_10001302:
    mov    DWORD PTR [ecx+0x30],eax
.org 0x305
L_10001305:
    movups xmm0,XMMWORD PTR [esp+0x3c]
.org 0x30a
L_1000130a:
    movups XMMWORD PTR [ecx+0x20],xmm0
.org 0x30e
L_1000130e:
    movups xmm0,XMMWORD PTR [esp+0x1c]
.org 0x313
L_10001313:
    movups xmm1,XMMWORD PTR [esp+0x2c]
.org 0x318
L_10001318:
    movups XMMWORD PTR [ecx+0x10],xmm1
.org 0x31c
L_1000131c:
    movups XMMWORD PTR [ecx],xmm0
.org 0x31f
L_1000131f:
    push   esi
.org 0x320
L_10001320:
    call   DWORD PTR [IAT_CloseHandle]
.org 0x326
L_10001326:
    mov    ecx,DWORD PTR [esp+0x4]
.org 0x32a
L_1000132a:
    mov    eax,ecx
.org 0x32c
L_1000132c:
    add    esp,0x350
.org 0x332
L_10001332:
    pop    esi
.org 0x333
L_10001333:
    pop    edi
.org 0x334
L_10001334:
    pop    ebx
.org 0x335
L_10001335:
    pop    ebp
.org 0x336
L_10001336:
    ret
.org 0x337
L_10001337:
    # Alignment padding: nop    WORD PTR [eax+eax*1+0x0]
    .byte 0x66,0xf,0x1f,0x84,0x0,0x0,0x0,0x0,0x0
.org 0x340
L_10001340:
.global LotteryGetField
LotteryGetField:
    sub    esp,0x34
.org 0x343
L_10001343:
    mov    ecx,DWORD PTR [esp+0x38]
.org 0x347
L_10001347:
    mov    edx,DWORD PTR [esp+0x3c]
.org 0x34b
L_1000134b:
    mov    eax,esp
.org 0x34d
L_1000134d:
    push   eax
.org 0x34e
L_1000134e:
    push   DWORD PTR [esp+0x44]
.org 0x352
L_10001352:
    # call   L_100010f0
    .byte 0xe8
    .long L_100010f0 - . - 4
.org 0x357
L_10001357:
    add    esp,0x8
.org 0x35a
L_1000135a:
    mov    ecx,eax
.org 0x35c
L_1000135c:
    mov    eax,0xffffffff
.org 0x361
L_10001361:
    test   ecx,ecx
.org 0x363
L_10001363:
    # je     L_100013a9
    .byte 0x74
    .byte L_100013a9 - . - 1
.org 0x365
L_10001365:
    mov    ecx,DWORD PTR [esp+0x44]
.org 0x369
L_10001369:
    cmp    ecx,0x6
.org 0x36c
L_1000136c:
    # ja     L_100013a9
    .byte 0x77
    .byte L_100013a9 - . - 1
.org 0x36e
L_1000136e:
    jmp    DWORD PTR [ecx*4+field_dispatch]
.org 0x375
L_10001375:
    mov    eax,DWORD PTR [esp+0x14]
.org 0x379
L_10001379:
    add    esp,0x34
.org 0x37c
L_1000137c:
    ret
.org 0x37d
L_1000137d:
    mov    eax,DWORD PTR [esp+0x24]
.org 0x381
L_10001381:
    add    esp,0x34
.org 0x384
L_10001384:
    ret
.org 0x385
L_10001385:
    mov    eax,DWORD PTR [esp+0x1c]
.org 0x389
L_10001389:
    add    esp,0x34
.org 0x38c
L_1000138c:
    ret
.org 0x38d
L_1000138d:
    mov    eax,DWORD PTR [esp+0x20]
.org 0x391
L_10001391:
    add    esp,0x34
.org 0x394
L_10001394:
    ret
.org 0x395
L_10001395:
    mov    eax,DWORD PTR [esp+0x18]
.org 0x399
L_10001399:
    add    esp,0x34
.org 0x39c
L_1000139c:
    ret
.org 0x39d
L_1000139d:
    mov    eax,DWORD PTR [esp+0x28]
.org 0x3a1
L_100013a1:
    add    esp,0x34
.org 0x3a4
L_100013a4:
    ret
.org 0x3a5
L_100013a5:
    mov    eax,DWORD PTR [esp+0x2c]
.org 0x3a9
L_100013a9:
    add    esp,0x34
.org 0x3ac
L_100013ac:
    ret
.org 0x3ad
L_100013ad:
    # Alignment padding: nop    DWORD PTR [eax]
    .byte 0xf,0x1f,0x0
.org 0x3b0
L_100013b0:
.global LotteryCommit
LotteryCommit:
    push   ebp
.org 0x3b1
L_100013b1:
    push   ebx
.org 0x3b2
L_100013b2:
    push   edi
.org 0x3b3
L_100013b3:
    push   esi
.org 0x3b4
L_100013b4:
    sub    esp,0x338
.org 0x3ba
L_100013ba:
    mov    ebx,DWORD PTR [esp+0x354]
.org 0x3c1
L_100013c1:
    mov    esi,DWORD PTR [esp+0x350]
.org 0x3c8
L_100013c8:
    mov    edi,DWORD PTR [esp+0x34c]
.org 0x3cf
L_100013cf:
    mov    ecx,edi
.org 0x3d1
L_100013d1:
    mov    edx,esi
.org 0x3d3
L_100013d3:
    push   0x0
.org 0x3d5
L_100013d5:
    push   ebx
.org 0x3d6
L_100013d6:
    # call   L_100010f0
    .byte 0xe8
    .long L_100010f0 - . - 4
.org 0x3db
L_100013db:
    add    esp,0x8
.org 0x3de
L_100013de:
    mov    ecx,eax
.org 0x3e0
L_100013e0:
    mov    eax,0x2
.org 0x3e5
L_100013e5:
    test   ecx,ecx
.org 0x3e7
L_100013e7:
    # jne    L_10001599
    .byte 0xf,0x85
    .long L_10001599 - . - 4
.org 0x3ed
L_100013ed:
    mov    edx,DWORD PTR [esp+0x35c]
.org 0x3f4
L_100013f4:
    mov    ebp,DWORD PTR [esp+0x358]
.org 0x3fb
L_100013fb:
    cmp    ebp,0x15
.org 0x3fe
L_100013fe:
    setae  al
.org 0x401
L_10001401:
    cmp    edx,0x15
.org 0x404
L_10001404:
    setae  cl
.org 0x407
L_10001407:
    or     cl,al
.org 0x409
L_10001409:
    cmp    DWORD PTR [esp+0x360],0x4
.org 0x411
L_10001411:
    setae  ch
.org 0x414
L_10001414:
    xor    eax,eax
.org 0x416
L_10001416:
    or     ch,cl
.org 0x418
L_10001418:
    # jne    L_10001599
    .byte 0xf,0x85
    .long L_10001599 - . - 4
.org 0x41e
L_1000141e:
    mov    DWORD PTR [esp+0x4],0x4c444846
.org 0x426
L_10001426:
    mov    DWORD PTR [esp+0x8],0x10001
.org 0x42e
L_1000142e:
    mov    DWORD PTR [esp+0xc],edi
.org 0x432
L_10001432:
    mov    DWORD PTR [esp+0x10],esi
.org 0x436
L_10001436:
    xor    edi,0x345a6785
.org 0x43c
L_1000143c:
    imul   eax,edi,0x1000193
.org 0x442
L_10001442:
    xor    esi,eax
.org 0x444
L_10001444:
    shr    eax,0xd
.org 0x447
L_10001447:
    xor    eax,esi
.org 0x449
L_10001449:
    mov    DWORD PTR [esp+0x14],ebx
.org 0x44d
L_1000144d:
    imul   eax,eax,0x1000193
.org 0x453
L_10001453:
    xor    ebx,eax
.org 0x455
L_10001455:
    shr    eax,0xd
.org 0x458
L_10001458:
    xor    eax,ebx
.org 0x45a
L_1000145a:
    mov    DWORD PTR [esp+0x18],ebp
.org 0x45e
L_1000145e:
    imul   eax,eax,0x1000193
.org 0x464
L_10001464:
    xor    ebp,eax
.org 0x466
L_10001466:
    shr    eax,0xd
.org 0x469
L_10001469:
    xor    eax,ebp
.org 0x46b
L_1000146b:
    mov    DWORD PTR [esp+0x1c],edx
.org 0x46f
L_1000146f:
    imul   eax,eax,0x1000193
.org 0x475
L_10001475:
    xor    edx,eax
.org 0x477
L_10001477:
    shr    eax,0xd
.org 0x47a
L_1000147a:
    xor    eax,edx
.org 0x47c
L_1000147c:
    mov    ecx,DWORD PTR [esp+0x360]
.org 0x483
L_10001483:
    mov    DWORD PTR [esp+0x20],ecx
.org 0x487
L_10001487:
    imul   eax,eax,0x1000193
.org 0x48d
L_1000148d:
    xor    ecx,eax
.org 0x48f
L_1000148f:
    shr    eax,0xd
.org 0x492
L_10001492:
    xor    eax,ecx
.org 0x494
L_10001494:
    mov    ecx,DWORD PTR [esp+0x364]
.org 0x49b
L_1000149b:
    mov    DWORD PTR [esp+0x24],ecx
.org 0x49f
L_1000149f:
    imul   eax,eax,0x1000193
.org 0x4a5
L_100014a5:
    xor    ecx,eax
.org 0x4a7
L_100014a7:
    shr    eax,0xd
.org 0x4aa
L_100014aa:
    xor    eax,ecx
.org 0x4ac
L_100014ac:
    mov    ecx,DWORD PTR [esp+0x368]
.org 0x4b3
L_100014b3:
    mov    DWORD PTR [esp+0x28],ecx
.org 0x4b7
L_100014b7:
    imul   eax,eax,0x1000193
.org 0x4bd
L_100014bd:
    xor    ecx,eax
.org 0x4bf
L_100014bf:
    shr    eax,0xd
.org 0x4c2
L_100014c2:
    xor    eax,ecx
.org 0x4c4
L_100014c4:
    mov    ecx,DWORD PTR [esp+0x36c]
.org 0x4cb
L_100014cb:
    mov    DWORD PTR [esp+0x2c],ecx
.org 0x4cf
L_100014cf:
    imul   eax,eax,0x1000193
.org 0x4d5
L_100014d5:
    xor    ecx,eax
.org 0x4d7
L_100014d7:
    shr    eax,0xd
.org 0x4da
L_100014da:
    xor    eax,ecx
.org 0x4dc
L_100014dc:
    mov    ecx,DWORD PTR [esp+0x370]
.org 0x4e3
L_100014e3:
    mov    DWORD PTR [esp+0x30],ecx
.org 0x4e7
L_100014e7:
    imul   eax,eax,0x1000193
.org 0x4ed
L_100014ed:
    xor    ecx,eax
.org 0x4ef
L_100014ef:
    shr    eax,0xd
.org 0x4f2
L_100014f2:
    xor    eax,ecx
.org 0x4f4
L_100014f4:
    imul   eax,eax,0x1000193
.org 0x4fa
L_100014fa:
    mov    ecx,eax
.org 0x4fc
L_100014fc:
    shr    ecx,0xd
.org 0x4ff
L_100014ff:
    xor    ecx,eax
.org 0x501
L_10001501:
    xor    ecx,0xf4d5c39b
.org 0x507
L_10001507:
    mov    DWORD PTR [esp+0x34],ecx
.org 0x50b
L_1000150b:
    mov    DWORD PTR [esp],0x0
.org 0x512
L_10001512:
    lea    esi,[esp+0x38]
.org 0x516
L_10001516:
    mov    ecx,esi
.org 0x518
L_10001518:
    # call   L_100015b0
    .byte 0xe8
    .long L_100015b0 - . - 4
.org 0x51d
L_1000151d:
    mov    ecx,eax
.org 0x51f
L_1000151f:
    xor    eax,eax
.org 0x521
L_10001521:
    test   ecx,ecx
.org 0x523
L_10001523:
    # je     L_10001599
    .byte 0x74
    .byte L_10001599 - . - 1
.org 0x525
L_10001525:
    sub    esp,0x1c
.org 0x528
L_10001528:
    movaps xmm0,XMMWORD PTR [append_open_arguments]
.org 0x52f
L_1000152f:
    movups XMMWORD PTR [esp+0x4],xmm0
.org 0x534
L_10001534:
    mov    DWORD PTR [esp],esi
.org 0x537
L_10001537:
    mov    DWORD PTR [esp+0x18],0x0
.org 0x53f
L_1000153f:
    mov    DWORD PTR [esp+0x14],0x80
.org 0x547
L_10001547:
    call   DWORD PTR [IAT_CreateFileA]
.org 0x54d
L_1000154d:
    mov    esi,eax
.org 0x54f
L_1000154f:
    xor    eax,eax
.org 0x551
L_10001551:
    cmp    esi,0xffffffff
.org 0x554
L_10001554:
    # je     L_10001599
    .byte 0x74
    .byte L_10001599 - . - 1
.org 0x556
L_10001556:
    push   0x2
.org 0x558
L_10001558:
    push   0x0
.org 0x55a
L_1000155a:
    push   0x0
.org 0x55c
L_1000155c:
    push   esi
.org 0x55d
L_1000155d:
    call   DWORD PTR [IAT_SetFilePointer]
.org 0x563
L_10001563:
    mov    eax,esp
.org 0x565
L_10001565:
    lea    ecx,[esp+0x4]
.org 0x569
L_10001569:
    push   0x0
.org 0x56b
L_1000156b:
    push   eax
.org 0x56c
L_1000156c:
    push   0x34
.org 0x56e
L_1000156e:
    push   ecx
.org 0x56f
L_1000156f:
    push   esi
.org 0x570
L_10001570:
    call   DWORD PTR [IAT_WriteFile]
.org 0x576
L_10001576:
    xor    ecx,ecx
.org 0x578
L_10001578:
    test   eax,eax
.org 0x57a
L_1000157a:
    # je     L_1000158e
    .byte 0x74
    .byte L_1000158e - . - 1
.org 0x57c
L_1000157c:
    cmp    DWORD PTR [esp],0x34
.org 0x580
L_10001580:
    # jne    L_1000158e
    .byte 0x75
    .byte L_1000158e - . - 1
.org 0x582
L_10001582:
    push   esi
.org 0x583
L_10001583:
    call   DWORD PTR [IAT_FlushFileBuffers]
.org 0x589
L_10001589:
    mov    ecx,0x1
.org 0x58e
L_1000158e:
    push   esi
.org 0x58f
L_1000158f:
    mov    esi,ecx
.org 0x591
L_10001591:
    call   DWORD PTR [IAT_CloseHandle]
.org 0x597
L_10001597:
    mov    eax,esi
.org 0x599
L_10001599:
    add    esp,0x338
.org 0x59f
L_1000159f:
    pop    esi
.org 0x5a0
L_100015a0:
    pop    edi
.org 0x5a1
L_100015a1:
    pop    ebx
.org 0x5a2
L_100015a2:
    pop    ebp
.org 0x5a3
L_100015a3:
    ret
.org 0x5a4
L_100015a4:
    # Alignment padding: data16 data16 nop WORD PTR cs:[eax+eax*1+0x0]
    .byte 0x66,0x66,0x66,0x2e,0xf,0x1f,0x84,0x0,0x0,0x0,0x0,0x0
.org 0x5b0
L_100015b0:
.global BuildJournalPath
BuildJournalPath:
    push   ebp
.org 0x5b1
L_100015b1:
    push   ebx
.org 0x5b2
L_100015b2:
    push   edi
.org 0x5b3
L_100015b3:
    push   esi
.org 0x5b4
L_100015b4:
    push   eax
.org 0x5b5
L_100015b5:
    mov    esi,ecx
.org 0x5b7
L_100015b7:
    mov    edi,0xfffffff4
.org 0x5bc
L_100015bc:
    mov    ebx,DWORD PTR [IAT_GetEnvironmentVariableA]
.org 0x5c2
L_100015c2:
    mov    ebp,DWORD PTR [IAT_CreateDirectoryA]
.org 0x5c8
L_100015c8:
    # jmp    L_100015d9
    .byte 0xeb
    .byte L_100015d9 - . - 1
.org 0x5ca
L_100015ca:
    # Alignment padding: nop    WORD PTR [eax+eax*1+0x0]
    .byte 0x66,0xf,0x1f,0x44,0x0,0x0
.org 0x5d0
L_100015d0:
    add    edi,0x4
.org 0x5d3
L_100015d3:
    # je     L_1000185d
    .byte 0xf,0x84
    .long L_1000185d - . - 4
.org 0x5d9
L_100015d9:
    push   0x300
.org 0x5de
L_100015de:
    push   esi
.org 0x5df
L_100015df:
    push   DWORD PTR [edi+environment_order_end]
.org 0x5e5
L_100015e5:
    call   ebx
.org 0x5e7
L_100015e7:
    lea    ecx,[eax-0x300]
.org 0x5ed
L_100015ed:
    cmp    ecx,0xfffffd01
.org 0x5f3
L_100015f3:
    # jb     L_100015d0
    .byte 0x72
    .byte L_100015d0 - . - 1
.org 0x5f5
L_100015f5:
    movzx  ecx,BYTE PTR [esi+eax*1-0x1]
.org 0x5fa
L_100015fa:
    cmp    ecx,0x2f
.org 0x5fd
L_100015fd:
    # je     L_10001620
    .byte 0x74
    .byte L_10001620 - . - 1
.org 0x5ff
L_100015ff:
    cmp    ecx,0x5c
.org 0x602
L_10001602:
    # je     L_10001620
    .byte 0x74
    .byte L_10001620 - . - 1
.org 0x604
L_10001604:
    cmp    eax,0x2ff
.org 0x609
L_10001609:
    # je     L_100015d0
    .byte 0x74
    .byte L_100015d0 - . - 1
.org 0x60b
L_1000160b:
    mov    WORD PTR [esi+eax*1],0x5c
.org 0x611
L_10001611:
    inc    eax
.org 0x612
L_10001612:
    # Alignment padding: data16 data16 data16 data16 nop WORD PTR cs:[eax+eax*1+0x0]
    .byte 0x66,0x66,0x66,0x66,0x66,0x2e,0xf,0x1f,0x84,0x0,0x0,0x0,0x0,0x0
.org 0x620
L_10001620:
    cmp    eax,0x2fe
.org 0x625
L_10001625:
    # ja     L_100015d0
    .byte 0x77
    .byte L_100015d0 - . - 1
.org 0x627
L_10001627:
    mov    BYTE PTR [esi+eax*1],0x46
.org 0x62b
L_1000162b:
    # je     L_100015d0
    .byte 0x74
    .byte L_100015d0 - . - 1
.org 0x62d
L_1000162d:
    mov    BYTE PTR [esi+eax*1+0x1],0x48
.org 0x632
L_10001632:
    cmp    eax,0x2fc
.org 0x637
L_10001637:
    # ja     L_100015d0
    .byte 0x77
    .byte L_100015d0 - . - 1
.org 0x639
L_10001639:
    mov    BYTE PTR [esi+eax*1+0x2],0x44
.org 0x63e
L_1000163e:
    # je     L_100015d0
    .byte 0x74
    .byte L_100015d0 - . - 1
.org 0x640
L_10001640:
    mov    BYTE PTR [esi+eax*1+0x3],0x5f
.org 0x645
L_10001645:
    cmp    eax,0x2fa
.org 0x64a
L_1000164a:
    # ja     L_100015d0
    .byte 0x77
    .byte L_100015d0 - . - 1
.org 0x64c
L_1000164c:
    mov    BYTE PTR [esi+eax*1+0x4],0x53
.org 0x651
L_10001651:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x657
L_10001657:
    mov    BYTE PTR [esi+eax*1+0x5],0x74
.org 0x65c
L_1000165c:
    cmp    eax,0x2f8
.org 0x661
L_10001661:
    # ja     L_100015d0
    .byte 0xf,0x87
    .long L_100015d0 - . - 4
.org 0x667
L_10001667:
    mov    BYTE PTR [esi+eax*1+0x6],0x61
.org 0x66c
L_1000166c:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x672
L_10001672:
    mov    BYTE PTR [esi+eax*1+0x7],0x74
.org 0x677
L_10001677:
    cmp    eax,0x2f6
.org 0x67c
L_1000167c:
    # ja     L_100015d0
    .byte 0xf,0x87
    .long L_100015d0 - . - 4
.org 0x682
L_10001682:
    mov    BYTE PTR [esi+eax*1+0x8],0x69
.org 0x687
L_10001687:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x68d
L_1000168d:
    mov    BYTE PTR [esi+eax*1+0x9],0x6f
.org 0x692
L_10001692:
    cmp    eax,0x2f4
.org 0x697
L_10001697:
    # ja     L_100015d0
    .byte 0xf,0x87
    .long L_100015d0 - . - 4
.org 0x69d
L_1000169d:
    mov    BYTE PTR [esi+eax*1+0xa],0x6e
.org 0x6a2
L_100016a2:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x6a8
L_100016a8:
    mov    WORD PTR [esi+eax*1+0xb],0x73
.org 0x6af
L_100016af:
    push   0x0
.org 0x6b1
L_100016b1:
    push   esi
.org 0x6b2
L_100016b2:
    mov    DWORD PTR [esp+0x8],eax
.org 0x6b6
L_100016b6:
    call   ebp
.org 0x6b8
L_100016b8:
    mov    eax,DWORD PTR [esp]
.org 0x6bb
L_100016bb:
    cmp    eax,0x2f3
.org 0x6c0
L_100016c0:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x6c6
L_100016c6:
    lea    ecx,[eax+0xd]
.org 0x6c9
L_100016c9:
    mov    BYTE PTR [esi+eax*1+0xc],0x5c
.org 0x6ce
L_100016ce:
    cmp    ecx,0x2ff
.org 0x6d4
L_100016d4:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x6da
L_100016da:
    lea    ecx,[eax+0xe]
.org 0x6dd
L_100016dd:
    mov    BYTE PTR [esi+eax*1+0xd],0x6c
.org 0x6e2
L_100016e2:
    cmp    ecx,0x2ff
.org 0x6e8
L_100016e8:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x6ee
L_100016ee:
    lea    ecx,[eax+0xf]
.org 0x6f1
L_100016f1:
    mov    BYTE PTR [esi+eax*1+0xe],0x6f
.org 0x6f6
L_100016f6:
    cmp    ecx,0x2ff
.org 0x6fc
L_100016fc:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x702
L_10001702:
    lea    ecx,[eax+0x10]
.org 0x705
L_10001705:
    mov    BYTE PTR [esi+eax*1+0xf],0x74
.org 0x70a
L_1000170a:
    cmp    ecx,0x2ff
.org 0x710
L_10001710:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x716
L_10001716:
    lea    ecx,[eax+0x11]
.org 0x719
L_10001719:
    mov    BYTE PTR [esi+eax*1+0x10],0x74
.org 0x71e
L_1000171e:
    cmp    ecx,0x2ff
.org 0x724
L_10001724:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x72a
L_1000172a:
    lea    ecx,[eax+0x12]
.org 0x72d
L_1000172d:
    mov    BYTE PTR [esi+eax*1+0x11],0x65
.org 0x732
L_10001732:
    cmp    ecx,0x2ff
.org 0x738
L_10001738:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x73e
L_1000173e:
    lea    ecx,[eax+0x13]
.org 0x741
L_10001741:
    mov    BYTE PTR [esi+eax*1+0x12],0x72
.org 0x746
L_10001746:
    cmp    ecx,0x2ff
.org 0x74c
L_1000174c:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x752
L_10001752:
    lea    ecx,[eax+0x14]
.org 0x755
L_10001755:
    mov    BYTE PTR [esi+eax*1+0x13],0x79
.org 0x75a
L_1000175a:
    cmp    ecx,0x2ff
.org 0x760
L_10001760:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x766
L_10001766:
    lea    ecx,[eax+0x15]
.org 0x769
L_10001769:
    mov    BYTE PTR [esi+eax*1+0x14],0x5f
.org 0x76e
L_1000176e:
    cmp    ecx,0x2ff
.org 0x774
L_10001774:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x77a
L_1000177a:
    lea    ecx,[eax+0x16]
.org 0x77d
L_1000177d:
    mov    BYTE PTR [esi+eax*1+0x15],0x67
.org 0x782
L_10001782:
    cmp    ecx,0x2ff
.org 0x788
L_10001788:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x78e
L_1000178e:
    lea    ecx,[eax+0x17]
.org 0x791
L_10001791:
    mov    BYTE PTR [esi+eax*1+0x16],0x75
.org 0x796
L_10001796:
    cmp    ecx,0x2ff
.org 0x79c
L_1000179c:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x7a2
L_100017a2:
    lea    ecx,[eax+0x18]
.org 0x7a5
L_100017a5:
    mov    BYTE PTR [esi+eax*1+0x17],0x61
.org 0x7aa
L_100017aa:
    cmp    ecx,0x2ff
.org 0x7b0
L_100017b0:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x7b6
L_100017b6:
    lea    ecx,[eax+0x19]
.org 0x7b9
L_100017b9:
    mov    BYTE PTR [esi+eax*1+0x18],0x72
.org 0x7be
L_100017be:
    cmp    ecx,0x2ff
.org 0x7c4
L_100017c4:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x7ca
L_100017ca:
    lea    ecx,[eax+0x1a]
.org 0x7cd
L_100017cd:
    mov    BYTE PTR [esi+eax*1+0x19],0x64
.org 0x7d2
L_100017d2:
    cmp    ecx,0x2ff
.org 0x7d8
L_100017d8:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x7de
L_100017de:
    lea    ecx,[eax+0x1b]
.org 0x7e1
L_100017e1:
    mov    BYTE PTR [esi+eax*1+0x1a],0x5f
.org 0x7e6
L_100017e6:
    cmp    ecx,0x2ff
.org 0x7ec
L_100017ec:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x7f2
L_100017f2:
    lea    ecx,[eax+0x1c]
.org 0x7f5
L_100017f5:
    mov    BYTE PTR [esi+eax*1+0x1b],0x76
.org 0x7fa
L_100017fa:
    cmp    ecx,0x2ff
.org 0x800
L_10001800:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x806
L_10001806:
    lea    ecx,[eax+0x1d]
.org 0x809
L_10001809:
    mov    BYTE PTR [esi+eax*1+0x1c],0x31
.org 0x80e
L_1000180e:
    cmp    ecx,0x2ff
.org 0x814
L_10001814:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x81a
L_1000181a:
    lea    ecx,[eax+0x1e]
.org 0x81d
L_1000181d:
    mov    BYTE PTR [esi+eax*1+0x1d],0x2e
.org 0x822
L_10001822:
    cmp    ecx,0x2ff
.org 0x828
L_10001828:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x82e
L_1000182e:
    lea    edx,[eax+0x1f]
.org 0x831
L_10001831:
    mov    BYTE PTR [esi+ecx*1],0x64
.org 0x835
L_10001835:
    cmp    edx,0x2ff
.org 0x83b
L_1000183b:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x841
L_10001841:
    mov    BYTE PTR [esi+eax*1+0x1f],0x61
.org 0x846
L_10001846:
    cmp    eax,0x2df
.org 0x84b
L_1000184b:
    # je     L_100015d0
    .byte 0xf,0x84
    .long L_100015d0 - . - 4
.org 0x851
L_10001851:
    mov    BYTE PTR [esi+eax*1+0x20],0x74
.org 0x856
L_10001856:
    add    esi,eax
.org 0x858
L_10001858:
    add    esi,0x21
.org 0x85b
L_1000185b:
    # jmp    L_1000189c
    .byte 0xeb
    .byte L_1000189c - . - 1
.org 0x85d
L_1000185d:
    movsd  xmm0,QWORD PTR [relative_prefix]
.org 0x865
L_10001865:
    movsd  QWORD PTR [esi],xmm0
.org 0x869
L_10001869:
    mov    DWORD PTR [esi+0x8],0x6f697461
.org 0x870
L_10001870:
    mov    WORD PTR [esi+0xc],0x736e
.org 0x876
L_10001876:
    mov    BYTE PTR [esi+0xe],0x0
.org 0x87a
L_1000187a:
    push   0x0
.org 0x87c
L_1000187c:
    push   esi
.org 0x87d
L_1000187d:
    call   DWORD PTR [IAT_CreateDirectoryA]
.org 0x883
L_10001883:
    movaps xmm0,XMMWORD PTR [journal_suffix_prefix]
.org 0x88a
L_1000188a:
    movups XMMWORD PTR [esi+0xe],xmm0
.org 0x88e
L_1000188e:
    mov    DWORD PTR [esi+0x1e],0x61642e31
.org 0x895
L_10001895:
    mov    BYTE PTR [esi+0x22],0x74
.org 0x899
L_10001899:
    add    esi,0x23
.org 0x89c
L_1000189c:
    mov    BYTE PTR [esi],0x0
.org 0x89f
L_1000189f:
    mov    eax,0x1
.org 0x8a4
L_100018a4:
    add    esp,0x4
.org 0x8a7
L_100018a7:
    pop    esi
.org 0x8a8
L_100018a8:
    pop    edi
.org 0x8a9
L_100018a9:
    pop    ebx
.org 0x8aa
L_100018aa:
    pop    ebp
.org 0x8ab
L_100018ab:
    ret
.org 0x8ac
.section .rdata,"a",@progbits
field_dispatch:
    .long L_10001375
    .long L_10001395
    .long L_10001385
    .long L_1000138d
    .long L_1000137d
    .long L_1000139d
    .long L_100013a5
environment_order:
    .long env_localappdata,env_appdata,env_temp
environment_order_end:
.org 0x30
read_open_arguments:
    .long 0x80000000,3,0,3
append_open_arguments:
    .long 0xc0000000,1,0,4
relative_prefix:
    .ascii ".\\FHD_St"
.org 0x60
journal_suffix_prefix:
    .ascii "\\lottery_guard_v"
env_temp: .asciz "TEMP"
env_localappdata: .ascii "LOCAL"
env_appdata: .asciz "APPDATA"
.org 0x82
export_directory:
    .long 0,0
    .short 0,0
    .long export_dll_name-0x10000000,1,4,4
    .long export_functions-0x10000000,export_names-0x10000000,export_ordinals-0x10000000
export_dll_name: .asciz "FHDStationsLotteryNative_v46.dll"
export_functions:
    .long LotteryCommit-0x10000000,LotteryGetField-0x10000000,LotteryHasRecord-0x10000000,LotteryNumber-0x10000000
export_names:
    .long export_Commit-0x10000000,export_GetField-0x10000000,export_HasRecord-0x10000000,export_Number-0x10000000
export_ordinals: .short 0,1,2,3
export_Commit: .asciz "LotteryCommit"
export_GetField: .asciz "LotteryGetField"
export_HasRecord: .asciz "LotteryHasRecord"
export_Number: .asciz "LotteryNumber"
.org 0x130
import_directory:
    .long import_lookup-0x10000000,0,0,import_dll_name-0x10000000,import_addresses-0x10000000
    .long 0,0,0,0,0
import_lookup:
    .long hint_CloseHandle-0x10000000
    .long hint_CreateDirectoryA-0x10000000
    .long hint_CreateFileA-0x10000000
    .long hint_FlushFileBuffers-0x10000000
    .long hint_GetCurrentProcessId-0x10000000
    .long hint_GetCurrentThreadId-0x10000000
    .long hint_GetEnvironmentVariableA-0x10000000
    .long hint_GetTickCount-0x10000000
    .long hint_ReadFile-0x10000000
    .long hint_SetFilePointer-0x10000000
    .long hint_WriteFile-0x10000000
    .long 0
import_addresses:
IAT_CloseHandle:
    .long hint_CloseHandle-0x10000000
IAT_CreateDirectoryA:
    .long hint_CreateDirectoryA-0x10000000
IAT_CreateFileA:
    .long hint_CreateFileA-0x10000000
IAT_FlushFileBuffers:
    .long hint_FlushFileBuffers-0x10000000
IAT_GetCurrentProcessId:
    .long hint_GetCurrentProcessId-0x10000000
IAT_GetCurrentThreadId:
    .long hint_GetCurrentThreadId-0x10000000
IAT_GetEnvironmentVariableA:
    .long hint_GetEnvironmentVariableA-0x10000000
IAT_GetTickCount:
    .long hint_GetTickCount-0x10000000
IAT_ReadFile:
    .long hint_ReadFile-0x10000000
IAT_SetFilePointer:
    .long hint_SetFilePointer-0x10000000
IAT_WriteFile:
    .long hint_WriteFile-0x10000000
    .long 0
    .balign 2,0
hint_CloseHandle: .short 0
    .asciz "CloseHandle"
    .balign 2,0
hint_CreateDirectoryA: .short 0
    .asciz "CreateDirectoryA"
    .balign 2,0
hint_CreateFileA: .short 0
    .asciz "CreateFileA"
    .balign 2,0
hint_FlushFileBuffers: .short 0
    .asciz "FlushFileBuffers"
    .balign 2,0
hint_GetCurrentProcessId: .short 0
    .asciz "GetCurrentProcessId"
    .balign 2,0
hint_GetCurrentThreadId: .short 0
    .asciz "GetCurrentThreadId"
    .balign 2,0
hint_GetEnvironmentVariableA: .short 0
    .asciz "GetEnvironmentVariableA"
    .balign 2,0
hint_GetTickCount: .short 0
    .asciz "GetTickCount"
    .balign 2,0
hint_ReadFile: .short 0
    .asciz "ReadFile"
    .balign 2,0
hint_SetFilePointer: .short 0
    .asciz "SetFilePointer"
    .balign 2,0
hint_WriteFile: .short 0
    .asciz "WriteFile"
import_dll_name: .asciz "KERNEL32.dll"
.section .data,"aw",@progbits
last_number: .long 0xffffffff
entropy_counter: .long 0

/* Original 16-bit DOS loader stub; not a DLL execution entry point. */
.section .dosstub,"a",@progbits
.code16
    push cs
    pop ds
    mov dx,14
    mov ah,9
    int 0x21
    mov ax,0x4c01
    int 0x21
    .ascii "This program cannot be run in DOS mode.$"
    .zero 2
.code32
