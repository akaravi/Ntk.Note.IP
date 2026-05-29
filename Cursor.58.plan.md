# Cursor Plan — Ntk.Note.IP (Post-S9 Part 58)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 58",
    "updatedAt": "2026-05-30T22:00:00+03:30",
    "previousPart": "Cursor.57.plan.md"
  },
  "Part 58": {
    "title": "Refresh token rotation + 401 interceptor",
    "goal": "AuthRemotePort.refresh via Retrofit; AuthRepository.refreshTokens; QueuedInterceptor retry; verify Part 57 tests"
  },
  "Result 58": {
    "summary": "postApiV1UsersRefresh; AuthTokenRefreshInterceptor on authenticated Dio; applyTokens on success / logout on failure; auth_repository_refresh_test (20/20). Part 57 verified: 18→20 tests, analyze clean.",
    "paths": {
      "interceptor": "lib/core/auth/auth_token_refresh_interceptor.dart",
      "remote": "lib/data/datasources/auth_remote_datasource.dart",
      "ports": "lib/data/datasources/auth_remote_port.dart",
      "storePort": "lib/core/auth/auth_token_store.dart (AuthTokenStorePort)"
    },
    "verification": {
      "flutterTest": "20/20 pass",
      "dartAnalyze": "no issues (--fatal-infos)"
    },
    "deferred": [
      "FCM push for IP change",
      "Store release signing CI",
      "Go-Live .well-known placeholders"
    ],
    "nextStage": "Store release prep or product backlog from IPNote.plan"
  }
}
```