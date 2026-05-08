# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record # shortcut to access instance variables. It creates getter methods for instance variables.

  def initialize(user, record)
    @user = user # user (who is logged in)
    @record = record # record (model being accessed)
  end

  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present?
  end

  def edit?
    update?
  end

  def destroy?
    user&.admin?
  end

  def admin_only?
    user&.admin?
  end

  class Scope # Scope defines WHICH records a user is allowed to SEE- Not actions
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end


# rough

# Policy means-> can you DO something?

# Examples:

# create member?
# delete member?
# update member?

# Scope -> what CAN you SEE?

# Examples:

# class Scope
#   def resolve
#     @scope.all
#   end
# end


# another case
#
# def resolve
#   if user.admin?
#     scope.all
#   else
#     scope.where(active: true)
#   end
# end

# which members appear in index page?
