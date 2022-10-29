# frozen_string_literal: true

require 'test_helper'
require 'rubycritic/analysers/helpers/modules_locator'
require 'rubycritic/core/analysed_module'
require 'pathname'

describe RubyCritic::ModulesLocator do
  describe '#name' do
    context 'when a file a top-level Ruby constant' do
      it 'returns the name of the class' do
        analysed_module = RubyCritic::AnalysedModule.new(
          pathname: Pathname.new('test/samples/top_level_class.rb'),
          methods_count: 1
        )
        _(RubyCritic::ModulesLocator.new(analysed_module).name)
          .must_equal 'Foo'
      end

      it 'returns the name of the module' do
        analysed_module = RubyCritic::AnalysedModule.new(
          pathname: Pathname.new('test/samples/top_level_module.rb'),
          methods_count: 1
        )
        _(RubyCritic::ModulesLocator.new(analysed_module).name)
          .must_equal 'Bar'
      end

      it 'returns the qualified name of the nested class' do
        analysed_module = RubyCritic::AnalysedModule.new(
          pathname: Pathname.new('test/samples/nested_class.rb'),
          methods_count: 1
        )
        _(RubyCritic::ModulesLocator.new(analysed_module).name)
          .must_equal 'Foo::Bar'
      end
    end
  end

  describe '#names' do
    context 'when a file contains Ruby code' do
      it 'returns the names of all the classes and modules inside the file' do
        analysed_module = RubyCritic::AnalysedModule.new(
          pathname: Pathname.new('test/samples/module_names.rb'),
          methods_count: 1
        )
        _(RubyCritic::ModulesLocator.new(analysed_module).names)
          .must_equal ['Foo', 'Foo::Bar', 'Foo::Baz', 'Foo::Qux', 'Foo::Quux::Corge']
      end
    end

    context 'when a file is empty' do
      it 'returns the name of the file titleized' do
        analysed_module = RubyCritic::AnalysedModule.new(
          pathname: Pathname.new('test/samples/empty.rb'),
          methods_count: 1
        )
        _(RubyCritic::ModulesLocator.new(analysed_module).names).must_equal ['Empty']
      end
    end

    context 'when a file has no methods' do
      it 'returns the names of all the classes and modules inside the file' do
        analysed_module = RubyCritic::AnalysedModule.new(
          pathname: Pathname.new('test/samples/no_methods.rb'),
          methods_count: 0
        )
        capture_output_streams do
          _(RubyCritic::ModulesLocator.new(analysed_module).names).must_equal ['Foo::NoMethods']
        end
      end
    end
  end
end
