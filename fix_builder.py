from pathlib import Path
p=Path('build.mjs');s=p.read_text(encoding='utf8')
s=s.replace("src['Suivi VPO'].slice(19)","src['Suivi VPO'].slice(19,77)")
s=s.replace('AVERAGEIFS(${qnote},${qcrit})','SUMIFS(${qnote},${qcrit})/COUNTIFS(${qcrit},${qnote},">=0",${qnote},"<>")')
s=s.replace('AVERAGEIFS(${qnote},${crit})','SUMIFS(${qnote},${crit})/COUNTIFS(${crit},${qnote},">=0",${qnote},"<>")')
s=s.replace('${range(\'Suivi mensuel\',col)},">=0")','${range(\'Suivi mensuel\',col)},">=0",${range(\'Suivi mensuel\',col)},"<>")')
s=s.replace('${range(\'Suivi mensuel\',\'C\')},">=0")','${range(\'Suivi mensuel\',\'C\')},">=0",${range(\'Suivi mensuel\',\'C\')},"<>")')
s=s.replace("setNumberFormat('mmmm yyyy')","setNumberFormat('mm/yyyy')")
s=s.replace("val(db,'A39','Compléments du mois')","val(db,'A39','Avis suivis (stock déclaré)')")
s=s.replace("val(db,'C39','Avis suivis');",'')
# Explicit source citation on each input table.
s=s.replace("val(s,'A4','Saisie jaune. Calculs gris. Filtrer la colonne Ville. 500 lignes disponibles, extensibles par insertion dans le tableau.');","val(s,'A4','Source : Lille_TDB QSE.xlsm. Saisie jaune, calculs gris. 500 lignes extensibles. Filtrer Ville.');")
p.write_text(s,encoding='utf8')
