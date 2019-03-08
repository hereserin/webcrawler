require_relative "spider.rb"
require 'byebug'

class Wikipedia
  attr_reader :root, :handler

  def initialize(root: "https://en.wikipedia.org/wiki/Portal:Current_events", handler: :process_index, **options)
    @root = root
    @handler = handler
    @options = options
  end

  def results(&block)
    spider.results(&block)
  end

  # def handler_method(page, data = {})
  #  enqueue urls and/or record data
  # end

  def process_index(page, data = {})
    # page.links_with(href: %r{\?page=\d+}).each do |link|
    #   spider.enqueue(link.href, :process_index)
    # end

    page.links_with(href: %r{/wiki/\w+$}).each do |link|
      spider.enqueue(link.href, :process_wiki, name: link.text)
    end
  end

  def process_wiki(page, data = {} )

    paragraphs = page.search("p").each_with_object([]) do |paragraph, arr|
      arr << paragraph.text
    end

    links = page.links.each_with_object({}) do |link, o|
      key = link.text
      val = link.href
      o[key] = val
    end
    spider.record(data.merge(links).merge(paragraphs: paragraphs))
  end

  private

  def spider
    @spider ||= Spider.new(self, @options)
  end
end
