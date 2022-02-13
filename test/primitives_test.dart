import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reactives/reactives.dart';

void main() {
  Widget getApp() => MaterialApp(home: Scaffold(body: _PrimitiveTestWidget()));
  testWidgets('defaults / initial values', (tester) async {
    /// create a state so we can construct reactive directly
    final state = _PrimitiveTestWidgetState(); //
    expect(ReactiveInt(state).value, 0);
    expect(ReactiveInt(state, initial: 1).value, 1);
    expect(ReactiveDouble(state).value, 0);
    expect(ReactiveDouble(state, initial: 1).value, 1);
    expect(ReactiveString(state).value, '');
    expect(ReactiveString(state, initial: 'a').value, 'a');
    expect(ReactiveBool(state).value, false);
    expect(ReactiveBool(state, initial: true).value, true);
  });

  testWidgets('widgets rebuild when data changes', (tester) async {
    await tester.pumpWidget(getApp());
    _PrimitiveTestWidgetState state = tester.state(find.byType(_PrimitiveTestWidget));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('0.0'), findsOneWidget);
    expect(find.text('false'), findsOneWidget);
    expect(find.text(''), findsOneWidget);
    state.someInt.value = 1;
    state.someDouble.value = 1.0;
    state.someString.value = 'hello';
    state.someBool.value = true;
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('1.0'), findsOneWidget);
    expect(find.text('true'), findsOneWidget);
    expect(find.text('hello'), findsOneWidget);
  });
}

class _PrimitiveTestWidget extends StatefulWidget {
  @override
  _PrimitiveTestWidgetState createState() => _PrimitiveTestWidgetState();
}

class _PrimitiveTestWidgetState extends State<_PrimitiveTestWidget> with ReactiveHostMixin {
  late final ReactiveInt someInt = ReactiveInt(this);
  late final ReactiveDouble someDouble = ReactiveDouble(this);
  late final ReactiveString someString = ReactiveString(this);
  late final ReactiveBool someBool = ReactiveBool(this);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${someInt.value}'),
        Text('${someDouble.value}'),
        Text(someString.value),
        Text('${someBool.value}'),
      ],
    );
  }
}
