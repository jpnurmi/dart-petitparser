import '../../../buffer.dart';
import '../../context/context.dart';
import '../../context/result.dart';
import '../../core/parser.dart';

/// Returns a parser that consumes nothing and succeeds.
///
/// For example, `char('a').or(epsilon())` is equivalent to
/// `char('a').optional()`.
Parser<void> epsilon() => epsilonWith<void>(null);

/// Returns a parser that consumes nothing and succeeds with [result].
Parser<T> epsilonWith<T>(T result) => EpsilonParser<T>(result);

/// A parser that consumes nothing and succeeds.
class EpsilonParser<T> extends Parser<T> {
  final T result;

  EpsilonParser(this.result);

  @override
  Result<T> parseOn(Context context) => context.success(result);

  @override
  int fastParseOn(Buffer buffer, int position) => position;

  @override
  EpsilonParser<T> copy() => EpsilonParser<T>(result);

  @override
  bool hasEqualProperties(EpsilonParser<T> other) =>
      super.hasEqualProperties(other) && result == other.result;
}
