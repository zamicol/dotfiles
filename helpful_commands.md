# Git Based System Auxiliary Memory for Biological Analog Interface #


## Network ##
Network Editor GUI

    nm-connection-editor

## Used ports and Unix sockets ##

    netstat -nl

## SSH

Master socket:

    ssh -M -S ~/.ssh/<name> -fnNT -L 9000:localhost:<remote_port> <remote>
    ssh -S ~/.ssh/<another_name> -fnNT -L 9001:localhost:<another_remote_port> <another_remote>
    ssh -S ~/.ssh/dev -O check <name>
    ssh -S ~/.ssh/dev -O stop <name>
    ssh -S ~/.ssh/dev -O exit <name>

Normal Tunnel:

    ssh -L 9000:localhost:<remote_port> <remote>

## git ##

Remove a directory from tracking

   git rm -r --cached <dir>

## SHA 256 fingerprint ##

    ssh-keygen -lf ~/.ssh/known_hosts


## Processes ##
Find a process

    ps -ef | grep <process name>


## Archiving and Compression ##

untar tar.gz

    tar -C <location> -xzf <tar>

## USB ISO image disk gui ##

    sudo gnome-disks
    mintstick -m iso
    # Easy windows GUI:
    winusb

## Cron ##
root's cron:

    crontab -e
