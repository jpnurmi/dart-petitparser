import '../../buffer.dart';
import 'result.dart';

/// An immutable parse result in case of a successful parse.
class Success<R> extends Result<R> {
  const Success(Buffer buffer, int position, this.value)
      : super(buffer, position);

  @override
  bool get isSuccess => true;

  @override
  final R value;

  @override
  String get message =>
      throw UnsupportedError('Successful parse results do not have a message.');

  @override
  Result<T> map<T>(T Function(R element) callback) => success(callback(value));

  @override
  String toString() => 'Success[${toPositionString()}]: $value';
}
