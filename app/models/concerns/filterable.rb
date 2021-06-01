module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_query(filter_params)
      results = self.where(nil)
      filter_params.each do |key, val|
        results = results.public_send("filter_by_#{key}", val)
      end
      results
    end
  end
end
