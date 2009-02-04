class TomatoesController
  
  def create(params)
    tomato = Tomato.new(params)
    storage = KirbyStorage.new
    storage.save(tomato)
  end
  
end