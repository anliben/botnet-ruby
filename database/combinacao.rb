# frozen_string_literal: true
require "sqlite3"

class Combinacao
  attr_accessor :db

  def initialize
    @db = SQLite3::Database.new "database/helper/combinacao.db"
    migrate
  end

  def insert(aposta1_id, aposta2_id)
    @db.execute "insert into combinacao (aposta1_id, aposta2_id) values (?, ?)", [aposta1_id, aposta2_id]
  end

  def get_comb
    @db.execute "select aposta1_id, aposta2_id from combinacao"
  end

  def migrate
    @db.execute <<-SQL
      create table if not exists combinacao (
        id integer primary key autoincrement,
        aposta1_id integer,
        aposta2_id integer
      );
    SQL
  end

end
