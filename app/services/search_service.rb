class SearchService
  attr_reader :type, :query
  
  TYPES = { all: ThinkingSphinx, Answer: Answer, Comment: Comment, User: User, Question: Question }

  def initialize(params)
    @type = params[:type].to_sym
    @query = params[:query]
  end

  def call
    TYPES[type].search ThinkingSphinx::Query.escape(query)
  end

end
