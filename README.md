# is_agent_shapes

What an intersyntactic agent writes to say what it is called.

An agent's actor id is `agent:<id>`. The id is opaque: its install mints it
once, on first boot, and keeps it. The name is separate, because the agent
chooses it and may change it. A rename then leaves every node the agent has
written still naming it, since those nodes hold the id, and the id never
changes.

```dart
import 'package:is_agent_shapes/is_agent_shapes.dart';
import 'package:is_shapes/is_shapes.dart';

// The id the install minted on first boot and keeps.
final id = ActorId.parse('agent:7f3a9c21')!;

// The first node the agent writes says what it is called.
final named = AgentName(agent: id, name: 'Wren');

// A rename: a later pass of the same node, written by the same agent.
final renamed = AgentName(agent: id, name: 'Kestrel');
```

## What is here

- `AgentName`: what an agent calls itself. Its `agent` is marked `@identity`,
  so the node is about the agent, and its `name` is its value. A rename is a
  later pass of the same node, at the same anchor, and a reader takes the
  latest. It holds no time, because the journey path's order already says
  which pass is latest.

## The rule a reader keeps

**A pass of `AgentName` counts only when the agent it names wrote it.** A
reader discards a pass from anyone else. The shape can't check this, so the
reader has to: an agent's name is the agent's to choose, and no one else can
rename it. It is the same kind of rule as `Withdraw`'s, which counts only
from the target's author.

The name is a plain field, not a `Value` from
[`is_shapes`](https://github.com/intersyntactic/shapes). A `Value` is what
another actor can propose a correction to, and no one corrects an agent's
name for it.

## What it doesn't do

It mints nothing and keeps nothing. The install mints its agent's id on first
boot, in whatever form it likes as long as `ActorId.parse` reads it, and keeps
it. The tail is opaque, so no reader looks inside it, and its form is no one
else's contract. This package declares a shape and nothing that runs.

## The pure list

A shape file may import only what import admission's pure list allows
([#1046](https://github.com/enspyrco/intersyntactic/issues/1046)). This
package imports only `is_shapes`, so it has to be added to that list beside
it. `test/pure_list_test.dart` holds it to the list, and it reads directives
from the parse tree, so every branch of a conditional import is read.

## Depending on it

```yaml
dependencies:
  is_agent_shapes: ^0.1.0
```

It is published after `is_shapes`, which it depends on.
