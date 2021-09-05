class Gate
  def initialize(name)
    @name = name
  end

  def enter(ticket)
    ticket.stamp(@name)
  end
end

class ticket
  #省略

  def stamp(name)
    @stamped_at = name
  end
end