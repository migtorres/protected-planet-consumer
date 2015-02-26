class Gef::PameRecordController < ApplicationController

  def index
    @pame_assessments =  Gef::PameRecord.joins(:gef_wdpa_record, :gef_area)
                                        .select('*')
                                        .where('gef_wdpa_records.wdpa_id = ? AND gef_areas.gef_pmis_id = ?',
                                                params[:wdpa_id], params[:gef_pmis_id])
                                        .order('gef_pame_records.assessment_year ASC')
  end

  def show
    @assessment = Gef::PameRecord.data_list(mett_original_uid: params[:mett_original_uid],
                                            wdpa_id: params[:wdpa_id]).delete_if { |k, v| v == '' }
  end
end