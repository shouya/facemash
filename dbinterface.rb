
require 'mysql'
require_relative 'dbconfig'


@db_conn = nil

def create_tables(conn)
  SQL_CREATE_TABLE = <<HERE
CREATE TABLE student_info (
   id INT,
   name VARCHAR(255),
   department VARCHAR(20),
   class VARCHAR(20),
   barcode VARCHAR(20)
);
HERE
  conn.query()

end

def connect_database
  return @db_conn if @db_conn

  @db_conn = Mysql.connect(MYSQL_HOST, MYSQL_USERNAME,
                           MYSQL_PASSWORD, MYSQL_DBNAME)
  if @db_conn.list_tables.empty?
    create_tables(@db_conn)
  end
end
