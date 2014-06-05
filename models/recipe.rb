require 'pry'

def get_db
  connection = PG.connect(dbname: 'recipe_box')
  results = connection.exec('SELECT * FROM recipes ORDER BY name ASC')
  connection.close
  results.to_a
end

class Recipe
  def initialize(recipe)
    @id = recipe["id"]
    @name = recipe["name"]
    @instructions = recipe["instructions"]
    @description= recipe["description"]
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end

  def id
    @id
  end

  def name
    @name
  end

end

all_recipes = get_db

all_recipes.each do |db_entry|
  recipe = Recipe.new(db_entry)
end
