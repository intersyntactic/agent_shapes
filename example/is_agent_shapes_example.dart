// An install minting its agent's id on first boot, and the agent naming
// itself, then renaming itself.
import 'package:is_agent_shapes/is_agent_shapes.dart';

void main() {
  // Once, on first boot. The install keeps it.
  final id = mintAgentId();

  // The first node the agent writes says what it is called.
  final named = AgentName(agent: id, name: 'Wren');

  // A rename is a later pass of the same node, at the same anchor, written
  // by the same agent. A reader takes the latest.
  final renamed = AgentName(agent: id, name: 'Kestrel');

  print('${named.agent} was ${named.name}, and is ${renamed.name}');
}
