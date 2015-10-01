class Parcc::Importers::Species::TaxonomicClassProtectedAreas < Parcc::Importers::Base
  def import
    csv_reader(source_file_path).each do |record|
      protected_area = fetch_protected_area(record[:wdpa_id])
      next unless protected_area
      taxonomic_class= fetch_taxonomic_class(record[:taxon_class])
      next unless taxonomic_class

      add_row_to_tcpa( {
        parcc_protected_area_id: protected_area.id,
        parcc_taxonomic_class_id: taxonomic_class.id,
        count_total_species: record[:tot_species],
        count_vulnerable_species: record[:vuln_species]
      })
    end
  end

  private

  def add_row_to_tcpa counts
    Parcc::TaxonomicClassProtectedArea.create(counts)
  end
  
  def source_file_path
    Rails.root.join('lib/data/parcc/species/taxonomic_class_protected_areas.csv')
  end
end