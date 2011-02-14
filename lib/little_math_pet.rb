class LittleMathPet
  # This is used to match numbers in regular expressions
  NUMBER_RX = '([\+\-]?\d+(\.\d+)?)'
  
  # This is used to match mathematical signs in regular expressions
  SIGN_RX = '([\+\-\/\*\^])'
  
  # The proper math order (power, multiplication/division and addiction/subtraction)
  MATH_ORDER = [%w[^], %w[* /], %w[+ -]]
  
  # The processes to use for the math
  MATH_PROCS = {
    '-' => Proc.new{|a,b| a-b},
    '+' => Proc.new{|a,b| a+b},
    '*' => Proc.new{|a,b| a*b},
    '/' => Proc.new{|a,b| a/b},
    '^' => Proc.new{|a,b| a**b}
  }

  def initialize(math_expression)
    @math = math_expression
    @math = @math.gsub(/\s/, '') # no spaces allowed
    
    @math = @math.gsub(/\:/, '/') # 4:2 -> 4/2
    @math = @math.gsub(/\*\*/, '^') # 4**2 -> 4^2 to make it easier to differantiate from 4*2
    
    @math = @math.gsub(/\[/, '(')
    @math = @math.gsub(/\]/, ')')
  end
  
  def calc(variables = {})
    unless variables.empty?
      variables.each do |letter, number|
        @math.gsub!(letter.to_s, number.to_s)
      end
    end
    
    raise 'Invalid math expression' unless @math[/^[\d\-\+\/\*\^\.\(\)]+$/]
    
    do_math(@math)
  end
  
  private
  
  # This is the top level method which deals with the various cases
  def do_math(math)
    case math
    when /\([^\)]+\)/
      math = math.gsub(/\(([^\)]+)\)/) do |match|
        do_math($1)
      end
      
      do_math(math)
    when /^#{NUMBER_RX}(#{SIGN_RX}#{NUMBER_RX})+$/
      solve_math(math)
    when /^#{NUMBER_RX}$/
      math.to_f
    when /^#{SIGN_RX}$/
      math
    when ""
      # this appears when '-5' gets split to ['', '-', '5']
      0.0
    else
      raise 'Invalid math expression'
    end
  end
  
  # This is the actual solver that invokes the marh Procs
  def solve_math(math)
    parts = math.split(/#{SIGN_RX}/)
    
    until parts.all?{|p| p.to_s[/^#{SIGN_RX}$/] or p.is_a?(Float)}
      parts.collect! do |part|
        do_math(part)
      end
    end
    
    # reduces the math expression one process at a time until we have a number
    until parts.length == 1
      i = 0
      proc_positions = parts.inject({}) do |hash, part|
        if part.to_s[/^#{SIGN_RX}$/]
          hash[part] ||= i
        end
        i += 1
        
        hash
      end
      
      next_proc = nil
      next_position = nil
      MATH_ORDER.each do |symbols|
        unless (symbols & proc_positions.keys).empty? or next_proc
          next_proc = (symbols & proc_positions.keys).min_by do |p|
            proc_positions[p]
          end
          next_position = proc_positions[next_proc]
        end
      end
      
      if parts[next_position][/^#{SIGN_RX}$/]
        result = MATH_PROCS[parts[next_position]].call((parts[next_position-1] || 0), parts[next_position+1])
        parts[next_position-1] = parts[next_position+1] = nil
        parts[next_position] = result
        parts.compact!
      else
        raise 'Invalid math expression'
      end
    end
    
    return parts.first
  end
end
