require "sqlite3"

class Aposta
  attr_accessor :db

  def initialize()
    @db = SQLite3::Database.new "database/helper/aposta.db"
    migrate
  end

  def insert(title, odd, link)
    @db.execute "insert into aposta (title, link, odd) values (?, ?, ?)", [title, link, odd]
    @db.execute("SELECT id FROM aposta WHERE ID = (SELECT MAX(ID) FROM aposta);")
  end

  def get_aposta_by_title(title)
    @db.execute "select * from aposta where title = ?", [title]
  end

  def get_id_by_title(title)
    @db.execute "select id from aposta where title = ?", [title]
  end

  def get_aposta_by_id(id)
    @db.execute "select * from aposta where id = ?", [id]
  end

  def migrate
    @db.execute <<-SQL
      create table if not exists aposta (
        id integer primary key autoincrement,
        title varchar(30),
        link varchar(30),
        odd varchar(30)
      );
    SQL
  end
end
