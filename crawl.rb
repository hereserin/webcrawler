require_relative "programmableweb.rb"

if __FILE__== $0
  spider = ProgrammableWeb.new
  spider.results.lazy.take(5).each_with_index do |result, i|
    puts "%-3s: %s" % [i, result.inspect]
  end
end
