# BooksCloud
This demo project is Rails-based practice project built to strengthen core web development concepts including authentication (Devise), CRUD operations, associations, nesting and RESTful routing. It focuses on building a clean architecture without scaffolding to improve deep understanding of Rails internals.


Yes, you are using Pundit in your Rails app.

Pundit Usage Documentation
Pundit is a Ruby gem for handling authorization in Rails applications. It uses policy classes to define permissions and scopes for models. Below is a breakdown of where and how Pundit is currently implemented in your Book Cloud app, based on the existing code.

1. Policy Classes (Already Created)
You have several policy files in policies:

application_policy.rb - Base policy class with default methods.
book_policy.rb - Defines permissions for Book model.
borrowing_policy.rb - Defines permissions for Borrowing model.
fine_policy.rb - Defines permissions for Fine model.
member_policy.rb - Defines permissions for Member model.
These policies contain methods like index?, show?, create?, etc., which determine if a user can perform actions on records. They also include resolve for scoping queries.

2. Where Pundit Is Used in Controllers
BorrowingsController (borrowings_controller.rb)
Usage: policy_scope(Borrowing) in the index action.
How it works:
policy_scope applies the resolve method from BorrowingPolicy to filter the borrowings that the current user can see.
For example, it might limit results to borrowings related to the user's role (e.g., admin sees all, members see their own).
No authorize calls for individual actions like show, create, or return_book – these actions are not protected by Pundit checks.
MembersController (members_controller.rb)
Usage:
policy_scope(Member) in the index action (similar to borrowings).
authorize @member, :suspend? in suspend and unsuspend actions.
How it works:
policy_scope scopes the member list based on MemberPolicy#resolve.
authorize checks if the current user has permission to suspend/unsuspend a specific member by calling MemberPolicy#suspend?(@member). If not authorized, it raises a Pundit::NotAuthorizedError.
FinesController (fines_controller.rb)
Usage: policy_scope(Fine) in index, outstanding, and paid actions.
How it works: Scopes fine queries using FinePolicy#resolve, limiting visible fines based on user permissions.
Admin Controllers (e.g., admin/users_controller.rb, admin/dashboard_controller.rb)
Usage: Custom authorize_admin! before_action.
How it works: This is a custom method (not standard Pundit) that likely checks if the user is an admin. It redirects or raises an error if not. It's not using Pundit's authorize or policy_scope directly.
3. Global Pundit Setup
ApplicationController (application_controller.rb):
Includes Pundit module.
Has a rescue_from Pundit::NotAuthorizedError that catches authorization failures and shows a flash alert: "You are not authorized to perform this action."
This ensures unauthorized actions display a user-friendly error instead of crashing.
4. How Pundit Works Overall
Authorization Flow:
When authorize(record, action) is called, Pundit looks for a policy class (e.g., BookPolicy) and calls the method matching the action (e.g., show?(record)).
The policy method receives the current user (current_user) and the record, and returns true/false.
If false, Pundit::NotAuthorizedError is raised and handled by the rescue in ApplicationController.
Scoping Flow:
policy_scope(Model) calls the resolve method on the policy, which returns a scoped query (e.g., where(user_id: current_user.id) for non-admins).
This filters database queries at the controller level to only return authorized records.
Current User: Pundit uses current_user (from Devise) in policies. Policies access it via user parameter.
Not Used Everywhere: Controllers like BooksController and AuthorsController do not use policy_scope or authorize, so they rely on other logic (e.g., admin checks) for access control.
5. Recommendations (Without Code Changes)
Inconsistent Usage: You're using Pundit in some controllers but not others. For full security, add authorize checks to actions like BooksController#show, BorrowingsController#create, etc.
Testing Policies: Ensure policies are tested; they define your app's security rules.
Admin Checks: The custom authorize_admin! could be replaced with Pundit policies for consistency.
This covers the current Pundit implementation. If you need examples of how specific policies work, let me know!