require "discordcr"
require "./pepperoni_secrets.cr"

client = Discord::Client.new(token: TOKEN, client_id: 291390171151335424_u64)

PREFIX = "A^"

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
  if payload.content.starts_with? PREFIX + "help" || PREFIX + "commands" || PREFIX + "cmds"
    client.create_message(payload.channel_id, "Oh, hey, this is the rewritten version of CahBot, and here are the commands thus far

__Cah's Commands__
`A^die`: Kills the bot
`A^restart`: Kills the bot, pulls some code, and reboots

__Other Commands__
`A^ping`: Makes sure the bot is even alive")

client.run
