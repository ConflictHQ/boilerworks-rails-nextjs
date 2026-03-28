class FormSubmissionPolicy < ApplicationPolicy
  def index? = has?("form.view")
  def show? = has?("form.view")
  def create? = has?("form.add")

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("form.view") ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
