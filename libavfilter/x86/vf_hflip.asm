;*****************************************************************************
;* x86-optimized functions for hflip filter
;*
;* Copyright (C) 2017 Paul B Mahol
;*
;* This file is part of FFmpeg.
;*
;* FFmpeg is free software; you can redistribute it and/or
;* modify it under the terms of the GNU Lesser General Public
;* License as published by the Free Software Foundation; either
;* version 2.1 of the License, or (at your option) any later version.
;*
;* FFmpeg is distributed in the hope that it will be useful,
;* but WITHOUT ANY WARRANTY; without even the implied warranty of
;* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;* Lesser General Public License for more details.
;*
;* You should have received a copy of the GNU Lesser General Public
;* License along with FFmpeg; if not, write to the Free Software
;* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
;*****************************************************************************

%include "libavutil/x86/x86util.asm"

SECTION_RODATA

pb_flip_byte:  db 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
pb_flip_short: db 14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1

SECTION .text

INIT_XMM ssse3
cglobal hflip_byte, 3, 6, 3, src, dst, w, x, v, r
    mova    m0, [pb_flip_byte]
    mov     xq, 0
    mov     wd, dword wm
    mov     rq, wq
    and     rq, 2 * mmsize - 1
    cmp     wq, 2 * mmsize
    jl .loop1
    sub     wq, rq

    .loop0:
        neg     xq
        movu    m1, [srcq + xq -     mmsize + 1]
        movu    m2, [srcq + xq - 2 * mmsize + 1]
        pshufb  m1, m0
        pshufb  m2, m0
        neg     xq
        movu    [dstq + xq         ], m1
        movu    [dstq + xq + mmsize], m2
        add     xq, mmsize * 2
        cmp     xq, wq
        jl .loop0

        cmp    rq, 0
        je .end
        add    wq, rq

    .loop1:
        neg    xq
        mov    vb, [srcq + xq]
        neg    xq
        mov    [dstq + xq], vb
        add    xq, 1
        cmp    xq, wq
        jl .loop1
    .end:
RET

cglobal hflip_short, 3, 6, 3, src, dst, w, x, v, r
    mova    m0, [pb_flip_short]
    mov     xq, 0
    mov     wd, dword wm
    add     wq, wq
    mov     rq, wq
    and     rq, 2 * mmsize - 1
    cmp     wq, 2 * mmsize
    jl .loop1
    sub     wq, rq

    .loop0:
        neg     xq
        movu    m1, [srcq + xq -     mmsize + 2]
        movu    m2, [srcq + xq - 2 * mmsize + 2]
        pshufb  m1, m0
        pshufb  m2, m0
        neg     xq
        movu    [dstq + xq         ], m1
        movu    [dstq + xq + mmsize], m2
        add     xq, mmsize * 2
        cmp     xq, wq
        jl .loop0

        cmp    rq, 0
        je .end
        add    wq, rq

    .loop1:
        neg    xq
        mov    vw, [srcq + xq]
        neg    xq
        mov    [dstq + xq], vw
        add    xq, 2
        cmp    xq, wq
        jl .loop1
    .end:
RET
