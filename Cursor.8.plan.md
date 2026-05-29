# Cursor Plan — Ntk.Note.IP (Stage S3 batch 4)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S3",
    "part": "Part 8",
    "updatedAt": "2026-05-29T16:00:00+03:30",
    "previousPart": "Cursor.7.plan.md"
  },
  "Part 8": {
    "title": "Stage S3 — Whois, Blacklist, Privacy, Subnet/Convert",
    "goal": "S3-007, S3-011, S3-013, S3-020, S3-021 + Angular tools panel"
  },
  "Result 8": {
    "summary": "GetWhoisIp (Fake/Rdap), GetListBlacklist (Fake/Dnsbl), GetPrivacyFlags, ActionCalculateSubnet, ActionConvertIp; tools UI on /ip-lookup.",
    "api": {
      "Whois": "GET /api/Whois/GetWhoisIp?address=",
      "Blacklist": "GET /api/Blacklist/GetList?address= (data: BlacklistHitDto[])",
      "IpTools": [
        "GET GetPrivacyFlags",
        "GET ActionCalculateSubnet?cidr=",
        "POST ActionConvertIp"
      ]
    },
    "providers": {
      "Whois": "Fake | Rdap (rdap.org)",
      "Blacklist": "Fake | Dnsbl (Spamhaus, SpamCop, SORBS)",
      "IpLookup": "extended proxy/hosting/mobile on IpApi"
    },
    "tests": { "totalPipeline": 63 },
    "deferred": ["S3-008 GetWhoisDomain", "S3-010 DnsPropagation", "S3-014 SSL", "S3-015 Port check"],
    "nextStage": "Stage S4 or guest rate limit + cleanup Todo template"
  }
}
```
