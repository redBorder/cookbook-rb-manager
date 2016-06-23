class Chef
  class Recipe
    def get_managers()
      managers = search(:node, "recipes:manager")
      managers = ["localhost"] if managers.empty?
      return managers
    end
  end
end
