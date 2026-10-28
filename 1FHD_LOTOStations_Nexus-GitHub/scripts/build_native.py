"""Assemble the recovered instructions and emit the explicit original PE layout."""
from pathlib import Path
import json, struct, subprocess, tempfile

OPTIONAL_FIELDS=[('magic','H'),('linker_major','B'),('linker_minor','B'),('size_code','I'),('size_initialized_data','I'),('size_uninitialized_data','I'),('entry_rva','I'),('base_code','I'),('base_data','I'),('image_base','I'),('section_alignment','I'),('file_alignment','I'),('os_major','H'),('os_minor','H'),('image_major','H'),('image_minor','H'),('subsystem_major','H'),('subsystem_minor','H'),('win32_version','I'),('image_size','I'),('headers_size','I'),('checksum','I'),('subsystem','H'),('dll_characteristics','H'),('stack_reserve','I'),('stack_commit','I'),('heap_reserve','I'),('heap_commit','I'),('loader_flags','I'),('directory_count','I')]

def build(source):
    source=Path(source).resolve();profile=json.loads((source/'pe_profile.json').read_text())
    sections=profile['sections'];payloads={}
    with tempfile.TemporaryDirectory() as directory:
        root=Path(directory);obj=root/'native.o';elf=root/'native.elf'
        subprocess.run(['as','--32',str(source/'lottery_native.S'),'-o',str(obj)],check=True,capture_output=True)
        subprocess.run(['ld','-m','elf_i386','-T',str(source/'link.ld'),str(obj),'-o',str(elf)],check=True,capture_output=True)
        for name in ['.text','.rdata','.data','.dosstub']:
            output=root/(name[1:]+'.bin')
            subprocess.run(['objcopy','--dump-section',name+'='+str(output),str(elf)],check=True,capture_output=True)
            payloads[name]=output.read_bytes()
    relocation=bytearray()
    for block in profile['relocation_blocks']:
        entries=block['entries'];relocation.extend(struct.pack('<II',block['page_rva'],8+2*len(entries)))
        relocation.extend(struct.pack('<'+'H'*len(entries),*entries))
    payloads['.reloc']=bytes(relocation)
    optional=profile['optional'];coff=profile['coff']
    out=bytearray(max(s['raw_offset']+s['raw_size'] for s in sections))
    struct.pack_into('<30HI',out,0,*profile['dos_words'],profile['pe_header_offset'])
    stub=payloads['.dosstub'];assert len(stub)==profile['pe_header_offset']-64
    out[64:64+len(stub)]=stub
    at=profile['pe_header_offset'];out[at:at+4]=b'PE\0\0';at+=4
    names=['machine','section_count','timestamp','symbol_table_offset','symbol_count','optional_header_size','characteristics']
    struct.pack_into('<HHIIIHH',out,at,*[coff[name] for name in names]);at+=20
    for name,fmt in OPTIONAL_FIELDS:
        struct.pack_into('<'+fmt,out,at,optional[name]);at+=struct.calcsize('<'+fmt)
    for rva,size in profile['directories']:struct.pack_into('<II',out,at,rva,size);at+=8
    assert at==profile['pe_header_offset']+24+coff['optional_header_size']
    for section in sections:
        struct.pack_into('<8s8I',out,at,section['name'].encode().ljust(8,b'\0'),
                         *[section[k] for k in ['virtual_size','rva','raw_size','raw_offset','relocations_pointer','line_numbers_pointer','relocations_and_lines','characteristics']])
        at+=40;data=payloads[section['name']]
        assert len(data)==section['virtual_size'] and len(data)<=section['raw_size']
        out[section['raw_offset']:section['raw_offset']+len(data)]=data
        if section['name']=='.text':
            # Original MSVC-compatible code-section alignment fill.
            end=section['raw_offset']+section['raw_size']
            out[section['raw_offset']+len(data):end]=b'\xcc'*(section['raw_size']-len(data))
    return bytes(out)

if __name__=='__main__':
    import sys
    Path(sys.argv[2]).write_bytes(build(sys.argv[1]))
