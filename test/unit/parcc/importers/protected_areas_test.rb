require 'test_helper'

class ParccImportersProtectedAreasTest < ActiveSupport::TestCase
  PA_123_JSON = JSON.parse(
    File.read(Rails.root.join('test/fixtures/parcc/pp_area_123.json')),
    symbolize_names: true
  )


  test '::import calls #import on a new instance' do
    Parcc::Importers::ProtectedAreas.expects(:new).returns(
      mock.tap { |m| m.expects(:import) }
    )

    Parcc::Importers::ProtectedAreas.import
  end

  test '#import creates a Parcc::ProtectedArea from CSV' do
    CSV.stubs(:foreach).returns([{
      wdpaid: 123,
      name: 'Manbone',
      :'' => '321',
      polyid: 321,
      point: 'polygon',
      iucn_cat: 'II',
      designation: 'National Park',
      country: 'BEN'
    }])

    Parcc::ProtectedArea.expects(:create).with(
      name: 'Manbone',
      wdpa_id: 123,
      iucn_cat: 'II',
      designation: 'National Park',
      iso_3: 'BEN',
      parcc_id: '321',
      poly_id: 321,
      geom_type: 'polygon'
    )

    Parcc::Importers::ProtectedAreas.import
  end
end
