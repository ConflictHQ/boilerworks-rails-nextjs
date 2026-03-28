class FormDefinitionPolicy < ApplicationPolicy
  def index? = has?("form.view")
  def show? = has?("form.view")
  def create? = has?("form.add")
  def update? = has?("form.change")
  def destroy? = has?("form.delete")

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("form.view") ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
