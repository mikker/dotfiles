---
name: cloud-share
description: Share files on the web from s3.brnbw.com, Mikkel's public S3 share. Use to upload an artifact, screenshot, image, video, HTML page, report, or a tiny static site (a folder with an index.html) and get a public link, or when asked to "share", "upload", "put it online", "give me a link to", or "cloud share" something.
---

# Cloud share

`share` (next to this file) uploads a file or a folder to the bucket behind **https://s3.brnbw.com** and prints its
public URL. Run it with the skill folder's absolute path:

```sh
~/.agents/skills/cloud-share/share report.html              # https://s3.brnbw.com/report-k3x9q2mw7a.html
~/.agents/skills/cloud-share/share shot.png "board restyle" # https://s3.brnbw.com/board-restyle-p0w8v1nq3e.png
~/.agents/skills/cloud-share/share dist/ demo               # https://s3.brnbw.com/demo-7hd02kq9xm/index.html
```

- **A file** goes up as `<name>-<random>.<ext>`. The name comes from the second argument, or else the file's own name,
  turned into a lowercase slug.
- **A folder** goes up under `<name>-<random>/`, with its layout kept. The URL is the folder's `index.html`, or one URL
  per file when there's no index. The bare folder URL (`…/demo-7hd02kq9xm/`) doesn't serve the index, so always link
  `index.html`. Relative links inside the site work. Root-relative ones (`/assets/x.css`) don't, so build with a
  relative base (Vite: `base: './'`).
- **Every upload is new.** The random suffix means a re-upload gets a new URL and never overwrites, because CloudFront
  caches for a day and the files are marked immutable. To update a share, upload again and give the new link.
- **Content types** come from the extension, and text types get `charset=utf-8`.

Show the URL to the user as a link. For an image, `show_images` can show it from its URL.

## Public means public

Anyone with the link can open it, and links get forwarded. Never upload secrets, credentials, `.env` files, customer or
personal data, or private code without the user saying so. When it's unclear whether something is fine to make public,
ask first. The key can't delete anything, so a mistaken upload stays up until Mikkel removes it with the admin key.

## Credentials

The script uses the IAM user `agent-cloud-share`. It can only upload (`s3:PutObject`) to the `s3-brnbw-com` bucket:
it can't list, delete, or touch any other bucket. Its key is in 1Password (Brainbow vault, "AWS agent cloud share
(s3.brnbw.com)"). On first use, the script reads it with `op` and caches it as an s3cmd config in
`~/.config/cloud-share/s3cfg` (mode 0600). It needs `s3cmd` (`mise use -g pipx:s3cmd`).

If an upload fails with `AccessDenied` or `InvalidAccessKeyId`, the key was probably rotated. Delete the cached config
and run the script again. Don't fall back to other AWS credentials.
