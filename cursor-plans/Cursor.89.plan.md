{
  "metadata": {
    "title": "Cursor.89 — publish/ for outputs, artifacts/ for ZIP",
    "updatedAt": "2026-05-30"
  },
  "part89": {
    "tasks": [
      "Route Web publish to publish/web (was artifacts/publish/web)",
      "Keep Flutter under publish/flutter/*",
      "Move ZIP staging to artifacts/zip-staging",
      "Default ZIP output artifacts/release-zips (not under publish/)",
      "Sync CI and runbooks"
    ]
  },
  "result89": {
    "status": "completed",
    "publishLayout": {
      "web": "publish/web",
      "webDebug": "publish/web-debug",
      "flutterAndroid": "publish/flutter/android",
      "flutterWeb": "publish/flutter/web"
    },
    "zip": {
      "staging": "artifacts/zip-staging",
      "defaultOutput": "D:/PublishKaravi/IPNote.ir"
    }
  }
}
