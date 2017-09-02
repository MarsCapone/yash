
require_relative 'builtins'

class Pipeline
  def initialize(left, right)
    @left = left
    @right = right
  end

  def execute(stdin, stdout)
    reader, writer = IO.pipe
    pids = @left.execute(stdin, writer.fileno) + @right.execute(reader.fileno, stdout)
    reader.close
    writer.close
    pids
  end
end

class Command
  def initialize(args)
    @args = args
    @chandler = CommandHandler.new
  end

  def execute(stdin, stdout)
    @chandler.handle(@args, stdin, stdout)
  end
end

class CommandHandler
  def initialize
    @cmds = [Demo.new, Exit.new] # fill this with classes which extend BuiltinCommand
  end

  def handle(all_args, stdin, stdout)
    root, args = all_args[0], all_args.slice(1, all_args.length)
    @cmds.each do |cmd|
      if cmd.equals?(root) then
        return cmd.handle(args, stdin, stdout) # should return a list of pids
      end
    end
    # only happens if nothing matches
    [spawn(*all_args, 0 => stdin, 1 => stdout)]
  end
end
