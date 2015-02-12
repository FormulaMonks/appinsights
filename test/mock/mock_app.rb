class MockApp
  attr_reader :middlewares

  def initialize
    @middlewares = []
  end

  def use(middleware, *params, &block)
    @middlewares << [middlewares, params, block]
  end
end
