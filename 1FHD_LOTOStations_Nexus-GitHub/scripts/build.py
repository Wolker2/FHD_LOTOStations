#!/usr/bin/env python3
"""Build every supplied runtime file from recovered editable source."""
from pathlib import Path
import argparse, hashlib, json, platform, subprocess, zipfile, zlib
from PIL import __version__ as pillow_version
from dat_codec import encode as encode_dat,decode as decode_dat
from gi_png import encode as encode_gi
from build_native import build as build_native
from audit import inspect,walk
ROOT=Path(__file__).resolve().parents[1]
PREFIX='Mods/FHD_MODS/FHD_LOTOStations/'
def load(path):return json.loads(Path(path).read_text('utf-8'))
def sha(data):return hashlib.sha256(data).hexdigest()
def compile_source(root=ROOT):
    source=root/'source';files={};configs={}
    for path in sorted((source/'CFG').rglob('*.json')):
        name=path.relative_to(source).with_suffix('.dat').as_posix();tree=load(path);data=encode_dat(tree)
        assert decode_dat(data,tree['format'])==tree
        files[name]=data;configs[name]=tree
    for graphic in load(source/'graphics/images.json'):
        files[graphic['runtime_path']]=encode_gi(graphic,source/'graphics'/graphic['png'])
    files['Data/FHDStationsLotteryNative.dll']=build_native(source/'native')
    files['ModuleInfo.txt']=(source/'ModuleInfo.txt').read_bytes().decode('utf-8').encode('cp1251')
    return files,configs
def resource_audit(files,configs):
    refs=[]
    for alias,value in walk(configs['CFG/CacheData.dat']['root']):
        path=value.replace('\\','/')
        if path.startswith(PREFIX):refs.append({'alias':alias,'present':path[len(PREFIX):] in files})
    return {'cache_references_checked':len(refs),'missing':[r for r in refs if not r['present']],
            'native_library_present':'Data/FHDStationsLotteryNative.dll' in files}
def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--strict-original',action='store_true');args=parser.parse_args()
    files,configs=compile_source();expected=load(ROOT/'original-file-sha256.json')
    if set(files)!=set(expected):raise SystemExit('Runtime file list differs from upload')
    hashes={name:sha(data) for name,data in sorted(files.items())};changed=[name for name in hashes if hashes[name]!=expected[name]]
    if args.strict_original and changed:raise SystemExit('Original SHA-256 mismatch: '+repr(changed))
    resources=resource_audit(files,configs)
    if resources['missing']:raise SystemExit('Missing resources: '+repr(resources['missing']))
    audit=inspect(configs)
    if audit['reference_failures']:raise SystemExit('Reference failures: '+repr(audit['reference_failures']))
    out=ROOT/'dist';out.mkdir(exist_ok=True);archive=out/'FHD_LOTOStations_v4.8_FROM_SOURCE.zip'
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
        for name,data in sorted(files.items()):
            info=zipfile.ZipInfo(PREFIX+name,date_time=(2026,10,28,0,0,0));info.external_attr=0o644<<16
            z.writestr(info,data,compress_type=zipfile.ZIP_DEFLATED,compresslevel=9)
    with zipfile.ZipFile(archive) as z:assert z.testzip() is None
    report={'runtime_files':len(files),'source_derived_files':len(files),'byte_identical_to_upload':not changed,
            'different_files':changed,'prebuilt_runtime_inputs_used':False,'game_required_for_build':False,
            'dat_files':3,'gi_files':8,'dll_files':1,'scr_files':0,'native_code_instructions':597,
            'resource_audit':resources,'static_audit':audit,'sha256':hashes,'package_sha256':sha(archive.read_bytes()),
            'python':platform.python_version(),'zlib':zlib.ZLIB_RUNTIME_VERSION,'pillow':pillow_version,
            'assembler':subprocess.check_output(['as','--version'],text=True).splitlines()[0],
            'linker':subprocess.check_output(['ld','--version'],text=True).splitlines()[0],
            'live_game_executed':False}
    (out/'build-report.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(f'PASS: {len(files)} runtime files built; {len(files)-len(changed)} original hashes match')
    print('Known uploaded findings preserved:',', '.join(f['id'] for f in audit['findings']))
    print('Package:',archive)
if __name__=='__main__':main()
