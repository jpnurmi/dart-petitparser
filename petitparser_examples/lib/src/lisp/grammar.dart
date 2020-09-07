import 'package:petitparser/petitparser.dart';

/// LISP grammar.
class LispGrammar extends GrammarParser {
  LispGrammar() : super(LispGrammarDefinition());
}

/// LISP grammar definition.
class LispGrammarDefinition extends GrammarDefinition {
  Parser start() => ref0(atom).star().end();

  Parser atom() => ref0(atom_).trim(ref0(space));
  Parser atom_() =>
      ref0(list) |
      ref0(number) |
      ref0(string) |
      ref0(symbol) |
      ref0(quote) |
      ref0(quasiquote) |
      ref0(unquote) |
      ref0(splice);

  Parser list() =>
      ref2(bracket, '()', ref0(cells)) |
      ref2(bracket, '[]', ref0(cells)) |
      ref2(bracket, '{}', ref0(cells));
  Parser cells() => ref0(cell) | ref0(empty);
  Parser cell() => ref0(atom) & ref0(cells);
  Parser empty() => ref0(space).star();

  Parser number() => ref0(number_).flatten('Number expected');
  Parser number_() =>
      anyOf('-+').optional() &
      char('0').or(digit().plus()) &
      char('.').seq(digit().plus()).optional() &
      anyOf('eE').seq(anyOf('-+').optional()).seq(digit().plus()).optional();

  Parser string() => ref2(bracket, '""', ref0(character).star());
  Parser character() => ref0(characterEscape) | ref0(characterRaw);
  Parser characterEscape() => char('\\') & any();
  Parser characterRaw() => pattern('^"');

  Parser symbol() => ref0(symbol_).flatten('Symbol expected');
  Parser symbol_() =>
      pattern('a-zA-Z!#\$%&*/:<=>?@\\^_|~+-') &
      pattern('a-zA-Z0-9!#\$%&*/:<=>?@\\^_|~+-').star();

  Parser quote() => char('\'') & ref0(list);
  Parser quasiquote() => char('`') & ref0(list);
  Parser unquote() => char(',') & ref0(list);
  Parser splice() => char('@') & ref0(list);

  Parser space() => whitespace() | ref0(comment);
  Parser comment() => char(';') & Token.newlineParser().neg().star();
  Parser bracket(String brackets, Parser parser) =>
      char(brackets[0]) & parser & char(brackets[1]);
}