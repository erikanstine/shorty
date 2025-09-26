require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it 'requires target_url' do
      link = Link.new(target_url: nil)

      expect(link).not_to be_valid
      expect(link.errors[:target_url]).to include("can't be blank")
    end

    it 'requires http/https format' do
      link = Link.new(target_url: 'ftp://foo')
      expect(link).not_to be_valid

      link.target_url = 'https://ok.example'
      expect(link).to be_valid
    end
  end

  describe '.create vs .create!' do
    it 'returns an unsaved model (no bang) when invalid' do
      link = Link.create(target_url: nil)

      expect(link).not_to be_persisted
      expect(link.errors.full_messages).to include(a_string_matching(/Target url/))
    end

    it 'raises when invalid (bang)' do
      expect { Link.create!(target_url: nil) }
        .to raise_error(ActiveRecord::RecordInvalid, /Target url/)
    end

    it 'persists when valid' do
      expect { Link.create!(target_url: 'https://example.com') }.to change(Link, :count).by(1)
    end
  end

  describe '#active?' do
    it 'is true when expires_at is nil' do
      link = Link.new(expires_at: nil)
      expect(link.active?).to be true
    end

    it 'is true when expires_at is in the future' do
      link = Link.new(expires_at: 1.hour.from_now)
      expect(link.active?).to be true
    end

    it 'is false when expires_at is in the past' do
      link = Link.new(expires_at: 1.minute.ago)
      expect(link.active?).to be false
    end
  end

  describe '.active' do
    it 'returns only unexpired links' do
      a = Link.create!(target_url: 'https://a.co', expires_at: nil)
      b = Link.create!(target_url: 'https://b.co', expires_at: 10.minutes.from_now)
      Link.create!(target_url: 'https://c.co', expires_at: 1.minute.ago)
      expect(Link.active).to contain_exactly(a, b)
    end
  end

  describe '#increment_clicks!' do
    it 'atomically increments and returns new count' do
      link = Link.create!(target_url: 'https://d.co', clicks_count: 0)
      expect(link.increment_clicks!).to eq(1)
      expect(link.reload.clicks_count).to eq(1)
    end
  end
end
