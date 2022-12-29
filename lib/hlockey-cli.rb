require("hlockey")
require("hlockey-cli/actions")
require("hlockey-cli/user_selection")
require("hlockey-cli/version")

module HlockeyCLI
  def self.main
    puts("Please wait...")

    Hlockey::League.start

    if Time.now < Hlockey::League.start_time
      puts(Hlockey::Messages.SeasonStarts(Hlockey::League.start_time))
    end

    loop do
      Hlockey::League.update_state
      puts(Hlockey::Messages.SeasonDay(Hlockey::League.day))
      # Will exit program if invalid option chosen
      Actions.send(
        user_selection(Actions.methods(false),
          default: :exit,
          str_process: proc { |str| str.capitalize.sub("_", " ") })
      )
    end
  end
end
