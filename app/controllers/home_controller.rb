class HomeController < ApplicationController
  def landing_screen
  end

  def carrot_analy
  end

  def foam_tree
    data = File.open('junk.txt').read.downcase
    keywords = data.gsub!("\n",',').gsub!("\r", ',').split(/[\s,']/) - ['a', 'is', 'the', 'hi', 'to', 'am', '', 'from', 'an', 'my', 'your', 'not', 'are', 'cant', 'can', 'would', 'wont', 'you', '1', '2', '3', '4', 'went', 'in', 'no', 'did', 'didnt']
    processed_details = {}
    keywords.each do |keyword|
      if processed_details[keyword.to_sym].present?
        processed_details[keyword.to_sym] = processed_details[keyword.to_sym] + 1
      else
        processed_details[keyword.to_sym] = 1
      end
    end
    render json: processed_details
  end
end
