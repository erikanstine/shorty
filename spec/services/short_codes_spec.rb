# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShortCodes do
  describe '.random' do
    it 'returns a string of the expected length'
    it 'uses only URL-safe characters'
    it 'produces diverse values across calls'
  end

  describe 'collision handling' do
    it 'retries when generated code is taken'
    it 'optionally increases length after N retries'
  end
end
