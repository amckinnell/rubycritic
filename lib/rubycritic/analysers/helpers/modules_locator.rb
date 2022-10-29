# frozen_string_literal: true

require 'rubycritic/analysers/helpers/parser'

module RubyCritic
  class ModulesLocator
    def initialize(analysed_module)
      @analysed_module = analysed_module
    end

    # ARM (2022-10-29): No longer called.
    def first_name
      names.first
    end

    def name
      if ::Parser::AST::Node::MODULE_TYPES.include?(node.type)
        # ARM (2022-10-29): Of course, we want a loop or a recursion.
        constants = []

        constant_node = node.children.first
        raise "wrong type" unless constant_node.type == :const
        constants << constant_node.children.last

        constant_node = node.children[1].children.first
        raise "wrong type" unless constant_node.type == :const
        constants << constant_node.children.last

        constants.join('::')
      else
        name_from_path
      end
    end

    def names
      names = node.module_names
      if names.empty?
        name_from_path
      else
        names
      end
    end

    private

    def node
      Parser.parse(content)
    end

    def content
      File.read(@analysed_module.path)
    end

    def name_from_path
      [file_name.split('_').map(&:capitalize).join]
    end

    def file_name
      @analysed_module.pathname.basename.sub_ext('').to_s
    end
  end
end
