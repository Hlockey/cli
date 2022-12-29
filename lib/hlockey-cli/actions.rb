require("hlockey-cli/user_selection")

module HlockeyCLI::Actions
  def self.games
    if Hlockey::League.games.empty?
      puts(Hlockey::Messages.NoGames)
      return
    end

    game = user_selection(Hlockey::League.games)
    return if game.nil?

    puts("#{game.home.emoji} #{game} #{game.away.emoji}")

    loop do
      Hlockey::League.update_state
      game.stream.each(&method(:puts))

      break unless game.in_progress

      game.stream.clear
      sleep(5)
    end
  end

  def self.standings
    if Hlockey::League.champion_team
      puts(Hlockey::Messages.SeasonChampion(Hlockey::League.champion_team))
    elsif Hlockey::League.playoff_teams
      put_standings("Playoffs", Hlockey::League.playoff_teams)
    end
    Hlockey::League.divisions.each(&method(:put_standings))
  end

  def self.team_info
    team = user_selection(Hlockey::League.teams)
    return if team.nil?

    puts("#{team.emoji} #{team}")
    team.roster.each do |pos, player|
      puts("  #{Hlockey::Team.pos_name(pos)}:\n    #{player}")
      player.stats.each { |stat, value| puts("      #{stat}: #{value.round(1)}") }
    end
    puts("  wins: #{team.wins}")
    puts("  losses: #{team.losses}")
  end

  def self.election
    Hlockey::Data.election.each do |category, options|
      puts(category)
      options.each { |name, description| puts("  #{name} #{description}") }
    end
    # TODO: add an actual link to the website, probably should be from Hlockey lib data
    puts("Go to the website to vote.")
  end

  def self.information
    Hlockey::Data.information.each do |title, info|
      puts(title)
      info.each_line { |line| puts("  #{line}") }
    end
    puts("Links")
    Hlockey::Data.links.each { |site, link| puts("  #{site}: #{link}") }
  end

  def put_standings(division_name, teams)
    puts(division_name)
    teams.each { |team| puts("  #{"#{team.emoji} #{team}".ljust(26)} #{team.w_l}") }
  end
end
