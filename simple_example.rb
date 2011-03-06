require_relative 'lib/bayes'

bayes = Bayes.new

Dir.glob('data/*.txt') do |fn|
  fn =~ /data\/(.*)\.txt/; topic = $1
  File.open(fn) do |f|
    bayes.update_data(topic.to_sym, f.readlines)
  end
end


p bayes.classify('adasdasdas car asdasdasd dsadaskdjalsd sd asd ')