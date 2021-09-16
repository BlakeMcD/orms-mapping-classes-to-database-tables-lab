class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  @@all = []

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
    @id = nil
    @name = name 
    @grade = grade 
    @@all << self
  end

  def self.all 
  @@all
  end

  # Create Table Method
  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade TEXT
      )")
  end
  #At first, I made the mistake of including parameters...but the create table method doesn't need parameters

  # def self.create_table
  #   sql =  <<-SQL
  #     CREATE TABLE IF NOT EXISTS students (
  #       id INTEGER PRIMARY KEY,
  #       name TEXT,
  #       grade TEXT
  #       );
  #   SQL
  #   DB[:conn].execute(sql)
  # end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create (name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end
