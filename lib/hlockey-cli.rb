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

      selected_action = user_selection(
        Actions::ACTIONS,
        default: :Exit,
        str_process: proc { |s| s.to_s.capitalize.sub("_", " ") }
      )
      if selected_action == :Exit
        exit
      end
      Actions.send(selected_action, league)
    end
  end
end
