printf "irb"

def irb_load_status(text)
  printf " #{text}"
end

%w[
  rubygems
  irb/completion
  irb/ext/save-history
  pp
  wirble
].each do |r|
  irb_load_status r
  begin
    require r
  rescue LoadError
    printf "\e[1;31m!\e[0m"
  end
end

IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "> ",
  :PROMPT_N => ".. ",
  :PROMPT_S => ".. ",
  :PROMPT_C => ".. ",
  :RETURN   => "= %s\n"
}

IRB.conf[:USE_READLINE] = true
IRB.conf[:PROMPT_MODE]  = :CUSTOM
IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"

IRB.conf[:LOAD_MODULES] = []  unless IRB.conf.key?(:LOAD_MODULES)

[
  'irb/completion',
  'irb/ext/save-history'
].each do |m|
  unless IRB.conf[:LOAD_MODULES].include?(m)
    IRB.conf[:LOAD_MODULES] << m
  end
end

class Object
  def benchmark(count = 1)
    require 'benchmark'

    result = nil

    Benchmark.bm do |b|
      b.report {
        count.times {
          result = yield
        }
      }
    end

    result
  end
  alias_method :bench, :benchmark

  def profile(count = 1)
    begin
      require 'ruby-prof'
    rescue LoadError
      raise "RubyProf not installed. Install it with: gem install ruby-prof"
    end

    result = nil

    RubyProf::FlatPrinter.new(
      RubyProf.profile {
        count.times {
          result = yield
        }
      }
    ).print STDOUT, :min_percent => 1

    result
  end
  alias_method :prof, :profile

  def copy(thing)
    string = (thing.is_a? String) ? thing : thing.inspect.gsub("\"","\\\"")
    `echo "#{string}" | pbcopy`
    thing
  end

  def local_methods
    (methods - Object.instance_methods).sort
  end
  alias_method :methods!, :local_methods
end


if defined? Wirble
  Wirble.init

  Wirble::Colorize.colors = {
    # delimiter colors
    :comma              => :white,
    :refers             => :white,

    # container colors (hash and array)
    :open_hash          => :white,
    :close_hash         => :white,
    :open_array         => :white,
    :close_array        => :white,

    # object colors
    :open_object        => :yellow,
    :object_class       => :light_blue,
    :object_addr_prefix => :white,
    :object_addr        => :light_red,
    :object_line_prefix => :red,
    :close_object       => :yellow,

    # symbol colors
    :symbol             => :light_red,
    :symbol_prefix      => :light_red,

    # string colors
    :open_string        => :light_green,
    :string             => :light_green,
    :close_string       => :light_green,

    # misc colors
    :number             => :light_red,
    :keyword            => :light_red,
    :class              => :light_blue,
    :range              => :white,
  }

  Wirble.colorize
end

puts "\n#{RUBY_DESCRIPTION}"
