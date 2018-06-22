class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM songs
    SQL

    DB[:conn].execute(sql)
  end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first

    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    DB[:conn].execute(sql, 9).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < ?
    SQL

    DB[:conn].execute(sql, 12).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num_of_students)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    students_array = []
     DB[:conn].execute(sql, 10).map do |row|
      students_array << self.new_from_db(row) until students_array.count == num_of_students
    end

    students_array
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    students_array = DB[:conn].execute(sql, 10).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = ?
    SQL

    students_array = DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end

    students_array
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    all_students = DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    all_students
  end
end
