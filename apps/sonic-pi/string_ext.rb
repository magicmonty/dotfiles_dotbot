
class String
  def notes(scl)
    self.upcase.scan(/\w/).map { |c| c.ord - 65 }.map { |idx| scl[idx] }.ring
  end

  def bools()
    self.upcase.chars.select { |c| c =~ /[X.01]/ }.map { |c| c == 'X' || c == '1' }.ring
  end
end
