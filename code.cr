require "discordcr"
require "urban"
require "./pepperoni_secrets.cr"
require "db"
require "pg"

client = Discord::Client.new(token: TOKEN, client_id: 291390171151335424_u64)

PREFIX = "A^"

START = Time.utc_now

client.on_ready do |things|
  client.create_message(287050338144616449_u64, "Annnnnnd we're r-r-ready, woot")
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "ping"
    m = client.create_message(payload.channel_id, "Pong!")
    time = Time.utc_now - payload.timestamp
    client.edit_message(m.channel_id, m.id, "Pong! That took around #{time.total_milliseconds.round(0)} ms.")
  end
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "restart"
    if payload.author.id == 228290433057292288_u64
      client.create_message(payload.channel_id, "Restarting")
      Process.exec("sh restart.sh", shell: true)
    else
      client.create_message(payload.channel_id, "https://youtu.be/Hwz7YN1AQmQ")
    end
  end
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "die"
    if payload.author.id == 228290433057292288_u64
      client.create_message(payload.channel_id, "See ya :wave::skin-tone-1:")
      exit
    else
      client.create_message(payload.channel_id, "https://youtu.be/Hwz7YN1AQmQ")
    end
  end
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "urban"
    if payload.content.size != 7
      stuff = Urban.define("#{payload.content[8..-1]}")
      begin
        client.create_message(payload.channel_id, "First result for `#{payload.content[8..-1]}`

Word/Term: #{stuff.list.first.word}
Author: #{stuff.list.first.author}
Definition: #{stuff.list.first.definition}
Example: *#{stuff.list.first.example}*

:thumbsup: - #{stuff.list.first.thumbs_up}
:thumbsdown: - #{stuff.list.first.thumbs_down}")
      rescue e
        client.create_message(payload.channel_id, "Some sort of error occured, here it is, `#{e}`")
      end
    else
      client.create_message(payload.channel_id, "Please specify a term to look up on UD, thanks")
    end
  end
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "console"
    if payload.author.id == 228290433057292288_u64
      time = Time.utc_now - payload.timestamp
      begin
        client.create_message(payload.channel_id, "```
#{Process.run(payload.content[10..-1], shell: true, output: IO)}
```
Executed in about #{(Time.utc_now - payload.timestamp).total_milliseconds.round(0)}ms")
      rescue e
        client.create_message(payload.channel_id, "```
Something went so wrong that this message had to trigger
```
Executed in about #{time.total_milliseconds.round(0)}ms")
      end
    else
      client.create_message(payload.channel_id, "https://youtu.be/Hwz7YN1AQmQ")
    end
  end
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "info"
    client.create_message(payload.channel_id, "**info**

The bot's uptime: About #{(START - payload.timestamp).total_hours}
The server's uptime: #{`uptime -p`}")
  end
end


client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "help"
    client.create_message(payload.channel_id, "Oh, hey, this is the rewritten version of CahBot, and here are the commands thus far

__Cah's Commands__
`A^die`: Kills the bot
`A^restart`: Kills the bot, pulls some code, and reboots
`A^console`: Do things in the console

__Other Commands__
`A^ping`: Makes sure the bot is even alive
`A^cmds`: This
`A^urban <term>`: Pops up the first result in Urban Dictionary")
  end
end

client.run
