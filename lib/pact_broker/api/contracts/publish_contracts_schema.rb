require "dry-validation"
require "pact_broker/api/contracts/dry_validation_workarounds"
require "pact_broker/api/contracts/dry_validation_macros"
require "pact_broker/messages"
require "pact_broker/api/contracts/utf_8_validation"
require "pact_broker/api/contracts/validation_helpers"
require "pact_broker/api/contracts/publish_contracts_contract_contract"

module PactBroker
  module Api
    module Contracts
      class PublishContractsSchema < Dry::Validation::Contract

        include DryValidationMethods
        using PactBroker::HashRefinements

        json do
          required(:pacticipantName).filled(:string)
          required(:pacticipantVersionNumber).filled(:string)
          optional(:tags).maybe{ array? & each { filled? } }
          optional(:branch).maybe(:string)
          optional(:buildUrl).maybe(:string)
          required(:contracts).array(:hash)
        end

        rule(:pacticipantName).validate(:not_blank_if_present)
        rule(:pacticipantVersionNumber).validate(:not_blank_if_present, :not_multiple_lines)
        rule(:branch).validate(:not_blank_if_present, :not_multiple_lines)
        rule(:buildUrl).validate(:not_multiple_lines)
        rule(:tags).validate(:array_values_not_blank_if_any)

        rule(:contracts).validate(validate_each_with_contract: PublishContractsContractContract)

        # validate_consumer_name_matches_pacticipant_name
        rule(:contracts, :pacticipantName) do
          values[:contracts]&.each_with_index do | contract, index |
            if values[:pacticipantName] && contract[:consumerName] && (contract[:consumerName] != values[:pacticipantName])
              key([:contracts, index]).failure(validation_message("consumer_name_in_contract_mismatch_pacticipant_name", { consumer_name_in_contract: contract[:consumerName], pacticipant_name: values[:pacticipantName] }))
            end
          end
        end

        def self.call(params)
          flatten_indexed_messages(new.call(params&.symbolize_keys).errors.to_hash)
        end
      end
    end
  end
end
