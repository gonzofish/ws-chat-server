# WebSocket Chat Server

This is just a toy chat server I wrote to get more comfortable/reacquainted with WebSockets!

## Dependencies

The only dependency is the [EM-WebSocket library](https://github.com/igrigorik/em-websocket/).
To install it, just run:

```shell
gem install em-websocket
```

## Running the Server

To run the server:

```shell
ruby em-ws.rb
```

## Message Format

The format for a message, both to and from the client, is:

```typescript
{
    type: string;
    username: string;
    value?: any;
}
```

All messages require a `type` and `username`, but only some messages will
provide or require a `value`.

To see the types of messages the client can send, please see
[Accepted Message Types](#client-types). For the types of messages the
server will send, please see [Response Types](#server-types).

## <a href="client-types"></a>Accepted Messages Types

Type|Purpose
---|---
`login`|Let's a user register their username, must be unique
`logout`|Unregister the username
`chat`|Send a chat message

All other types will result in a error message being returned.

## <a href="server-types"></a>Responses Types

Type|Purpose
---|---
`login_failure`|Username from a `login` is taken
`logged_in`|Username successfully registered
`chat`|A chat message was sent
`error`|An unknown message type was sent

All users receive the `chat` messages, but only the sending user will
receive the other three message types.