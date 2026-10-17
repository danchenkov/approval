class ApplicationRecord < ActiveRecord::Base
  # Shared parent for our database models. `primary_abstract_class` tells Rails
  # this class has no table of its own; Request, Reviewer, and Decision do.
  primary_abstract_class
end
