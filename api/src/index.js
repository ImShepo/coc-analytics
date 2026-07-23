require('dotenv').config();

const { Agent, fetch: undiciFetch } = require('undici');
const cors = require('cors');
const express = require('express');
const rateLimit = require('express-rate-limit');

// Direct VPC + Cloud NAT can need 30s+ on cold start before egress works.
const upstreamAgent = new Agent({
  connectTimeout: 60_000,
  headersTimeout: 60_000,
  bodyTimeout: 60_000,
});

const PORT = Number(process.env.PORT || 8080);
const COC_KEY = (process.env.COC_KEY || '').replace(/^['"]|['"]$/g, '').trim();
const COC_API_BASE = 'https://api.clashofclans.com/v1';
const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || '*')
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);

if (!COC_KEY) {
  console.error('Missing COC_KEY. Set it in api/.env or the host environment.');
  process.exit(1);
}

const app = express();

app.disable('x-powered-by');
app.set('trust proxy', 1);

app.use(
  cors({
    origin(origin, callback) {
      if (!origin || ALLOWED_ORIGINS.includes('*') || ALLOWED_ORIGINS.includes(origin)) {
        callback(null, true);
        return;
      }
      callback(new Error('Not allowed by CORS'));
    },
  }),
);

app.use(express.json({ limit: '32kb' }));

app.use(
  rateLimit({
    windowMs: 60 * 1000,
    max: Number(process.env.RATE_LIMIT_PER_MINUTE || 60),
    standardHeaders: true,
    legacyHeaders: false,
  }),
);

app.get('/health', (_req, res) => {
  res.json({ ok: true, service: 'coc-analytics-api' });
});

/**
 * Ownership check — requires the in-game API token from
 * Settings → More settings → API Token.
 *
 * Builds an encoded upstream path from the route param so a decoded `#`
 * never becomes a URL fragment (which would break the Supercell request).
 */
app.post('/v1/players/:playerTag/verifytoken', (req, res) => {
  const token = typeof req.body?.token === 'string' ? req.body.token.trim() : '';
  if (!token) {
    res.status(400).json({
      reason: 'badRequest',
      message: 'Missing token',
    });
    return;
  }

  let tag = String(req.params.playerTag || '').trim();
  try {
    tag = decodeURIComponent(tag);
  } catch (_) {
    // keep raw param
  }
  tag = tag.replace(/^#/, '').toUpperCase();
  if (!tag) {
    res.status(400).json({
      reason: 'badRequest',
      message: 'Missing player tag',
    });
    return;
  }

  const upstreamPath = `/players/%23${encodeURIComponent(tag)}/verifytoken`;
  return proxyToCocPath(res, upstreamPath, { method: 'POST', body: { token } });
});

/**
 * Transparent proxy for the endpoints the mobile app uses:
 *   GET /v1/players/%23TAG
 *   GET /v1/clans/%23TAG
 *   GET /v1/clans?name=...
 */
app.get('/v1/*', (req, res) => proxyToCoc(req, res));

app.use((_req, res) => {
  res.status(404).json({ reason: 'notFound', message: 'Not found' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`coc-analytics-api listening on 0.0.0.0:${PORT}`);
});

process.on('uncaughtException', (err) => {
  console.error('uncaughtException', err);
});

process.on('unhandledRejection', (err) => {
  console.error('unhandledRejection', err);
});

async function proxyToCoc(req, res, { method = 'GET', body } = {}) {
  const upstreamPath = req.originalUrl.replace(/^\/v1/, '') || '/';
  return proxyToCocPath(res, upstreamPath, { method, body });
}

async function proxyToCocPath(res, upstreamPath, { method = 'GET', body } = {}) {
  const upstreamUrl = `${COC_API_BASE}${upstreamPath}`;

  try {
    const headers = {
      Authorization: `Bearer ${COC_KEY}`,
      Accept: 'application/json',
    };
    if (body !== undefined) {
      headers['Content-Type'] = 'application/json';
    }

    const upstream = await undiciFetch(upstreamUrl, {
      method,
      headers,
      body: body !== undefined ? JSON.stringify(body) : undefined,
      dispatcher: upstreamAgent,
    });

    const contentType = upstream.headers.get('content-type') || 'application/json';
    const responseBody = await upstream.text();

    res.status(upstream.status);
    res.setHeader('Content-Type', contentType);
    res.send(responseBody);
  } catch (error) {
    console.error('Upstream CoC API error:', error);
    res.status(502).json({
      reason: 'proxyError',
      message: 'Failed to reach Clash of Clans API',
    });
  }
}
