#!/usr/bin/env python3
"""Export current tracked/untracked source, excluding Git-ignored local state and credentials."""
import argparse
import hashlib
from pathlib import Path
import subprocess
import zipfile

ROOT=Path(__file__).resolve().parents[1]
def export(destination):
    raw=subprocess.check_output(['git','ls-files','--cached','--others','--exclude-standard','-z'],cwd=ROOT)
    names=sorted(set(x.decode('utf-8') for x in raw.split(b'\0') if x))
    manifest=[]
    destination.parent.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(destination,'w',zipfile.ZIP_DEFLATED) as archive:
        for name in names:
            p=ROOT/name
            if not p.exists() or not p.is_file():continue
            if p.is_symlink() or not p.resolve().is_relative_to(ROOT):raise RuntimeError('Refusing symlink/outside source: '+name)
            if p.name in {'LocalConfig.h','supabase-public.json','local.properties'} or p.name.startswith('.env') or p.suffix in {'.jks','.keystore','.key','.pem'}:continue
            data=p.read_bytes()
            archive.writestr(zipfile.ZipInfo.from_file(p,'REAKT/'+name),data,compress_type=zipfile.ZIP_DEFLATED)
            manifest.append(hashlib.sha256(data).hexdigest()+'  '+name)
        archive.writestr('REAKT/CONTENTS-SHA256.txt','\n'.join(manifest)+'\n')
    with zipfile.ZipFile(destination) as archive:
        assert archive.testzip() is None
        for line in archive.read('REAKT/CONTENTS-SHA256.txt').decode().splitlines():
            expected,name=line.split('  ',1)
            assert hashlib.sha256(archive.read('REAKT/'+name)).hexdigest()==expected,name
    digest=hashlib.sha256(destination.read_bytes()).hexdigest()
    destination.with_suffix(destination.suffix+'.sha256').write_text(digest+'  '+destination.name+'\n')
    print(f'Exported and verified {len(manifest)} source files: {destination} ({destination.stat().st_size} bytes)')
    print('SHA256 '+digest)
if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--output',type=Path,default=ROOT.parent/'exports/REAKT-MVP-2026-10-22.zip')
    export(parser.parse_args().output.resolve())
