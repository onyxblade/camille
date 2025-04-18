
RSpec.describe Camille::CodeGenerator do
  describe '.generate_ts' do
    before(:all) do
      class Camille::Types::SampleType < Camille::Type
        include Camille::Types

        alias_of(
          id: Number,
          name: String
        )
      end

      class Camille::Schemas::SampleSchema < Camille::Schema
        include Camille::Types

        get :data do
          response(sample: SampleType)
        end
      end
    end
    after(:all) do
      Camille::Loader.loaded_types.delete(Camille::Types::SampleType)
      Camille::Loader.loaded_schemas.delete(Camille::Schemas::SampleSchema)
      Camille::Types.send(:remove_const, :SampleType)
      Camille::Schemas.send(:remove_const, :SampleSchema)
    end

    it 'returns correct ts' do
      Camille.configure do |config|
        config.ts_header = '#ts_header'
      end

      text = <<~EOF
        #ts_header

        export type DateTime = string
        export type Decimal = number
        export type SampleType = {id: number, name: string}

        export default {
          sampleSchema: {
            data(): Promise<{sample: SampleType}>{ return request('get', '/sample_schema/data', {}) },
          },
        }
      EOF

      expect(Camille::CodeGenerator.generate_ts).to eq(text)

      Camille.configure do |config|
        config.ts_header = nil
      end
    end
  end
end
