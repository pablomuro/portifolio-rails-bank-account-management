require "application_system_test_case"

class AccountTransactionsTest < ApplicationSystemTestCase
  setup do
    @account_transaction = account_transactions(:one)
  end

  test "visiting the index" do
    visit account_transactions_url
    assert_selector "h1", text: "Account Transactions"
  end

  test "creating a Account transaction" do
    visit account_transactions_url
    click_on "New Account Transaction"

    fill_in "Account", with: @account_transaction.account_id
    fill_in "Account money amount", with: @account_transaction.account_money_amount
    fill_in "Date", with: @account_transaction.date
    fill_in "Transaction type", with: @account_transaction.transaction_type
    fill_in "Transaction value", with: @account_transaction.transaction_value
    click_on "Create Account transaction"

    assert_text "Account transaction was successfully created"
    click_on "Back"
  end

  test "updating a Account transaction" do
    visit account_transactions_url
    click_on "Edit", match: :first

    fill_in "Account", with: @account_transaction.account_id
    fill_in "Account money amount", with: @account_transaction.account_money_amount
    fill_in "Date", with: @account_transaction.date
    fill_in "Transaction type", with: @account_transaction.transaction_type
    fill_in "Transaction value", with: @account_transaction.transaction_value
    click_on "Update Account transaction"

    assert_text "Account transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Account transaction" do
    visit account_transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account transaction was successfully destroyed"
  end
end
