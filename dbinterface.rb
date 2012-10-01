
require 'mysql'
require_relative 'dbconfig'


@db_conn = nil

def create_tables(conn)
  conn.query(<<HERE)
CREATE TABLE student_info (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(255) NOT NULL,
   barcode VARCHAR(20) NOT NULL,
   class VARCHAR(20)
);
HERE

end

def connect_database
  return @db_conn if @db_conn

  @db_conn = Mysql.connect(MYSQL_HOST, MYSQL_USERNAME,
                           MYSQL_PASSWORD, MYSQL_DBNAME)

  create_tables(@db_conn) unless  @db_conn.list_tables.include? 'student_info'

  return @db_conn
end

def insert_data(name, barcode, clazz = nil)
  pst = @db_conn.prepare(<<HERE)
INSERT INTO student_info
  (name, barcode, class)
VALUES
  (?, ?, ?);
HERE

  pst.execute(name, barcode, clazz || '')


end
