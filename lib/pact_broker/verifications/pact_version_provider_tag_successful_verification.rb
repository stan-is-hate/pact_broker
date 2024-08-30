require "pact_broker/domain/verification"

# Represents a non WIP, successful verification for a provider version with a tag.

module PactBroker
  module Verifications
    class PactVersionProviderTagSuccessfulVerification < Sequel::Model
      set_primary_key :id
      plugin :insert_ignore, identifying_columns: [:pact_version_id, :provider_version_tag_name, :wip]
    end
  end
end

# Table: pact_version_provider_tag_successful_verifications
# Columns:
#  id                        | integer                     | PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY
#  pact_version_id           | integer                     | NOT NULL
#  provider_version_tag_name | text                        | NOT NULL
#  wip                       | boolean                     | NOT NULL
#  verification_id           | integer                     |
#  execution_date            | timestamp without time zone | NOT NULL
# Indexes:
#  pact_version_provider_tag_successful_verifications_pkey    | PRIMARY KEY btree (id)
#  pact_version_provider_tag_verifications_pv_pvtn_wip_unique | UNIQUE btree (pact_version_id, provider_version_tag_name, wip)
#  pact_ver_prov_tag_success_verif_verif_id_ndx               | btree (verification_id)
# Foreign key constraints:
#  pact_version_provider_tag_successful_verifications_pv_id_fk | (pact_version_id) REFERENCES pact_versions(id) ON DELETE CASCADE
#  pact_version_provider_tag_successful_verifications_v_id_fk  | (verification_id) REFERENCES verifications(id) ON DELETE SET NULL
