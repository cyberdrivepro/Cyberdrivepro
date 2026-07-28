# CyberDrive Pro v1.0 — Technical & Developer Documentation

**CyberDrive Pro v1.0** turns your Telegram infrastructure (User MTProto & Bot Pools) into a high-performance personal desktop cloud storage client. Files upload directly to Telegram Private Storage Channels or Saved Messages with multi-part parallel worker chunking, instant SHA-256 deduplication, zero-refresh live UI updates, and public/private share link controls.

---

## 1. Core Architecture & Storage Engines

```
Browser (Cyber Client)  ⇄  CyberDrive Pro API  ⇄  Upload Scheduler
                                                        │
                              ┌─────────────────────────┼─────────────────────────┐
                              │                         │                         │
                         Multi-Bot Pool            MTProto Pool            Sync Engine
                        (Bot1, Bot2, Bot3...)   (User Sessions)        (Channel History Scanner)
                              │                         │                         │
                              └─────────────────────────┴─────────────────────────┘
                                                        │
                                          Private Telegram Storage Channels
```

### Pluggable Storage Providers & Schedulers:
1. **User MTProto Engine (GramJS):** Uploads large files (up to 2GB/4GB per chunk) with 8–16 parallel part streams into Private Channels or Saved Messages (`me`).
2. **Bot Storage Engine (Telegram Bot API):** Multi-bot worker pool (`Bot 1`, `Bot 2`, `Bot 3`...) load balancing chunk uploads across channels.
3. **Hybrid Mode Scheduler:** Automatically routes small files (<= 20MB) to Telegram Bot API and large files (> 20MB) to MTProto User sessions.

---

## 2. Key Features & Optimizations

### ⚡ SHA-256 Instant Deduplication
- Incoming files are hashed via streaming SHA-256.
- Matching hashes instantly reuse existing Telegram message references — consuming **0 bytes** of upload bandwidth!

### 📥 IDM-Style Parallel Worker Queue
- Configurable worker pool concurrency (8 to 16 workers).
- Multi-part chunking with 1.9 GB safety threshold.
- Live Server-Sent Events (SSE) broadcasting speed, ETA, chunk grid status, and pause/resume/cancel controls.

### 🎥 HTTP Range Streaming (`206 Partial Content`)
- Supports Range requests (`bytes=X-Y`) allowing instant seeking in built-in media players (`PlayerModal`) and multi-thread download managers.

### 🤖 Multi-Bot Worker Pool & Auto-Fallback
- Connect 8+ Telegram bots in parallel.
- Automatically handles `429 FloodWait` rate limits by shifting chunk uploads to the next available healthy bot or MTProto session.

---

## 3. Developer API

Every user can call these Developer API endpoints directly from external scripts:

```http
POST   /api/v1/upload            multipart field "file", optional ?public=1
GET    /api/v1/files              list your files
GET    /api/v1/files/:id          metadata for one file
GET    /api/v1/files/:id/stream   download/stream (supports Range)
DELETE /api/v1/files/:id          delete file
```

### Auth Headers:
```http
X-API-Key: cd_xxxxxxxxxxxxxxxxxxxx
Authorization: Bearer cd_xxxxxxxxxxxxxxxxxxxx
```

---

## 4. Configuration (`backend/.env`)

```env
# Get TG_API_ID and TG_API_HASH from https://my.telegram.org
TG_API_ID=38854541
TG_API_HASH=c41ddebc281b945936a640e74f083dca

# Telegram Bot API & Private Storage Channel
TG_BOT_TOKEN=8998765213:AAElgP2pmyrJ0rxrTPWSc4ubPfH_J81XLlk
TG_CHANNEL_ID=-1003767197790

# Security Secrets
SESSION_ENCRYPT_KEY=your_long_random_encryption_secret
COOKIE_SECRET=your_cookie_session_secret
PORT=4000
PUBLIC_BASE_URL=http://localhost:5173
```

---

## 5. Quickstart & Local Execution

### Backend:
```powershell
cd backend
npm install
npm start
```

### Frontend:
```powershell
cd frontend
npm install
npm run dev
```

---

## 6. Credits & Community

**CyberDrive Pro v1.0** — Personal Desktop Telegram Cloud Suite.
- Powered by **ShreeAPI** · Designed by **AnshAPI**
- Community: [t.me/shreeapi](https://t.me/shreeapi) & [t.me/nepalimomoswala](https://t.me/nepalimomoswala)
