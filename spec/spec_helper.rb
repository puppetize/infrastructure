RSpec.configure do |config|
  unless config.exclusion_filter.has_key? :thorough
    config.filter_run_excluding :thorough => true
  end

  if config.filter[:thorough]
    config.filter_run_excluding :thorough => false
  end
end
