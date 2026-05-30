{
  "metadata": {
    "title": "Cursor.80 — WHOIS domain Rdap + port43 fallback",
    "updatedAt": "2026-05-30"
  },
  "part80": {
    "tasks": [
      "Diagnose WHOIS domain returning Fake provider data",
      "Enable Whois Provider Rdap in appsettings (dev/prod/base)",
      "Add Port43WhoisDomainLookup fallback for .ir and RDAP 404 TLDs",
      "DomainNameValidator strip URL/path before host check",
      "Fix Angular WHOIS domain button disabled flag (toolsLoading)",
      "Unit tests for port43 parser and URL domain normalization"
    ]
  },
  "result80": {
    "status": "completed",
    "rootCause": "Whois:Provider=Fake returned placeholder ns1.example.com; rdap.org has no bootstrap for .ir (404)",
    "fix": "RdapWhoisProvider with port-43 fallback (whois.nic.ir for .ir); real RDAP for com/net/org",
    "tests": "Application.UnitTests Whois + DomainNameValidator: 8 passed"
  }
}
