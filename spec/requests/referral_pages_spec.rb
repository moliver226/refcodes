require 'spec_helper'

describe "Referral pages" do
  
  subject { page }

  describe "referrals page" do

    let!(:r1) { FactoryGirl.create(:referral, details: "Lorem ipsum", link: "http://example.com") }
    let!(:r2) { FactoryGirl.create(:referral, details: "Lorem ipsum et", link: "http://example2.com") }
    before { visit root_path }

    it { should have_content('Refcodes') }
    it { should have_title('Refcodes') }

    describe "referrals" do
      it { should have_content(r1.details) }
      it { should have_content(r2.details) }
    end

    describe "referral creation" do

      describe "with invalid information" do
        it "should not create a referral" do
          expect { click_button "Submit" }.not_to change(Referral, :count)
        end

        describe "error messages" do
          before { click_button "Submit" }
          it { should have_content('error') }
        end
      end

      describe "with valid information" do

        before { fill_in 'referral_details', with: "Lorem ipsum" }
        it "should create a referral" do
          expect { click_button "Submit" }.to change(Referral, :count).by(1)
        end
      end
    end
  end
end