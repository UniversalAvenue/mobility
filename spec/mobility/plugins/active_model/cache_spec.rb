require "spec_helper"

describe "Mobility::Plugins::ActiveModel::Cache", orm: :active_record do
  include Helpers::Plugins
  plugin_setup active_model: true, cache: true

  let(:model_class) do
    Class.new do
      include ::ActiveModel::Dirty
    end
  end

  %w[changes_applied clear_changes_information].each do |method_name|
    it "clears backend cache after #{method_name}" do
      model_class.include attributes

      expect(instance.mobility_backends[:title]).to receive(:clear_cache).once
      instance.send(method_name)
    end
  end
end
