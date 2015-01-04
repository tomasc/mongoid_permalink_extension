# coding: utf-8

require 'test_helper'

# ---------------------------------------------------------------------
  
class MongoidPermalinkExtensionTest
  include Mongoid::Document
  field :permalink, type: MongoidPermalinkExtension::Permalink
end

# ---------------------------------------------------------------------
  
module MongoidPermalinkExtension
  describe Permalink do
    
    subject { MongoidPermalinkExtensionTest.new }

    describe '.demongoize' do
      let(:permalink_value) { 'something stored in the database' }
      it 'does not change the value' do
        MongoidPermalinkExtension::Permalink.demongoize(permalink_value).must_equal permalink_value
      end
    end

    describe '.mongoize' do
      it 'converts anything to string' do
        MongoidPermalinkExtension::Permalink.mongoize(12).must_equal '12'
      end
      it 'stores transformed string' do
        MongoidPermalinkExtension::Permalink.mongoize("some some").must_be :present?
      end
      it 'stores nil if nil passed' do
        MongoidPermalinkExtension::Permalink.mongoize(nil).must_be_nil
      end
      it 'converts spaces to hyphens' do
        MongoidPermalinkExtension::Permalink.mongoize(" ").must_equal '-'
        MongoidPermalinkExtension::Permalink.mongoize("    ").must_equal '-'
      end
      it 'converts to camel case' do
        MongoidPermalinkExtension::Permalink.mongoize("hello hello").wont_include 'h'
      end
      it 'converts all dashes to hyphens' do
        MongoidPermalinkExtension::Permalink.mongoize("–").must_equal '-'
        MongoidPermalinkExtension::Permalink.mongoize("—").must_equal '-'
      end
      it 'remove non-alphanumeric characters' do
        %w(?!@#$%^&*()+=/.,;<>[]).shuffle.each do |i|
          MongoidPermalinkExtension::Permalink.mongoize(i).wont_include i
        end
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
end