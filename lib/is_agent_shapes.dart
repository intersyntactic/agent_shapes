/// What an agent writes to say what it is called, and the two shapes a
/// conversation turns on: what a person said, and the agent's reply to it.
///
/// An agent's actor id is `agent:<id>`, an opaque id its install mints once,
/// on first boot, and keeps. Its name is not part of the id: the agent chooses
/// its name, the name can change, and the id never does, so a rename leaves
/// every node the agent has written still naming it. The name is an
/// [AgentName], a node in a journey path like any other.
///
/// How an install mints the id is the install's business: the tail is
/// opaque, so no reader looks inside it, and [ActorId.parse] is the only
/// check it has to pass.
///
/// [UserSaid] and [ReplyText] are the minimum a module needs to carry a
/// Teams or Slack conversation across a journey path: one shape for what
/// a person said, one for the agent's reply to it
/// (https://github.com/enspyrco/intersyntactic/issues/1090). Both are facts,
/// written once and never revised, so neither declares `@identity`: every
/// field is identity, the safe default for a node nothing ever corrects.
///
/// It imports only `is_shapes`, so a shape file may import it under import
/// admission's pure list once it is on it
/// (https://github.com/enspyrco/intersyntactic/issues/1046).
library;

import 'package:is_shapes/is_shapes.dart';

/// What an agent calls itself.
///
/// The node is about [agent], its [identity]; [name] is its value. So a rename
/// is a later pass of the same node, at the same anchor, saying a new name,
/// and a reader takes the latest pass. There is no time in it: the journey
/// path's order says which pass is latest.
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

/// What a person said, as a module received it from its source.
///
/// [source] names the message in its source's own terms: a Teams activity
/// id, a Slack `ts`. It is a plain string because what counts as well formed
/// is each source's business, not this shape's; a module that needs to parse
/// its own source's ids wraps this field on its own side.
///
/// There is no echo-matching here: a module writes [UserSaid] once, the
/// journey path hands it back a [TurnId] on append, and that is the id
/// everything after it — not least [ReplyText.answers] — points at. A
/// module never has to compare text to tell its own message from an echo of
/// it.
///
/// "Who may write a [UserSaid]" is the owner gate: an acceptor refuses one
/// from a module that does not own [author]'s source, so one module can
/// never put words in another's mouth.
final class UserSaid {
  const UserSaid({
    required this.author,
    required this.source,
    required this.text,
  });

  /// Who said it.
  final ActorId author;

  /// The message's id in its source's own terms (a Teams activity id, a
  /// Slack `ts`).
  final String source;

  /// What they said.
  final String text;
}

/// The agent's reply to one [UserSaid], written once, when the message it
/// answers is finished.
///
/// A streamed reply is shown live and never stored piece by piece
/// (https://github.com/enspyrco/intersyntactic/issues/1090#issuecomment-6811669435):
/// this is the one pass a message gets, not the latest of several.
///
/// [answers] is the [TurnId] the journey path gave the [UserSaid] on append.
/// It is how a module knows which conversation to post into and which
/// message to thread under, and it is what makes two replies two different
/// nodes: each answers a different message, so no turn number or index is
/// needed alongside it.
final class ReplyText {
  const ReplyText({
    required this.by,
    required this.answers,
    required this.text,
  });

  /// The agent that wrote the reply.
  final ActorId by;

  /// The [UserSaid] this replies to, by the [TurnId] it was given on append.
  final TurnId answers;

  /// What the agent said back.
  final String text;
}
