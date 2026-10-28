# FHD_LOTOStations 4.8 — sources for Nexus Mods review

**All 13 supplied runtime files rebuild byte for byte from recovered editable source**, including the 5,632-byte native DLL. Six automated tests and 88 checks executing the DLL's real x86 instructions passed. **The uploaded mod also contains the functional inconsistencies documented below; they are preserved, not silently repaired.** No live game test or moderation approval is claimed.

Original ModuleInfo identifies author **Prolog_D** and displays **ver.4.8 FINAL**. Its text, encoding, priority and runtime values are unchanged. The native export-directory DLL name still contains `_v46`; that original metadata is also retained.

## Known findings in the supplied mod

| Finding | Evidence and consequence |
| --- | --- |
| LotteryPlay code order | The stored block is sorted and ordered `01..10,100..109,11..99`. Handlers `100..109` therefore precede prize-variable declarations, prize calculation and the external commit. For example, `if(prizeType==1)` precedes `int prizeType=0;`. The supplied engine reference's `GenerateCodeStringFromBlock` / `TBlockParEC.ConcatenateValues` concatenates stored entries and child braces without integer-key sorting. This is a concrete ordering defect; exact live-game compiler behavior was not executed. |
| Prize types 4 and 5 rejected | Lang code creates type 4 hull rewards and type 5 artifacts, but both native commit validation and journal-record validation accept only types 0–3. Native emulation reproduces return 0 without appending either reward type. The intended hull/artifact branches cannot register a new result through this DLL. |
| Flush result ignored | After a full 52-byte write, LotteryCommit calls FlushFileBuffers but ignores its return value and reports success even when the flush fails. Emulation reproduces this with an injected API failure. Durable storage is therefore not established merely by the success return value. |

The build verifies preservation of these original files. Passing reconstruction tests does not mean the lottery is gameplay-correct. Fixing these findings would require a separately identified runtime revision; this package intentionally reproduces the upload.

## Mod and external journal

The configuration provides station search in discovered sectors and a lottery scheduled every 182 game turns, open for 60 days. Station-search UI, reward calculations and restoration logic are fully visible in `source/CFG/Rus/Lang.json`; form definitions and native bindings are in `Main.json`.

The DLL exports four cdecl functions, as bound in Main.dat:

| Export | Contract |
| --- | --- |
| `LotteryNumber()` | Returns 0–20, avoiding an immediate repeat within the same loaded DLL instance |
| `LotteryHasRecord(start, station, player)` | Reports whether a valid matching journal record exists |
| `LotteryGetField(start, station, player, field)` | Reads chosen number, winning number, prize type or prize parameters P1–P4 at indices 0–6; missing/invalid access returns `0xffffffff` |
| `LotteryCommit(start, station, player, chosen, winning, type, P1, P2, P3, P4)` | Returns 1 for a new complete write, 2 for an existing record or 0 on failure/unsupported input |

The native code tries `LOCALAPPDATA`, `APPDATA`, then `TEMP`, using `FHD_Stations/lottery_guard_v1.dat` below the selected directory. If no suitable environment value is available, it uses `./FHD_Stations/lottery_guard_v1.dat`. This file is external to game saves. The intended restoration/anti-reroll behavior is subject to the findings above and has not been validated in a running game.

Records are 52 bytes: `FHDL` magic, version `0x00010001`, the three-part key, chosen/winning numbers, prize type, four prize parameters and a 32-bit checksum. The checksum is not keyed authentication. Random-number inputs are tick count, process ID, thread ID and an in-process counter; no cryptographic randomness claim is made.

All 11 imports are visible in the assembly source: CloseHandle, CreateDirectoryA, CreateFileA, FlushFileBuffers, GetCurrentProcessId, GetCurrentThreadId, GetEnvironmentVariableA, GetTickCount, ReadFile, SetFilePointer and WriteFile, from KERNEL32.dll. No game executable is required for building or testing this package.

## Repository contents

| Path | Purpose |
| --- | --- |
| `source/CFG/*.json`, `source/CFG/Rus/Lang.json` | Complete recovered DAT trees, code strings, stored order, sorting metadata and cipher seeds |
| `source/graphics/*.png` | All eight editable lossless pixel sources |
| `source/graphics/images.json` | Explicit GI headers, bounds, masks, reserved values and runtime paths |
| `source/native/lottery_native.S` | Complete recovered GNU x86 assembly: 597 original .text instructions, named exports/helpers, imports, strings, tables, initial data and DOS stub |
| `source/native/link.ld`, `pe_profile.json` | Explicit section placement, PE fields and base-relocation layout |
| `source/ModuleInfo.txt` | UTF-8 metadata emitted as original CP1251 bytes and line endings |
| `scripts/` | Full builder, independent DAT and graphics codecs, native assembler/PE emitter and static audit |
| `tests/` | Six source tests and a Win32 API/journal fixture executing actual DLL machine code |
| `original-file-sha256.json`, `build-verification.json` | Original runtime hashes and completed verification results |
| `.github/workflows/build.yml` | GitHub source build/check workflow |

The input did not contain original C/C++ or a native project. The assembly is recovered source, not an assertion that original authoring files were supplied. Every instruction is visible; short/near branch encodings and alignment NOPs are explicit to retain original bytes. There is no opaque executable blob or original DLL build input. Arbitrary instruction-size changes require updating the fixed layout and PE/relocation profile; the original mod already rebuilds without any manual recovery.

The supplied mod has no SCR. Its embedded game code is already present in recovered configuration source, so an RSON project is not required. All eight graphics are single-layer type-0 RGB565 images. PNGs are build inputs, not duplicate previews; recovered colors rebuild exactly, while new edits are quantized to RGB565's 5/6/5 channel bits. Original layered artwork was not supplied.

The two BMP screenshots and the separate balanced-rewards text table are excluded from this compact source package; actual reward calculations remain in Lang.json. Original compiled DAT/GI/DLL files are excluded as well.

## Build and checks

Verified on 28 October 2026 with Python 3.12.14, zlib 1.3.2, Pillow 12.3.0, GNU binutils 2.42 and Unicorn 2.1.4. Building needs Python 3.10+, Pillow and GNU `as`, `ld`, `objcopy` supporting i386 ELF. The custom emitter produces the original PE32 DLL layout. No Windows SDK, original DLL, game installation or external decompiler is needed. Unicorn is required only for native tests.

```sh
python3 -m pip install -r requirements.txt -r requirements-tests.txt
python3 scripts/build.py --strict-original
python3 -m unittest discover -s tests -v
```

Output: `dist/FHD_LOTOStations_v4.8_FROM_SOURCE.zip` and `dist/build-report.json`. The generated installable ZIP contains all 13 runtime files at `Mods/FHD_MODS/FHD_LOTOStations`. The GitHub review archive itself contains source files, not an installed mod. For deliberate source edits, omit `--strict-original`; the report lists changed hashes.

Tests cover all 13 original hashes, 8 local CacheData references, DAT source roundtrips, source edits to embedded code, an isolated source-only build, all 65,536 RGB565 colors through PNG and pixel edits. Native tests execute at the preferred and relocated DLL bases, with in-memory API/file fixtures. They cover commit/read/duplicate behavior, field values, cross-instance journal reuse, changed-key lookups, malformed/partial records, number/type bounds, write/open/flush failures, fallback paths and 256 RNG samples per base. The same byte-identical rebuilt DLL is used by these checks.

## Provenance and limits

Input: `FHD_LOTOStations.rar`, SHA-256 `cb97d8cc86cbda3ded525b5d1156fc254dae74e12b18d2fbb9abd41917317ab4`. All 16 supplied files extracted successfully; 13 runtime files are reproduced. Native DLL SHA-256: `c49b5de54718ac6cd164f27cee5062fb9cb882a39d44f2a3172b3310bc7586cf`.

No actual Windows filesystem, real journal durability, save rollback, live game-script compilation, prize delivery, mixed-mod compatibility or full UI rendering was tested. The test fixture never opens a real journal or save. Existing game fonts, styles, sounds and non-replaced image resources remain external dependencies; other image aliases are listed in the report. Hosted GitHub execution, antivirus verdicts and Nexus moderation approval are not claimed.

The DAT codec follows format conventions studied in the previously supplied MIT-licensed [rangers-utils](https://github.com/murgesku/rangers-utils). GI handling was checked against the previously supplied [SRHD-XenoModKit](https://github.com/Xenomorphchyma/SRHD-XenoModKit) format implementation. Script-order evidence comes from the previously supplied [SpaceRangersHD_decomp](https://github.com/pakompom/SpaceRangersHD_decomp) engine references. Existing authorship is preserved; no new license or redistribution permission is inferred.
