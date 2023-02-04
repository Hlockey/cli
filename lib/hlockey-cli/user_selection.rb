module HlockeyCLI
  def self.user_selection(choices, default: nil, str_process: proc { |s| s })
    puts("Please enter a number...")

    # 1 is added to i when printing choices
    # to avoid confusing a non-numerical input with the first choice
    choices.each_with_index do |choice, i|
      puts("#{(i + 1).to_s.rjust(2)} - #{str_process.call(choice)}")
    end
    puts("anything else - #{default || "Back"}")

    # 1 is subracted to undo adding 1 earlier
    choice_idx = $stdin.gets.to_i - 1

    if !choice_idx.negative? && choice_idx < choices.length
      choices[choice_idx]
    else
      default
    end
  end
end
