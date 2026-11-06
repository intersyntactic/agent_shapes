// An agent naming itself, then renaming itself.
import 'package:is_agent_shapes/is_agent_shapes.dart';
import 'package:is_shapes/is_shapes.dart';

void main() {
  // The id the install minted on first boot and keeps. Its tail is opaque.
  final id = ActorId.parse('agent:7f3a9c21')!;

  // The first node the agent writes says what it is called.
  final named = AgentName(agent: id, name: 'Wren');

  // A rename is a later pass of the same node, at the same anchor, written
  // by the same agent. A reader takes the latest.
  final renamed = AgentName(agent: id, name: 'Kestrel');

  print('${named.agent} was ${named.name}, and is ${renamed.name}');
}
