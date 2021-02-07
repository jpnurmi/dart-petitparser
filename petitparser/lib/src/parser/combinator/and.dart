import '../../../buffer.dart';
import '../../context/context.dart';
import '../../context/result.dart';
import '../../core/parser.dart';
import 'delegate.dart';

extension AndParserExtension<T> on Parser<T> {
  /// Returns a parser (logical and-predicate) that succeeds whenever the
  /// receiver does, but never consumes input.
  ///
  /// For example, the parser `char('_').and().seq(identifier)` accepts
  /// identifiers that start with an underscore character. Since the predicate
  /// does not consume accepted input, the parser `identifier` is given the
  /// ability to process the complete identifier.
  Parser<T> and() => AndParser<T>(this);
}

/// The and-predicate, a parser that succeeds whenever its delegate does, but
/// does not consume the input stream [Parr 1994, 1995].
class AndParser<T> extends DelegateParser<T> {
  AndParser(Parser delegate) : super(delegate);

  @override
  Result<T> parseOn(Context context) {
    final result = delegate.parseOn(context);
    if (result.isSuccess) {
      return context.success(result.value);
    } else {
      return result as Result<T>;
    }
  }

  @override
  int fastParseOn(Buffer buffer, int position) {
    final result = delegate.fastParseOn(buffer, position);
    return result < 0 ? -1 : position;
  }

  @override
  AndParser<T> copy() => AndParser<T>(delegate);
}
