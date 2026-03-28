class CategoryPolicy < ApplicationPolicy
  def index? = has?("category.view")
  def show? = has?("category.view")
  def create? = has?("category.add")
  def new? = create?
  def update? = has?("category.change")
  def edit? = update?
  def destroy? = has?("category.delete")

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("category.view") ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
