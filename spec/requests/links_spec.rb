# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Links', type: :request do
  describe 'POST /links' do
    it 'creates a link for a valid target_url'
    it 'rejects creation for an invalid target_url'
    it 'supports optional expiration input'
    it 'returns JSON when requested'
  end

  describe 'GET /:code (resolve)' do
    it 'redirects to the target_url for active links'
    it '404s for unknown codes'
    it '404s for expired links'
    it 'increments clicks_count on success'
  end
end
