# onamae_ddns
## Overview
お名前.comでDDNSを実現するための、DNS登録ツール。

## Usage
### kubernetesのCronJobとして実行する
毎日0時に実行するCronJobのサンプル。

```
apiVersion: batch/v1
kind: CronJob
metadata:
  name: onamae-ddns
  namespace: default
spec:
  schedule: "0 0 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: onamae-ddns
              image: harbor.home.arpa/nshome/onamae_ddns:latest
              args:
                - --domname
                - nakaosora.info
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