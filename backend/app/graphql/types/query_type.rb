module Types
  class QueryType < Types::BaseObject
    # Me
    field :me, Types::UserType, null: true, description: "Current authenticated user"

    def me
      context[:current_user]
    end

    # Products
    field :products, [Types::ProductType], null: false, description: "List all products" do
      argument :search, String, required: false
      argument :category_id, ID, required: false
    end

    field :product, Types::ProductType, null: true, description: "Find product by ID" do
      argument :id, ID, required: true
    end

    def products(search: nil, category_id: nil)
      require_auth!
      scope = Pundit.policy_scope(context[:current_user], Product).includes(:category)
      scope = scope.where("name ILIKE ?", "%#{search}%") if search.present?
      scope = scope.where(category: Category.find_by_uuid!(category_id)) if category_id.present?
      scope.order(created_at: :desc)
    end

    def product(id:)
      require_auth!
      product = Product.find_by_uuid!(id)
      Pundit.authorize(context[:current_user], product, :show?)
      product
    end

    # Categories
    field :categories, [Types::CategoryType], null: false, description: "List all categories"

    field :category, Types::CategoryType, null: true, description: "Find category by ID" do
      argument :id, ID, required: true
    end

    def categories
      require_auth!
      Pundit.policy_scope(context[:current_user], Category).order(:name)
    end

    def category(id:)
      require_auth!
      category = Category.find_by_uuid!(id)
      Pundit.authorize(context[:current_user], category, :show?)
      category
    end

    # Form Definitions
    field :form_definitions, [Types::FormDefinitionType], null: false, description: "List all form definitions"

    field :form_definition, Types::FormDefinitionType, null: true, description: "Find form definition by slug" do
      argument :slug, String, required: true
    end

    def form_definitions
      require_auth!
      Pundit.policy_scope(context[:current_user], FormDefinition).order(created_at: :desc)
    end

    def form_definition(slug:)
      require_auth!
      fd = FormDefinition.find_by!(slug: slug)
      Pundit.authorize(context[:current_user], fd, :show?)
      fd
    end

    # Form Submissions
    field :form_submissions, [Types::FormSubmissionType], null: false, description: "List form submissions" do
      argument :form_definition_slug, String, required: false
    end

    def form_submissions(form_definition_slug: nil)
      require_auth!
      scope = Pundit.policy_scope(context[:current_user], FormSubmission).includes(:form_definition)
      if form_definition_slug.present?
        fd = FormDefinition.find_by!(slug: form_definition_slug)
        scope = scope.where(form_definition: fd)
      end
      scope.order(created_at: :desc)
    end

    # Workflow Definitions
    field :workflow_definitions, [Types::WorkflowDefinitionType], null: false, description: "List all workflow definitions"

    field :workflow_definition, Types::WorkflowDefinitionType, null: true, description: "Find workflow by slug" do
      argument :slug, String, required: true
    end

    def workflow_definitions
      require_auth!
      Pundit.policy_scope(context[:current_user], WorkflowDefinition).order(created_at: :desc)
    end

    def workflow_definition(slug:)
      require_auth!
      wd = WorkflowDefinition.find_by!(slug: slug)
      Pundit.authorize(context[:current_user], wd, :show?)
      wd
    end

    # Workflow Instances
    field :workflow_instances, [Types::WorkflowInstanceType], null: false, description: "List workflow instances" do
      argument :workflow_definition_slug, String, required: false
    end

    def workflow_instances(workflow_definition_slug: nil)
      require_auth!
      scope = Pundit.policy_scope(context[:current_user], WorkflowInstance).includes(:workflow_definition)
      if workflow_definition_slug.present?
        wd = WorkflowDefinition.find_by!(slug: workflow_definition_slug)
        scope = scope.where(workflow_definition: wd)
      end
      scope.order(created_at: :desc)
    end

    private

    def require_auth!
      raise GraphQL::ExecutionError.new("Authentication required", extensions: { code: "UNAUTHENTICATED" }) unless context[:current_user]
    end
  end
end
