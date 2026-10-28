"""Single-layer GI0 RGB565 <-> lossless editable RGB PNG and explicit metadata."""
from pathlib import Path
from array import array
import os, struct, sys, tempfile
from PIL import Image

def export(data,png):
    assert data[:4]==b'gi\0\0';h=struct.unpack_from('<15I',data,4)
    assert h[5:11]==(0xf800,0x7e0,0x1f,0,0,1)
    offset,size,*layer=struct.unpack_from('<8I',data,64)
    width,height=layer[2]-layer[0],layer[3]-layer[1]
    assert offset==96 and size==len(data)-96==width*height*2
    image=Image.frombytes('RGB',(width,height),data[96:],'raw','BGR;16')
    png=Path(png);png.parent.mkdir(parents=True,exist_ok=True)
    descriptor,temporary=tempfile.mkstemp(prefix='gi-export-',suffix='.png',dir=png.parent);os.close(descriptor)
    try:
        image.save(temporary,format='PNG',compress_level=9)
        with Image.open(temporary) as check:check.load()
        os.replace(temporary,png)
    finally:Path(temporary).unlink(missing_ok=True)
    return {'format':'srhd-gi0-rgb565-png-v1','version':h[0],'bounds':list(h[1:5]),
            'masks':list(h[5:9]),'reserved':list(h[11:15]),'layer_bounds':layer[:4],'layer_reserved':layer[4:]}

def encode(source,png):
    assert source['format']=='srhd-gi0-rgb565-png-v1'
    bounds=source['layer_bounds'];width,height=bounds[2]-bounds[0],bounds[3]-bounds[1]
    with Image.open(png) as image:
        assert image.mode=='RGB' and image.size==(width,height)
        raw=image.tobytes()
    samples=array('H',(((r>>3)<<11)|((g>>2)<<5)|(b>>3) for r,g,b in zip(raw[0::3],raw[1::3],raw[2::3])))
    if sys.byteorder!='little':samples.byteswap()
    pixels=samples.tobytes();assert source['masks']==[0xf800,0x7e0,0x1f,0]
    header=struct.pack('<4s15I',b'gi\0\0',source['version'],*source['bounds'],*source['masks'],0,1,*source['reserved'])
    return header+struct.pack('<8I',96,len(pixels),*bounds,*source['layer_reserved'])+pixels
