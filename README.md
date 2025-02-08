Auto-Mount and Assign Drive Letter to a VHD on Windows Startup

This script automatically mounts a VHD (Virtual Hard Disk) at Windows startup and assigns it a specific drive letter. It can be used with Task Scheduler to ensure the VHD is always available.

Features

Mounts a specified VHD or VHDX file.

Ensures the disk is set online and not read-only.

Assigns a fixed drive letter.

Initializes the disk if it's newly created.

PowerShell Script

$vhdPath = "D:\path\to\your.vhdx"  # Change this to your actual VHD file path
$driveLetter = "Z"  # Change this to your preferred drive letter

# Mount the VHD
$disk = Mount-DiskImage -ImagePath $vhdPath -PassThru | Get-Disk

# Set the disk online and ensure it's writable
Set-Disk -Number $disk.Number -IsOffline $false -IsReadOnly $false

# Initialize the disk if it has no partitions
if (($disk | Get-Partition).Count -eq 0) {
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT
    New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter | Format-Volume -FileSystem NTFS -Confirm:$false
}

# Assign a drive letter if not already assigned
$partition = $disk | Get-Partition | Where-Object { $_.DriveLetter -eq $null }
if ($partition) {
    $partition | Set-Partition -NewDriveLetter $driveLetter
}

Setup Instructions

1. Save the Script

Save the above script as mount-vhd.ps1, e.g., in C:\Scripts\mount-vhd.ps1.

2. Create a Scheduled Task

To run this script at startup:

Open Task Scheduler (Win + R, type taskschd.msc, press Enter).

Click Create Task (not Basic Task).

General Tab:

Name: Mount VHD

Select Run with highest privileges.

Triggers Tab:

Click New → Select At startup → Click OK.

Actions Tab:

Click New → Choose Start a program.

In Program/script, enter:

powershell.exe

In Add arguments, enter:

-ExecutionPolicy Bypass -File "C:\Scripts\mount-vhd.ps1"

Click OK.

Conditions Tab:

Uncheck "Start the task only if the computer is on AC power" (optional).

Click OK to save the task.

3. Test the Script

To verify the script:

Manually run the PowerShell script: Open PowerShell as Administrator and execute:

& "C:\Scripts\mount-vhd.ps1"

Run the scheduled task manually to test if it works.

Notes

This script assumes the VHD has a valid file system. If it's a new disk, it initializes it.

Modify $driveLetter as needed to ensure a specific letter is used.

Ensure PowerShell execution policy allows script execution (Set-ExecutionPolicy RemoteSigned -Scope LocalMachine).

License

This script is provided under the MIT License. Feel free to modify and distribute
