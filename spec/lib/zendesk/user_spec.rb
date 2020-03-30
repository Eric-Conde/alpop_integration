# frozen_string_literal: true

require 'zendesk/user'

  describe Zendesk::User do
    describe 'initializer' do
      context 'when Zendesk::User is initialized' do
        it 'sets the user id' do
          user = build :user

          expect(user.id).not_to be_nil
        end
      end
    end

  describe '.find' do
    before(:each) do
      find_user_by_id_response = '{"user": {"id": 2122}}'

      # Stub find user by id to avoid HTTP requests.
      stub_request(:get, 'https://alpophelp.zendesk.com/api/v2/user/2122')
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: find_user_by_id_response, headers: {})
    end
  end

    context 'when call .find()' do
      it 'retrieves a user by id' do
        user = Zendesk::User.find(2122)

        expect(user.id).to eq 2122
      end
    end
  end
end
