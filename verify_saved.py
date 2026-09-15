from pathlib import Path
import openpyxl,zipfile,xml.etree.ElementTree as ET
p=Path('outputs/qse_multivilles/Tableau_de_bord_QSE_multivilles.xlsx')
w=openpyxl.load_workbook(p,read_only=True,data_only=True)
assert abs(w['Tableau de bord']['B11'].value-0.9526061224489799)<1e-9
assert w['Tableau de bord']['B14'].value=='n.d.'
assert w['Tableau de bord']['B26'].value==13
assert w['Contrôles qualité']['A55'].value is None
assert w['Suivi mensuel']['A18'].value is None
errors=[(s.title,c.coordinate,c.value) for s in w for row in s for c in row if c.data_type=='e']
assert not errors,errors
with zipfile.ZipFile(p) as z:
 assert not any('externalLinks/' in n for n in z.namelist())
 charts=[n for n in z.namelist() if '/charts/chart' in n and n.endswith('.xml')]
 assert len(charts)==2
 tables=[n for n in z.namelist() if n.startswith('xl/tables/table') and n.endswith('.xml')]
 assert len(tables)==6
 for n in tables:
  root=ET.fromstring(z.read(n));assert root.find('{http://schemas.openxmlformats.org/spreadsheetml/2006/main}autoFilter') is not None
print('Fichier final vérifié :',len(w.sheetnames),'onglets, 6 tableaux filtrables, 2 graphiques, aucune erreur Excel enregistrée, aucun lien externe.',p.stat().st_size,'octets')
