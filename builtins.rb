
class BuiltinCommand
  def initialize(command)
    @command = command
  end

  def equals?(other)
    @command == other
  end

  # return a list of pids
  def handle(args, stdin, stdout)
  end
end

class Demo < BuiltinCommand
  def initialize
    super('demo')
  end

  def handle(args, stdin, stdout)
    p 'this is the demo command'
    []
  end
end

class Exit < BuiltinCommand
  def initialize
    super('exit')
  end

  def handle(args, stdin, stdout)
    raise ArgumentError
  end
end
