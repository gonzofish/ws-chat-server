require 'em-websocket'
require 'json'
require_relative 'json-handler'

class ChatSocket < Struct.new(:socket)
    Channel = EM::Channel.new
    Handler = JH.new

    def initialize(socket)
        self.socket = socket
        @username = ""

        socket.onclose { self.on_close }
        socket.onmessage { |message| self.on_message(message) }
        socket.onopen { self.on_open }
    end

    def on_close
        Handler.remove_user(@username)
        puts "Connection closed"
    end

    def on_message(json)
        message = Handler.handle(json, socket)
        response = JSON.generate(message)
        type = message[:type]

        if type == :chat
            Channel.push response
        else
            if type == :logged_in
                @username = message[:username]
            end

            socket.send(response)
        end
    end

    def on_open
        Channel.subscribe { |message| socket.send(message) }
    end
end