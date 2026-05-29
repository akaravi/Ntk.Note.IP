/// Returns the new address when a public IP change should be reported.
String? detectPublicIpChange({
  required String? previousAddress,
  required String currentAddress,
}) {
  final current = currentAddress.trim();
  if (current.isEmpty) {
    return null;
  }

  final previous = previousAddress?.trim();
  if (previous == null || previous.isEmpty) {
    return null;
  }

  if (previous == current) {
    return null;
  }

  return current;
}
