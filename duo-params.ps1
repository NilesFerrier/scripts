$params = @{
    Name      = 'Duo logon for Servers'
    Key       = 'HKLM\SOFTWARE\SOFTWARE\Policies\Duo Security\DuoCredProv'
    ValueName = 'AutoPush'
    Value     = 0
    Type      = 'DWORD'
}
Set-GPRegistryValue @params



KeyPath     : SOFTWARE\Policies\Duo Security\DuoCredProv
FullKeyPath : HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Duo Security\DuoCredProv
Hive        : LocalMachine
PolicyState : Set
Value       : 0
Type        : DWord
ValueName   : AutoPush
HasValue    : True

KeyPath     : SOFTWARE\Policies\Duo Security\DuoCredProv
FullKeyPath : HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Duo Security\DuoCredProv
Hive        : LocalMachine
PolicyState : Set
Value       : 1
Type        : DWord
ValueName   : OfflineAvailable
HasValue    : True

KeyPath     : SOFTWARE\Policies\Duo Security\DuoCredProv
FullKeyPath : HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Duo Security\DuoCredProv
Hive        : LocalMachine
PolicyState : Set
Value       : api-8aca7df2.duosecurity.com
Type        : String
ValueName   : Host
HasValue    : True

KeyPath     : SOFTWARE\Policies\Duo Security\DuoCredProv
FullKeyPath : HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Duo Security\DuoCredProv
Hive        : LocalMachine
PolicyState : Set
Value       : DI3R1AT3INTYK075HFE3
Type        : String
ValueName   : IKey
HasValue    : True

KeyPath     : SOFTWARE\Policies\Duo Security\DuoCredProv
FullKeyPath : HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Duo Security\DuoCredProv
Hive        : LocalMachine
PolicyState : Set
Value       : pJH5hYKVrSaPwIIaFnE5PX8DZTdFvvnLd93mMDtK
Type        : String
ValueName   : SKey
HasValue    : True

KeyPath     : SOFTWARE\Policies\Duo Security\DuoCredProv
FullKeyPath : HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Duo Security\DuoCredProv
Hive        : LocalMachine
PolicyState : Set
Value       : 1
Type        : DWord
ValueName   : FailOpen
HasValue    : True



PS C:\temp>