require 'spec_helper'

RSpec.describe 'Validations' do
  describe 'validate_required_attributes' do
    it 'raises an error if required attributes are missing' do
      expect { Dialpad::Subscriptions::CallEvent.retrieve }.to raise_error(Dialpad::Subscriptions::CallEvent::RequiredAttributeError)
    end
  end
end
