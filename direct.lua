function translate (kc)
    local keys = {
        [0x01] = 0x1b, -- Esc
        [0x02] = 0x31, -- 1
        [0x03] = 0x32, -- 2
        [0x04] = 0x33, -- 3
        [0x05] = 0x34, -- 4
        [0x06] = 0x35, -- 5
        [0x07] = 0x36, -- 6
        [0x08] = 0x37, -- 7
        [0x09] = 0x38, -- 8
        [0x0A] = 0x39, -- 9
        [0x0B] = 0x30, -- 0
        [0x0C] = 0xbd, -- -
        [0x0D] = 0xbb, -- =
        [0x0E] = 0x08, -- Back Space
        [0x0F] = 0x09, -- Tab
        [0x10] = 0x51, -- Q
        [0x11] = 0x57, -- W
        [0x12] = 0x45, -- E
        [0x13] = 0x52, -- R
        [0x14] = 0x54, -- T
        [0x15] = 0x59, -- Y
        [0x16] = 0x55, -- U
        [0x17] = 0x49, -- I
        [0x18] = 0x4f, -- O
        [0x19] = 0x50, -- P
        [0x1A] = 0xdb, -- [
        [0x1B] = 0xdd, -- ]
        [0x1C] = 0x0d, -- Enter
        [0x1D] = 0xa2, -- Left Ctrl
        [0x1E] = 0x41, -- A
        [0x1F] = 0x53, -- S
        [0x20] = 0x44, -- D
        [0x21] = 0x46, -- F
        [0x22] = 0x47, -- G
        [0x23] = 0x48, -- H
        [0x24] = 0x4a, -- J
        [0x25] = 0x4b, -- K
        [0x26] = 0x4c, -- L
        [0x27] = 0xba, -- ;
        [0x28] = 0xde, -- '
        [0x29] = 0xc0, -- `
        [0x2A] = 0xa0, -- Left Shift
        [0x2B] = 0xdc, -- \
        [0x2C] = 0x5a, -- Z
        [0x2D] = 0x58, -- X
        [0x2E] = 0x43, -- C
        [0x2F] = 0x56, -- V
        [0x30] = 0x42, -- B
        [0x31] = 0x4e, -- N
        [0x32] = 0x4d, -- M
        [0x33] = 0xbc, -- ,
        [0x34] = 0xbe, -- .
        [0x35] = 0xbf, -- /
        [0x36] = 0xa1, -- Right Shift
        [0x37] = nil, -- *
        [0x38] = 0xa4, -- Left Alt
        [0x39] = 0x20, -- Space
        [0x3A] = 0x14, -- Caps Lock
        [0x3B] = 0x70, -- F1
        [0x3C] = 0x71, -- F2
        [0x3D] = 0x72, -- F3
        [0x3E] = 0x73, -- F4
        [0x3F] = 0x74, -- F5
        [0x40] = 0x75, -- F6
        [0x41] = 0x76, -- F7
        [0x42] = 0x77, -- F8
        [0x43] = 0x78, -- F9
        [0x44] = 0x79, -- F10
        [0x45] = 0x90, -- Num Lock
        [0x46] = 0x91, -- Scroll Lock
        [0x47] = 0x67, -- Num7
        [0x48] = 0x68, -- Num8
        [0x49] = 0x69, -- Num9
        [0x4A] = 0x6d, -- -
        [0x4B] = 0x64, -- Num4
        [0x4C] = 0x65, -- Num5
        [0x4D] = 0x66, -- Num6
        [0x4E] = 0x6b, -- +
        [0x4F] = 0x61, -- Num1
        [0x50] = 0x62, -- Num2
        [0x51] = 0x63, -- Num3
        [0x52] = 0x60, -- Num0
        [0x53] = 0x6e, -- .
        [0x57] = 0x7a, -- F11
        [0x58] = 0x7b, -- F12
        [0x64] = 0x7c, -- F13
        [0x65] = 0x7d, -- F14
        [0x66] = 0x7e, -- F15
        [0x70] = 0x15, -- Kana
        [0x79] = 0x1c, -- Convert
        [0x7B] = 0x1d, -- No Convert
        [0x7D] = nil, -- ¥
        [0x8D] = nil, -- =
        [0x90] = nil, -- ^
        [0x91] = nil, -- @
        [0x92] = nil, -- :
        [0x93] = nil, -- _
        [0x94] = 0x19, -- Kanji
        [0x95] = nil, -- Stop
        [0x96] = nil, -- Japan AX
        [0x97] = nil, -- J3100
        [0x9C] = 0x0d, -- Enter
        [0x9D] = 0xa3, -- Right Ctrl
        [0xB3] = 0x6e, -- ,
        [0xB5] = 0x6f, -- /
        [0xB7] = nil, -- Sys Rq
        [0xB8] = 0xa5, -- Right Alt
        [0xC5] = 0x13, -- Pause
        [0xC7] = 0x24, -- Home
        [0xC8] = 0x26, -- ↑
        [0xC9] = 0x21, -- Page Up
        [0xCB] = 0x25, -- ←
        [0xCD] = 0x27, -- →
        [0xCF] = 0x23, -- End
        [0xD0] = 0x28, -- ↓
        [0xD1] = 0x22, -- Page Down
        [0xD2] = 0x2d, -- Insert
        [0xD3] = 0x2e, -- Delete
        [0xDB] = 0x5b, -- Left Windows
        [0xDC] = 0x5c, -- Right Windows
        [0xDD] = nil, -- Menu
        [0xDE] = nil, -- Power
        [0xDF] = nil, -- Windows
    }
    return keys[kc]
end
