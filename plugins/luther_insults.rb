#  -*- coding: utf-8 -*-
#  luther_insults.rb
#  Author: William Woodruff
#  ------------------------
#  A Cinch plugin that grabs Insults by Martin Luther for yossarian-bot.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

require 'nokogiri'
require 'open-uri'

require_relative 'yossarian_plugin'

class LutherInsults < YossarianPlugin
	include Cinch::Plugin
	use_blacklist

	URL = 'http://ergofabulous.org/luther/'

	def usage
		'!luther [nick] - Fetch a random insult from Martin Luther\'s oeuvre and direct it at a nickname if given.'
	end

	def match?(cmd)
		cmd =~ /^(!)?luther$/
	end

	match /luther$/, method: :luther_insult

	def luther_insult(m)
		page = Nokogiri::HTML(open(URL).read)
		insult = page.css('p').first.text

		m.reply insult, true
	end

	match /luther (\S+)/, method: :luther_insult_nick, strip_colors: true

	def luther_insult_nick(m, nick)
		if m.channel.users.key?(User(nick))
			begin
				page = Nokogiri::HTML(open(URL).read)
				insult = page.css('p').first.text

				m.reply "#{nick}: #{insult}"
			rescue Exception => e
				m.reply e.to_s, true
			end
		else
			m.reply "I don\'t see #{nick} in this channel."
		end
	end
end
