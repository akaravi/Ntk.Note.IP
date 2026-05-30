import '../api/api_routes.dart';
import '../config/app_config.dart';

enum CodeSnippetTabId { csharp, javascript, python, bash }

class CodeSnippetTab {
  const CodeSnippetTab({
    required this.id,
    required this.labelKey,
    required this.build,
  });

  final CodeSnippetTabId id;
  final String labelKey;
  final String Function(String plainUrl) build;
}

const codeSnippetTabs = <CodeSnippetTab>[
  CodeSnippetTab(
    id: CodeSnippetTabId.csharp,
    labelKey: 'codeTabCsharp',
    build: _csharp,
  ),
  CodeSnippetTab(
    id: CodeSnippetTabId.javascript,
    labelKey: 'codeTabJavascript',
    build: _javascript,
  ),
  CodeSnippetTab(
    id: CodeSnippetTabId.python,
    labelKey: 'codeTabPython',
    build: _python,
  ),
  CodeSnippetTab(
    id: CodeSnippetTabId.bash,
    labelKey: 'codeTabBash',
    build: _bash,
  ),
];

String get myIpPlainUrl =>
    ApiRoutes.myIpPlainUrl(AppConfig.current.apiBaseUrl);

String _csharp(String url) =>
    '''using var client = new HttpClient();
var ip = await client.GetStringAsync("$url");
Console.WriteLine(ip.Trim());''';

String _javascript(String url) => '''const response = await fetch("$url");
const ip = (await response.text()).trim();
console.log(ip);''';

String _python(String url) =>
    '''import urllib.request

with urllib.request.urlopen("$url") as response:
    print(response.read().decode().strip())''';

String _bash(String url) => 'curl -4 -s "$url"';
