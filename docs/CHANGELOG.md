# Development tooling — conversation payload follow-up (2026-11-09)

Added a command capture wrapper that stores full output and returns metadata even on failure. Reduced mandatory recovery reading by preserving old status/handoff in history and keeping compact current checkpoints. Guidance now covers large tool arguments, source transfers and duplicated API responses. This reduces observable payload hazards; it does not establish or repair ChatGPT's server-side failure. No game runtime or release change.

# Development tooling — bounded image evidence (2026-11-09)

Replaced base64 image log dumps with PNG files and path/size manifests. Character inspection retains its rendered sheets and frame metadata as a downloadable Actions artifact. Added regression checks for bounded output and original-byte preservation, and documented safe image transfer after a reported conversation-size rejection. No game version or save changes.

Earlier game/tooling changes are preserved in [the changelog archive](history/CHANGELOG-2026-11-09.md).
