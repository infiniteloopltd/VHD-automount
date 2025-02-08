$vhdPath = "C:\research\VHD\TestVHD.vhd"  # Change this to your actual VHD file path
$driveLetter = "Z"  # Change this to your preferred drive letter

# Mount the VHD
$disk = Mount-DiskImage -ImagePath $vhdPath -PassThru | Get-Disk

# Set the disk online and initialize if necessary
Set-Disk -Number $disk.Number -IsOffline $false -IsReadOnly $false
if (($disk | Get-Partition).Count -eq 0) {
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT
    New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -Confirm:$false
}

# Assign a drive letter if not already assigned
$partition = $disk | Get-Partition | Where-Object { $_.DriveLetter -eq $null }
if ($partition) {
    $partition | Set-Partition -NewDriveLetter $driveLetter
}
