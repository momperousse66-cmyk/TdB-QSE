import fs from 'node:fs/promises';
import {Workbook} from '@oai/artifact-tool';
console.log('Artifact available',typeof Workbook.create);
const {data:d}=JSON.parse(await fs.readFile('source.json','utf8'));
for(const s of ['Suivi PdP',"Plan d'actions","Plan d'actions - Audit chantier",'Suivi Habilitations','Indice qualité et nb contrôle','Conso papier','Tableau suivi RC ']){
 let start={'Suivi PdP':11,"Plan d'actions":15,"Plan d'actions - Audit chantier":15,'Suivi Habilitations':8,'Indice qualité et nb contrôle':2,'Conso papier':60,'Tableau suivi RC ':2}[s];
 console.log(s,JSON.stringify(d[s].slice(start).map((r,i)=>({row:i+start+1,v:r.slice(0,s==='Suivi PdP'?10:7)})).filter(x=>x.v.some(v=>v!==null))));
}
