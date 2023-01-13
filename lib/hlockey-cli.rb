require("hlockey")
require("hlockey-cli/actions")
require("hlockey-cli/user_selection")
require("hlockey-cli/version")

module HlockeyCLI
  def self.main
    puts("Please wait...")

    league = Hlockey::League.new

    if Time.now < league.start_time
      puts(Hlockey::Messages.SeasonStarts(league.start_time))
    end

    loop do
      league.update_state
      puts(Hlockey::Messages.SeasonDay(league.day))
      # Will exit program if invalid option chosen
      Actions.send(
        user_selection(Actions.methods(false),
          default: :exit,
          str_process: proc { |str| str.capitalize.sub("_", " ") }), league
      )
    end
  end
end
