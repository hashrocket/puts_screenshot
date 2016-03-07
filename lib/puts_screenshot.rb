require "puts_screenshot/version"
require 'capybara'
require 'base64'

module PutsScreenshot

  def puts_screenshot
    if screenshot_path
      $stdout.puts ImageCat.new(screenshot_path).encoded_image
    else
      $stderr.puts <<-WARNING
can't figure out how to git a screenshot to puts.

To puts a screenshot from #{Capybara.current_driver} try this:

  brew install webkit2png
      WARNING
    end
  end

  def screenshot_path
    real_screenshot or fake_screenshot
  end

  def real_screenshot
    begin
      Pathname(page.save_screenshot)
    rescue Capybara::NotSupportedByDriverError
    end
  end

  def fake_screenshot
    html_path = Pathname(page.save_page)
    system(<<-CMD)
      webkit2png #{html_path} -D #{Capybara.save_and_open_page_path} -o #{html_path.basename} -F > /dev/null
    CMD

    Dir[Capybara.save_and_open_page_path.join("*.png")]
    .map(&method(:Pathname))
    .find do |file|
      file.to_s.start_with? html_path.to_s
    end
  end

  class ImageCat
    attr_accessor :image_path

    def initialize(image_path)
      @image_path = image_path
    end

    def encoded_image
      options = {
        inline: 1,
      }.merge(dimensions).map {|k,v| [k,v].join "=" }.join ";"

      "#{osc}1337;File=#{options}:#{Base64.encode64(image_path.read)}#{st}"
    end

    private
    def tmux?
      !! /^screen/.match(ENV['TERM'])
    end

    def osc
      "\033#{ "Ptmux;\033\033" if tmux? }]"
    end

    def st
      "\a#{ "\033\\" if tmux? }"
    end

    def dimensions
      if tmux?
        `tmux list-panes` =~ /\[(?<x>\d+)x(?<y>\d+)\].*active/
        {width: $~[:x], height: $~[:y]}
      else
        {}
      end
    end
  end
end
