require 'em-websocket'
require_relative 'chat-socket'

EventMachine.run {
    host = "0.0.0.0"
    port = 4567

    EventMachine::WebSocket.start(:host => host, :port => port) do |ws|
        ChatSocket.new(ws)
    end

    puts "Start server at #{host}:#{port}"
}
