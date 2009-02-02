class TomatoesController
  
  def create(params)
    tomato = Tomato.new(params)
    storage = Storage.new
    storage.save(tomato)
  end
  
end