# onamae_ddns
## Overview
お名前.comでDDNSを実現するためのDNS自動登録ツール。

自身のグローバルIPと現在Aレコードに登録されている値を比較し、差分がある時だけ更新する。
登録はできず更新のみなので初期登録は画面から実施する必要がある。

## Usage
### CLI
「www.example.com」のAレコードを更新するサンプルコマンド。

```
USER_ID=userid PASSWORD=pass ./onamae_ddns.sh --domname example.com --hostname www
```

### CronJob(Kubernetes)
10分おきに実行するCronJobのサンプル。

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: onamae-ddns
  namespace: default
spec:
  schedule: "0/10 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: onamae-ddns
              image: onamae_ddns:latest
              args:
                - --domname
                - example.com
                - --hostname
                - www
              env:
                - name: USER_ID
                  valueFrom:
                    secretKeyRef:
                      name: onamae-ddns-secret
                      key: user_id
                - name: PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: onamae-ddns-secret
                      key: password
          restartPolicy: OnFailure
```