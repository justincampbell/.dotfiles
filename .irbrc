printf "irb"

%w[
  rubygems
  irb/completion
  irb/ext/save-history
  pp
  wirble
].each do |path|
  printf " #{path}"

  begin
    require path
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

IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE]  = :CUSTOM
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:USE_READLINE] = true

IRB.conf[:LOAD_MODULES] ||= %w[irb/completion irb/ext/save-history]

def self.silence_active_record
  if defined? ActiveRecord
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
  end

  result = yield

  ActiveRecord::Base.logger = old_logger if old_logger

  result
end

def self.benchmark(count = 1)
  require 'benchmark'

  result = nil

  silence_active_record do
    Benchmark.bm do |benchmark|
      benchmark.report {
        count.times {
          result = yield
        }
      }
    end
  end

  result
end

def self.profile(count = 1)
  begin
    require 'ruby-prof'
  rescue LoadError
    raise "RubyProf not installed. Install it with: gem install ruby-prof"
  end

  result = nil

  silence_active_record do
    RubyProf::FlatPrinter.new(
      RubyProf.profile {
        count.times {
          result = yield
        }
      }
    ).print STDOUT, :min_percent => 1
  end

  result
end

def self.copy(thing)
  string = (thing.is_a? String) ? thing : thing.inspect.gsub("\"","\\\"")
  `echo -n "#{string}" | pbcopy`
  thing
end

class Object
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
