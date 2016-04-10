require 'spec_helper'

describe Package, type: :model do
  subject { FactoryGirl.create(:package) }
  let(:category) { FactoryGirl.create(:category) }

  describe '#categorise' do
    it 'adds a category to categories' do
      expect do
        subject.categorise(category)
      end.to change(PackageCategorisation, :count).by(1)
    end
  end

  describe '#uncategorise' do
    before do
      subject.categorise(category)
    end

    it 'removes a category from categories' do
      expect do
        subject.uncategorise(category)
      end.to change(PackageCategorisation, :count).by(-1)
    end
  end

  describe 'Class Methods' do
    subject       { Package }
    let(:file)    { File.join(File.dirname(__FILE__), '../fixtures/packages.json') }
    let(:json)    { JSON.parse(File.read(file, external_encoding: 'iso-8859-1', internal_encoding: 'utf-8')) }
    let(:package) { subject.new(subject.build_package_attributes(json[0])) }

    describe '.from_data_json' do
      it 'returns a new Package instance when given a parsed json' do
        from_json = subject.from_data_json(json[0])
        expect(from_json.class).to eq(Package)
        expect(from_json.name).to eq(package.name)
      end
    end

    describe '.build_package_attributes' do
      it 'returns a Hash' do
        expect(subject.build_package_attributes(json[0]).class).to eq(Hash)
      end
    end

    describe '.extract_keywords' do
      it 'returns an Array' do
        expect(subject.extract_keywords(json[0]['versions']).class).to eq(Array)
      end
    end

    describe '.extract_versions' do
      it 'returns a hash containing cleaned up versions' do
        expect(subject.extract_versions(json[0]['versions']).keys.size).to eq(json[0]['versions'].keys.size)
      end
    end
  end
end
