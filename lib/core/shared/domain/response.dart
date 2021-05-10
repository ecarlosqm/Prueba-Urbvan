class Response<T> {
  final bool fail;
  final T? value;
  final String? message;

  get success => !fail;

  factory Response.fail(String message) {
    return Response._(
        fail: true, value: null, message: message);
  }

  factory Response.success([T? position]) {
    return Response._(fail: false, value: position, message: null);
  }

  Response._({
    required this.fail,
    required this.value,
    required this.message,
  });
}