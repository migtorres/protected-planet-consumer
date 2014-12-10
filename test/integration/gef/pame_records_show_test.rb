require 'test_helper'

def setup
  gef_area_1 = FactoryGirl.create(:gef_area, gef_pmis_id: 666777)

  FactoryGirl.create(:gef_wdpa_record, gef_area: gef_area_1, wdpa_id: 999888)
end

class Gef::PameRecordsShowTest < ActionDispatch::IntegrationTest
  test 'returns a page for given gef_id, wdpa_id and pame_id' do
    gef_area = FactoryGirl.create(:gef_area, gef_pmis_id: 666777)

    gef_name = FactoryGirl.create(:gef_pame_name, name: 'Killbear')

    wdpa_area = FactoryGirl.create(:gef_wdpa_record, gef_area: gef_area, wdpa_id: 333444, gef_pame_name: gef_name)

    FactoryGirl.create(:gef_pame_record, gef_wdpa_record: wdpa_area, mett_original_uid: 999888, gef_pame_name: gef_name)

    get '/gef/area/666777/wdpa-record/333444/pame-record/999888'

    assert_equal 200, response.status
  end

  test 'renders PAME heading' do
    gef_area = FactoryGirl.create(:gef_area, gef_pmis_id: 666777)

    gef_name = FactoryGirl.create(:gef_pame_name, name: 'Killbear')

    wdpa_area = FactoryGirl.create(:gef_wdpa_record, gef_area: gef_area, wdpa_id: 333444, gef_pame_name: gef_name)

    FactoryGirl.create(:gef_pame_record, gef_wdpa_record: wdpa_area, mett_original_uid: 999888, gef_pame_name: gef_name)

    visit '/gef/area/666777/wdpa-record/333444/pame-record/999888'

    assert page.has_selector?('h2', text: 'WDPA ID #333444 - Assessment 999888'), 'h2 does not match'
  end

  test 'renders pa_name in attributes table' do
    gef_area = FactoryGirl.create(:gef_area, gef_pmis_id: 666777)

    gef_name = FactoryGirl.create(:gef_pame_name, name: 'Killbear')

    wdpa_area = FactoryGirl.create(:gef_wdpa_record, gef_area: gef_area, wdpa_id: 333444, gef_pame_name: gef_name)

    FactoryGirl.create(:gef_pame_record, gef_wdpa_record: wdpa_area, mett_original_uid: 999888, gef_pame_name: gef_name, assessment_year: 2007)

    visit '/gef/area/666777/wdpa-record/333444/pame-record/999888'

    assert page.has_selector?('table', text: /2007/), 'assessment_year not in table'
  end
end
