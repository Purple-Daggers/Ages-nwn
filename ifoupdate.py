import glob
import os
import subprocess
import tempfile

areaList = []

for are in glob.glob("./src/are/*.json"):
    name = os.path.basename(are)
    name = os.path.splitext(name)[0]  # .json
    name = os.path.splitext(name)[0]  # .are

    areaList.append(
        '{"__struct_id":6,"Area_Name":{"type":"resref","value":"%s"}}' % name
    )

areaListStr = ",".join(areaList)

perl_script = r'''
s|"Mod_Area_list":\{"type":"list","value":\[(.*?)\]\},|"Mod_Area_list":{"type":"list","value":[%s]},|
''' % areaListStr

with tempfile.NamedTemporaryFile(
    mode="w",
    suffix=".pl",
    delete=False,
    encoding="windows-1252"
) as f:
    f.write(perl_script)
    perl_file = f.name

try:
    cmd = (
        '.\\tools\\nwn_gff.exe -i .\\src\\ifo\\module.ifo.json -k json | '
        f'perl -p "{perl_file}" | '
        '.\\tools\\nwn_gff.exe -l json -o .\\src\\ifo\\module.ifo.json --pretty'
    )
    result = os.system(cmd)

finally:
    os.unlink(perl_file)