#encoding: utf-8

require 'set'

class Bayes

  def initialize(debug = false)
    @word_categories = {}
    @categories = Set.new
    @debug = debug
  end

  def clean_text(text)
    [*text].join(' ').gsub(/\s+/, ' ').split(' ')
  end

  def update_data(topic, text)
    @categories.add(topic)
    text = clean_text(text)
    text.each do |w|
      @word_categories[w] ||= Set.new
      @word_categories[w] << topic
    end
  end

  def classifiers(text)
    uni_cat_probability = 1.to_f / @categories.size
    probabilities = Hash[@categories.map { |c| [c, uni_cat_probability] }]
#    probabilities = {}
    text = clean_text(text)
    text.each do |w|
      cats = @word_categories[w] || []
      puts "#{w} -> #{cats.inspect}" if @debug
      @categories.each do |c|
        if cats.include?(c)
          p_w_cat = (1.to_f / @word_categories.size) * (1.to_f / cats.size) / uni_cat_probability
          p_cat_w = uni_cat_probability * p_w_cat
        else
          p_cat_w = 0.0000001
        end
        p_cat = probabilities[c]
        probabilities[c] = (p_cat * p_cat_w) / (1.to_f - (1.to_f - p_cat)*(1.to_f - p_cat_w))
      end
      # for each word
      # for each category the word points to
      # p[cat|w] = p[cat]p[w|cat]
      # p[w|cat] = p[w]*p[cat|w]/p[cat]

    end
    probabilities
  end

  def classify(text)
    probabilities = classifiers(text)
    probabilities.to_a.sort { |a, b| a[1] <=> b[1] }[-1][0]
  end
end