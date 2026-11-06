import 'package:is_agent_shapes/is_agent_shapes.dart';
import 'package:test/test.dart';

void main() {
  // An agent id is written into every node the agent writes, for good, so
  // its form is a wire contract: a change to it is a change to every id
  // minted after it.
  test(
    'an agent id is agent: and 32 lower-case hex digits, fresh each time',
    () {
      final ids = [for (var i = 0; i < 64; i++) mintAgentId().value];
      for (final id in ids) {
        expect(id, matches(RegExp(r'^agent:[0-9a-f]{32}$')));
      }
      expect(ids.toSet(), hasLength(ids.length));
    },
  );
}
