# apply_patch

This Pi extension exposes a **JSON-schema tool**, not a freeform declaration.
Call it with `{ "input": "*** Begin Patch\n...\n*** End Patch" }`; `input`
contains the patch text, not another JSON-encoded document.

All source and move paths must be nonempty and relative to the working
directory. Paths are validated before any hunk is applied. This is a relative
path policy, not a sandbox: `../` paths and symlinks are not confined to the cwd.

Each hunk's read-modify-write operation participates in Pi's shared file
mutation queue. Moves lock both canonical paths in sorted order and reject
source/destination aliases. Cancellation is checked at safe boundaries: an
in-flight filesystem operation is awaited while locks remain held, then any
completed file mutation is recorded before cancellation is reported.

Application remains best-effort, not transactional. Error results have
`isError: true` and preserve the patch, summaries, and diffs for completed
mutations, including a move destination written before source removal fails.
Re-read affected files before retrying. Created parent directories are not
included in file-change summaries. A rejected low-level write can itself leave
partial bytes; this extension does not provide atomic writes or rollback.
Queue guarantees apply to cooperating Pi tools, not external writers or
concurrent symlink retargeting.

## Offline tests

From this directory:

```sh
node --test tests/offline.test.mjs
```

The test uses the installed Pi package (including its actual queue and built-in
edit/write implementations), temporary directories, and isolated filesystem
fault injection. It requires no model or network. Set `PI_TEST_PACKAGE` to the
Pi package directory on another installation. The test lives under `tests/`
without an `index.ts`/`index.js`, so it is not an extension entrypoint.
