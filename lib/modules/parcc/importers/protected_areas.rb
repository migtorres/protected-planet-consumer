class Parcc::Importers::ProtectedAreas
  IDENTITY = -> (value) { value }
  PROPERTY = -> (prop) { lambda { |value| value[prop] } }

  CONVERSIONS = {
    name:          {dest: :name,        block: IDENTITY},
    wdpa_id:       {dest: :wdpa_id,     block: IDENTITY},
    iucn_category: {dest: :iucn_cat,    block: PROPERTY.(:name) },
    designation:   {dest: :designation, block: PROPERTY.(:name) },
    countries: {
      dest: :iso_3,
      block: -> (countries) { countries.first[:iso_3] }
    }
  }

  def self.from_wdpa_id wdpa_id
    instance = new wdpa_id
    instance.import
  end

  def initialize wdpa_ids
    @wdpa_ids = Array.wrap(wdpa_ids)
  end

  def import
    wdpa_ids.map(
      &method(:create_pa)
    ).instance_eval { length <= 1 ? first : self }
  end

  private

  def create_pa wdpa_id
    properties = pa_props(wdpa_id)
    return unless properties

    Parcc::ProtectedArea.create(properties)
  end

  def pa_props wdpa_id
    json_pa = protected_planet_reader.protected_area_from_wdpaid id: wdpa_id

    json_pa.each_with_object({}) do |(key, value), props|
      next unless conv = CONVERSIONS[key]
      props[conv[:dest]] = conv[:block].(value)
    end
  rescue ProtectedPlanetReader::ProtectedAreaRetrievalError => e
    Rails.logger.warn e.message
    return nil
  end

  def protected_planet_reader
    ProtectedPlanetReader.new
  end

  def wdpa_ids
    @wdpa_ids
  end
end
