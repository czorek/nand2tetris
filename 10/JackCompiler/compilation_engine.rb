module Jack
  class CompilationEngine
    def initialize(tokenizer, output_file)
      @tokenizer = tokenizer
      @output_file = output_file
    end

    def compile
    end

    private
    attr_reader :tokenizer, :output_file
  end
end