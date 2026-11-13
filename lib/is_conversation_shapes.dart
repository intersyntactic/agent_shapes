/// The shapes a journey path's conversation turns on, needed by whichever
/// module carries one, not only the agent: what an agent calls itself, what
/// a person said, and the agent's reply to it.
///
/// Named for what needs these shapes, not for who writes each one:
/// [UserSaid] is person-authored, and this package held it anyway, because
/// the test RULINGS gives a package like this is "which modules need the
/// shape,"
/// the same test that put `Comment`/`Correction`/`Approve`/`Seen` in
/// `is_annotation_shapes` regardless of who annotates. It was named
/// `is_agent_shapes` first and renamed once `UserSaid` made the mismatch
/// visible; `is_agent_shapes` on pub.dev is discontinued in its favour.
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
/// a person said, one for the agent's reply to it. Both are facts,
/// written once and never revised, so neither declares `@identity`: every
/// field is identity, the safe default for a node nothing ever corrects.
/// [SourceMessageId] is the typed id [UserSaid.source] carries, so a message
/// id stays a message id and never drifts into a bare [String] that any
/// field could be built from.
///
/// It imports only `is_shapes`, so a shape file may import it under import
/// admission's pure list once it is on it.
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

/// A message's id in its source's own terms: a Teams activity id, a Slack
/// `ts`. Opaque here, like [ActorId]'s tail — this package doesn't know
/// Teams or Slack, so it can't say what either one's ids look like, only
/// that a [UserSaid] carries one and not a bare [String] that any module
/// could build out of the wrong characters.
///
/// A module that must tell Teams' ids from Slack's wraps this field on its
/// own side, the way `SlackActorId` wraps [ActorId] in `slack_module`.
final class SourceMessageId {
  const SourceMessageId._(this.value);

  /// The id, as its source wrote it.
  final String value;

  /// [s] as a source message id, read back from text; null for an empty
  /// string or one with leading, trailing or inner whitespace, since no
  /// known source's ids have any.
  static SourceMessageId? parse(String s) =>
      s.isNotEmpty && !s.contains(RegExp(r'\s')) ? SourceMessageId._(s) : null;

  @override
  bool operator ==(Object other) =>
      other is SourceMessageId && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// What a person said, as a module received it from its source.
///
/// There is no echo-matching here: a module describes a [UserSaid] once, the
/// composition appends it after the airlock has witnessed its arrival, and
/// the journey path delivers the [TurnId] it was given back to the module —
/// that is the id everything after it, not least [ReplyText.answers], points
/// at. A module never has to compare text to tell its own message from an
/// echo of it, and it never appends on its own behalf
/// (https://github.com/intersyntactic/teams_module/pull/13).
///
/// "Who may write a [UserSaid]" is the owner gate: enforced once, outside
/// every module, by whatever appends on their behalf, so one module can
/// never put words in another's mouth.
final class UserSaid {
  const UserSaid({
    required this.author,
    required this.source,
    required this.text,
  });

  /// Who said it.
  final ActorId author;

  /// The message's id in its source's own terms.
  final SourceMessageId source;

  /// What they said.
  final String text;
}

/// The agent's reply to one [UserSaid], written once, when the message it
/// answers is finished.
///
/// A streamed reply is shown live and never stored piece by piece: this is
/// the one pass a message gets, not the latest of several.
///
/// [answers] is the [TurnId] the journey path delivered back for the
/// [UserSaid] once it was appended. It is how a module knows which
/// conversation to post into and which message to thread under, and it is
/// what makes two replies two different nodes: each answers a different
/// message, so no turn number or index is needed alongside it.
final class ReplyText {
  const ReplyText({
    required this.by,
    required this.answers,
    required this.text,
  });

  /// The agent that wrote the reply.
  final ActorId by;

  /// The [UserSaid] this replies to, by the [TurnId] it was delivered back.
  final TurnId answers;

  /// What the agent said back.
  final String text;
}
