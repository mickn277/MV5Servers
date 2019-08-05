#/usr/bin/python3

import codecs
import os
import winreg as reg

# Top 15 names of overlay icons that shall be boosted:

boost = """
    Tortoise1Normal
    Tortoise2Modified
    Tortoise3Conflict
    Tortoise4Locked
    Tortoise5ReadOnly
    Tortoise6Deleted
    Tortoise7Added
    Tortoise8Ignored
    Tortoise9Unversioned
    GoogleDriveSynced
    GoogleDriveSyncing
    OneDrive4
    OneDrive5
    DropboxExt1
    DropboxExt2
"""
# Some common shell overlay icon's and their meaning
#
# Tortoise1Normal
# Tortoise2Modified
# Tortoise3Conflict
# Tortoise4Locked
# Tortoise5ReadOnly
# Tortoise6Deleted
# Tortoise7Added
# Tortoise8Ignored
# Tortoise9Unversioned
#
# GoogleDriveBlacklisted
# GoogleDriveSynced
# GoogleDriveSyncing
#
# DropboxExt1  # Green        Synced!
# DropboxExt2  # Blue         Sync in progress
# DropboxExt3  # Green (lock) Synced! (locked file)
# DropboxExt4  # Blue (lock)  Sync in progress (locked file)
# DropboxExt5  # Red          Sync not happening
# DropboxExt6  # Red (lock)   Sync not happening (locked file)
# DropboxExt7  # Gray         A file/folder isn't syncing
# DropboxExt8  # Gray (lock)  A file/folder isn't syncing (locked file)
#
# OneDrive1 # Error Not syncing (red x)
# OneDrive2 # Synced - Shared
# OneDrive3 # Syncing - Shared - UpToDateCloud
# OneDrive4 # Synced - UpToDatePinned
# OneDrive5 # Syncing
# OneDrive6 # ReadOnly
# OneDrive7 # Synced - UpToDateUnpinned


boost = set(boost.split())

backup_filename = 'IconOverlayBackup.reg'

key = (r'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion'
       r'\Explorer\ShellIconOverlayIdentifiers')
sub_key = key.split('\\', 1)[1]

def main():

    with reg.OpenKey(reg.HKEY_LOCAL_MACHINE, sub_key) as base:
        backup = []
        names = set()
        deletes = []
        renames = []
        i = 0
        while True:
            try:
                name = reg.EnumKey(base, i)
                value = reg.QueryValue(base, name)
            except OSError:
                break
            backup.append((name, value))
            core = name.strip()
            if core in names:
                deletes.append(name)
            else:
                names.add(core)
                if core in boost:
                    core = ' ' + core
                if core != name:
                    renames.append((name, core))
            i += 1

        if deletes or renames:
            print('Write backup file', backup_filename)
            with codecs.open(backup_filename, 'w', 'utf_16_le') as backup_file:
                wr = backup_file.write
                wr('\ufeff')
                wr('Windows Registry Editor Version 5.00\r\n\r\n')
                wr('[{}]\r\n\r\n'.format(key))
                for name, value in backup:
                    wr('[{}\\{}]\r\n'.format(key, name))
                    wr('@="{}"\r\n\r\n'.format(value))

            for name in deletes:
                print('Delete', repr(name))
                reg.DeleteKey(base, name)
            for old_name, new_name in renames:
                print('Rename', repr(old_name), 'to', repr(new_name))
                value = reg.QueryValue(base, old_name)
                reg.CreateKey(base, new_name)
                reg.SetValue(base, new_name, reg.REG_SZ, value)
                reg.DeleteKey(base, old_name)

            print('Restart Windows Explorer')
            if not os.system('taskkill /F /IM explorer.exe'):
                os.system('start explorer.exe')

        else:
            print('Nothing to rename')


if __name__ == '__main__':
    main()