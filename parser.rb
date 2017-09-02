require_relative 'pipeline'

class Parser < Parslet::Parser
  root :cmdline

  rule(:cmdline) { pipeline | command }
  rule(:pipeline) { command.as(:left) >> pipe.as(:pipe) >> cmdline.as(:right) }
  rule(:command) { arg.as(:arg).repeat(1).as(:command) >> space? }
  rule(:arg) { single_quoted_arg | double_quoted_arg | unquoted_arg }

  rule(:unquoted_arg) { match[%q{^\s'|}].repeat(1) >> space? }
  rule(:single_quoted_arg) { str("'").ignore >> match[%q{^'}].repeat(0) >> str("'").ignore >> space? }
  rule(:double_quoted_arg) { str('"').ignore >> match[%q{^"}].repeat(0) >> str('"').ignore >> space? }

  rule(:space) { match[%q{\s}].repeat(1).ignore }
  rule(:space?) { space.maybe }
  rule(:pipe) { str("|") >> space? }
end

class Transform < Parslet::Transform
  rule(left: subtree(:left), pipe: "|", right: subtree(:right)) { Pipeline.new(left, right) }
  rule(command: sequence(:args)) { Command.new(args) }
  rule(arg: simple(:arg)) { arg }
end
