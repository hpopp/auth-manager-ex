# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-03-07

### Added

- `revoke_session_by_token/1` for revoking a session by its secret token value
  (calls `POST /sessions/revoke`). Requires auth-manager >= 0.9.0.

## [0.1.0] - 2026-02-13

Initial release.
