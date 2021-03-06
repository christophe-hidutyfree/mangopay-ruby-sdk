require_relative '../../spec_helper'

describe MangoPay::ImmediateContribution, :type => :feature do

    let(:new_user) {
        MangoPay::User.create({
            'Tag' => 'test',
            'Email' => 'my@email.com',
            'FirstName' => 'John',
            'LastName' => 'Doe',
            'CanRegisterMeanOfPayment' => true
            })
    }

    let(:new_card) do
        card = MangoPay::Card.create({
            'Tag' => 'test-card',
            'OwnerID' => new_user['ID'],
            'ReturnURL' => 'http://leetchi.com'
            })
        visit(card['RedirectURL'])
        fill_in('number', :with => '4970100000000154')
        fill_in('cvv', :with => '123')
        click_button('paybutton')
        card = MangoPay::Card.details(card['ID'])
        while (card["CardNumber"] || []).length != 16 do
            card = MangoPay::Card.details(card['ID'])
        end
        card
    end

    let(:new_immediate_contribution) do
        c = MangoPay::ImmediateContribution.create({
            'Tag' => 'test_contribution',
            'UserID' => new_user['ID'],
            'PaymentCardID' => new_card['ID'],
            'WalletID' => 0,
            'Amount' => 33300
            })
    end

    let(:new_immediate_contribution_refund) {
        MangoPay::ImmediateContribution.refund({
            'ContributionID' => new_immediate_contribution['ID'],
            'UserID' => new_user['ID'],
            'Tag' => 'test_immediate_contribution_refund'
            })
    }

    describe "CREATE" do
        it "creates an immediate contribution" do
            expect(new_immediate_contribution['ID']).not_to be_nil
        end
    end

    describe "GET" do
        it "get the immediate contribution" do
            immediate_contribution = MangoPay::ImmediateContribution.details(new_immediate_contribution['ID'])
            expect(immediate_contribution['ID']).to eq(new_immediate_contribution['ID'])
        end
    end

    describe "REFUND" do
        it "creates a refund request for the immediate contribution" do
            expect(new_immediate_contribution_refund['ID']).not_to be_nil
        end
        it "gets the refund request" do
            immediate_contribution_refund = MangoPay::ImmediateContribution.get_refund(new_immediate_contribution_refund['ID'])
            expect(immediate_contribution_refund['ID']).to eq(new_immediate_contribution_refund['ID'])
        end
    end

end
