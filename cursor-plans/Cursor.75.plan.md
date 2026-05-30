{
  "metadata": {
    "title": "Cursor.75 — Auth remember me + refresh tokens",
    "updatedAt": "2026-05-30"
  },
  "messages": [
    {
      "role": "user",
      "content": "Token/refresh management + remember me checkbox (1 month) for Flutter, dashboard, admin login."
    }
  ],
  "rules": [
    {
      "id": "backend-jwt",
      "prompt": "JwtOptions: RefreshTokenExpirationDays=30, CookieRememberMeDays=30; Identity BearerToken + ApplicationCookie configured."
    },
    {
      "id": "web-cookie",
      "prompt": "Angular login: useCookies=true; useSessionCookies=!rememberMe; checkbox AUTH.REMEMBER_ME."
    },
    {
      "id": "flutter-bearer",
      "prompt": "Flutter: persist tokens when rememberMe; startup refresh; 401 interceptor refresh; session-only when unchecked."
    }
  ],
  "assembledPrompt": "Implement 30-day remember-me auth across Flutter bearer and Web cookie flows.",
  "part75": {
    "tasks": [
      "JwtOptions + IdentityAuthenticationExtensions",
      "Angular auth.service + login UI + i18n",
      "Flutter token store persist mode + auth_controller startup refresh + login checkbox",
      "Tests + readmehistory"
    ]
  },
  "result75": {
    "status": "completed",
    "backend": "RefreshTokenExpiration 30d; cookie ExpireTimeSpan 30d sliding",
    "web": "rememberMe → persistent cookie; !rememberMe → session cookie",
    "flutter": "rememberMe → secure storage + refresh on launch; else in-memory session",
    "tests": "auth_repository_refresh_test + auth_token_mapper_test pass",
    "note": "Restart Web API to load Infrastructure.dll changes"
  }
}
