#!/bin/bash
set -e

# デフォルト値は環境変数から
USER_ID="${USER_ID}"
PASSWORD="${PASSWORD}"
SUBDOMAIN="${SUBDOMAIN}"
DOMAIN="${DOMAIN}"

# 引数解析
while [[ $# -gt 0 ]]; do
  case $1 in
    --hostname)
      SUBDOMAIN="$2"
      shift 2
      ;;
    --domname)
      DOMAIN="$2"
      shift 2
      ;;
    *)
      echo "不明な引数: $1"
      exit 1
      ;;
  esac
done

# 必須チェック
if [[ -z "$USER_ID" || -z "$PASSWORD" || -z "$DOMAIN" ]]; then
  echo "エラー: USER_ID、PASSWORD、DOMAIN は必須です。"
  echo "使用例:"
  echo "USER_ID=xxxx PASSWORD=xxxx ./onamae_ddns.sh --domname example.com [--hostname www]"
  exit 1
fi

# FQDN組み立て
FULLDOMAIN="${SUBDOMAIN:+${SUBDOMAIN}.}$DOMAIN"
echo $FULLDOMAIN

# グローバルIP取得
CURRENT_IP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | tr -d '"')
echo "現在のグローバルIP: $CURRENT_IP"

# DNSに登録されているIP取得
DOM_IP=$(dig +short A "${FULLDOMAIN}")
echo "DNSに登録されたIP: $DOM_IP"

# IPが同じなら更新不要
if [ "$CURRENT_IP" = "$DOM_IP" ]; then
  echo "既に最新が適用されています。"
  exit 0
fi

# DDNS更新処理
echo "DNSを更新します..."
{
  echo "LOGIN"
  echo "USERID:$USER_ID"
  echo "PASSWORD:$PASSWORD"
  echo "."
  echo "MODIP"
  echo "HOSTNAME:$SUBDOMAIN"
  echo "DOMNAME:$DOMAIN"
  echo "IPV4:$CURRENT_IP"
  echo "."
  echo "LOGOUT"
  echo "."
} | openssl s_client -connect ddnsclient.onamae.com:65010 -quiet

echo "更新が完了しました。"
