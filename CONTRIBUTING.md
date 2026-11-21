# Contributing to `tapes`

First off: **thank you for contributing to `tapes`!**

These guidelines are lenient in spirit, not a rigid checklist so follow the spirit not the wording. That said, if something breaks or gets hard to understand inituitively, I will request changes.

- **Do not push directly to `main`.** Create a branch or fork and open a pull request. If you do, don't be surprised if your commit disappears from a local push.
- **Match the commit style.** Check `git log` for previous commit messages to see the conventions used here. That said I did make a lot of unconventional commits in the past so try to only consider the recent ones
- **Write tests.** Try not to ship code blind—test thoroughly. Test coverage in this repo is currently light, so adding tests is a great way to contribute.
- **Optional tooling:** `sccache` is supported as an optional dev-dependency if you want faster and better local builds.

---

- **Keep `main.rs` as an orchestrator.** It should act as an entry point that delegates work to `cli`, `utils` or other files. Most errors should bubble up to `main.rs` unless a specific error needs local handling for safety.
- **Respect module boundaries for helpers.** Keep helpers in the file where they are used by default. Move a helper into `util` (or `utils`) only when at least two files need it and the context makes sense.
  - *Example:* Keep the `insert` helper in the `insert` command unless `install` needs it, whereas `get_tapes_data` fits in `utils` without question.
- **Extract large structs.** If a struct definition gets long, move it into its own file.

---

- **Follow idiomatic Rust.** Standard Rust formatting and style are expected.
- **Prioritize safety and simplicity over speed and complexity.** Safety comes first, and simple code beats clever complexity every time. If you have to explain with it does with comments and words, it's too complex. There are exceptions ofcourse
- **Avoid `.clone()` and `unsafe`** unless clearly justified. *Rust is a bitch, I know*
- **Follow Never-Nesting.** Five levels of nesting is out; even three levels starts getting painful. Return early and flatten logic where possible.
- **Write readable code, not hieroglyphs.** Give code room to breathe, avoid clever tricks that require arcane knowledge, and follow **DRY** (Don't Repeat Yourself). Tricks are fun until you're patching them at 2 AM.
- **Use helpers in moderation.** Extract helpers to break up dense or staged functions. If the block starts to do something that would be better in an helper, make it an helper. That said, don't overdo it
 - **Check for typos.** Run [typos](https://github.com/crate-ci/typos) before submitting to catch spelling mistakes. The CI will judge you either way

## AI

- **Understand everything you submit.** You are responsible for every line and every bug.
- **No fully agentic commits.** Don't let an autonomous agent commit directly without human review and ownership.
- **Avoid AI-written READMEs and documentation.** Keep docs human-written and accurate to the codebase.
- **Treat AI like Stack Overflow without `Ctrl+C` or `Ctrl+V`.** Use it to learn and reason through problems, not to blindly paste generated code.
