class ProductPolicy < ApplicationPolicy
  def index? = has?("product.view")
  def show? = has?("product.view")
  def create? = has?("product.add")
  def new? = create?
  def update? = has?("product.change")
  def edit? = update?
  def destroy? = has?("product.delete")

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("product.view") ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
