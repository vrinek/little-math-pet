# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LittleMathPet do
  context "when a single number is given" do
    equations = {
      "8"     => 8.0,
      "78.65" => 78.65,
      "-3.5"  => -3.5,
      "30%"   => 0.3
    }

    equations.each do |equation, result|
      it "returns that number in float (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == result
      end
    end
  end

  context "when a simple equation is given" do
    equations = {
      "5+3"     => 8.0,
      "7-5"     => 2.0,
      "5-7"     => -2.0,
      "5*3"     => 15.0,
      "15/5"    => 3.0,
      "-15/5"   => -3.0,
      "2^3"     => 8.0,
      "12+50%"  => 18.0,
      "120*25%" => 30.0,
      "7 / 50%" => 14.0
    }

    equations.each do |equation, result|
      it "solves the equation (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == result
      end
    end
  end

  context "when a more complex equation is given" do
    equations = {
      "5+3+10" => 18.0,
      "7-5-2" => 0.0,
      "5-7+6" => 4.0,
      "5*3/10" => 1.5,
      "15/5*2" => 6.0,
      "-15/5*7" => -21.0,
      "12+10+50%+20%" => 30,
      "-6 * 5" => -30,
      "6 * -5" => -30,
      "30 / -3" => -10,
      "-30 / -3" => 10,
    }

    equations.each do |equation, result|
      it "solves the equation (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == result
      end
    end

    equations = {
      "5*3+10" => 25.0,
      "10+3*5" => 25.0,
      "5-7/2" => 1.5,
      "-8/2^2" => -2.0,
      "(5+2)*2" => 14.0,
      "(5+2)+50%" => 10.5,
    }

    equations.each do |equation, result|
      it "respects the proper math order (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == equations[equation]
      end
    end
  end

  context "when an equation with multiple parenthesis is given" do
    equations = {
      "5 - (-3 - (-8 / 2))" => 4.0,
      "((7 - 2) * 6) / 2" => 15.0,
    }

    equations.each do |equation, result|
      it "respects the proper math order (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == equations[equation]
      end
    end
  end

  context "when a different grammar is used for the equation" do
    equations = {
      "5*3:10" => 1.5,
      "-8/2**2" => -2.0,
      "5 + 7" => 12.0,
      "[5+2] : 2" => 3.5,
      "100 + 40 %" => 140,
      "12 ÷ 4 + 5" => 8,
      "2 × 8 - 7" => 9,
      "2 × [8 - 7]" => 2,
    }

    equations.each do |equation, result|
      it "solves the equation (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == result
      end
    end
  end

  context "when using curly brackets" do
    equations = {
      "{5*3}:10" => 1.5,
      "-8/{2**2}" => -2.0,
    }

    equations.each do |equation, result|
      it "solves the equation (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc.should == result
      end
    end
  end

  context "when something unknown is given as math" do
    equations = [
      "five * 5",
      "something else",
      "+*+"
    ]

    equations.each do |equation|
      it "raises an exception (#{equation.inspect})" do
        begin
          LittleMathPet.new(equation).calc
          true.should == false
        rescue => e
          e.message.should =~ /Invalid math expression/
        end
      end
    end
  end

  context "when a variable is given (x => 3)" do
    value = '3'
    equations = {
      "5+x+10" => 18.0,
      "7-5-x" => -1.0,
      "5*x/10" => 1.5,
      "15/5*x" => 9.0,
      "10+x*5" => 25.0,
      "x-7/2" => -0.5,
      "-9/x^2" => -1.0,
      "x*(2+3)/2" => 7.5
    }

    equations.each do |equation, result|
      it "uses it in place of x (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc(:x => value).should == result
      end
    end
  end

  context "when multiple variables are given (a => 2, b => 5)" do
    values = {:a => 2, :b => 5}
    equations = {
      "5+a+10/b" => 9.0,
      "7-5-a*b" => -8.0,
      "5^a/10/b" => 0.5,
      "b*(a+3)/2" => 12.5
    }

    equations.each do |equation, result|
      it "uses them in place of the variables (#{equation} = #{result})" do
        LittleMathPet.new(equation).calc(values).should == result
      end
    end
  end

  context "when some variables are missing" do
    values = {:a => 2, :b => 5}
    equations = [
      "5+a+10/x",
      "7-5-a*y",
      "c^a/10/b",
      "v*(e+3)/2"
    ]

    equations.each do |equation, result|
      it "raises an exception (#{equation.inspect})" do
        begin
          LittleMathPet.new(equation).calc.should == result
          true.should == false
        rescue => e
          e.message.should == 'Invalid math expression'
        end
      end
    end
  end
end
