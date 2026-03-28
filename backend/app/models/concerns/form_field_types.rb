module FormFieldTypes
  TYPES = {
    text: { label: "Text", icon: "type", validations: %w[required min_length max_length pattern] },
    textarea: { label: "Text Area", icon: "align-left", validations: %w[required min_length max_length] },
    number: { label: "Number", icon: "hash", validations: %w[required min max step] },
    email: { label: "Email", icon: "mail", validations: %w[required] },
    phone: { label: "Phone", icon: "phone", validations: %w[required pattern] },
    url: { label: "URL", icon: "link", validations: %w[required] },
    date: { label: "Date", icon: "calendar", validations: %w[required min max] },
    time: { label: "Time", icon: "clock", validations: %w[required] },
    datetime: { label: "Date & Time", icon: "calendar-clock", validations: %w[required] },
    select: { label: "Select", icon: "chevron-down", validations: %w[required], has_options: true },
    multi_select: { label: "Multi Select", icon: "list", validations: %w[required min max], has_options: true },
    radio: { label: "Radio", icon: "circle-dot", validations: %w[required], has_options: true },
    checkbox: { label: "Checkbox", icon: "check-square", validations: %w[required] },
    toggle: { label: "Toggle", icon: "toggle-left", validations: [] },
    file: { label: "File Upload", icon: "upload", validations: %w[required max_size accept] },
    image: { label: "Image", icon: "image", validations: %w[required max_size] },
    rich_text: { label: "Rich Text", icon: "text", validations: %w[required] },
    rating: { label: "Rating", icon: "star", validations: %w[required min max] },
    slider: { label: "Slider", icon: "sliders", validations: %w[required min max step] },
    color: { label: "Color", icon: "palette", validations: %w[required] },
    signature: { label: "Signature", icon: "pen-tool", validations: %w[required] },
    hidden: { label: "Hidden", icon: "eye-off", validations: [] }
  }.freeze

  def self.all = TYPES
  def self.names = TYPES.keys.map(&:to_s)
end
