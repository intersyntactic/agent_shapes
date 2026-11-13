# Changelog

## 0.1.0

- First release as `is_conversation_shapes`, renamed from `is_agent_shapes`
  (https://github.com/enspyrco/intersyntactic/issues/1090): the package held
  `UserSaid`, a person-authored shape, which made the old name's framing —
  "who writes it" rather than "which modules need it" — visibly wrong.
  `is_agent_shapes` is discontinued on pub.dev in this package's favour.
- `AgentName`: what an agent calls itself. Its identity is the agent's
  `agent:<id>`, which names the agent in every node it writes, and its value
  is the name, which can change while the id never does.
- `UserSaid`: what a person said, as a module received it from its source —
  carries who said it, the message's id in its source's own terms, and the
  text. Ends echo-matching: a reply answers it by the `TurnId` the journey
  path delivers back, never by comparing text.
- `ReplyText`: the agent's reply to one `UserSaid`, written once, when the
  message it answers is finished.
- `SourceMessageId`: the typed id `UserSaid.source` carries, so a message id
  never drifts into a bare `String`.
