require("hlockey-cli/user_selection")

module HlockeyCLI::Actions
  ACTIONS = %i[games standings team_info election information]

  class << self
    def games(league)
      if league.games.empty?
        puts(Hlockey::Messages.NoGames)
        return
      end

      game = HlockeyCLI.user_selection(
        league.games,
        str_process: proc { |game| game.to_s + "\n       Weather: #{game.weather}" }
      )
      return if game.nil?

      puts("#{game.home.emoji} #{game} #{game.away.emoji}")

      loop do
        league.update_state
        game.stream.each { |message| puts("#{message}\n\n") }

        break unless game.in_progress

        game.stream.clear
        sleep(5)
      end
    end

    def standings(league)
      if league.champion_team
        puts(Hlockey::Messages.SeasonChampion(league.champion_team))
      elsif league.playoff_teams
        put_standings("Playoffs", league.playoff_teams)
      end
      league.divisions.each { |name, teams| put_standings(name, teams) }
    end

    def team_info(league)
      team = HlockeyCLI.user_selection(league.teams)
      return if team.nil?

      puts("#{team.emoji} #{team}")
      team.roster.each do |pos, player|
        puts("  #{Hlockey::Team.pos_name(pos)}:\n    #{player}")
        player.stats.each { |stat, value| puts("      #{stat}: #{value.round(1)}") }
      end
      puts("  wins: #{team.wins}")
      puts("  losses: #{team.losses}")
    end

    def election(_)
      Hlockey::Data.election.each do |category, options|
        puts(category)
        options.each { |name, description| puts("  #{name}\n    #{description}") }
      end
      # TODO: add an actual link to the website,
      # probably should be from Hlockey lib data
      puts("Go to the website to vote.")
    end

    def information(_)
      Hlockey::Data.information.each do |title, info|
        puts(title)
        info.each_line { |line| puts("  #{line}") }
      end
      puts("Links")
      Hlockey::Data.links.each { |site, link| puts("  #{site}: #{link}") }
    end

    private

    def put_standings(division_name, teams)
      puts(division_name)
      teams.each { |team| puts("#{team.emoji} #{team} ".ljust(27) + team.w_l) }
    end
  end
end
