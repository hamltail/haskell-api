# Haskell API

Take silly things seriously.

## API Design

Haskellで実装するPublic Backend APIです。

### API Category

このAPIはPublic APIです。

`/api/v1/*` へのアクセスにはAPIキーが必要です。APIキーは `X-API-Key` ヘッダーに指定します。
`/health` は認証なしでアクセスできます。

```json
{
  "meta": {
    "api": {
      "name": "haskell-api",
      "language": "Haskell",
      "category": "public"
    }
  }
}
```

APIに関する設定値は、環境変数から取得します。

```text
API_NAME=haskell-api
API_LANGUAGE=Haskell
API_CATEGORY=public
API_KEY=your-api-key
```

### Endpoints

#### `GET /health`

APIの稼働状態を確認します。

#### `GET /api/v1/posts`

投稿一覧を取得します。

#### `GET /api/v1/posts/:id`

指定したIDの投稿を取得します。

### Post

投稿データはPawthのデータ構造を参考にします。

```json
{
  "id": 1,
  "user": {
    "username": "hamru",
    "displayName": "はむる"
  },
  "content": "HaskellでAPIを作っています。",
  "postedOn": "2026-09-05",
  "createdAt": "2026-09-05T13:00:00+09:00"
}
```

### Response

```json
{
  "meta": {
    "api": {
      "name": "haskell-api",
      "language": "Haskell",
      "category": "public"
    },
    "count": 1
  },
  "data": {
    "posts": [
      {
        "id": 1,
        "user": {
          "username": "hamru",
          "displayName": "はむる"
        },
        "content": "HaskellでAPIを作っています。",
        "postedOn": "2026-09-05",
        "createdAt": "2026-09-05T13:00:00+09:00"
      }
    ]
  }
}
```

### Error Response

```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Post not found"
  }
}
```

主なHTTPステータス:

- `200 OK` - リクエスト成功
- `401 Unauthorized` - APIキーが無効
- `404 Not Found` - リソースが存在しない
- `500 Internal Server Error` - サーバー内部エラー

## Data Source

JSONファイルを使用します。

## Setup

```bash
npm install
```

`.env.example` を参考に `.env.local` を作成します。

```bash
npm run dev
```

## Test

```bash
npm test
```

## Docker

```bash
docker build -t haskell-api .
```

```bash
docker run --rm \
  -p 3000:3000 \
  -e API_NAME=haskell-api \
  -e API_LANGUAGE=Haskell \
  -e API_CATEGORY=public \
  -e API_KEY=test-api-key \
  haskell-api
```

## License

このリポジトリは学習・技術検証目的で公開しています。

著作権は作者に帰属します。
無断転載・再配布・商用利用はご遠慮ください。

This repository is published for learning and technical verification purposes.

All rights to the content belong to the author.

Please do not reproduce, redistribute, or use any part of this project for commercial purposes without permission.

## Author

- h-waji (hamltail)
