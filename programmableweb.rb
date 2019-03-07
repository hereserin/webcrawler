require_relative "spider.rb"

class ProgrammableWeb
  attr_reader :root, :handler

  def initialize(root: "https://www.programmableweb.com/apis/directory", handler: :process_index, **options)
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
    page.links_with(href: %r{\?page=\d+}).each do |link|
      spider.enqueue(link.href, :process_index)
    end

    page.links_with(href: %r{/api/\w+$}).each do |link|
      spider.enqueue(link.href, :process_api, name: link.text)
    end
  end

  def process_api(page, data = {} )
    fields = page.search("#tabs-content .field").each_with_object({}) do |tag, o|
      key = tag.search("label").text.strip.downcase.gsub(%r{[^\w]+}, ' ').gsub(%r{\s+}, "_").to_sym
      val = tag.search("span").text
      o[key] = val
    end
    categories = page.search("article.node-api .tags").first.text.strip.split(/\s+/)
    spider.record(data.merge(fields).merge(categories: categories))
  end

  private

  def spider
    @spider ||= Spider.new(self, @options)
  end
end
