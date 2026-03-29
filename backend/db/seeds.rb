puts "Seeding permissions..."

permission_data = [
  { name: "View Items",    slug: "item.view" },
  { name: "Add Items",     slug: "item.add" },
  { name: "Change Items",  slug: "item.change" },
  { name: "Delete Items",  slug: "item.delete" },
  { name: "View Categories",  slug: "category.view" },
  { name: "Add Categories",   slug: "category.add" },
  { name: "Change Categories", slug: "category.change" },
  { name: "Delete Categories", slug: "category.delete" },
  { name: "View Forms", slug: "form.view" },
  { name: "Add Forms", slug: "form.add" },
  { name: "Change Forms", slug: "form.change" },
  { name: "Delete Forms", slug: "form.delete" },
  { name: "View Workflows", slug: "workflow.view" },
  { name: "Add Workflows", slug: "workflow.add" },
  { name: "Change Workflows", slug: "workflow.change" },
  { name: "Delete Workflows", slug: "workflow.delete" }
]

permissions = permission_data.map do |attrs|
  Permission.find_or_create_by!(slug: attrs[:slug]) do |p|
    p.name = attrs[:name]
  end
end

puts "  Created #{permissions.size} permissions"

puts "Seeding groups..."

admin_group = Group.find_or_create_by!(name: "Admin")
admin_group.permissions = Permission.all

editor_group = Group.find_or_create_by!(name: "Editor")
editor_group.permissions = Permission.where(slug: %w[item.view category.view form.view workflow.view])

puts "  Created Admin group (#{admin_group.permissions.count} permissions)"
puts "  Created Editor group (#{editor_group.permissions.count} permissions)"

puts "Seeding admin user..."

admin = User.find_or_initialize_by(email_address: "admin@boilerworks.dev")
admin.assign_attributes(
  password: "password",
  password_confirmation: "password",
  first_name: "Admin",
  last_name: "User"
)
admin.save!
admin.groups = [admin_group] unless admin.groups.include?(admin_group)

puts "  Created admin@boilerworks.dev (password: password)"

puts "Seeding categories..."

categories = {}
[
  { name: "Electronics", slug: "electronics", description: "Electronic devices and accessories" },
  { name: "Clothing", slug: "clothing", description: "Apparel and fashion items" },
  { name: "Home & Garden", slug: "home-garden", description: "Home improvement and garden supplies" }
].each do |attrs|
  cat = Category.find_or_create_by!(slug: attrs[:slug]) do |c|
    c.name = attrs[:name]
    c.description = attrs[:description]
  end
  categories[attrs[:slug]] = cat
end

puts "  Created #{categories.size} categories"

puts "Seeding items..."

items = [
  { name: "Wireless Headphones", slug: "wireless-headphones", description: "Bluetooth noise-cancelling headphones", price: 79.99, category: categories["electronics"] },
  { name: "USB-C Hub", slug: "usb-c-hub", description: "7-in-1 USB-C docking station", price: 49.99, category: categories["electronics"] },
  { name: "Mechanical Keyboard", slug: "mechanical-keyboard", description: "Cherry MX Brown switches, RGB backlit", price: 129.99, category: categories["electronics"] },
  { name: "Denim Jacket", slug: "denim-jacket", description: "Classic fit stonewash denim jacket", price: 89.99, category: categories["clothing"] },
  { name: "Running Shoes", slug: "running-shoes", description: "Lightweight breathable running shoes", price: 119.99, category: categories["clothing"] },
  { name: "Garden Tool Set", slug: "garden-tool-set", description: "5-piece stainless steel garden tool kit", price: 34.99, category: categories["home-garden"] }
]

items.each do |attrs|
  category = attrs.delete(:category)
  Item.find_or_create_by!(slug: attrs[:slug]) do |p|
    p.assign_attributes(attrs)
    p.category = category
  end
end

puts "  Created #{items.size} items"

puts "Seeding sample form definition..."

FormDefinition.find_or_create_by!(slug: "contact-form") do |f|
  f.name = "Contact Form"
  f.description = "A simple contact form"
  f.status = "published"
  f.schema = {
    "fields" => [
      { "name" => "name", "type" => "text", "label" => "Full Name", "validations" => { "required" => true } },
      { "name" => "email", "type" => "email", "label" => "Email Address", "validations" => { "required" => true } },
      { "name" => "subject", "type" => "select", "label" => "Subject", "options" => [
        { "label" => "General Inquiry", "value" => "general" },
        { "label" => "Support", "value" => "support" },
        { "label" => "Feedback", "value" => "feedback" }
      ], "validations" => { "required" => true } },
      { "name" => "message", "type" => "textarea", "label" => "Message", "validations" => { "required" => true, "min_length" => 10 } },
      { "name" => "rating", "type" => "rating", "label" => "How would you rate us?", "validations" => { "min" => 1, "max" => 5 } }
    ]
  }
end
puts "  Created sample contact form"

puts "Seeding sample workflow definition..."

WorkflowDefinition.find_or_create_by!(slug: "content-approval") do |w|
  w.name = "Content Approval"
  w.description = "Review and approval workflow for content"
  w.target_type = "Item"
  w.states = [
    { "name" => "draft", "initial" => true, "label" => "Draft" },
    { "name" => "in_review", "label" => "In Review" },
    { "name" => "approved", "label" => "Approved" },
    { "name" => "rejected", "label" => "Rejected" },
    { "name" => "published", "label" => "Published" }
  ]
  w.transitions = [
    { "from" => "draft", "to" => "in_review", "label" => "Submit for Review" },
    { "from" => "in_review", "to" => "approved", "label" => "Approve" },
    { "from" => "in_review", "to" => "rejected", "label" => "Reject" },
    { "from" => "approved", "to" => "published", "label" => "Publish" },
    { "from" => "rejected", "to" => "draft", "label" => "Revise" }
  ]
end
puts "  Created sample content approval workflow"

puts "Seeding complete!"
