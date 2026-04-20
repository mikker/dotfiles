# Pear Release Flow

## Baseline sequence

1. Allocate or reuse an upgrade link.
2. Store the link in package metadata.
3. Bump the version.
4. Build distributables or OTA bundles.
5. Assemble the deployment directory in the shape Pear expects.
6. Stage the new build onto the link.
7. Seed it.

## Update behavior

A running app should surface `updating` and `updated` events clearly. Applying the update is a host concern. Testing the update path locally should be deliberate because it can replace the running build.

## Release discipline

- Keep dev and release settings distinct.
- Do not fake update links in production code.
- Test update flow with a separate storage location so you can compare pre-update and post-update behavior.
