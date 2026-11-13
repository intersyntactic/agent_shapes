# Changelog

## 0.1.0

- First release as `is_conversation_shapes`
  (https://github.com/enspyrco/intersyntactic/issues/1090): named for which
  modules need a shape, not for who writes it — `UserSaid` is
  person-authored, and belongs here on that test regardless.
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
