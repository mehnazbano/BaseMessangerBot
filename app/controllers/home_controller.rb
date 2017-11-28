class HomeController < ApplicationController
  def landing_screen
  end

  def carrot_analy
  end

  def foam_tree
    data = File.open('junk.txt').read.downcase
    # keywords = data.gsub!("\n",',').gsub!("\r", ',').split(/[\s,']/) - ['a', 'gi','and','is', 'the', 'hi', 'to', 'am', '', 'from', 'an', 'my', 'your', 'not', 'are', 'cant', 'can', 'would', 'wont', 'you', '1', '2', '3', '4', 'went', 'in', 'no', 'did', 'didnt']
    keywords = data.split(/[\s,']/).delete_if(&:empty?).collect(&:strip) - ['it','i','was','hello', 'a', 'is', 'the', 'hi', 'to', 'am', '', 'from', 'an', 'my', 'your', 'not', 'are', 'cant', 'can', 'would', 'wont', 'you', '1', '2', '3', '4', 'went', 'in', 'no', 'did', 'didnt']
    processed_details = {}
    keywords.each do |keyword|
      if processed_details[keyword.to_sym].present?
        processed_details[keyword.to_sym] = processed_details[keyword.to_sym] + 1
      elsif processed_details[keyword.singularize.to_sym].present?
        processed_details[keyword.singularize.to_sym] = processed_details[keyword.singularize.to_sym] + 1
      else
        processed_details[keyword.to_sym] = 1
      end
    end
    render json: processed_details
  end

  def d3_analy
    data = File.open('junk.txt').read.downcase
    # keywords = data.gsub!("\n",',').gsub!("\r", ',').split(/[\s,']/) - ['a', 'is', 'the', 'hi', 'to', 'am', '', 'from', 'an', 'my', 'your', 'not', 'are', 'cant', 'can', 'would', 'wont', 'you', '1', '2', '3', '4', 'went', 'in', 'no', 'did', 'didnt']
    keywords = data.split(/[\s,']/).delete_if(&:empty?).collect(&:strip) - ['it','i','was','hello','a', 'is', 'the', 'hi', 'to', 'am', '', 'from', 'an', 'my', 'your', 'not', 'are', 'cant', 'can', 'would', 'wont', 'you', '1', '2', '3', '4', 'went', 'in', 'no', 'did', 'didnt']
    processed_details = {}
    keywords.each do |keyword|
      if processed_details[keyword.to_sym].present?
        processed_details[keyword.to_sym] = processed_details[keyword.to_sym] + 1
      elsif processed_details[keyword.singularize.to_sym].present?
        processed_details[keyword.singularize.to_sym] = processed_details[keyword.singularize.to_sym] + 1
      else
        processed_details[keyword.to_sym] = 1
      end
    end
    my_details = {children: [] }
    processed_details.each do |word, count|
      my_details[:children] << {facilityId: word, responseCount: count}
    end
    render json: my_details
  end

  def keyword_search
    @keyword = params['keyword']
    @related_text = []
    data = File.open('junk.txt').read.downcase.split(',').flatten.compact.delete_if(&:empty?).collect(&:strip)
    @related_text = data.select{|dd| dd.downcase.include?(@keyword)}.group_by{|text| [text]}
    render json: { content: render_to_string( 'home/_carrot_search',
      locals: { related_text: @related_text },
      formats: [:html],
      layout: false ) }
  end

end
