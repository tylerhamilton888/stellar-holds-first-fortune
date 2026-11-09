# Development tooling — enforced output safety sweep (2026-11-09)

Bounded production-tool summaries; removed raw failure tails; capped repeated-error samples while retaining full logs and total error counts. Large validation plans stay in files. CI captures tool output and retains diagnostics on failure. Automated policy checks reject direct console/encoding paths, uncaptured workflow commands and oversized current documents. Added safe log excerpts and finite timeout validation. Existing release and test-success gates remain intact.

# Development tooling — conversation payload follow-up (2026-11-09)

Added a command capture wrapper that stores full output and returns metadata even on failure. Reduced mandatory recovery reading by preserving old status/handoff in history and keeping compact current checkpoints. Guidance now covers large tool arguments, source transfers and duplicated API responses. This reduces observable payload hazards; it does not establish or repair ChatGPT's server-side failure. No game runtime or release change.

# Development tooling — bounded image evidence (2026-11-09)

Replaced base64 image log dumps with PNG files and path/size manifests. Character inspection retains its rendered sheets and frame metadata as a downloadable Actions artifact. Added regression checks for bounded output and original-byte preservation, and documented safe image transfer after a reported conversation-size rejection. No game version or save changes.

Earlier game/tooling changes are preserved in [the changelog archive](history/CHANGELOG-2026-11-09.md).
