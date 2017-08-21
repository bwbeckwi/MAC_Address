#requires -Version 4.0
#requires -Modules NetAdapter



$url = 'http://goo.gl/VG9XdU'
$target = "$home\Documents\macvendor.csv"
$exists = Test-Path -Path $target
if (!$exists)
{
    Invoke-WebRequest -Uri $url -UseBasicParsing -OutFile $target
}

$content = Import-Csv -Path $target

Get-NetAdapter |
  ForEach-Object {
      $macString = $_.MacAddress.SubString(0, 8).Replace('-','')
      $manufacturer = $content.
      Where{$_.Assignment -like "*$macString*"}.
      Foreach{$_.ManufacturerName}

        $_ |
            Add-Member -MemberType NoteProperty -Name Manufacturer -Value $manufacturer[0] -PassThru |
            Select-Object -Property Name, Mac*, Manufacturer
  }
