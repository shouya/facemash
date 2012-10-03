# -*- coding: utf-8 -*-

require 'tiny_tds'

require_relative 'dbdump.conf'

def get_conn
  TinyTds::Client.new(:username => DB_LOGINID,
                      :password => DB_PASSWD,
                      :host => DB_HOST,
                      :tds_version => '70',
                      :database => DB_NAME)
end


client = get_conn


DB_DIR_BASE = File.join(DIR_BASE, DB_NAME)
Dir.exist?(DB_DIR_BASE) || Dir.mkdir(DB_DIR_BASE)


tables = client.execute('exec sp_tables').each.to_a

tables.each do |tbl|
  tbl_name = tbl['TABLE_NAME']
  next if tbl['TABLE_TYPE'] != 'TABLE'
  next if tbl_name =~ /^sys/

  puts "tbl： #{tbl_name}"

  tbl_header = nil
  tbl_data = []

  first_row = client.execute('select top 1 * from [%s]' % tbl_name)
  first_field_name = first_row.fields.first
  page_mark_value = nil
  first_row.each do |row|
    page_mark_value = row.values.first
  end

  begin

    query = '
select top %d *
from [%s]
where %s >= \'%s\'
order by %s asc
' % [PAGE_SIZE, tbl_name, first_field_name, page_mark_value, first_field_name]

#    puts query

    tbl_content = client.execute(query)

    tbl_content.each(:timezone => :local) do |row|
      tbl_header ||= row.keys
      tbl_data << row.values.map {|x| x.is_a?(Time) ? x.to_s : x}
    end

    page_mark_value = tbl_content.affected_rows == PAGE_SIZE &&
      tbl_content.each.last.values.first || nil

  end while page_mark_value

  File.write(File.join(DB_DIR_BASE, tbl_name + '.tbl'),
             Marshal.dump(:name => tbl_name,
                          :header => tbl_header,
                          :data => tbl_data))

end

