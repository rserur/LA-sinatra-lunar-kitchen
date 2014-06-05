require 'pry'

def get_db
  connection = PG.connect(dbname: 'recipe_box')
  results = connection.exec('SELECT * FROM recipes ORDER BY name ASC')
  connection.close
  results.to_a
end

def get_recipe(id)
  connection = PG.connect(dbname: 'recipe_box')
  results = connection.exec('SELECT * FROM recipes WHERE id = $1 ORDER BY name ASC', [id.to_i])
  connection.close
  results.to_a
  results[0]
end

def get_ingredients(id)
  connection = PG.connect(dbname: 'recipe_box')
  results = connection.exec("SELECT * FROM ingredients WHERE recipe_id = $1", [id])
  connection.close
  results.to_a
end

class Ingredient
  def initialize(ingredient)
    @name = ingredient["name"]
  end

  def name
    @name
  end

end

class Recipe
  def initialize(recipe)
    @id = recipe["id"]
    @name = recipe["name"]
    @instructions = recipe["instructions"]
    @description= recipe["description"]
    @ingredients = []
  end

  def self.all

    recipes = []
    all_recipes = get_db

    all_recipes.each do |db_entry|
      recipes << Recipe.new(db_entry)
    end

    recipes
    # ObjectSpace.each_object(self).to_a
  end

  def id
    @id
  end

  def name
    @name
  end

  def self.find(id)
    Recipe.new(get_recipe(id))
  end

  def instructions
    if @instructions == nil
      @instructions = "This recipe doesn't have any instructions."
    else
      @instructions
    end
  end

  def description
    if @description == nil
      @description = "This recipe doesn't have a description."
    else
      @description
    end
  end

  def ingredients

    all_ingredients = get_ingredients(@id)

    all_ingredients.each do |ingredient|
      @ingredients << Ingredient.new(ingredient)
    end

    @ingredients

  end

end


