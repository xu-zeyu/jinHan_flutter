enum AppThemeMode {
  light('浅色', 'light'),
  dark('深色', 'dark'),
  gold('金色', 'gold');

  const AppThemeMode(this.label, this.value);

  final String label;
  final String value;
}
