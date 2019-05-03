
class String
  def to_notes(scl)
    self.upcase.scan(/\w/).map { |c| c.ord - 65 }.map { |idx| scl[idx] }
  end
end
