require 'em-websocket'
require 'json'

class JsonHandler
    Users = []

    def handle(json, socket)
        message = JSON.parse(json)
        type = message['type']

        return case type
            when "login" then handle_login(message, socket)
            when "logout" then handle_logout(message)
            when "chat" then handle_chat(message)
            else handle_unknown(message)
        end
    end

    def remove_user(username)
        if Users.include?(username)
            Users.delete(username)
        end
    end

    private

    def handle_chat(message)
        {
            type: :chat,
            username: message['username'],
            value: message['value']
        }
    end

    def create_channel(username, socket)
        exists = Users.include?(username)

        if !exists
            Users.push(username)
        end

        exists
    end

    def handle_login(message, socket)
        # login
        username = message['username']
        exists = create_channel(username, socket)
        type =  if exists
                    :login_failure
                else
                    :logged_in
                end

        {
            type: type,
            username: username
        }
    end

    def handle_logout(message)
        # logout
        username = message['username']

        remove_user(username)

        {
            type: :logged_out,
            username: username,
            value: true
        }
    end

    def handle_unknown(message)
        username = message['username']

        {
            type: :error,
            username: username,
            value: 'Unknown message type'
        }
    end
end

JH = JsonHandler