class ApiResult<T> {
  const ApiResult._({
    required this.isSuccess,
    this.data,
    this.errorMessage,
  });

  factory ApiResult.ok(T data) => ApiResult._(isSuccess: true, data: data);

  factory ApiResult.fail(String message) =>
      ApiResult._(isSuccess: false, errorMessage: message);

  final bool isSuccess;
  final T? data;
  final String? errorMessage;
}
