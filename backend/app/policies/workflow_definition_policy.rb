class WorkflowDefinitionPolicy < ApplicationPolicy
  def index? = has?("workflow.view")
  def show? = has?("workflow.view")
  def create? = has?("workflow.add")
  def update? = has?("workflow.change")
  def destroy? = has?("workflow.delete")

  class Scope < ApplicationPolicy::Scope
    def resolve
      has?("workflow.view") ? scope.all : scope.none
    end

    private

    def has?(slug) = user&.has_permission?(slug)
  end
end
