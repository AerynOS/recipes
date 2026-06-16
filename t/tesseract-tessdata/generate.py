#!/usr/bin/env python
# SPDX-FileCopyrightText: 2025 AerynOS Developers
# SPDX-License-Identifier: MPL-2.0

from pathlib import Path
import re
from string import Template


langs=['afr',
    'amh',
    'ara',
    'asm',
    'aze',
    'aze_cyrl',
    'bel',
    'ben',
    'bod',
    'bos',
    'bre',
    'bul',
    'cat',
    'ceb',
    'ces',
    'chi_sim',
    'chi_sim_vert',
    'chi_tra',
    'chi_tra_vert',
    'chr',
    'cos',
    'cym',
    'dan',
    'dan_frak',
    'deu',
    'deu_frak',
    'div',
    'dzo',
    'ell',
    'eng',
    'enm',
    'epo',
    'equ',
    'est',
    'eus',
    'fao',
    'fas',
    'fil',
    'fin',
    'fra',
    'frk',
    'frm',
    'fry',
    'gla',
    'gle',
    'glg',
    'grc',
    'guj',
    'hat',
    'heb',
    'hin',
    'hrv',
    'hun',
    'hye',
    'iku',
    'ind',
    'isl',
    'ita',
    'ita_old',
    'jav',
    'jpn',
    'jpn_vert',
    'kan',
    'kat',
    'kat_old',
    'kaz',
    'khm',
    'kir',
    'kmr',
    'kor',
    'kor_vert',
    'lao',
    'lat',
    'lav',
    'lit',
    'ltz',
    'mal',
    'mar',
    'mkd',
    'mlt',
    'mon',
    'mri',
    'msa',
    'mya',
    'nep',
    'nld',
    'nor',
    'oci',
    'ori',
    'osd',
    'pan',
    'pol',
    'por',
    'pus',
    'que',
    'ron',
    'rus',
    'san',
    'sin',
    'slk',
    'slk_frak',
    'slv',
    'snd',
    'spa',
    'spa_old',
    'sqi',
    'srp',
    'srp_latn',
    'sun',
    'swa',
    'swe',
    'syr',
    'tam',
    'tat',
    'tel',
    'tgk',
    'tgl',
    'tha',
    'tir',
    'ton',
    'tur',
    'uig',
    'ukr',
    'urd',
    'uzb',
    'uzb_cyrl',
    'vie',
    'yid',
    'yor']

package_output = \
"""\
##@@BEGIN_PACKAGES
packages    :
"""


package_template = Template(\
"""\
    - "${name}":
        summary: "${summary}"
        description: "${summary}"
        rundeps:
            - ${rundep}
        paths:
          - /usr/share/tesseract/tessdata/${lang}.traineddata

""")
for lang in langs:
    if lang == "osd":
        name = "tesseract-osd"
        summary = "Orientation & Script Detection Data for tesseract"
        rundep = "tesseract"
    elif lang == "equ":
        name = "tesseract-equ"
        summary = "Equation traineddata for tesseract"
        rundep = "tesseract"
    else:
        name = f"tesseract-langpack-{lang}"
        summary = f"Tesseract OCR data - ({lang})"
        rundep = "tesseract-common"
    package = package_template.substitute(
        lang = lang,
        name = name,
        summary = summary,
        rundep = rundep)
    package_output += package


package_output += \
"""\
##@@END_PACKAGES
"""


stone_recipe = Path("./stone.yaml")
if not stone_recipe.is_file():
    print("This script needs to be ran in the same directory as a stone.yaml")
    exit(1)

# Read the stone so we can modify it
with open(stone_recipe, 'r') as file:
    stone_content = file.read()

# Replace the upstreams section
stone_content = re.sub('##@@BEGIN_PACKAGES?(.*?)##@@END_PACKAGES', package_output, stone_content, flags=re.DOTALL)

print("Updating stone.yaml")
with open(stone_recipe, "w") as f:
    f.write(stone_content)
