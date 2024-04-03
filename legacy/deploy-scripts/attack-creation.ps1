# Creation of the Attack VM
#
# References:
# https://www.virtualbox.org/manual/ch08.html
# https://renenyffenegger.ch/notes/Companies-Products/Oracle/VM-VirtualBox/command-line/PowerShell/unattended-os-installation

# Initialize Variables
$env:path = "C:\Program Files\Oracle\VirtualBox;$env:path"

$vmName = "Attack"
$vmPath = "E:\vm\$vmName"
$isoFile = "F:\iso\debian-10.5.0-amd64-netinst.iso"

$preseedFile = $PSScriptRoot + "\attack-preseed.cfg"
$preseedUrl = "https://www.debian.org/releases/stable/example-preseed.txt"

# Get ISO if it doesn't exist
if (![System.IO.File]::Exists($isoFile)) {
    Write-Host "Downloading Debian 10.5.0 ISO..."
    Invoke-WebRequest -Uri "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.5.0-amd64-netinst.iso" -OutFile $isoFile
}

# Create new VM
Write-Host "Creating VM..."
#VBoxManage unattended detect --iso=$isoFile
VBoxManage createvm --name $vmName --ostype Debian_64 --register
if (! (test-path $vmPath\$vmName.vbox)) {
    Write-Host "Issue creating VM. Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    return
}

# Hard Drive
Write-Host "Creating HDD..."
VBoxManage createmedium --filename $vmPath\hard-drive.vdi --size 32768
if (! (test-path $vmPath\hard-drive.vdi)) {
    Write-Host "Issue creating HDD. Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    return
}

# SATA Controller
Write-Host "Creating SATA controller..."
VBoxManage storagectl $vmName --name SATA --add sata --controller IntelAHCI
VBoxManage storageattach $vmName --storagectl SATA --port 0 --device 0 --type hdd --medium $vmPath\hard-drive.vdi

# IDE Controller & DVD Drive
Write-Host "Creating IDE controller & DVD Drive..."
VBoxManage storagectl $vmName --name IDE --add ide
VBoxManage storageattach $vmName --storagectl IDE --port 0 --device 0 --type dvddrive --medium $isoFile

# Motherboard I/O APIC
Write-Host "Setting I/O..."
VBoxManage modifyvm $vmName --ioapic on

# Boot Order
Write-Host "Setting boot order..."
VBoxManage modifyvm $vmName --boot1 dvd --boot2 disk --boot3 none --boot4 none

# Memory
Write-Host "Setting memory..."
VBoxManage modifyvm $vmName --memory 8192 --vram 32

# CPUs
Write-Host "Setting CPUs..."
VBoxManage modifyvm $vmName --cpus 2

# Auto-Mount Shared Folder 'hacking'
Write-Host "Creating shared folder..."
VBoxManage sharedfolder add $vmName --name 'hacking' --hostpath "F:\hacking" --automount --auto-mount-point "/home/gbm/hacking"

# Clipboard Sharing
Write-Host "Enabling clipboard sharing..."
VBoxManage modifyvm $vmName --clipboard-mode bidirectional

# Graphics Controller
Write-Host "Setting graphics controller..."
VBoxManage modifyvm $vmName --graphicscontroller vboxsvga

# OS Install
VBoxManage unattended install $vmName --auxiliary-base-path="$vmPath\AUX-" --iso=$isoFile --install-additions

# Load correct preseed
if (![System.IO.File]::Exists($preseedFile)) {
    Write-Host "Downloading Debian preeseed file..."
    Invoke-WebRequest -Uri $preseedUrl -OutFile $preseedFile
    (Get-Content $preseedFile) -Replace "^d-i netcfg/get_hostname.*","d-i netcfg/get_hostname string attack" | Set-Content $preseedFile
    (Get-Content $preseedFile) -Replace "^d-i netcfg/get_domain.*","d-i netcfg/get_domain string gingerbread.net" | Set-Content $preseedFile
    (Get-Content $preseedFile) -Replace "^#tasksel tasksel/first.*","tasksel tasksel/first multiselect standard, xfce-desktop" | Set-Content $preseedFile
    (Get-Content $preseedFile) -Replace "^#d-i pkgsel/include.*","d-i pkgsel/include string openssh-server build-essential" | Set-Content $preseedFile
    (Get-Content $preseedFile) -Replace "^#d-i passwd/root-login.*","d-i passwd/root-login boolean false" | Set-Content $preseedFile

    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
    "d-i preseed/late_command string cp /cdrom/vboxpostinstall.sh /target/root/vboxpostinstall.sh \" >> $preseedFile
    " && chmod +x /target/root/vboxpostinstall.sh \" >> $preseedFile
    " && /bin/sh /target/root/vboxpostinstall.sh --need-target-bash --preseed-late-command" >> $preseedFile
}
Copy-Item $preseedFile $vmPath\AUX-preseed.cfg -Force



# TODO: Fix for Debian Graphical install
#$config = "$vmPath\AUX-isolinux-isolinux.cfg"
#(Get-Content $config) -Replace "^default vesamenu","default menu" | Set-Content $config
Write-Host "IMPORTANT: Select 'Install', not 'Graphical install' during boot. Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')

# Complete
VBoxManage startvm $vmName
Write-Host "VM creation complete."