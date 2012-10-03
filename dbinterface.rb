
require 'mysql'
require_relative 'dbconfig'




class Database
  attr :db_conn

  TABLE_NAME = 'student_info'

  def initialize
    @db_conn = get_connection
    create_table unless @db_conn.list_tables.include? 'student_info'
  end

  def get_connection
    @db_conn || connect_database
  end

  def create_table
    @db_conn.query(<<HERE)
CREATE TABLE #{TABLE_NAME} (
   id INT PRIMARY KEY AUTO_INCREMENT,
   name VARCHAR(255) NOT NULL,
   barcode VARCHAR(20) NOT NULL,
   other_info VARCHAR(20),
   rating INT
);
HERE

  end

  def connect_database
    Mysql.connect(MYSQL_HOST, MYSQL_USERNAME,
                  MYSQL_PASSWORD, MYSQL_DBNAME)
  end

  def insert_data(name, barcode, other_info = nil)
    pst = @db_conn.prepare(<<HERE)
INSERT INTO #{TABLE_NAME}
  (name, barcode, other_info, rating)
VALUES
  (?, ?, ?, 0);
HERE

    pst.execute(name, barcode, other_info || '')
  end

  def vote_student(id)
    pst = @db_conn.prepare(<<HERE)
UPDATE #{TABLE_NAME}
SET rating = rating + 1
WHERE id = ?
HERE

    pst.execute(id.to_i)
  end

  def random_pick
    tbl_rst = @db_conn.query(<<HERE)
SELECT id, name, other_info, barcode
FROM #{TABLE_NAME}
ORDER BY RAND()
LIMIT 0, 2
HERE

    result = {}

    [:pic_left, :pic_right].each do |side|
      row = tbl_rst.fetch_row

      result.merge!(side => {})
      result[side].merge!(:id => row[0].to_i,
                          :info => row[1] + (row[2] ? ", #{row[2]}" : nil).to_s,
                          :barcode => row[3].to_s)
    end

    return result
  end

end

