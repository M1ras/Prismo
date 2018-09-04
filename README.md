# Prismo
A userland bootloader for Linux.

## Dependencies
- Linux (duh)
- bash 4.0+ (tested with bash 4.4.23)
- GNU coreutils (tested with GNU coreutils 8.29)
  - printf
  - id
- grubby (tested with grubby 8.40)
- kexec-tools (tested with kexec-tools 2.0.17)
  - kexec

## Installation
1. Download Prismo  
  `git clone git@gitlab.com:Miras/Prismo.git`  
  `cd Prismo`
2. Reset Prismo to a stable version  
  `git reset --hard '1.0.0'`
3. Copy `prismo-grubby.sh` to `/usr/local/bin`  
  `sudo cp prismo-grubby.sh /usr/local/bin/prismo`
4. Fix `/usr/local/bin/prismo` permissions  
  `sudo chown root:root /usr/local/bin/prismo`  
  `sudo chmod 755 /usr/local/bin/prismo`

## Usage
`prismo -h` prints help.  
`prismo -v` prints version.  
`sudo prismo -l` loads a kernel.
