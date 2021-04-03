namespace :bot do
  desc "bot"
  task talk: :environment do
    BotController.talk_bot
  end
end
