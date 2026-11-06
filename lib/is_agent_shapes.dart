/// What an agent writes to say what it is called, and the id that names it in
/// every node it writes.
///
/// An agent's actor id is `agent:<id>`, an opaque id its install mints once,
/// on first boot, with [mintAgentId], and keeps. Its name is not part of the
/// id: the agent chooses its name, the name can change, and the id never
/// does, so a rename leaves every node the agent has written still naming it.
/// The name is an [AgentName], a node in the line like any other.
///
/// It imports only `is_shapes` and `dart:math`, so a shape file may import it
/// under import admission's pure list once it is on it
/// (https://github.com/enspyrco/intersyntactic/issues/1046).
library;

import 'dart:math';

import 'package:is_shapes/is_shapes.dart';

/// What an agent calls itself.
///
/// The node is about [agent], its [identity]; [name] is its value. So a rename
/// is a later pass of the same node, at the same anchor, saying a new name,
/// and a reader takes the latest pass. There is no time in it: the line's
/// order says which pass is latest.
///
/// A pass counts only when [agent] wrote it. The shape can't check that, so a
/// reader discards a pass written by anyone else: an agent's name is the
/// agent's to choose, and no one else can rename it.
///
/// The name is a plain field, not a [Value]. A [Value] is what another actor
/// can propose a correction to, and no one corrects an agent's name for it.
final class AgentName {
  const AgentName({required this.agent, required this.name});

  /// The agent this names.
  @identity
  final ActorId agent;

  /// The name the agent chose.
  final String name;
}

/// A fresh agent id: `agent:` and 128 random bits in lower-case hex, from
/// [Random.secure].
///
/// An install calls this once, on first boot, and keeps what it returns.
/// Calling it again makes a different agent, not the same one renamed. It
/// keeps nothing itself: keeping the id is the install's business, and this
/// package imports no `dart:io`.
ActorId mintAgentId() {
  final random = Random.secure();
  final hex = StringBuffer();
  for (var i = 0; i < 16; i++) {
    hex.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
  }
  return ActorId.parse('agent:$hex')!;
}
