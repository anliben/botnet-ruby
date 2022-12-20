# frozen_string_literal: true
require "sqlite3"
require_relative 'database/combinacao.rb'
require_relative 'database/aposta.rb'

class Manager

  attr_accessor :platforms, :db_aposta, :db_comb
  def initialize
    @platforms = %w[bet365 pinnacle 1xbet betway leonbets marathonbet betfair rivalo]
    @db_aposta = Aposta.new
    @db_comb = Combinacao.new

    @db_comb.get_comb.each do |id1, id2|
      @apostas = provider(id1, id2)
      if @apostas[:result]
        2.times do |index|
          if index == 1
            require_relative "sites/#{@apostas[:aposta1][:platform]}.rb"
            Navigation.new(@apostas[:aposta1])
          end

          if index == 2
            require_relative "sites/#{@apostas[:aposta2][:platform]}.rb"
            Navigation.new(@apostas[:aposta2])
          end
        end
      end
    end

  end

  def provider(p1, p2)
    @platform_resolve1 = false
    @platform_resolve2 = false

    @aposta1 = nil
    @aposta2 = nil

    @db_aposta.get_aposta_by_id(p1).each do |id, title, link, odd|
      @platforms.each do |platform|
        if link.include? platform
          @platform_resolve1 = true
          @aposta1 = {id: id, title: title, link: link, odd: odd, platform: platform}
        end
      end
    end

    @db_aposta.get_aposta_by_id(p2).each do |id, title, link, odd|
      @platforms.each do |platform|
        if link.include? platform
          @platform_resolve2 = true
          @aposta2 = {id: id, title: title, link: link, odd: odd, platform: platform}
        end
      end
    end

    return {result: @platform_resolve1 && @platform_resolve2, aposta1: @aposta1, aposta2: @aposta2}
  end

end

Manager.new