import fs from 'node:fs/promises';
const {data:d}=JSON.parse(await fs.readFile('source.json','utf8'));
for(const [n,start]of [['Suivi VPO',19],['Exercices Obligatoires',14]])console.log(n,JSON.stringify(d[n].slice(start).map((r,i)=>({row:i+start+1,r})).filter(x=>x.r[0])));
