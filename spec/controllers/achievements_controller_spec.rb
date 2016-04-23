require 'rails_helper'

describe AchievementsController do
	shared_examples 'public access to achievements' do
		describe 'GET :index' do
			it 'render :index template' do
				get :index
				expect(response).to render_template(:index)
			end

			it 'assigns only public achievements' do
				public_achievement = FactoryGirl.create(:public_achievement)
				private_achievement = FactoryGirl.create(:private_achievement)
				get :index
				expect(assigns(:achievements)).to match_array([public_achievement])
			end
		end

		describe 'GET :show' do
			let(:achievement) { FactoryGirl.create(:achievement)}

			it 'renders :show template' do
				get :show, id: achievement.id
				expect(response).to render_template(:show)
			end
		end
	end
	describe 'guest user' do
		it_behaves_like 'public access to achievements'

		describe 'GET :edit' do
			let(:achievement){FactoryGirl.create(:public_achievement)}

			it 'redirects to login' do
				get :edit, id: achievement
				expect(response).to redirect_to(new_user_session_url)
			end
		end

		describe 'PUT :update' do
			let(:achievement){ FactoryGirl.create(:public_achievement)}
			let(:attributes){ FactoryGirl.attributes_for(:public_achievement)}

			it 'redirects to login' do
				put :update, id: achievement, achievement: attributes
				expect(response).to redirect_to(new_user_session_url)
			end
		end

		describe 'DELETE :destroy' do
			let(:achievement){FactoryGirl.create(:public_achievement)}
			it 'redirects to login' do
				delete :destroy, id: achievement
				expect(response).to redirect_to(new_user_session_url)
			end
		end

		describe 'GET :new' do
			it 'redirects to login' do
				get :new
				expect(response).to redirect_to(new_user_session_url)
			end
		end

	end

	describe 'authenticated user' do
		let(:user){ FactoryGirl.create(:user) }
		before do
			sign_in(user)
		end

		it_behaves_like 'public access to achievements'

		describe 'GET :new' do
			it 'renders :new template' do
				get :new
				expect(response).to render_template(:new)
			end

			it 'assigns new Achievement to form' do
				get :new
				expect(assigns(:achievement)).to be_a_new(Achievement)
			end
		end

		describe 'POST :create' do
			let(:valid_data){ FactoryGirl.attributes_for(:achievement) }
			context 'valid data' do
				it 'redirects to achievement#show' do
					post :create, achievement: valid_data
					expect(response).to redirect_to(achievement_path(assigns[:achievement]))
				end

				it 'creates a new achievement in the database' do
					expect {
						post :create, achievement: valid_data
						}.to change(Achievement, :count).by(1)
				end
			end

			context 'invalid data' do
				let(:invalid_data){ FactoryGirl.attributes_for(:achievement, title: '') }
				it 'redirects to achievement#new' do
					post :create, achievement: invalid_data
					expect(response).to render_template(:new)
				end

				it 'does not create a new achievement in database' do
					expect{
						post :create, achievement: invalid_data
					}.not_to change(Achievement, :count)
				end
			end
		end

		context 'is owner of the achievement' do
			let(:achievement){FactoryGirl.create(:public_achievement, user: user)}
			describe 'GET :edit' do
				it 'renders :edit template' do
					get :edit, id: achievement
					expect(response).to render_template(:edit)
				end

				it 'assigns the right acheivement to template' do
					get :edit, id: achievement
					expect(assigns(:achievement)).to eq(achievement)
				end
			end

			describe 'PUT :update' do
				context 'valid data' do
					let(:valid_attributes) {FactoryGirl.attributes_for(:public_achievement, title: 'New Achievement')}

					it 'redirects to achievement#show' do
						put :update, id: achievement, achievement: valid_attributes
						expect(response).to redirect_to(achievement_path(achievement))
					end
					it 'changes the record in the database' do
						put :update, id: achievement, achievement: valid_attributes
						achievement.reload
						expect(achievement.title).to eq('New Achievement')
					end
				end

				context 'invalid data' do
					let(:invalid_attributes) {FactoryGirl.attributes_for(:public_achievement, title: '', description: 'desc')}

					it 'renders edit template' do
						put :update, id: achievement, achievement: invalid_attributes
						expect(response).to render_template(:edit)
					end
					it 'does not update the temlate in the database' do
						put :update, id: achievement, achievement: invalid_attributes
						achievement.reload
						expect(achievement.description).not_to eq('desc')
					end
				end
			end

			describe 'DELETE :destroy' do
				it 'redirects to achievements#index' do
					delete :destroy, id: achievement
					expect(response).to redirect_to(achievements_path)
				end
				it 'deletes the record in the database' do
					delete :destroy, id: achievement
					expect(Achievement.exists?(achievement.id)).to be_falsy
				end
			end
		end
		context 'is not owner of the achievement' do
			describe 'GET :edit' do
				let(:achievement){FactoryGirl.create(:public_achievement)}

				it 'redirects to achievements page' do
					get :edit, id: achievement
					expect(response).to redirect_to(achievements_path)
				end
			end

			describe 'PUT :update' do
				let(:achievement){ FactoryGirl.create(:public_achievement)}
				let(:attributes){ FactoryGirl.attributes_for(:public_achievement)}

				it 'redirects to achievements page' do
					put :update, id: achievement, achievement: attributes
					expect(response).to redirect_to(achievements_path)
				end
			end

			describe 'DELETE :destroy' do
				let(:achievement){FactoryGirl.create(:public_achievement)}
				it 'redirects to achievements page' do
					delete :destroy, id: achievement
					expect(response).to redirect_to(achievements_path)
				end
			end
		end
	end
end