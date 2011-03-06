#encoding:utf-8
Encoding.default_external = 'UTF-8'

require_relative 'lib/bayes'

bayes = Bayes.new

Dir.glob('data/*.txt') do |fn|
  fn =~ /data\/(.*)\.txt/; topic = $1
  File.open(fn) do |f|
    bayes.update_data(topic.to_sym, f.readlines)
  end
end

@correct = 0
@missed = 0
Dir.glob('verify/*.txt') do |fn|
  fn =~ /verify\/(.*)_(.*)\.txt/; topic = $1; sample = $2;
  File.open(fn) do |f|
    guessed_topic = bayes.classify(f.readlines.join(' '))
    puts "Sample: #{topic}_#{sample} -> #{guessed_topic}"
    if topic.to_sym == guessed_topic.to_sym
      @correct +=1
    else
      @missed +=1
    end
  end
end

puts "Total: Correct: #{@correct} Missed: #{@missed}"