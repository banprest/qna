class SearchService
  attr_reader :type, :query
  
  TYPES = %w(all Answer Comment User Question)

  def initialize(params)
    @type = params[:type]
    @query = params[:query]
  end

  def call
    if TYPES.include?(type)
      if type == 'all'
       ThinkingSphinx.search ThinkingSphinx::Query.escape(query)
      else 
        type.constantize.search ThinkingSphinx::Query.escape(query)
      end
    end
  end
end
