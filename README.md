# machin-healthcheck

A concurrent HTTP status/latency checker — a single native binary, written in
**[machin](https://github.com/javimosch/machin)** (MFL).

```
$ healthcheck http://example.com http://example.org http://httpforever.com http://bad.invalid
[DOWN] unreachable          http://bad.invalid
[200]  196ms        http://example.com
[200]  222ms        http://example.org
[200]  455ms        http://httpforever.com
```

Each URL is checked in its own goroutine; results stream back over a channel as
they complete (fast/failed ones first). Reports the HTTP status code and
round-trip latency, or `DOWN` if the host can't be reached.

## Build & run

Needs the [machin](https://github.com/javimosch/machin) compiler on `PATH` (or
`MACHIN=/path/to/machin`) and a C compiler.

```bash
./build.sh                 # → ./healthcheck   (encode → compile to native)
./healthcheck <url> [url ...]
```

`http` only — `https`/TLS is not supported (machin has no TLS), so `https://…`
URLs are reported as `[skip]`.

## How it works (and why it exists)

The whole tool is `healthcheck.src` (~60 lines of MFL). It uses:

- **`args()`** — the URLs to check
- **`go` + `chan`** — one goroutine per URL, results collected over a channel
- **`dial(host, port)`** — outbound TCP connect (DNS-resolved)
- **`now_ms()`** — millisecond latency timing
- **`parse_int()`** — the port out of `host:port`
- string ops (`index`/`substr`/`has_prefix`) to parse the URL and status line

It's also a **dogfooding artifact**: building it is what drove `dial`, `now_ms`,
and `parse_int` into machin itself (machin was server-only and had no
sub-second clock or string→int before this tool asked for them). Real use
surfaced the gaps; the language grew to fill them.

## Layout

```
machin-healthcheck/
├── healthcheck.src   # the whole tool (one file)
├── build.sh          # encode → compile to a native binary
└── README.md
```
