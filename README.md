オブザーバビリティ基盤を手っ取り早く体験するためのリポジトリです。

### 実行方法
## 前提
* Linux環境での実行を想定しています。
* terraformがインストールされている前提です。
* AWS認証情報は~/.aws/credentialsに記載するか、環境変数に設定されている前提です。
## 手順
1. infra/terraform/main.tfのtempo_s3_name、loki_s3_nameを任意の文字列に変更
2. infra/terraform配下で以下実行すると各種AWSリソースが作成できます。
```
cd infra/terraform
terraform init
terraform apply
```
※最初はECRリポジトリに何もPushされていないため、ECSのサービス作成の欄でエラーになります。

3. app/otel_tempo_loki/loki-config.yamlのs3の欄をご自身のバケット名、AWS認証情報に変更
4. app/otel_tempo_loki/tempo-config.yamlのs3欄をご自身のバケット名、AWS認証情報に変更
5. app/otel_tempo_loki/tempo-config.yamlのremotewrite.endpointの欄をご自身のManaged Prometheusのリモート書き込みURL、AWS認証情報に変更
6. app/otel_tempo_loki/otel-collector-config.yamlのprometheusremotewrite.endpointの欄をご自身のManaged Prometheusのリモート書き込みURLに変更
7. k6, observabilityのECRにpush
```
cd app/k6
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.ap-northeast-1.amazonaws.com
docker build . -t k6:latest
docker tag k6:latest <account_id>.dkr.ecr.ap-northeast-1.amazonaws.com/k6:latest
docker push <account_id>.dkr.ecr.ap-northeast-1.amazonaws.com/k6:latest

cd ../app/otel_tempo_loki
docker build . -t observability:latest
docker tag observability:latest <account_id>.dkr.ecr.ap-northeast-1.amazonaws.com/observability:latest
docker push <account_id>.dkr.ecr.ap-northeast-1.amazonaws.com/observability:latest
```

7. 再度terraform apply実行
8. Managed Grafanaにアクセスして、ユーザの登録
10. GrafanaのGUIから、各種データソースを登録（Tempo, LokiはNLBのエンドポイント:<port>, PrometheusはManaged PrometheusのリモートURLを指定）
