# coding: utf-8

require 'test_helper'

class MongoidPermalinkExtensionTest
  include Mongoid::Document
  field :permalink, type: MongoidPermalinkExtension::Permalink
end

# ---------------------------------------------------------------------

describe MongoidPermalinkExtension::Permalink do
  subject { MongoidPermalinkExtensionTest.new }

  # ---------------------------------------------------------------------

  describe '.demongoize' do
    let(:permalink_value) { 'something stored in the database' }
    it 'does not change the value' do
      MongoidPermalinkExtension::Permalink.demongoize(permalink_value).must_equal permalink_value
    end
  end

  # ---------------------------------------------------------------------

  describe '.mongoize' do
    it 'converts anything to string' do
      MongoidPermalinkExtension::Permalink.mongoize(12).must_equal '12'
    end

    it 'stores transformed string' do
      MongoidPermalinkExtension::Permalink.mongoize('some some').must_be :present?
    end

    it 'stores nil if nil passed' do
      MongoidPermalinkExtension::Permalink.mongoize(nil).must_be_nil
    end

    it 'converts spaces to hyphens' do
      MongoidPermalinkExtension::Permalink.mongoize('A B').must_equal 'A-B'
      MongoidPermalinkExtension::Permalink.mongoize('A    B').must_equal 'A-B'
    end

    it 'strips spaces around the string' do
      MongoidPermalinkExtension::Permalink.mongoize('  A B  ').must_equal 'A-B'
    end

    it 'converts slashes to hyphens' do
      MongoidPermalinkExtension::Permalink.mongoize('A/B').must_equal 'A-B'
    end

    it 'converts to camel case' do
      MongoidPermalinkExtension::Permalink.mongoize('hello hello').wont_include 'h'
      MongoidPermalinkExtension::Permalink.mongoize('hello hello').must_equal 'Hello-Hello'
    end

    it 'adds spaces to camel case' do
      MongoidPermalinkExtension::Permalink.mongoize('CamelCase').must_equal 'Camel-Case'
    end

    it 'preserves ABC' do
      MongoidPermalinkExtension::Permalink.mongoize('ABC Demo').must_equal 'ABC-Demo'
      # MongoidPermalinkExtension::Permalink.mongoize("ABCDeMo").must_equal 'ABC-De-Mo'
    end

    it 'preserves dashes as separators' do
      MongoidPermalinkExtension::Permalink.mongoize('Camel-Case').must_equal 'Camel-Case'
      MongoidPermalinkExtension::Permalink.mongoize('Camel--Case').must_equal 'Camel-Case'
    end

    it 'converts all dashes to hyphens' do
      MongoidPermalinkExtension::Permalink.mongoize('A–Z').must_equal 'A-Z'
      MongoidPermalinkExtension::Permalink.mongoize('A----–Z').must_equal 'A-Z'
      MongoidPermalinkExtension::Permalink.mongoize('A—Z').must_equal 'A-Z'
      MongoidPermalinkExtension::Permalink.mongoize('A—––––––Z').must_equal 'A-Z'
    end

    it 'remove non-alphanumeric characters' do
      %w(?!@#$%^&*()+=.,;<>[]“”).shuffle.each do |i|
        MongoidPermalinkExtension::Permalink.mongoize(i).wont_include i
      end
    end

    it 'does not start with a hyphen' do
      MongoidPermalinkExtension::Permalink.mongoize('“Yes” to a Historic Moment').must_equal 'Yes-To-A-Historic-Moment'
      MongoidPermalinkExtension::Permalink.mongoize('¿Yes?').must_equal 'Yes'
    end

    it 'preserves accented characters' do
      MongoidPermalinkExtension::Permalink.mongoize('Bienále Brno Česká republika').must_equal 'Bienale-Brno-Ceska-Republika'
    end

    it 'produces nice slugs' do
      MongoidPermalinkExtension::Permalink.mongoize('Future Vocabularies?').must_equal 'Future-Vocabularies'
      MongoidPermalinkExtension::Permalink.mongoize('2011 space odyssey').must_equal '2011-Space-Odyssey'
      MongoidPermalinkExtension::Permalink.mongoize('A permalink with & in it').must_equal 'A-Permalink-With-In-It'
    end
  end
end
