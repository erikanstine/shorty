require 'rails_helper'

RSpec.describe 'Smoke', type: :request do
  it 'runs the test suite' do
    expect(1 + 1).to eq(2)
  end
end
