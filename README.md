# PatentScraper
RSeleniumによるスクレイピング

# 動作環境
R version 3.5.1
<br>
Docker version 18.06.1-ce

# 環境構築
Docker Image のダウンロード

```
docker pull selenium/standalone-chrome
```

コンテナを立てる

```
docker run -d -p 4444:4444 selenium/standalone-chrome
```

以下のライブラリをダウンロード

```r
install.packages("RSelenium")
install.packages("rvest")
install.packages("XML")
```

# 実行手順
*patent_link.r*
<br>
特許一覧からか詳細ページのリンクを取得

*patent_detail.r*
<br>
特許の詳細ページから、情報を取得

*patent_link.r* → *patent_detail.r* の順で実行することで特許の詳細についてスクレイピングが可能
