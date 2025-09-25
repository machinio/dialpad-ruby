require "spec_helper"

RSpec.describe Dialpad::Webhook do
  let(:client) { instance_double(Dialpad::Client) }

  before do
    allow(Dialpad).to receive(:client).and_return(client)
  end

  describe ".retrieve" do
    it "retrieves a webhook by ID" do
      response = OpenStruct.new(id: 1, url: "https://example.com/webhook")
      expect(client).to receive(:get).with("/webhooks/1").and_return(response)

      result = described_class.retrieve(1)
      expect(result.id).to eq(1)
      expect(result.url).to eq("https://example.com/webhook")
    end

    it "raises error when ID is missing" do
      expect { described_class.retrieve(nil) }.to raise_error(Dialpad::Webhook::RequiredAttributeError, "Missing required attribute: ID")
    end

    it "raises error when ID is empty" do
      expect { described_class.retrieve("") }.to raise_error(Dialpad::Webhook::RequiredAttributeError, "Missing required attribute: ID")
    end
  end

  describe ".list" do
    it "lists all webhooks" do
      response = [
        OpenStruct.new(id: 1, url: "https://example.com/webhook1"),
        OpenStruct.new(id: 2, url: "https://example.com/webhook2")
      ]
      expect(client).to receive(:get).with("/webhooks", {}).and_return(response)

      result = described_class.list
      expect(result.length).to eq(2)
      expect(result.first.id).to eq(1)
    end

    it "lists webhooks with params" do
      params = { limit: 10, offset: 0 }
      response = [OpenStruct.new(id: 1)]
      expect(client).to receive(:get).with("/webhooks", params).and_return(response)

      result = described_class.list(params)
      expect(result.length).to eq(1)
    end
  end

  describe ".create" do
    it "creates a new webhook" do
      attributes = { hook_url: "https://example.com/webhook", events: ["call.completed"] }
      response = OpenStruct.new(id: 1, hook_url: "https://example.com/webhook")
      expect(client).to receive(:post).with("/webhooks", attributes).and_return(response)

      result = described_class.create(attributes)
      expect(result.id).to eq(1)
      expect(result.hook_url).to eq("https://example.com/webhook")
    end

    it "raises error when hook_url is missing" do
      attributes = { events: ["call.completed"] }
      expect { described_class.create(attributes) }.to raise_error(Dialpad::Webhook::RequiredAttributeError, "Missing required attributes: hook_url")
    end

    it "raises error when hook_url is empty" do
      attributes = { hook_url: "", events: ["call.completed"] }
      expect { described_class.create(attributes) }.to raise_error(Dialpad::Webhook::RequiredAttributeError, "Missing required attributes: hook_url")
    end
  end

  describe ".update" do
    it "updates a webhook" do
      attributes = { hook_url: "https://example.com/updated-webhook" }
      response = OpenStruct.new(id: 1, hook_url: "https://example.com/updated-webhook")
      expect(client).to receive(:put).with("/webhooks/1", attributes).and_return(response)

      result = described_class.update(1, attributes)
      expect(result.id).to eq(1)
      expect(result.hook_url).to eq("https://example.com/updated-webhook")
    end

    it "raises error when ID is missing" do
      attributes = { hook_url: "https://example.com/webhook" }
      expect { described_class.update(nil, attributes) }.to raise_error(Dialpad::Webhook::RequiredAttributeError, "Missing required attribute: ID")
    end
  end

  describe ".destroy" do
    it "deletes a webhook" do
      expect(client).to receive(:delete).with("/webhooks/1").and_return(nil)

      result = described_class.destroy(1)
      expect(result).to be_nil
    end

    it "raises error when ID is missing" do
      expect { described_class.destroy(nil) }.to raise_error(Dialpad::Webhook::RequiredAttributeError, "Missing required attribute: ID")
    end
  end
end
