# coc-analytics-api

Proxy for the Clash of Clans API. The Supercell `COC_KEY` stays on the server so you can whitelist **one fixed IP** for production.

## Why this exists

Supercell API keys are IP-locked. Mobile users have changing IPs, so the key must not live in the Flutter app.

```
App → this API (fixed IP) → api.clashofclans.com
```

## Local development

```bash
cd api
cp .env.example .env
# paste your COC_KEY (same key; whitelist your current public IP in Supercell)
npm install
npm run dev
```

Health check: http://localhost:8080/health

Player ownership check (in-game API token):

```
POST /v1/players/%23TAG/verifytoken
{ "token": "…" }
```

### Flutter on Android emulator

In `coc/.env`:

```
API_BASE_URL=http://10.0.2.2:8080/v1
```

`10.0.2.2` is the host machine from the Android emulator.

### Flutter on iOS simulator

```
API_BASE_URL=http://127.0.0.1:8080/v1
```

Do **not** put `COC_KEY` in the Flutter `.env` for production builds.

## Deploy (Cloud Run + Direct VPC + Cloud NAT)

Production (project `clash-of-clans-2fd27`, region `us-central1`):

| | |
|---|---|
| Service URL | `https://coc-analytics-api-srcfysg3wa-uc.a.run.app` |
| Flutter `API_BASE_URL` | `https://coc-analytics-api-srcfysg3wa-uc.a.run.app/v1` |
| Static egress IP | `35.253.218.34` |
| Secret | Secret Manager `coc-key` |

1. In [developer.clashofclans.com](https://developer.clashofclans.com/) edit your API key and allow **only** `35.253.218.34`.
2. Point Flutter release builds to the `API_BASE_URL` above (do **not** ship `COC_KEY` in the app).
3. Health check: `GET /health` → `{"ok":true,...}`.

Infra names: subnet `coc-run-subnet-26`, router `coc-router`, NAT `coc-nat`, IP `coc-nat-ip`, Artifact Registry `coc-api`.

## Endpoints proxied

Same paths the app already uses:

- `GET /v1/players/%23TAG`
- `GET /v1/clans/%23TAG`
- `GET /v1/clans?name=Name`
