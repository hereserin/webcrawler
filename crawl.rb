# require_relative "programmableweb.rb"
require_relative "wikipedia.rb"

if __FILE__== $0
  spider = Wikipedia.new
  spider.results.lazy.take(5).each_with_index do |result, i|
    puts "%-3s: %s" % [i, result.inspect]
  end
end
