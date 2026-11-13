# is_conversation_shapes

Shapes for a journey path's conversation, needed by whichever modules
carry one, not only the agent: what an agent calls itself, what a person
said, and the agent's reply to it.

```dart
import 'dart:typed_data';

import 'package:is_conversation_shapes/is_conversation_shapes.dart';
import 'package:is_shapes/is_shapes.dart';

// The id the install minted on first boot and keeps.
final id = ActorId.parse('agent:7f3a9c21')!;

// The first node the agent writes says what it is called.
final named = AgentName(agent: id, name: 'Wren');

// A rename: a later pass of the same node, written by the same agent.
final renamed = AgentName(agent: id, name: 'Kestrel');

// A person's message, as a module received it from its source.
final peter = ActorId.parse('teams:f6a2.../b901...')!;
final said = UserSaid(
  author: peter,
  source: SourceMessageId.parse('1234567890.123456')!,
  text: 'how is the demo coming?',
);

// The journey path delivers back a TurnId for `said` once it's appended;
// the agent's reply answers it by that id, never by matching text.
final saidId = TurnId.of(Uint8List(0)); // stood in here; nothing is stored
final reply = ReplyText(by: id, answers: saidId, text: 'nearly there');
```

## What is here

- `AgentName`: what an agent calls itself. Its `agent` is marked `@identity`,
  so the node is about the agent, and its `name` is its value. A rename is a
  later pass of the same node, at the same anchor, and a reader takes the
  latest. It holds no time, because the journey path's order already says
  which pass is latest.
- `UserSaid`: what a person said, as a module received it from its source —
  who said it, the message's id in its source's own terms, and the text.
  Written once and never revised, so every field is identity.
- `SourceMessageId`: the typed id `UserSaid.source` carries, opaque here like
  `ActorId`'s tail, since this package doesn't know Teams or Slack and can't
  say what either one's ids look like.
- `ReplyText`: the agent's reply to one `UserSaid`, written once, when the
  message it answers is finished. It `answers` by the `TurnId` the journey
  path delivered back for that `UserSaid`, which is what makes two replies
  two different nodes — no turn number or index needed alongside it.

## The rule a reader keeps

**A pass of `AgentName` counts only when the agent it names wrote it.** A
reader discards a pass from anyone else. The shape can't check this, so the
reader has to: an agent's name is the agent's to choose, and no one else can
rename it. It is the same kind of rule as `Withdraw`'s, which counts only
from the target's author.

**Who may write a `UserSaid` is the owner gate.** Enforced once, outside
every module, by whatever appends on a module's behalf, so one module can
never put words in another's mouth.

The name on `AgentName` is a plain field, not a `Value` from
[`is_shapes`](https://github.com/intersyntactic/shapes). A `Value` is what
another actor can propose a correction to, and no one corrects an agent's
name for it. `UserSaid` and `ReplyText` are facts, not values either: both
are written once and never revised.

## Why this package, not one per module

A shape only some modules need is declared once, in a package of its own,
because two declarations with one name are two types, and neither binds
where the other is accepted. That test is "which modules need the shape,"
not "who authors it" — the same test that put `Comment`, `Correction` and
`Approve` in `is_annotation_shapes` regardless of who annotates. `UserSaid`
is person-authored and still belongs here, because the Teams and Slack
modules both need it to carry a conversation across a journey path. This
package was named `is_agent_shapes` until that mismatch became visible; it
is now discontinued on pub.dev in this package's favour.

## What it doesn't do

It declares shapes and nothing that runs. The install mints an agent's id on
first boot, in whatever form it likes as long as `ActorId.parse` reads it,
and keeps it. The tail is opaque, so no reader looks inside it, and its form
is no one else's contract.

## The pure list

A shape file may import only what import admission's pure list allows
([#1046](https://github.com/enspyrco/intersyntactic/issues/1046)). This
package imports only `is_shapes`, so it has to be added to that list beside
it. `test/pure_list_test.dart` holds it to the list, and it reads directives
from the parse tree, so every branch of a conditional import is read.

## Depending on it

```yaml
dependencies:
  is_conversation_shapes: ^0.1.0
```

It is published after `is_shapes`, which it depends on.
