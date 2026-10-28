"""Execute the original PE32 routines with an in-memory Win32 file/API fixture.

No real journal, game save, Windows process or game executable is opened.
Both preferred and relocated DLL bases are tested. The fixture models API
return values and file bytes; it is not a Windows durability test.
"""
from pathlib import Path
import json, struct
from unicorn import Uc, UC_ARCH_X86, UC_MODE_32, UC_HOOK_CODE
from unicorn.x86_const import UC_X86_REG_EAX, UC_X86_REG_EIP, UC_X86_REG_ESP

APIS={'CloseHandle':1,'CreateDirectoryA':2,'CreateFileA':7,'FlushFileBuffers':1,
      'GetCurrentProcessId':0,'GetCurrentThreadId':0,'GetEnvironmentVariableA':3,
      'GetTickCount':0,'ReadFile':5,'SetFilePointer':4,'WriteFile':5}

class Native:
    def __init__(self,data,relocated=False,files=None,environment=None):
        nt=struct.unpack_from('<I',data,60)[0];opt=nt+24;preferred=struct.unpack_from('<I',data,opt+28)[0]
        self.base=preferred+(0x02000000 if relocated else 0);size=struct.unpack_from('<I',data,opt+56)[0]
        image=bytearray(size);headers=struct.unpack_from('<I',data,opt+60)[0];image[:headers]=data[:headers]
        section_table=opt+struct.unpack_from('<H',data,nt+20)[0]
        for i in range(struct.unpack_from('<H',data,nt+6)[0]):
            _,rva,length,raw=struct.unpack_from('<4I',data,section_table+40*i+8)
            image[rva:rva+length]=data[raw:raw+length]
        if relocated:
            at,length=struct.unpack_from('<II',image,opt+96+5*8);end=at+length
            while at<end:
                page,block_size=struct.unpack_from('<II',image,at);assert block_size>=8
                for pos in range(at+8,at+block_size,2):
                    entry=struct.unpack_from('<H',image,pos)[0]
                    if entry>>12==3:
                        target=page+(entry&4095);value=struct.unpack_from('<I',image,target)[0]
                        struct.pack_into('<I',image,target,(value+self.base-preferred)&0xffffffff)
                    else:assert entry>>12==0
                at+=block_size
        export=struct.unpack_from('<I',image,opt+96)[0];functions,names,ordinals=struct.unpack_from('<III',image,export+28)
        self.exports={}
        for i in range(struct.unpack_from('<I',image,export+24)[0]):
            pointer=struct.unpack_from('<I',image,names+4*i)[0];name=image[pointer:image.index(0,pointer)].decode()
            ordinal=struct.unpack_from('<H',image,ordinals+2*i)[0];self.exports[name]=struct.unpack_from('<I',image,functions+4*ordinal)[0]
        self.vm=Uc(UC_ARCH_X86,UC_MODE_32)
        for address,length in [(self.base,size),(0x20000000,0x20000),(0x30000000,0x10000)]:self.vm.mem_map(address,length)
        self.files={} if files is None else files;self.environment={'LOCALAPPDATA':'C:\\Fixture'} if environment is None else environment
        self.handles={};self.next_handle=10;self.calls=[];self.fail_open=False;self.fail_write=False;self.fail_flush=False;self.short_write=False
        self.stubs={};at=struct.unpack_from('<I',image,opt+96+8)[0]
        while any(image[at:at+20]):
            lookup,_,_,_,iat=struct.unpack_from('<5I',image,at)
            i=0
            while struct.unpack_from('<I',image,lookup+4*i)[0]:
                hint=struct.unpack_from('<I',image,lookup+4*i)[0];name=image[hint+2:image.index(0,hint+2)].decode()
                stub=0x30000000+len(self.stubs)*16;self.stubs[stub]=name
                struct.pack_into('<I',image,iat+4*i,stub);argc=APIS[name]
                self.vm.mem_write(stub,b'\xc2'+struct.pack('<H',argc*4) if argc else b'\xc3');i+=1
            at+=20
        assert set(self.stubs.values())==set(APIS)
        self.vm.mem_write(self.base,bytes(image));self.stop=0x3000f000
        self.vm.hook_add(UC_HOOK_CODE,self.api,begin=0x30000000,end=0x30000100)
    def put(self,address,value):self.vm.mem_write(address,struct.pack('<I',value&0xffffffff))
    def get(self,address):return struct.unpack('<I',self.vm.mem_read(address,4))[0]
    def string(self,address):
        data=bytearray()
        for index in range(2048):
            value=self.vm.mem_read(address+index,1)[0]
            if not value:return data.decode('ascii')
            data.append(value)
        raise AssertionError('Unterminated fixture string')
    def invoke(self,name,*arguments):
        stack=0x2001effc;self.vm.mem_write(stack,struct.pack('<'+'I'*(len(arguments)+1),self.stop,*[v&0xffffffff for v in arguments]))
        self.vm.reg_write(UC_X86_REG_ESP,stack)
        self.vm.emu_start(self.base+self.exports[name],self.stop,timeout=5_000_000,count=5_000_000)
        assert self.vm.reg_read(UC_X86_REG_EIP)==self.stop,'DLL call did not return'
        return self.vm.reg_read(UC_X86_REG_EAX)
    def api(self,vm,address,size,user_data):
        name=self.stubs.get(address)
        if not name:return
        stack=vm.reg_read(UC_X86_REG_ESP);args=[self.get(stack+4*(i+1)) for i in range(APIS[name])];self.calls.append(name);result=1
        if name=='GetEnvironmentVariableA':
            key,buffer,limit=args;text=self.environment.get(self.string(key),'').encode();result=len(text)
            if text and len(text)<limit:vm.mem_write(buffer,text+b'\0')
            elif len(text)>=limit:result=len(text)+1
        elif name=='CreateDirectoryA':pass
        elif name=='CreateFileA':
            path=self.string(args[0]);creation=args[4]
            if self.fail_open or (creation==3 and path not in self.files):result=0xffffffff
            else:
                self.files.setdefault(path,bytearray());result=self.next_handle;self.next_handle+=1
                self.handles[result]=[path,0]
        elif name=='CloseHandle':self.handles.pop(args[0],None)
        elif name=='SetFilePointer':
            handle,distance,high,method=args;entry=self.handles[handle]
            distance=distance if distance<0x80000000 else distance-0x100000000
            entry[1]=(len(self.files[entry[0]]) if method==2 else entry[1] if method==1 else 0)+distance;result=entry[1]
        elif name=='ReadFile':
            handle,buffer,count,output,_=args;entry=self.handles[handle];chunk=self.files[entry[0]][entry[1]:entry[1]+count]
            if chunk:vm.mem_write(buffer,bytes(chunk))
            entry[1]+=len(chunk);self.put(output,len(chunk))
        elif name=='WriteFile':
            handle,buffer,count,output,_=args;entry=self.handles[handle]
            if self.fail_write:result=0;self.put(output,0)
            else:
                length=count-1 if self.short_write else count;file=self.files[entry[0]]
                file[entry[1]:entry[1]+length]=vm.mem_read(buffer,length);entry[1]+=length;self.put(output,length)
        elif name=='FlushFileBuffers':result=0 if self.fail_flush else 1
        elif name=='GetCurrentProcessId':result=1234
        elif name=='GetCurrentThreadId':result=5678
        elif name=='GetTickCount':result=0x12345678
        else:raise AssertionError(name)
        vm.reg_write(UC_X86_REG_EAX,result&0xffffffff)

def verify(data):
    checks=0;findings=[]
    def check(condition,message):
        nonlocal checks
        assert condition,message;checks+=1
    for relocated in [False,True]:
        f=Native(data,relocated);key=(182,123,42);fields=(2,3,2,7,20,50,2)
        check(f.invoke('LotteryHasRecord',*key)==0,'Empty journal')
        check(f.invoke('LotteryGetField',*key,0)==0xffffffff,'Missing record field')
        check(f.invoke('LotteryCommit',*key,*fields)==1,'New commit')
        check(f.invoke('LotteryHasRecord',*key)==1,'Committed record present')
        for index,value in enumerate(fields):check(f.invoke('LotteryGetField',*key,index)==value,'Field roundtrip')
        path=next(iter(f.files));snapshot=bytes(f.files[path])
        check(path=='C:\\Fixture\\FHD_Stations\\lottery_guard_v1.dat','LocalAppData journal path')
        check(len(snapshot)==52 and snapshot[:4]==b'FHDL','Record layout')
        check(f.invoke('LotteryCommit',*key,*fields)==2 and bytes(f.files[path])==snapshot,'Duplicate is not appended')
        check(f.invoke('LotteryGetField',*key,7)==0xffffffff,'Unknown field rejected')
        check(f.invoke('LotteryHasRecord',183,123,42)==0,'Start turn participates in key')
        check(f.invoke('LotteryHasRecord',182,124,42)==0,'Station participates in key')
        check(f.invoke('LotteryHasRecord',182,123,43)==0,'Player participates in key')
        restarted=Native(data,relocated,files=f.files)
        check(restarted.invoke('LotteryHasRecord',*key)==1,'Journal persists across DLL instances')
        for prize in range(4):
            check(f.invoke('LotteryCommit',184+prize,123,42,2,3,prize,1,2,3,4)==1,'Supported prize type')
        for prize in [4,5]:
            before=len(f.files[path]);check(f.invoke('LotteryCommit',190+prize,123,42,2,3,prize,1,2,3,4)==0,'Types 4/5 rejected by original DLL')
            check(len(f.files[path])==before,'Rejected prize not written')
        for chosen,winning in [(21,3),(2,21),(-1,3),(2,-1)]:
            check(f.invoke('LotteryCommit',300+checks,123,42,chosen,winning,1,1,2,3,4)==0,'Invalid number rejected')
        corrupted=Native(data,relocated,files={path:bytearray(snapshot)});corrupted.files[path][20]^=1
        check(corrupted.invoke('LotteryHasRecord',*key)==0,'Changed payload checksum rejected')
        truncated=Native(data,relocated,files={path:bytearray(snapshot[:-1])})
        check(truncated.invoke('LotteryHasRecord',*key)==0,'Partial record rejected')
        blocked=Native(data,relocated);blocked.fail_open=True
        check(blocked.invoke('LotteryCommit',*key,*fields)==0,'Open failure reported')
        failed=Native(data,relocated);failed.fail_write=True
        check(failed.invoke('LotteryCommit',*key,*fields)==0,'Write failure reported')
        short=Native(data,relocated);short.short_write=True
        check(short.invoke('LotteryCommit',*key,*fields)==0,'Short write reported')
        flush=Native(data,relocated);flush.fail_flush=True
        check(flush.invoke('LotteryCommit',*key,*fields)==1,'Original DLL ignores flush failure')
        check('FlushFileBuffers' in flush.calls,'Flush is attempted')
        relative=Native(data,relocated,environment={});check(relative.invoke('LotteryCommit',*key,*fields)==1,'Relative fallback journal')
        check(next(iter(relative.files))=='.\\FHD_Stations\\lottery_guard_v1.dat','Relative path value')
        rng=Native(data,relocated);numbers=[rng.invoke('LotteryNumber') for _ in range(256)]
        check(all(0<=n<=20 for n in numbers),'Number range 0-20')
        check(all(a!=b for a,b in zip(numbers,numbers[1:])),'No consecutive repeat within DLL instance')
        check(len(set(numbers))>=15,'Deterministic fixture samples exercise multiple outcomes')
        check(not f.handles,'Opened handles closed')
    findings=[{'id':'native-prize-types','fact':'LotteryCommit rejects types 4 and 5; uploaded game script uses both.'},
              {'id':'flush-result','fact':'LotteryCommit returns 1 after a successful full write even if FlushFileBuffers returns failure.'}]
    return {'checks_passed':checks,'rng_samples_per_base':256,'bases_tested':2,'actual_dll_instructions_executed':True,
            'windows_apis_and_journal':'in-memory fixture','live_windows_game_executed':False,'findings':findings}

if __name__=='__main__':
    import sys
    print(json.dumps(verify(Path(sys.argv[1]).read_bytes()),ensure_ascii=False,indent=2))
