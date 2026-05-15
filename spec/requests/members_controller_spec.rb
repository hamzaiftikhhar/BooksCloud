# require 'rails_helper'

# RSpec.describe MembersController, type: :controller do
#   describe '#index' do
#     it 'returns a successful response' do
#       get :index

#       expect(response).to have_http_status(:ok)
#       expect(assigns(:members)).to match_array(Member.order(:first_name, :last_name).page(nil).per(10))
#     end
#   end

#   describe '#show' do
#     let(:member) { create(:member) }

#     it 'returns success and loads member' do
#       get :show, params: { id: member.id }

#       expect(response).to have_http_status(:ok)
#       expect(assigns(:member)).to eq(member)
#     end

#     it 'redirects when member not found' do
#       get :show, params: { id: 999999 }

#       expect(response).to redirect_to(members_path)
#       expect(flash[:alert]).to eq("Member not found.")
#     end
#   end

#   describe '#create' do
#     it 'creates member' do
#       expect {
#         post :create, params: {
#           member: { first_name: "John", last_name: "Doe" }
#         }
#       }.to change(Member, :count).by(1)
#     end

#     it 'does not create invalid member' do
#       expect {
#         post :create, params: {
#           member: { first_name: "", last_name: "" }
#         }
#       }.not_to change(Member, :count)
#     end
#   end

#   describe '#update' do
#     let(:member) { create(:member) }
