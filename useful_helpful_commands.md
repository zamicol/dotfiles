# Git Based System Auxiliary Memory for Biological Analog Interface #

This is NOT located here: https://gist.github.com/zamicol/50d6b3594cb191139b043418ec0c4072
even though I keep looking for a gist.  


# Encrypt a file

```
gpg -c file_name.txt
```

Decrypt:

gpg -d file_name.txt

Expire password cache:

```
echo RELOADAGENT | gpg-connect-agent
```

Then delete the unencrypted file:
v verbose
z zero out when done
f "force" change permissions if needed (use sudo if needed for this)
u delete the file when done.  

```
shred -vfzu file_name.txt 
```

# sh #

[Rich’s sh (POSIX shell) tricks](http://www.etalabs.net/sh_tricks.html)

# ssh #
## sockets ##
Master socket:

    ssh -M -S ~/.ssh/<name> -fnNT -L 9000:localhost:<remote_port> <remote>
    ssh -S ~/.ssh/<another_name> -fnNT -L 9001:localhost:<another_remote_port> <another_remote>
    ssh -S ~/.ssh/dev -O check <name>
    ssh -S ~/.ssh/dev -O stop <name>
    ssh -S ~/.ssh/dev -O exit <name>

Normal Tunnel:

    ssh -L 9000:localhost:<remote_port> <remote>

Regenerate Public Key from Private:

    ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub

## SHA256 fingerprint ##

    ssh-keygen -lf ~/.ssh/known_hosts

## Network ##
Network Editor GUI

    nm-connection-editor

## Used ports and Unix sockets ##

    netstat -nl

## git ##

Remove a directory from tracking

   git rm -r --cached <dir>


## Processes ##
Find a process

    ps -ef | grep <process name>


## Archiving and Compression ##

untar tar.gz

    tar -C <location> -xzf <tar>

## USB ISO image disk gui ##
# Startupdiskcreator disk burner usb burner

    sudo gnome-disks
    mintstick -m iso
    # Easy windows GUI:
    winusb

## Cron ##
root's cron:

    crontab -e


## Files ##
### Add a line if it doesn't already exist ###
    LINE='example line'
    FILE=file.txt
    grep -q "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

Find UUID of a swap file:
    findmnt -no SOURCE,UUID -T /swapfile
