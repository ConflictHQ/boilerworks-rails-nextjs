class ItemPolicy < ApplicationPolicy
  def index? = has?("item.view")
  def show? = has?("item.view")
  def create? = has?("item.add")
  def new? = create?
  def update? = has?("item.change")
  def edit? = update?
  def destroy? = has?("item.delete")

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("item.view") ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
