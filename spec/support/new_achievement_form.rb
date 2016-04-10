class NewAchievementForm
	include Capybara::DSL

	def visit_form
		visit('/')
		click_on('New Achievement')
		self
	end

	def fill_in_form(params)
		fill_in('Title', with: params.fetch(:title, 'Read a book'))
		fill_in('Description', with: 'Excellent reads')
		select('Public', from: 'Privacy')
		check('Featured achievement')
		attach_file('Cover image', "#{Rails.root}/spec/fixtures/cover_image.jpg")
		self
	end

	def submit_form
		click_on('Create Achievement')
		self
	end
end