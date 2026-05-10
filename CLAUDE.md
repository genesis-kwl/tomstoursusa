# Tom's Tours USA — Project Continuity Doc

> **Read this first when resuming the project.** This file is the single source of truth for context, intent, current state, and conventions. Update at the end of every session if anything changed.

**Last updated:** 2026-05-09 (S62)
**Repo:** https://github.com/genesis-kwl/tomstoursusa
**Live site:** https://genesis-kwl.github.io/tomstoursusa/
**Local path:** `~/tomstoursusa/`

---

## Context

This is a **Founder personal-track freelance project** — NOT a Gen2 Lab capability. Built by Founder (Genesis / 대표님) for **Tom Lee (이 토마스)**, a 70대 한국계 미국인 모터사이클 가이드 living in New Rochelle, NY. Tom guides 한국 라이더 (60-70대 중심) on US harley tours.

The site is Tom's customer-facing landing page that helps Korean riders book his guided tours. Tom is the customer. Founder ships and Tom uses verbatim feedback to direct edits.

**Working relationship:** Tom sends edits in Korean (KakaoTalk · email) → Founder relays them in chat → Claude (gen2-designer scope) implements → push to GitHub Pages auto-deploys.

---

## Intent

**Who the site speaks to:** 60-70대 Korean riders contemplating a "magazine-grade" US bike tour. Older audience — touch targets generous, type ≥16px (S54 floor), Korean-first copy, English only as branded eyebrows.

**What the site promises:**
> "라이딩 잡지에서만 보던 길을, 베테랑 가이드와 직접" (현재 hero copy)

The hero photo (Forrest Gump Point + 5 Korean riders + Monument Valley) IS the promise made visual. Hero must always be a destination + tribe shot, not a generic landscape.

**Conversion goal:** trigger contact via KAKAOTALK consultation. CTA = `tel:516-462-5817` (Tom's KakaoTalk-linked number — not 212-518-8772 which is the Manhattan landline fallback).

**Tone:** Tom-personal. Tom often supplies copy in his own voice (e.g., "제가 뉴욕에서 할리 모터사이클 활동을 왕성하게 했다는 사진들입니다..."). Preserve Tom's voice verbatim where possible. Don't over-edit.

**Brand:** Independent of Gen2 Lab brand v0.2. Tom's site uses its own teal CTA + sans (Inter / Pretendard) + photographic editorial register. **Do NOT apply Gen² Lab brand tokens here.**

---

## Outcome (current state, S62 close)

8-page LP-style site, fully shipped + deployed. Latest deploy: commit `75afe3f`, pushed 2026-05-06.

**Pages**
- `index.html` — home: hero (full-height) → prologue → stats → 4 routes → "미국이 바이커들의 천국" → 스릴 코스 → 토마스의 할리 라이프 갤러리 (79 photos) → teal CTA → footer
- `about.html` — "토마스 이" portrait hero → 한 사람의 미국 narrative → stats → 토마스의 할리 라이프 carousel (30 photos)
- `stories.html` — "투어 현장 사진첩" — masonry gallery (71 photos: 41 tour + 30 harley_life)
- `contact.html` — contact card + KAKAOTALK CTA
- `routes/east.html` `routes/west.html` `routes/transcontinental.html` `routes/route66.html` — 4 route detail pages

**Active state**
- Hero photo: Forrest Gump Point KakaoTalk photo (Tom-supplied 2026-05-06).
- Hero hi: "라이딩 잡지에서만 보던 길을, 베테랑 가이드와 직접" (Tom-edited 2026-05-06).
- Hero sub: "미국 대륙을 수차례 달려본 토마스와 함께. 미국 46년 거주 · 50개 주 주행 · 116명의 한국 라이더 가이드."
- KAKAOTALK CTA active across home/about/contact: `tel:516-462-5817`.
- Nav label: "투어 현장 사진첩" (was "이야기" — Founder-renamed 2026-05-06).
- Hero is `100dvh` on home (mobile + desktop verified).

**Tom carry-over (open)**
- Tom's first feedback (2026-04-26 close + 2026-05-06 batch) acknowledged + applied.
- Tom requested a meeting — 답장 초안 작성됨, Founder 발송 대기.

---

## Necessary Details

### Tech stack — keep it simple

- **Static HTML5 + CSS + vanilla JS.** No build, no framework, no bundler.
- Single `style.css` (~1400 LOC, sectioned).
- Inline `<script>` per page (lightbox + carousel only).
- **External:** Google Fonts (Inter · Public Sans · Pretendard Variable). Nothing else.
- **Hosting:**
  - **Primary (production · 2026-05-09→):** Tom's GoDaddy hosting at `tomstoursusa.com` (custom domain). Static files uploaded via FTP/SFTP. Auto-deploy via `.github/workflows/deploy-godaddy.yml` on every push to main (requires GitHub Secrets `FTP_HOST` · `FTP_USER` · `FTP_PASSWORD` · `FTP_REMOTE`). Manual one-shot push: `./deploy-manual.sh` (needs `brew install lftp` once).
  - **Mirror (preview · always-on):** GitHub Pages at `https://genesis-kwl.github.io/tomstoursusa/` — auto-deploys on push to main, no extra config. Useful as fallback / preview while DNS propagates / Tom GoDaddy hosting is troubled.
  - Both are kept in sync because both deploy from the same `main` branch.
- **Server (local dev):** `python3 -m http.server 4501` from `~/tomstoursusa/`. Don't introduce Vite / Live Server / Node — out of scope.

### Asset organization

- `images/tom_photo_##_*.jpg` — original Tom-supplied photos (numbered 00-31). 31 = current hero (KakaoTalk 2026-05-06).
- `images/harley_life/IMG_1296-1325.jpg` — 30 "토마스의 할리 라이프" photos. **JPEG q82** (converted from PNG 2026-05-06 for 87% size reduction). Naming preserved from Tom source.
- `images/tom_v2_2026-04-26/` — S60 supplementary set (death_valley, harley_##_korean_parade, route66). PNG (legacy, not yet optimized).
- `images/harley/` — empty placeholder.
- `images/_originals/` — DO NOT create. Don't keep PNG originals in repo (waste).

**Naming convention for new Tom photos:**
- Tour photos: `tom_photo_NN_<descriptor>.jpg` (next number after 31)
- Personal harley life: `harley_life/IMG_NNNN.jpg`
- Always JPEG q82, max width 2048px, target ≤600KB hero / ≤300KB gallery.
- Sips command: `sips -s format jpeg -s formatOptions 82 input.png --out output.jpg`

### Conventions (do not break)

1. **Every `<img>` either has `loading="lazy"` OR `fetchpriority="high"`** (hero only). No unmarked imgs. Audit:
   ```bash
   for f in index.html about.html stories.html contact.html routes/*.html; do
     total=$(grep -c "<img " "$f"); lazy=$(grep -c 'loading="lazy"' "$f"); eager=$(grep -c 'fetchpriority="high"' "$f")
     echo "$f: unmarked=$(( total - lazy - eager ))"
   done
   ```
   Goal: every line says `unmarked=0`.

2. **Home gallery `__photos` lightbox array is auto-built** from `#slideTrack .slide` figures at runtime (index.html `<script>`). The figures are the single source of truth — never re-introduce a hardcoded `__photos` array. Adding a new photo = adding one `<figure class="slide" data-idx="N" onclick="openLightbox(N)">` only.

3. **Hero full-height uses `.hero.hero--full`** (double-class specificity). The mobile `@media (max-width: 768px)` block at style.css:719 overrides single-class `.hero--full`, so the modifier MUST stay `.hero.hero--full`. Verified bug from 2026-05-06.

4. **KAKAOTALK CTA = `<a href="kakaotalk://friendsearch?id=Tomstoursusa">`** with the ID visible in the label (so desktop users / failed deep links can copy and search manually). Four pages: index.html · about.html · stories.html · contact.html (all teal-cta + contact bottom CTA). Secondary line on each surfaces the second ID (`newyorkthomaslee` ↔ 212). Keep all in sync (P29-style logistics). Tom owns TWO KakaoTalk accounts each tied to a different phone number — never collapse to one.

5. **Korean-first copy.** All user-facing strings are Korean. English only in branded eyebrows (DISCOVER · MEET YOUR GUIDE · etc.) and the wordmark "TOM'S TOURS USA".

6. **Photo count in lede must match actual count.** `index.html` lede says "사진 79장", stories.html hero says "71장". When adding/removing photos, update both.

7. **Footer brand line on every page:** "한국 라이더를 위한 미국 모터사이클 투어 가이드.<br>미국 46년 거주 · 50개 주 · 116명 가이드." Keep all 8 pages in sync.

8. **Nav label** = "투어 현장 사진첩" (NOT "이야기" or "투어 현장"). 8 pages must agree.

9. **Hero CSS modifiers** — `.hero` (default 21:9), `.hero--small` (56vh capped), `.hero--smaller` (44vh), `.hero--portrait` (about.html, taller), `.hero--full` (home, 100dvh). Don't invent more without reason.

10. **No emoji in product UI.** No gradients / blurs / cosmic / neon / dark theme. Light theme always (per gen2-designer canon, even on this non-Gen2 project).

### Gotchas

- **Mobile media query (style.css:699-748) re-overrides hero rules** — always use `.hero.hero--full` not `.hero--full`. Same applies to other modifiers if mobile media touches them.
- **The `.gitignore` ignores `.claude/` and `lonely/` and `.DS_Store`.** Don't `git add -A` blindly — use explicit file lists.
- **`_archive_atlas/` is committed** (4 files, old Atlas branding). Public on Pages at `/_archive_atlas/`. Founder hasn't decided to remove. Don't reference from main site nav. Don't delete without Founder OK.
- **`lonely/` exists locally as old version, ignored from git.** Don't reference. Don't push.
- **Stories.html uses a different lightbox pattern** than home. Home: `__photos` JS array auto-built + `openLightbox(N)`. Stories: simple click handler on `.masonry-item img` setting lightbox `src`. Don't unify casually.
- **About.html has its own carousel** (`#harleyLifeTrack`, `slideHarleyLife()`, `openLightboxLife()`) — independent of home's `#slideTrack`. Three separate JS namespaces. Naming is intentional.
- **Tom owns TWO KakaoTalk IDs** (S62 close · 2026-05-08): `Tomstoursusa` (Westchester · 516-462-5817 · primary) and `newyorkthomaslee` (Manhattan · 212-518-8772 · secondary). The earlier "Tomstourusa" typo in contact.html was a leftover error — corrected to `Tomstoursusa`. Both IDs are intentional registrations Tom uses; both are now deep-linked via `kakaotalk://friendsearch?id=...` across all CTAs.

### Workflow (per session)

1. **Read this file first.** Then `git log -10` for recent changes, `git status` for state.
2. **Start local dev server:** `cd ~/tomstoursusa && python3 -m http.server 4501 > /tmp/tomstours_server.log 2>&1 &` then visit http://localhost:4501/.
3. **Apply changes.** Use Edit/Write. Sed for bulk patterns. Python for structured generation (e.g., 30 figures).
4. **Verify locally** via curl + browser preview before commit.
5. **Commit small, focused.** Subject ≤72 chars, body explains why.
6. **Push to deploy** ONLY with Founder confirmation (external visibility = needs go-ahead).
   - Push triggers BOTH deploys: GitHub Pages (always works) AND GoDaddy (only if FTP secrets are set).
   - Live URL: `https://tomstoursusa.com/` (Tom's domain) and `https://genesis-kwl.github.io/tomstoursusa/` (mirror).

### Deployment (GoDaddy — production)

Two paths:

**(A) Auto-deploy via GitHub Action** (preferred, set up once)
- Workflow file: `.github/workflows/deploy-godaddy.yml`
- Required GitHub Secrets (Settings → Secrets → Actions): `FTP_HOST` · `FTP_USER` · `FTP_PASSWORD` · `FTP_REMOTE` (usually `/public_html/`)
- After secrets are set, every push to main = auto FTP sync
- View deploy logs in GitHub Actions tab

**(B) Manual one-shot** (for first push or out-of-band updates)
- Install `lftp` once: `brew install lftp`
- Set env vars + run: `FTP_HOST=... FTP_USER=... FTP_PASSWORD=... FTP_REMOTE=/public_html/ ./deploy-manual.sh`
- Mirrors current dir to remote, excludes git/internal docs, parallel transfer

**What we need from Tom (one-time):**
1. GoDaddy hosting **FTP host** (e.g. `ftp.tomstoursusa.com` or specific server like `ftpupload.net`)
2. **FTP username** (typically the cPanel user)
3. **FTP password** (or SFTP if Deluxe+ plan)
4. **Web root path** (`/public_html/` for cPanel default)
5. **Domain DNS state** — is `tomstoursusa.com` already pointed at the hosting? If not, set A record to GoDaddy hosting IP (or use their auto-config in cPanel).

### Routing (who handles what)

- **gen2-designer** — all CSS/HTML edits, copy decisions, photo curation. Even small CSS tweaks. P26 hardening: "external Gen2 Business projects (Tom's Tours · F·02) → gen2-designer territory".
- **Main Gen2** — bash/git/python plumbing, file ops, batch text replacements.
- **Founder** — final taste call, Tom communication, push approval.

### Design north stars (carry from gen2-designer canon)

- Pure white paper (no cream).
- Type ≥16px (S54 floor — Tom's audience is 60-70대).
- WCAG AA contrast.
- Brockmann 8-point grid (4·8·12·16·20·24·32·40·48·64·80·96·128).
- Hero text-shadow on photo backgrounds for readability.
- No dark theme.

---

## Resume protocol — for any session continuing this project

1. **Read this file (`CLAUDE.md`) completely** before any other action.
2. Run `git log --oneline -10` and `git status` to see what changed since last session.
3. If Founder says "Tom sent feedback…" — Tom's voice should be preserved verbatim where the request involves copy. Only optimize if the request involves layout / size / asset.
4. Apply the conventions above without re-asking. They are already-validated direction from prior sessions.
5. **Update this file at session close** if anything material changed (new conventions, new gotchas, new Tom feedback batch, schema changes). Bump "Last updated" date.
6. **Open carry-overs to never forget:**
   - Tom's meeting offer (Founder reply pending — 2026-04-26 close)
   - `_archive_atlas/` cleanup decision (Founder)
   - KAKAOTALK button label / tel mismatch (Founder may want clarifier)
   - `routes/transcontinental.html` still uses deprecated `tom_photo_25_*` thumbnail
   - Tom's KakaoTalk ID typo "Tomstourusa" (verify with Tom)

---

## People around Tom (internal record — DO NOT publish to the site)

These are people Founder has logged as connected to Tom. **Not for public exposure** unless Founder explicitly requests addition to a page. Track here so future sessions know the relationship landscape.

| Person | Relationship to Tom | Contact | Notes |
|---|---|---|---|
| **Tom Lee (이 토마스)** | Owner / guide | **KakaoTalk:** `Tomstoursusa` ↔ 516-462-5817 (Westchester / 웨체스터) · `newyorkthomaslee` ↔ 212-518-8772 (Manhattan / 맨하탄) · email tomstoursusa@gmail.com | The site's protagonist. All public CTAs route to KakaoTalk via `kakaotalk://friendsearch?id=...` deep links — no longer `tel:`. Primary CTA = `Tomstoursusa`. 70대, NY 거주 46년. |
| **Anne Lee** | Tom's daughter | `516-603-8778` | US-based. Likely bilingual. Founder logged 2026-05-07. Not on public site. |
| **Brian / 강석구** | UNRELATED to Tom's Tours — separate person/business | `347-844-0762` · The Clubhouse restaurant `theclubhouseny.com` (516-873-1110, 377 Denton Ave, New Hyde Park) | Founder explicitly clarified 2026-05-07: "completely apart from tomstoursusa.com." Logged here only because the info passed through this project's chat — DO NOT confuse with Tom's contacts. |

If Founder later directs adding any of these to the public site, that's a separate authorization. Default = internal record only.

---

## Source of truth pointers

- This doc is the project's local context.
- Cross-system memory: `~/.claude/projects/-Users-genesis-Gen2/memory/project_tomstoursusa_freelance.md` — Gen2 memory entry.
- Plans: `~/.claude/plans/bring-up-tomstoursusa-golden-beacon.md` — current session plan (transient).
- Gen2 broader context: `~/Gen2/CLAUDE.md` (Gen2 AOS — does not govern this project but provides Founder profile + design canon used as reference).

When this doc and memory disagree, **this doc wins** (it travels with the repo and is closest to the code). Update memory to match.
