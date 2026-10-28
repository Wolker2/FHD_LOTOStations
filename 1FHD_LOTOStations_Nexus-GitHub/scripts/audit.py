"""Static source/reference inspection. Known uploaded defects are reported intact."""
import re

def walk(block,path=''):
    for entry in block['entries']:
        name=path+'.'+entry['name'] if path else entry['name']
        if entry['kind']=='block':yield from walk(entry['value'],name)
        else:yield name,entry['value']
def blocks(block,path=''):
    for entry in block['entries']:
        if entry['kind']=='block':
            name=path+'.'+entry['name'] if path else entry['name']
            yield name,entry['name'],entry['value'];yield from blocks(entry['value'],name)
def descend(block,*names):
    for name in names:block=next(e['value'] for e in block['entries'] if e['kind']=='block' and e['name']==name)
    return block
def generated_code(block):
    # Matches TBlockParEC.ConcatenateValues: stored order, not integer-key order.
    return ''.join('{'+generated_code(e['value'])+'}' if e['kind']=='block' else e['value'] for e in block['entries'])

def inspect(configs):
    main=configs['CFG/Main.dat']['root'];lang=configs['CFG/Rus/Lang.dat']['root'];paths={p for p,_,_ in blocks(lang)}
    failures=[];buttons=0;declarations=0;values=[]
    for root in [main,lang]:
        for path,kind,child in blocks(root):
            fields={e['name']:e['value'] for e in child['entries'] if e['kind']=='parameter'}
            if kind=='GraphButton' and fields.get('Name'):
                buttons+=1
                if 'Caption' in fields and not fields.get('Font'):failures.append('Caption without font: '+path+'/'+fields['Name'])
        for path,value in walk(root):
            values.append(value)
            for target in re.findall(r"GenerateCodeStringFromBlock\('([^']+)'",value):
                if target not in paths:failures.append('Missing language code block: '+target)
            stripped=re.sub(r"'(?:''|[^'])*'",' ',value)
            for name in re.findall(r'\b(?:int|float|dword|str|unknown)\s+(\w+)\s*=',stripped):
                declarations+=1
                if re.fullmatch(r'[0-9a-fA-F]+[hH]|[01]+[bB]',name):failures.append('Numeric-literal variable name: '+name)
    play=descend(lang,'Script','StationFinder','LotteryPlay');names=[entry['name'] for entry in play['entries']]
    misplaced=names.index('100')<names.index('14');code=generated_code(play)
    assert misplaced and code.index('if(prizeType==1)')<code.index('int prizeType=0;')
    findings=[{'id':'lotteryplay-order','severity':'functional',
               'fact':'Stored LotteryPlay order is 01..10,100..109,11..99. The prize handlers use prizeType and other values before their declarations and before commit.',
               'evidence':{'handler_100_position':names.index('100'),'declaration_14_position':names.index('14'),'sorted_block':play['sorted']},
               'live_script_compilation_tested':False},
              {'id':'native-prize-types','severity':'functional',
               'fact':'Game script creates prizeType 4 (hull) and 5 (artifact), but native LotteryCommit and record validation accept only 0..3. Reproduced by DLL emulation.'},
              {'id':'flush-result','severity':'durability',
               'fact':'Native LotteryCommit reports success after a complete write even when FlushFileBuffers fails. Reproduced with an injected API failure.'}]
    own=dict(walk(configs['CFG/CacheData.dat']['root']))
    external=sorted({alias for value in values for alias in re.findall(r'\bBm\.[\w.]+',value) if alias not in own})
    return {'reference_failures':sorted(set(failures)),'named_buttons':buttons,'variable_declarations':declarations,
            'external_game_image_aliases':external,'findings':findings,'live_game_executed':False}
