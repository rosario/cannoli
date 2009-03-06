require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  def test_budget
  event = Event.new(:name => 'Test Event', :budget => 30.00)
  event.expenses.build(:amount => 10.00)
  event.expenses.build(:amount => 20.50)
  assert event.save
  
  assert_equal BigDecimal("30.50"), event.total_expenses
  assert event.budget_exceeded?
  end

end
