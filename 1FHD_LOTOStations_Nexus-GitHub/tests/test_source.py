from pathlib import Path
import copy, hashlib, json, shutil, struct, subprocess, sys, tempfile, unittest, zipfile
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'scripts'));sys.path.insert(0,str(ROOT/'tests'))
from build import compile_source,resource_audit,load,PREFIX
from audit import inspect,descend
from gi_png import export,encode
from verify_native import verify

class SourceTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.files,cls.configs=compile_source()

    def test_all_original_hashes_and_references(self):
        self.assertEqual({name:hashlib.sha256(data).hexdigest() for name,data in self.files.items()},load(ROOT/'original-file-sha256.json'))
        self.assertEqual(len(self.files),13)
        self.assertEqual(resource_audit(self.files,self.configs),{'cache_references_checked':8,'missing':[],'native_library_present':True})
        self.assertEqual(inspect(self.configs)['reference_failures'],[])

    def test_native_journal_and_number_generation(self):
        report=verify(self.files['Data/FHDStationsLotteryNative.dll'])
        self.assertEqual(report['checks_passed'],88)
        self.assertEqual(report['bases_tested'],2)

    def test_all_rgb565_colors_and_pixel_edit(self):
        source=copy.deepcopy(load(ROOT/'source/graphics/images.json')[0]);source['bounds']=source['layer_bounds']=[0,0,256,256]
        pixels=struct.pack('<65536H',*range(65536))
        header=struct.pack('<4s15I',b'gi\0\0',source['version'],*source['bounds'],*source['masks'],0,1,*source['reserved'])
        data=header+struct.pack('<8I',96,len(pixels),*source['layer_bounds'],*source['layer_reserved'])+pixels
        with tempfile.TemporaryDirectory() as folder:
            png=Path(folder)/'colors.png';metadata=export(data,png);self.assertEqual(encode(metadata,png),data)
            with Image.open(png) as image:image.load();image.putpixel((0,0),(255,0,0));image.save(png)
            self.assertEqual(struct.unpack_from('<H',encode(metadata,png),96)[0],0xf800)

    def test_embedded_code_edit_is_a_real_build_input(self):
        with tempfile.TemporaryDirectory() as folder:
            target=Path(folder);shutil.copytree(ROOT/'source',target/'source')
            path=target/'source/CFG/Rus/Lang.json';tree=load(path)
            block=descend(tree['root'],'Script','StationFinder','LotteryStart')
            entry=next(e for e in block['entries'] if e['kind']=='parameter' and 'CurTurn()+182' in e['value'])
            entry['value']=entry['value'].replace('CurTurn()+182','CurTurn()+183')
            path.write_text(json.dumps(tree,ensure_ascii=False),encoding='utf-8');files,_=compile_source(target)
        self.assertEqual([name for name in files if files[name]!=self.files[name]],['CFG/Rus/Lang.dat'])

    def test_original_findings_are_explicit_and_preserved(self):
        report=inspect(self.configs)
        self.assertEqual({f['id'] for f in report['findings']},{'lotteryplay-order','native-prize-types','flush-result'})
        order=next(f['evidence'] for f in report['findings'] if f['id']=='lotteryplay-order')
        self.assertLess(order['handler_100_position'],order['declaration_14_position'])

    def test_isolated_source_only_build(self):
        with tempfile.TemporaryDirectory() as folder:
            target=Path(folder)
            for name in ['scripts','source']:shutil.copytree(ROOT/name,target/name,ignore=shutil.ignore_patterns('__pycache__'))
            shutil.copy2(ROOT/'original-file-sha256.json',target/'original-file-sha256.json')
            self.assertFalse(any(p.suffix.lower() in ['.dat','.gi','.dll','.exe','.scr'] for p in target.rglob('*') if p.is_file()))
            result=subprocess.run([sys.executable,str(target/'scripts/build.py'),'--strict-original'],cwd=target,capture_output=True,text=True)
            self.assertEqual(result.returncode,0,result.stdout+'\n'+result.stderr)
            with zipfile.ZipFile(target/'dist/FHD_LOTOStations_v4.8_FROM_SOURCE.zip') as archive:
                self.assertEqual(len(archive.namelist()),13);self.assertIsNone(archive.testzip())
                for name,data in self.files.items():self.assertEqual(archive.read(PREFIX+name),data)
if __name__=='__main__':unittest.main()
