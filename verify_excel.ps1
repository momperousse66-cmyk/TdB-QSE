$ErrorActionPreference = 'Stop'
$targetPath = Join-Path (Get-Location) 'outputs/qse_multivilles/Tableau_de_bord_QSE_multivilles.xlsx'
$excelApp = New-Object -ComObject Excel.Application
$excelApp.Visible = $false
$excelApp.DisplayAlerts = $false
$excelApp.AutomationSecurity = 3
$book = $null
try {
 $book = $excelApp.Workbooks.Open($targetPath,0,$false)
 $excelApp.CalculateFullRebuild()
 $dash = $book.Worksheets.Item('Tableau de bord')
 $quality = $book.Worksheets.Item('Contrôles qualité')
 $monthly = $book.Worksheets.Item('Suivi mensuel')
 function AssertClose($label,$actual,$expected) { if ([math]::Abs([double]$actual-[double]$expected) -gt 0.00000001) { throw "$label : $actual au lieu de $expected" }; Write-Output "$label : OK ($actual)" }
 AssertClose 'Indice qualité Excel' $dash.Range('B11').Value2 0.9526061224489799
 AssertClose 'Actions en retard Excel' $dash.Range('B26').Value2 13
 AssertClose 'PdP complets Excel' $dash.Range('B28').Value2 (13.0/51)
 if ($dash.Range('B14').Value2 -ne 'n.d.') { throw 'Une donnée absente est devenue un zéro' }
 $quality.Range('G6').Value2 = 0.0
 $excelApp.CalculateFullRebuild()
 AssertClose 'Modification note Excel' $dash.Range('B11').Value2 0.9333163265306126
 $quality.Range('G6').Value2 = 0.9452
 $monthly.Range('D12').Value2 = 0.0
 $excelApp.CalculateFullRebuild()
 AssertClose 'Zéro explicite Excel' $dash.Range('B14').Value2 0
 $monthly.Range('D12').ClearContents()
 $quality.Range('A55').Value2 = 'Ville test'
 $quality.Range('B55').Value2 = 'TEST-1'
 $quality.Range('C55').Value2 = 'Site test'
 $quality.Range('F55').Value2 = $dash.Range('B6').Value2
 $quality.Range('G55').Value2 = 0.8
 $dash.Range('B5').Value2 = 'Ville test'
 $excelApp.CalculateFullRebuild()
 AssertClose 'Nouvelle ville et nouveau contrôle Excel' $dash.Range('B11').Value2 0.8
 AssertClose 'Nouveau contrôle compté Excel' $dash.Range('B10').Value2 1
 $quality.Range('A55:H55').ClearContents()
 $dash.Range('B5').Value2 = 'Lille'
 $excelApp.CalculateFullRebuild()
 foreach ($sheet in $book.Worksheets) {
  $errors = $null
  try { $errors = $sheet.UsedRange.SpecialCells(-4123,16) } catch { }
  if ($null -ne $errors) { throw "Erreur de formule dans $($sheet.Name) : $($errors.Address())" }
 }
 Write-Output "Feuilles : $($book.Worksheets.Count), graphiques : $($dash.ChartObjects().Count)"
 $dash.Activate()
 $dash.Range('A1').Select()
 $book.Save()
 Write-Output 'Vérification Excel terminée, valeurs initiales restaurées et fichier enregistré.'
} finally {
 if ($null -ne $book) { $book.Close($false) }
 $excelApp.Quit()
 [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excelApp) | Out-Null
}
