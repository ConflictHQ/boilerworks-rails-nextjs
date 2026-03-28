module Mutations
  class CreateFormSubmission < BaseMutation
    argument :form_definition_slug, String, required: true
    argument :data, GraphQL::Types::JSON, required: true

    field :ok, Boolean, null: false
    field :form_submission, Types::FormSubmissionType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(form_definition_slug:, data:)
      require_auth!
      fd = FormDefinition.find_by!(slug: form_definition_slug)
      authorize(FormSubmission, :create?)

      submission = fd.form_submissions.new(
        data: data,
        status: "submitted",
        submitted_by: context[:current_user],
        validated_at: Time.current
      )

      if submission.save
        { ok: true, form_submission: submission, errors: nil }
      else
        { ok: false, form_submission: nil, errors: format_errors(submission) }
      end
    end
  end
end
