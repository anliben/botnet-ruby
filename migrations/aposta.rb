require "sqlite3"
require_relative 'teste1'


db = SQLite3::Database.new "aposta.db"


rows = db.execute <<-SQL
  create table aposta (
    id integer primary key autoincrement,
    title varchar(30),
    link varchar(30),
    odd varchar(30)
  );
SQL
