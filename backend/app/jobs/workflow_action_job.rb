class WorkflowActionJob < ApplicationJob
  queue_as :default

  def perform(workflow_instance_id, action_data)
    instance = WorkflowInstance.find(workflow_instance_id)
    Rails.logger.info "Processing workflow action for instance #{instance.uuid}: #{action_data}"
  end
end
