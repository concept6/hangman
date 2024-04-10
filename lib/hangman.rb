

def hangman()
    # can load a saved game. only supports a single save, not multiple. 

    puts "Hello! Would you like to start a 'new' game or 'load' a saved game?!?"
    seek_input = true
    while seek_input == true
        game_desired = gets.chomp
        if game_desired == "new"
            seek_input = false
        elsif game_desired == "load"
            seek_input = false
        else
            puts "Please enter a valid command of 'new' or 'load'."
        end
    end

    # loads new or saved game

    if game_desired == 'new'

        dictionary_words = File.readlines('google-10000-english-no-swears.txt')

        # randomly select a word
        # if it's the less than 5 characters or greater than 12 characters, keep selecting until you got it
        need_word = true
        while need_word == true
            game_word = dictionary_words.sample.chomp
            if game_word.length >= 5 && game_word.length <=12
                need_word = false
            end
        end
        # puts game_word # to-do remove this debugging

        game_word_array = game_word.split("")

        word_progress_array = Array.new(game_word_array.length, '_')

        remaining_incorrect_guesses = 11
        guessed_letters = []
        round = 0

        reloaded = false

    elsif game_desired == 'load'

        filename = "saves/savedgame.csv"

        lines = File.readlines(filename)
        
        game_word_array = lines[0].split('')
        word_progress_array = lines[1].split('')
        remaining_incorrect_guesses = lines[2].to_i
        guessed_letters = lines[3].split('')
        round = lines[4].to_i

        reloaded = true

    end

    # gameplay loop

    game_active = true
    
    while game_active == true

        if round == 0 || reloaded == true
            puts "Current word progress is as follows: " + word_progress_array.join(" ")
            puts "You can still miss #{remaining_incorrect_guesses} guesses...before the hanging!"
            reloaded = false
        end

        seek_input = true
        while seek_input == true
            puts "Please enter your next guess! Of the form Ex. 'j'. (Alternatively, you may 'save' the game and quit.)"
            current_guess = gets.chomp
            current_guess.downcase!
            if current_guess == 'save'
                # serialize the save to a file in a saves folder

                Dir.mkdir('saves') unless Dir.exist?('saves')
            
                filename = "saves/savedgame.csv"

                File.open(filename,'w') do |file|
                    game_word_array.each {|a| file.print a}
                    file.print "\n"
                    word_progress_array.each {|a| file.print a}
                    file.print "\n"
                    file.print remaining_incorrect_guesses
                    file.print "\n"
                    guessed_letters.each {|a| file.print a}
                    file.print "\n"
                    file.print round
                end

                game_active = false
                return nil

            elsif current_guess.length == 1 && current_guess.match?(/[[:alpha:]]/) 
                if guessed_letters.include?(current_guess)
                    puts "You have already guessed that!"
                else
                    seek_input = false
                end
            end
        end

        # see how guess went, and update word_progress_array, guessed letters, and remaining_incorrect_guesses

        guessed_letters.push(current_guess)

        successful_guess = 0
        game_word_array.each_with_index do |a, i|
            if a == current_guess
                word_progress_array[i] = current_guess
                successful_guess += 1
            end
        end

        if word_progress_array.include?("_") == false
            puts "Congrats! You've guessed the word!"
            puts "The word was: " + word_progress_array.join("")
            puts "The man has survived!!"
            game_result = "won"
            game_active = false
        end
        
        if successful_guess > 0 
            puts "Success! Current word progress is as follows: " + word_progress_array.join(" ")
        elsif successful_guess == 0
            remaining_incorrect_guesses -= 1
            puts "That's a whiff! You can still miss #{remaining_incorrect_guesses} guesses...before the hanging!"
            if remaining_incorrect_guesses < 0
                puts "Oh...that's it then. The man has been hanged."
                game_result = 'lost'
                game_active = false
                break
            end
            puts "Current word progress is as follows: " + word_progress_array.join(" ")
        end

        round += 1
    end
    return nil
end

hangman()