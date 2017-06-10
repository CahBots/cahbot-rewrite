require "discordcr"
require "./pepperoni_secrets.cr"

client = Discord::Client.new(token: TOKEN, client_id: 291390171151335424_u64)

PREFIX = "A^"

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "ping"
    m = client.create_message(payload.channel_id, "Pong!")
    time = Time.utc_now - payload.timestamp
    client.edit_message(m.channel_id, m.id, "Pong! That took #{time.total_milliseconds.round(0)} ms.")
  end
end

client.on_message_create do |payload|
  if payload.content.starts_with? PREFIX + "restart"
    if payload.author.id == 228290433057292288_u64
      client.create_message(payload.channel_id, "Restarting")
      Process.exec("sh restart.sh", shell: true)
    else
      client.create_message(payload.channel_id, "Did you really think you'd be able to do this")
    end
  end
end

client.run