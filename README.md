# scripts

various scripts for various platforms


## Truenas Scale

### smb auxillary param

#### list smb shares

List the smb shares

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/scripts/refs/heads/main/truenas-scale/smbAuxUpdater.sh  | bash
```

#### update smb id's
update via id

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/scripts/refs/heads/main/truenas-scale/smbAuxUpdater.sh  | bash -s -- --id #
```

#### remove aux
remove aux via id

```shell
curl -sSL https://raw.githubusercontent.com/xstar97/scripts/refs/heads/main/truenas-scale/smbAuxUpdater.sh  | bash -s -- --id # --remove-aux
```


## Talos/kubernetes

### Webhook receiver url


```shell
curl -sSL https://raw.githubusercontent.com/xstar97/scripts/refs/heads/main/talos/flux/getWebHookUrl.sh  | bash
```