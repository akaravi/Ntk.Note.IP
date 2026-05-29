export type CodeSnippetTabId = 'csharp' | 'javascript' | 'python' | 'bash';

export interface CodeSnippetTab {
  id: CodeSnippetTabId;
  labelKey: string;
  build: (plainUrl: string) => string;
}

export const CODE_SNIPPET_TABS: CodeSnippetTab[] = [
  {
    id: 'csharp',
    labelKey: 'CODE.TAB_CSHARP',
    build: (url) => `using var client = new HttpClient();
var ip = await client.GetStringAsync("${url}");
Console.WriteLine(ip.Trim());`,
  },
  {
    id: 'javascript',
    labelKey: 'CODE.TAB_JAVASCRIPT',
    build: (url) => `const response = await fetch("${url}");
const ip = (await response.text()).trim();
console.log(ip);`,
  },
  {
    id: 'python',
    labelKey: 'CODE.TAB_PYTHON',
    build: (url) => `import urllib.request

with urllib.request.urlopen("${url}") as response:
    print(response.read().decode().strip())`,
  },
  {
    id: 'bash',
    labelKey: 'CODE.TAB_BASH',
    build: (url) => `curl -4 -s "${url}"`,
  },
];
