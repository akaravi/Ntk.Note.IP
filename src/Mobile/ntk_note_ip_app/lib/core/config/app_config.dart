enum AppFlavor { dev, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
  });

  final AppFlavor flavor;
  final String apiBaseUrl;

  static const AppConfig current = AppConfig(
    flavor: AppFlavor.dev,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:5340',
    ),
  );
}
