require 'spec_helper'

describe Company do

  before { @company = Company.new(name: "Bloc") }

  subject { @company }

  it { should respond_to(:name) }
  it { should be_valid }
  it { should respond_to(:referrals)}

  describe "referral associations" do

    before { @company.save }

    let!(:older_referral) do
      FactoryGirl.create(:referral, company: @company, created_at: 1.day.ago)
    end
    let!(:newer_referral) do
      FactoryGirl.create(:referral, company: @company, created_at: 1.hour.ago)
    end

    it "should have the right referrals in the right order" do
      expect(@company.referrals.to_a).to eq [newer_referral, older_referral]
    end

    it "should destroy associated referrals" do
      referrals = @company.referrals.to_a
      @company.destroy
      expect(referrals).not_to be_empty
      referrals.each do |referral|
        expect(Referral.where(id: Referral.id)).to be_empty
      end
    end
  end
end