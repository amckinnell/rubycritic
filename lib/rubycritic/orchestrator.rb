module Rubycritic

  class Orchestrator
    def initialize
      @source_control_system = SourceControlSystem.create
    end

    def critique(paths)
      source = SourceLocator.new(paths)
      analysed_files = source.pathnames.map do |pathname|
        AnalysedFile.new(:pathname => pathname, :smells => [])
      end
      AnalysersRunner.new(analysed_files).run
      ComplexityAdapter::Flog.new(analysed_files).complexity
      if @source_control_system.has_revision?
        # @smells = RevisionComparator.new(@smells, @source_control_system).smells
        Analyser::Churn.new(analysed_files, @source_control_system).churn
      end
      analysed_files
    end
  end

end