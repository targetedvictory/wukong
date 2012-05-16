module Wukong
  def self.dataflow(*args, &block)
    @dataflow ||= Dataflow.new(*args, &block)
  end

  class Dataflow < Hanuman::Graph
    def process(rec)
      stages.to_a.first.process(rec)
    end

    def add_stage(stage)
      stages << stage
      stage
    end

    def reject(re_or_block=nil, &block)
      raise ArgumentError, "Supply a block or regular expression, not both" if re_or_block && block
      if re_or_block.is_a?(Regexp)
        add_stage(Widget::RegexpRejecter.new(:re => re_or_block))
      else
        block ||= re_or_block
        add_stage(Widget::ProcRejecter.new(block))
      end
    end

    def select(re_or_block=nil, &block)
      raise ArgumentError, "Supply a block or regular expression, not both" if re_or_block && block
      if re_or_block.is_a?(Regexp)
        add_stage(Widget::RegexpFilter.new(:re => re_or_block))
      else
        block ||= re_or_block
        add_stage(Widget::ProcFilter.new(block))
      end
    end

    def self.register_processor(name, klass=nil, &meth_body)
      raise ArgumentError, 'Supply either a processor class or a block' if (klass && meth_body) || (!klass && !meth_body)
      if block_given?
        define_method(name) do |*args, &blk|
          add_stage meth_body.call(*args, &blk)
        end
      else
        define_method(name) do |*args, &blk|
          add_stage klass.new(*args, &blk)
        end
      end
    end
  end
end