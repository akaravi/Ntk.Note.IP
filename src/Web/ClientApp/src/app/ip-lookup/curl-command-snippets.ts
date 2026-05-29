export type CurlCommandTabId = 'linux' | 'mac' | 'windows' | 'powershell' | 'mikrotik';

export interface CurlCommandTab {
  id: CurlCommandTabId;
  labelKey: string;
  build: (plainUrl: string) => string;
}

export const CURL_COMMAND_TABS: CurlCommandTab[] = [
  {
    id: 'linux',
    labelKey: 'CMD.TAB_LINUX',
    build: (url) => `curl -4 -s "${url}"`,
  },
  {
    id: 'mac',
    labelKey: 'CMD.TAB_MAC',
    build: (url) => `curl -4 -s "${url}"`,
  },
  {
    id: 'windows',
    labelKey: 'CMD.TAB_WINDOWS',
    build: (url) => `curl -4 -s "${url}"`,
  },
  {
    id: 'powershell',
    labelKey: 'CMD.TAB_POWERSHELL',
    build: (url) => `(Invoke-WebRequest -Uri "${url}" -UseBasicParsing).Content.Trim()`,
  },
  {
    id: 'mikrotik',
    labelKey: 'CMD.TAB_MIKROTIK',
    build: (url) => `/tool fetch url="${url}" mode=https keep-result=no as-value`,
  },
];
