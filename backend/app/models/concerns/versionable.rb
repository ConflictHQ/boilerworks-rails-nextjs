module Versionable
  extend ActiveSupport::Concern

  # lock_version is managed automatically by ActiveRecord optimistic locking
end
