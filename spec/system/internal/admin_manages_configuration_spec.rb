require "rails_helper"

RSpec.describe "Admin manages configuration", type: :system do
  let(:admin) { create(:user, :super_admin) }

  before do
    sign_in admin
    visit internal_config_path
  end

  # Note: The :meta_keywords are handled slightly differently in the view, so we
  # can't check them the same way as the rest.
  (VerifySetupCompleted::MANDATORY_CONFIGS - [:meta_keywords]).each do |option|
    it "marks #{option} as required" do
      selector = "label[for='site_config_#{option}']"
      expect(find(selector).text).to end_with("*")
    end
  end

  context "when mandatory options are missing" do
    it "does not show the banner on the config page" do
      allow(SiteConfig).to receive(:tagline).and_return(nil)
      expect(page).not_to have_content("Setup not completed yet, please visit the configuration page.")
    end

    it "does show the banner on other pages" do
      allow(SiteConfig).to receive(:tagline).and_return(nil)
      visit root_path
      expect(page).to have_content("Setup not completed yet, please visit the configuration page.")
    end
  end
end
